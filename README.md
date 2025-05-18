# Image Enhancement by Brightness and Contrast Manipulation using Verilog

## 📌 Overview
This project implements real-time image enhancement techniques (brightness adjustment, contrast manipulation, thresholding, and inversion) using Verilog HDL for FPGA platforms. The system processes bitmap images in hexadecimal format and outputs enhanced images with improved visual quality, targeting applications in surveillance, smart cities, and industrial inspection.

## 🎯 Key Features
- **Real-time Processing**: Achieves >30 FPS for VGA (640x480) resolution.
- **Low Hardware Complexity**: Uses fixed-point arithmetic and pipelined architecture.
- **Multiple Operations**:
  - Brightness addition/subtraction
  - Contrast adjustment
  - Image inversion
  - Thresholding
- **SDG-11 Alignment**: Supports sustainable urban development through enhanced surveillance and traffic management.

## 🛠️ Hardware/Software Tools
| Tool                 | Specification                          |
|----------------------|----------------------------------------|
| Programming Language | Verilog HDL                            |
| Simulation Tool      | ModelSim (Intel FPGA Starter Edition)  |
| Input Format         | Hexadecimal (.hex)                     |
| Output Format        | Bitmap (.bmp)                          |
| Target FPGA          | Mid-range (e.g., Artix-7, Spartan-6)   |

## 📂 Project Structure
Project_Verilog/
├── docs/ # Project report and documentation
├── src/
│ ├── parameter.v # Configuration parameters
│ ├── image_read.v # Image input and processing module
│ ├── image_write.v # Output image generation module
│ └── tb_simulation.v # Testbench for verification
├── images/ # Sample input/output images
├── results/ # Synthesis reports and timing analysis
└── README.md # This file
