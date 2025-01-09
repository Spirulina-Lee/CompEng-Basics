# **FPGA Labs - SystemVerilog**
> **Course 课程**: EE310  
> **University 大学**: Northern Arizona University  

This repository contains the labs, assignments, and past exam materials for the EE310 course, focusing on FPGA development using the Intel 5CSMA5F31C6 FPGA board and SystemVerilog programming.  
本仓库包含 EE310 课程的实验、作业以及往年考试资料，重点是使用 Intel 5CSMA5F31C6 FPGA 开发板和 SystemVerilog 语言进行开发。

---

## Repository Structure 仓库结构
- **Exam 考试资料**: Includes past exam papers and resources provided by senior Yixin Wang for review.  
  包含往年考试卷子和学长 Yixin Wang 提供的复习资料。
- **Lab1 - Lab8 实验**: Source code, test benches, and simulation files for all lab exercises.  
  包括所有实验的源代码、测试代码和仿真文件。
- **Project 课程项目**: The final course project, including design files, reports, and documentation.  
  包含最终课程项目的设计文件、报告和文档。
- **Pin Information 管脚信息**: Text files specifying the pin mappings and configurations for the FPGA board.  
  包含 FPGA 开发板的管脚映射和配置的文本文件。

---

## Intel 5CSMA5F31C6 FPGA Overview Intel 5CSMA5F31C6 FPGA 概述
The Intel 5CSMA5F31C6 is an FPGA from the Cyclone V series, providing high performance and low power consumption. It is commonly used in embedded systems and digital design applications.  
Intel 5CSMA5F31C6 是 Cyclone V 系列的 FPGA，提供高性能和低功耗，广泛用于嵌入式系统和数字设计应用。

---

## Getting Started 入门
To use this repository, ensure you have access to:  
使用本仓库前，请确保您具备以下工具：
- **Intel 5CSMA5F31C6 FPGA Development Board**  
  Intel 5CSMA5F31C6 FPGA 开发板
- **Intel Quartus Prime** or another compatible IDE for FPGA development  
  或其他兼容 FPGA 开发的 IDE

---

### Cloning the Repository 克隆仓库
1. Open your terminal and run the following command:  
   打开终端并运行以下命令：
   ```bash
   git clone https://github.com/Spirulina-Lee/CompEng-Basics.git
   ```
2. Alternatively, click the Code button, then Download ZIP to download all files without needing Git.
> ***可能需要科学的网络环境***

### Running Code 运行代码
1. Import the project into Intel Quartus Prime.
将项目导入 Intel Quartus Prime。
2. Compile and synthesize the SystemVerilog code.
编译并综合 SystemVerilog 代码。
3. Upload the generated bitstream file to the FPGA board.
将生成的比特流文件上传到 FPGA 开发板。
4. Follow the instructions in each lab report or project documentation for specific configurations and tests.
根据每个实验报告或项目文档中的说明进行特定的配置和测试。


## 贡献指南

欢迎贡献！如果你有改进建议或希望添加更多课程内容，请按照以下步骤操作：

1. Fork 此仓库。
2. 创建一个新分支（`git checkout -b feature-name`）。
3. 提交你的更改（`git commit -m '添加某功能'`）。
4. 推送到该分支（`git push origin feature-name`）。
5. 提交一个 Pull Request。
