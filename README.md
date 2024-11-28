
# Processor Design and FPGA Deployment Guide

This guide outlines the detailed steps required to set up, simulate, and deploy the processor design using Vivado and FPGA. Follow the instructions step-by-step for a seamless workflow.

---

## **SETUP PROCESS**

### 1. **Create Instruction Memory and Data Memory**
- Open **Vivado** and create a new project.
- Use the **IP Catalog** feature:
  - Navigate to the **Memory & Storage Elements** category.
  - Select **Block Memory Generator**.
  - Refer the Memory folder for exact configurations of both BRAM generated
  - Configure two separate memories: **Instruction Memory** and **Data Memory**.
  - Ensure that both memories have the required address widths and data widths.

---

### 2. **Add Datapath Modules**
- Copy all Verilog modules from the `DataPath` folder into the Vivado project:
- For each module:
  - Open and review its interface (inputs, outputs, and parameter declarations).
  - Ensure no naming conflicts between modules.
  - Add testbenches (if not already provided) to verify their standalone functionality.
  - Check that wires between modules (e.g., ALU output to register bank input) are logically correct.

---

### 3. **Add Control Unit Modules**
- Copy the `Control Unit` and `Branch Control` Verilog files into the project:
  - **Control Unit**: Responsible for generating control signals based on instruction opcodes.
  - **Branch Control**: Handles branching and jump operations.
  - Use individual testbenches to validate signal generation for various instructions.

---

### 4. **Integrate Processor**
- Copy the `Processor.v` file into the project.
- Steps to integrate:
  - Include connections to both the `DataPath` and `ControlPath` modules.
  - Ensure input clock and reset signals are correctly routed.
  - If the design involves hierarchical modules, verify module instantiations in `Processor.v`.
  - Set as the **Top Module**, navigate to **Project Settings** > **Top Module** and select `Processor.v`.
  - Run initial synthesis to check for unresolved ports or errors.

---

### 5. **Write Assembly Code**
- Open the `instruction.s` file for reference.
- Guidelines for writing assembly:
  - Follow instruction formats and opcodes as defined in the ISA.
  - Use comments to annotate each instruction for clarity.
  - Avoid syntax errors by using the correct labels and delimiters.
  - Cross-check assembly code with the provided ISA documentation to ensure correctness.

---

### 6. **Generate `.coe` Files**
  - Use the `assembler.py` script to convert the assembly code into `.coe` files:
  - Command: 
    ```bash
    python3 assembler.py <input_file.s>
    ```
  - Verify that the input `.s` file is in the same directory as `assembler.py`.
  - Check the output `.coe` files for errors or missing values.
  - If the `.coe` file is incorrect, revisit the assembly code and correct errors.

---

### 7. **Update Memory Modules**
- Load the `.coe` files into the Instruction Memory and Data Memory modules:
  - Open each BRAM instance in Vivado.
  - Navigate to the **Initialization File** section.
  - Replace the existing file (if any) with the generated `.coe` file.
- Verify:
  - Each memory module has been updated with the correct `.coe` file.
  - Perform a test synthesis to confirm proper initialization.

---

### 8. **Simulation Setup**
- Simulate the integrated processor design:
  - Add a testbench to the `Processor.v` file.
  - Include realistic input stimuli (e.g., instruction sequences, initial data values).
- Use Vivado’s simulation tools:
  - Check for correct control signal generation.
  - Verify datapath functionality (e.g., ALU operations, memory accesses).
- Debug:
  - Trace signals to identify mismatches between expected and observed behavior.
  - Fix any logic errors before moving to FPGA deployment.

---

### 9. **Add FPGA Wrapper**
- Copy the `FPGA_Wrapper.v` file into the project.
- Role of the wrapper:
  - Maps internal processor signals to FPGA I/O pins.
  - Adds any necessary interfacing logic.
  - Ensure all FPGA pins are defined as inputs/outputs in the wrapper.

---

### 10. **Add Constraints File**
- Write and include the `FPGA_XDC.xdc` constraints file:
  - Map FPGA pins to physical board pins (e.g., clock, reset, I/O signals).
  - Ensure Pin mappings match the FPGA board specifications.
---

### 11. **Run Synthesis, Implementation, and Generate Bitstream**
- Steps in Vivado:
  - **Synthesis**: Convert Verilog code into gate-level representation.
  - **Implementation**: Map synthesized design onto the FPGA’s physical resources.
  - **Generate Bitstream**: Create a file to program the FPGA.
  - Monitor logs for errors or critical warnings.

---

### 12. **Program the FPGA**
- Open Vivado’s **Hardware Manager**.
- Connect to the FPGA board:
  - Ensure the board is powered and connected via USB/JTAG.
  - Select the generated bitstream file and upload it to the FPGA.
  - Verify successful programming through Vivado.

---

### 13. **Observe Outputs**
- Use FPGA input pins to select outputs for observation:
  - `0000` → Current value from the **ALUOut PIPO Module**.
  - `0001` to `1111` → Value stored in the **Register Bank** at the respective index.
  - If outputs are incorrect, revisit the control signals and datapath connections.

---

## **FILE DESCRIPTIONS**

### Folders
- **DataPath**: Contains Verilog modules for the datapath design.
- **ControlPath**: Contains Verilog modules for the control unit.

### Key Files
- **Processor.v**: Top module for integrating the design.
- **FPGA_Wrapper.v**: Wrapper module for FPGA implementation.
- **FPGA_XDC.xdc**: Constraints file for FPGA pin mapping.
- **assembler.py**: Python script to convert assembly code into `.coe` files.

---

## **NOTES**
- Always validate individual modules before integration.
- Use Vivado's debugging tools to trace signal propagation and resolve issues.
- Document observed outputs for post-deployment analysis.

--- 
