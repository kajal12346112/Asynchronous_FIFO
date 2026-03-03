# Asynchronous_FIFO
This project implements a parameterized Asynchronous FIFO (First-In-First-Out) in Verilog for safe data transfer between two independent clock domains.
The design solves Clock Domain Crossing (CDC) issues using:
Gray code pointers
Two-flop synchronizers
Dual-port memory
Safe full/empty detection logic

Features
Dual-clock FIFO with separate read and write clocks
Automatic RAM address management and domain crossing
FIFO status outputs: full, empty

Usage
This architecture is widely used in SoCs, AXI bridges, DSP systems, UART, PCIe interfaces, and multi-clock FPGA systems.

