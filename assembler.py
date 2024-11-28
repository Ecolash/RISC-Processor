import sys
import os
import re
opcodes = {
    'ALU' : '000000',    # opcode['ALU'] = 0x00
    'ALUI': '11xxxx',    # opcode['ALUI'] = 0x3x 
    'LD'  : '000001',    # opcode['LD'] = 0x01
    'ST'  : '000010',    # opcode['ST'] = 0x02
    'BR'  : '000011',    # opcode['BR'] = 0x03
    'BMI' : '000100',    # opcode['BMI'] = 0x04
    'BPL' : '000101',    # opcode['BPL'] = 0x05
    'BZ'  : '000110',    # opcode['BZ'] = 0x06
    'MOVE': '000111',    # opcode['MOVE'] = 0x07
    'CMOV': '101010',    # opcode['CMOV'] = 0x2A
    'JR'  : '101000',    # opcode['JR'] = 0x28
    'HALT': '001000',    # opcode['HALT'] = 0x08
    'NOP' : '001001'     # opcode['NOP'] = 0x09
}

ALUFunc = {
    'ADD' : '0000',    # ALUFunc['ADD'] = 0x0
    'SUB' : '0001',    # ALUFunc['SUB'] = 0x1
    'NOT' : '0010',    # ALUFunc['NOT'] = 0x2
    'SLL' : '0011',    # ALUFunc['SLL'] = 0x3
    'AND' : '0100',    # ALUFunc['AND'] = 0x4
    'OR'  : '0101',    # ALUFunc['OR']  = 0x5
    'SRL' : '0110',    # ALUFunc['SRL'] = 0x6
    'SRA' : '0111',    # ALUFunc['SRA'] = 0x7
    'XOR' : '1000',    # ALUFunc['XOR'] = 0x8
    'NOR' : '1001',    # ALUFunc['NOR'] = 0x9
    'INC' : '1010',    # ALUFunc['INC'] = 0xA
    'DEC' : '1011',    # ALUFunc['DEC'] = 0xB
    'SLT' : '1100',    # ALUFunc['SLT'] = 0xC
    'SGT' : '1101',    # ALUFunc['SGT'] = 0xD
    'HAM' : '1110',    # ALUFunc['HAM'] = 0xE
    'LUI' : '1111'     # ALUFunc['LUI'] = 0xF
}

REG = {
    '$0'  : '0000',    # REG['$0'] = 0x0
    '$1'  : '0001',    # REG['$1'] = 0x1
    '$2'  : '0010',    # REG['$2'] = 0x2
    '$3'  : '0011',    # REG['$3'] = 0x3
    '$4'  : '0100',    # REG['$4'] = 0x4
    '$5'  : '0101',    # REG['$5'] = 0x5
    '$6'  : '0110',    # REG['$6'] = 0x6
    '$7'  : '0111',    # REG['$7'] = 0x7
    '$8'  : '1000',    # REG['$8'] = 0x8
    '$9'  : '1001',    # REG['$9'] = 0x9
    '$A'  : '1010',    # REG['$A'] = 0xA
    '$B'  : '1011',    # REG['$B'] = 0xB
    '$C'  : '1100',    # REG['$C'] = 0xC
    '$D'  : '1101',    # REG['$D'] = 0xD
    '$E'  : '1110',    # REG['$E'] = 0xE
    '$F'  : '1111',    # REG['$F'] = 0xF
    '$RA' : '1011',    # REG['$RA'] = 0xB (aliasing)
    '$SP' : '1110',    # REG['$SP'] = 0xE (aliasing)
    '$FO' : '1111'     # REG['$FO'] = 0xF (aliasing)
}

PSEUDO_OPS = {'LA':2, 'JAL':2}

def to_bin(value, bits=16):
    bin_width = bits
    mask = (1 << bits) - 1
    bin_value = value & mask
    return f'{bin_value:0{bin_width}b}'

# Parse .data section

def parse_data_section(data_lines, __GLOBAL_ADDR__ = 0):
    """Parse the .data section and return a dictionary of data labels with memory locations."""
    data_memory = {}
    data_instructions = []

    for line in data_lines:
        if ':' not in line:
            continue
        
        parts = line.split()
        label = parts[0].replace(':', '').strip()
        data_type = parts[1]
        
        if label in data_memory:
            raise ValueError(f"Duplicate label {label} in data section.")

        if data_type == '.int':
            value = int(parts[2])
            data_memory[label] = __GLOBAL_ADDR__
            data_instructions.append(to_bin(value, 32))
            __GLOBAL_ADDR__ += 1

        elif data_type == '.arr':
            # Use regular expression to capture numbers inside braces, ignore spaces
            values = re.findall(r'{\s*([\d\s,]+)\s*}', line)[0]
            values = [v.strip() for v in values.split(',')]  # Strip whitespace and split by commas
            data_memory[label] = __GLOBAL_ADDR__
            for value in values:
                data_instructions.append(to_bin(int(value), 32))
                __GLOBAL_ADDR__ += 1

        elif data_type == '.char':
            value = ord(parts[2].strip("'"))
            data_memory[label] = __GLOBAL_ADDR__
            data_instructions.append(to_bin(value, 32))
            __GLOBAL_ADDR__ += 1

        elif data_type == '.str':
            # Use regex to match the entire string in quotes, preserving spaces
            raw_string = re.findall(r'".*"', line)[0].strip('"')
            # Decode escape sequences like \n, \t, etc.
            string = raw_string.encode().decode('unicode_escape')
            data_memory[label] = __GLOBAL_ADDR__
            for char in string:
                data_instructions.append(to_bin(ord(char), 32))
                __GLOBAL_ADDR__ += 1
            data_instructions.append(to_bin(ord('\0'), 32))  # Null-terminate the string
            __GLOBAL_ADDR__ += 1
            

    return data_memory, data_instructions

# First pass: Label handling and memory address assignment
def first_pass(instructions, address_counter=0):
    """First pass: record the location of labels."""
    labels = {}
    instruction_memory = []
            
    pre_labels = {"booth_mul": 59, "prints": 99, "printc": 109, "printi": 116, "getchar": 123, "getint": 130}
    labels.update(pre_labels)

    for instr in instructions:
        if ':' in instr:  # It's a label
            label = instr.replace(':', '').strip()
            if label in labels: raise ValueError(f"Duplicate label {label}.")
            labels[label] = address_counter  # Record label address

        elif (instr.strip() != ''):
            instruction_memory.append(instr)
            parts = instr.replace(',', '').split()  
            op = parts[0].upper()
            
            if op in PSEUDO_OPS.keys():
                address_counter += PSEUDO_OPS[op]
            else:
                address_counter += 1  # Increment for each instruction

    return labels, instruction_memory, address_counter

# Second pass: Assembling instructions
def assemble(instructions, labels, data_labels, __GLOBAL_ADDR__=0):
    machine_code = []
    
    for instr in instructions:
        parts = instr.replace(',', '').split()  
        op = parts[0].upper()
            
        if op == 'LI':
            rs = REG[parts[1].upper()]
            rt = REG['$0']
            imm = to_bin(int(parts[2]), 18)
            opcode = opcodes['ALUI']
            func = ALUFunc['ADD']
            opcode = f"{opcode[:2]}{func}"
            instruction = f"{opcode}{rs}{rt}{imm[:18]}"

        elif op == 'LUI':
            opcode = opcodes['ALUI']
            rs = REG[parts[1].upper()]
            imm = to_bin(int(parts[2]), 18) 
            func = ALUFunc[op]
            opcode = f"{opcode[:2]}{func}"
            instruction = f"{opcode}{rs}{rs}{imm[:18]}"

        elif op.endswith('I') and op[:-1] in ALUFunc:
            if op[:-1] in ['NOTI', 'INCI', 'DECI']:
                print(f"Error: Unknown instruction {op}")
                exit(1)
                
            opcode = opcodes['ALUI']
            rs = REG[parts[1].upper()]
            rt = REG[parts[2].upper()]
            imm = to_bin(int(parts[3]), 18) 
            func = ALUFunc[op[:-1]]
            opcode = f"{opcode[:2]}{func}"
            instruction = f"{opcode}{rs}{rt}{imm[:18]}"
            
        elif op == 'NOT' or op == 'INC' or op == 'DEC' or op == 'HAM':
            opcode = opcodes['ALU']
            rs = REG[parts[1].upper()]
            rt = REG[parts[2].upper()] if len(parts) > 2 else REG[parts[1].upper()]
            rd = REG['$0']
            func = ALUFunc[op]
            shift = '0000000000'
            instruction = f"{opcode}{rs}{rt}{rd}{shift}{func}"

        elif op in ALUFunc:
            opcode = opcodes['ALU']
            rs = REG[parts[1].upper()]
            rt = REG[parts[2].upper()]
            rd = REG[parts[3].upper()]
            func = ALUFunc[op]
            shift = '0000000000'
            instruction = f"{opcode}{rs}{rt}{rd}{shift}{func}"

        # LD $rs, IMM($rt) or LD $rs, IMM (implicit zero addressing)
        # ST $rs, IMM($rt) or ST $rs, IMM (implicit zero addressing)

        elif op == 'LD' or op == 'ST':
            offset, rt = parts[2].split('(') if '(' in parts[2] else (parts[2], '$0')
            rt = rt.rstrip(')') if '(' in parts[2] else rt

            opcode = opcodes[op]
            rs = REG[parts[1].upper()]
            rt = REG[rt.upper()]
            if offset in data_labels:  offset = data_labels[offset]
            imm = to_bin(int(offset), 18)  
            if (op == 'LD'): instruction = f"{opcode}{rs}{rt}{imm[:18]}"
            else: instruction = f"{opcode}{rt}{rs}{imm[:18]}"

        elif op in ['BMI', 'BPL', 'BZ']:            
            label = parts[2]
            rs = REG[parts[1].upper()]
            rt = REG['$0']
            if label in labels:
                __LABEL_ADDR__ = labels[label]
                offset = __LABEL_ADDR__ - (__GLOBAL_ADDR__ + 1)  
               
            else: raise ValueError(f"Label {label} not found.")
            imm = to_bin(offset & 0x0FFFF, 18)
            opcode = opcodes[op]
            instruction = f"{opcode}{rt}{rs}{imm[:18]}"

        elif op == 'BR':
            label = parts[1]
            if label in labels:
                __LABEL_ADDR__ = labels[label]
                offset = __LABEL_ADDR__ - (__GLOBAL_ADDR__ + 1)

            else: raise ValueError(f"Label {label} not found.")
            imm = to_bin(offset & 0x0FFFFFFF, 26)
            opcode = opcodes[op]
            instruction = f"{opcode}{imm}"

        elif op == 'MOVE':
            opcode = opcodes[op]
            rs = REG[parts[1].upper()]
            rt = REG[parts[2].upper()]
            rd = REG['$0']
            shift = '0000000000'
            func = '0010'
            instruction = f"{opcode}{rs}{rt}{rd}{shift}{func}"

        elif op == 'CMOV':
            opcode = opcodes[op]
            rs = REG[parts[1].upper()]
            rt = REG[parts[2].upper()]
            rd = REG[parts[3].upper()]
            func = '0000'
            shift = '0000000000'
            instruction = f"{opcode}{rs}{rt}{rd}{shift}{func}"

        elif op == 'HALT' or op == 'NOP':
            opcode = opcodes[op]
            addr = '0' * 26
            instruction = f"{opcode}{addr}"
        
        elif op == 'JAL':
            rs = REG['$RA']
            rt = REG['$0']
            opcode1 = opcodes['ALUI']
            opcode2 = opcodes['BR']
            opcode1 = f"{opcode1[:2]}{ALUFunc['ADD']}"

            imm = to_bin(__GLOBAL_ADDR__ + 2, 18)
            pseudoinstr = f"{opcode1}{rs}{rs}{imm[:18]}"
            machine_code.append(pseudoinstr)
            __GLOBAL_ADDR__ += 1
            
            label = parts[1]
            if label in labels:
                __LABEL_ADDR__ = labels[label]
                offset = __LABEL_ADDR__ - (__GLOBAL_ADDR__ + 1)  
             
            else: raise ValueError(f"Label {label} not found.")
            imm = to_bin(offset & 0x0FFFF, 26)
            instruction = f"{opcode2}{imm}"

            
        elif op == "JR":
            rs1 = REG[parts[1].upper()]
            instruction = f"{opcodes[op]}00{rs1}000"


            
        elif op == 'LA':
            rt = REG['$0']
            rs = REG[parts[1].upper()]
            opcode1 = opcodes['ALUI']
            opcode2 = opcodes['ALUI']
            opcode1 = f"{opcode1[:2]}{ALUFunc['LUI']}"
            opcode2 = f"{opcode2[:2]}{ALUFunc['OR']}"

            addr = parts[2]
            if addr in data_labels: addr = data_labels[addr]
            else: raise ValueError(f"Label {addr} not found.")
    
            imm = to_bin(int(addr), 32)
            pseudo = f"{opcode1}{rs}{rt}00{imm[16:]}"
            instruction = f"{opcode2}{rs}{rt}00{imm[:16]}"
            machine_code.append(pseudo)
            __GLOBAL_ADDR__ += 1     
        
        else:
            print(f"Error: Unknown instruction {op}")
            exit(1)

        machine_code.append(instruction)
        __GLOBAL_ADDR__ += 1  

    return machine_code

def main():
    
    lineno = 271
 
    if len(sys.argv) < 2:
        print("Usage: python assembler.py <input_file> [-npp]")
        return
    
    input_file = sys.argv[1]
    with open(input_file, 'r') as f:
        assembly_program = f.readlines()

    
    data_section = []
    text_section = []
    section_map = {'.data': data_section, '.text': text_section}
    current_section = None

    for line in assembly_program:
        line = line.split('#')[0].strip()  
        if line in section_map:
            current_section = section_map[line]
            continue

        if current_section is not None:
            current_section.append(line)
   
    lables, text_section, __GLOBAL_ADDR__ = first_pass(text_section, lineno)
    data_labels, data_instructions = parse_data_section(data_section)
    machine_code = assemble(text_section, lables, data_labels, lineno)


    with open(f"{input_file.split('.')[0]}_instructions.coe", 'w', newline='\n') as out_f:
        out_f.write("memory_initialization_radix = 2;\n")
        out_f.write("memory_initialization_vector = \n")
        for line in machine_code: out_f.write(line.upper() + ',\n')
        out_f.write(machine_code[-1].upper() + ';\n')

    with open(f"{input_file.split('.')[0]}_memory.coe", 'w', newline='\n') as out_f:
        out_f.write("memory_initialization_radix = 2;\n")
        out_f.write("memory_initialization_vector = \n")
        for line in data_instructions: out_f.write(line.upper() + ',\n')
        out_f.write(data_instructions[-1].upper() + ';\n')


if __name__ == '__main__': main()