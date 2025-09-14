# 🚀 MiniMIPS - RISC Processor Design and FPGA Deployment Guide 

[![Made with Verilog](https://img.shields.io/badge/Made%20with-Verilog-blue.svg)]()  [![Vivado Tested](https://img.shields.io/badge/Tested%20on-Xilinx%20Vivado-green)]()  [![License](https://img.shields.io/badge/License-MIT-yellow.svg)]()  

**MiniMIPS** is a compact and efficient **RISC (Reduced Instruction Set Computer)** processor inspired by the **MIPS architecture**.  
This project was developed as part of the **Computer Organisation and Architecture Lab [CS39001]** course.  

It provides a **step-by-step workflow** for:  
✔️ Designing in **Verilog**  
✔️ Simulating in **Vivado**  
✔️ Deploying on **FPGA**

---

## 📑 Table of Contents
- [Overview](#overview)  
- [Datapath](#datapath)  
- [Setup Process](#setup-process)  
- [File Descriptions](#file-descriptions)  
- [Prerequisites](#prerequisites)  
- [How to Run](#how-to-run)  
- [Contributing](#contributing)  
- [License](#license)  

---

## 🔎 Overview
MiniMIPS implements a simplified ISA (Instruction Set Architecture) with a modular design philosophy.  
It consists of a **datapath**, **control unit**, and **memory modules**, all integrated into a top-level processor that can be deployed on an FPGA.

---

## 📊 Datapath
The datapath structure of MiniMIPS:

![Datapath](https://raw.githubusercontent.com/Ecolash/Computer-Organisation-Architecture/main/Verilog-%20RISC%20ISA%20Design/P2%20-%20Design%20Specifications/Datapath.png)

---

## ⚙️ Setup Process

### 1. Create Instruction & Data Memory
- Open **Vivado** → create project → add **Block Memory Generator** (BRAM).  
- Configure **Instruction Memory** & **Data Memory**.  
- Add wrappers: `BRAM_Data.v` and `BRAM_Instructions.v`.  

---

### 2. Add Datapath Modules
- Copy all modules from `DataPath/`.  
- Verify **interfaces**, check **signal connectivity**, and run **testbenches**.  

---

### 3. Add Control Unit
- Import `Control Unit` & `Branch Control`.  
- Validate **opcode decoding** and **branch logic**.  

---

### 4. Integrate Processor
- Add `Processor.v` → connect datapath & control.  
- Set as **Top Module**.  
- Run **initial synthesis**.  

---

### 5. Write Assembly Code
- Reference: `instruction.s`.  
- Follow **ISA format**, comment instructions, and validate against ISA doc.  

---

### 6. Generate `.coe` Files
```bash
python3 assembler.py <input_file.s>
```
- Produces `.coe` for memory initialization.  

---

### 7. Load Memory Modules
- Assign `.coe` files to BRAMs in Vivado.  
- Re-run synthesis.  

---

### 8. Simulation
- Add testbench for `Processor.v`.  
- Verify **control signals**, **ALU operations**, **memory access**.  

---

### 9. FPGA Wrapper
- Add `FPGA_Wrapper.v`.  
- Map processor I/O to FPGA pins.  

---

### 10. Add Constraints
- Define pins in `FPGA_XDC.xdc`.  

---

### 11. Build Flow
- Run **Synthesis → Implementation → Bitstream generation**.  

---

### 12. Program FPGA
- Connect board via USB/JTAG.  
- Upload `.bit` using Vivado.  

---

### 13. Debug & Observe
- Input select pins → view ALU output or register bank.  
- Debug incorrect outputs by rechecking **signals & control logic**.  

---

## 📂 File Descriptions
| Folder / File | Description |
|---------------|-------------|
| `DataPath/`   | Verilog modules for datapath |
| `ControlPath/`| Verilog control unit modules |
| `Memory/`     | BRAM configurations |
| `Processor.v` | Top-level integration |
| `FPGA_Wrapper.v` | FPGA wrapper |
| `FPGA_XDC.xdc` | FPGA pin constraints |
| `assembler.py` | Assembly → `.coe` converter |

---

## 🛠️ Prerequisites
- **Xilinx Vivado** (tested on 2020.2+)  
- **FPGA Board** (e.g., Xilinx Artix-7 / Basys-3)  
- **Python 3.8+** (for assembler)  

---

## ▶️ How to Run
1. Clone repo:
   ```bash
   git clone https://github.com/<your-username>/<your-repo>.git
   ```
2. Open Vivado → Import all Verilog files.  
3. Run steps from [Setup Process](#setup-process).  
4. Program FPGA → test assembly code execution.  

---

## 🤝 Contributing
Pull requests are welcome!  
For major changes, open an issue first to discuss your ideas.  

---

## 📜 License
This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.
