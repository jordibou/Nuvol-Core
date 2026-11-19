# Register file 

This section describes the functionality of the register file in the core. 
This module contains the 32 32-bit registers specified by RISCV. These registers can be even read or written. The read part consists on two addresses to be read with their corresponding read data outputs. Similarly, the write part has a one address and one data port for the data to write. 

## Ports
The ports in the register file are the following:
| Port name | Direction | Width     | Description   |
|---------- |-----------|----       |-------------  |
| clk_i     | Input     | 1 bit     | System clock  |
| raddr_a_i     | Input     | 5 bits     | Read address for the source register 1  |
| rdata_a_o     | Input     | 32 bits     | Read data for the source register 1  |
| raddr_b_i     | Input     | 5 bits     | Read address for the source register 2|
| rdata_b_o     | Input     | 32 bits     | Read data for the source register 2  |
| waddr_i     | Input     | 5 bits     | Write address for the destination register   |
| wen_i     | Input     | 1 bit     | Write enable for the destination register   |
| wdata_i     | Input     | 32 bits     | Write data for the destination register   |

## Logic
The register files 

## Verification Strategy


## Verification Results


