# RICSV-CPU
Single-stroke processor core with risc-v architecture and rv32I command support on System Verilog

1. To integrate a project into a file .xpr change the path variable by specifying your path to the project files
2. The ILA IP module is necessary for testing the FPGA configuration at the hardware level. If you are not going to use the debugging board, ignore this module.
3. The constraints file was implemented for additional hardware experiments. You can safely ignore it (perhaps in the future I will either add it or remove it from the project)
4. Everything about hardware testing in the source code has an FPGA comment. For simulation, you can ignore these code blocks, although they should not cause any problems.
