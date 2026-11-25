# Sangam-SoC

A RISC-V SoC project targeting a 5-stage pipelined RV64I processor and an integrated GPU, built iteratively from a working RV32I single-cycle core.

## Current Status

**Working**
- RV32I base integer ISA: **42 / 42** `rv32ui` tests pass under Verilator
- Zicsr (`csrrw`, `csrrs`, `csrrc` and immediate variants)
- Basic M-mode traps (`ecall`, `ebreak`, `mret`) with `mtvec`, `mepc`, `mcause`, `mtval`, `mscratch`, `mstatus`
- Memory-mapped simulation UART at `0x10000000`
- Verilator `-Wall` lint clean

**In Progress / Not Done Yet**
- `rv32mi` compliance: currently 11/16 pass; missing `misa`, `mhartid`, `mcycle`, `minstret`, `mie`/`mip`, plus illegal-instruction and misaligned-fetch traps
- Unified word-organized RAM with byte-enables (`wstrb`) and `valid`/`stall` handshake
- RV64I (`XLEN=64`, `ld`/`lwu`/`sd`, W-ops, 6-bit shifts)
- 5-stage pipeline (`IF/ID/EX/MEM/WB`, forwarding, load-use stall, branch flush)
- GPU ISA spec and simulator model

## Repository Structure

```
.
├── rtl/
│   ├── include/
│   │   └── cpu_defs.svh       # Shared types (alu_op_t, ctrl_t)
│   ├── core/
│   │   ├── top.sv             # Top-level datapath
│   │   ├── pc_reg.sv
│   │   ├── control_unit.sv
│   │   ├── imm_gen.sv
│   │   ├── regfile.sv
│   │   ├── alu.sv
│   │   ├── branch_man.sv
│   │   └── csr.sv
│   ├── mem/
│   │   ├── instr_mem.sv
│   │   ├── data_mem.sv
│   │   └── addr_decode.sv
│   └── periph/
│       └── uart_sim.sv        # Console UART for simulation
├── tb/                        # SystemVerilog testbenches
├── programs/                  # Assembly sources and .hex images
├── docs/                      # Roadmap and architecture notes
├── gpu/                       # GPU spec and model workspace
└── Makefile
```

## Memory Map (Current RV32I Baseline)

| Address | Device |
|---|---|
| `0x00000000` - `0x00003FFF` | Instruction / Data RAM (16 KiB) |
| `0x10000000` | Simulated UART TX |

*(Target memory map for RV64I spec freeze: RAM at `0x80000000`, UART at `0x10000000`.)*

## Running Lint & Simulation

```bash
make lint          # Verilator -Wall lint check
make sim-print     # Hello World over simulated UART (Icarus Verilog)
make sim-sum       # Sum 1..20 testbench
make sim-fib       # Fibonacci sequence testbench
make sim-sort      # Bubble sort testbench
```

Note: Icarus Verilog 13.0 may fail on packed structs (`ctrl_t`) in `cpu_defs.svh`; Verilator or Vivado XSim is recommended for full simulation.

## Roadmap

See [docs/roadmap.md](docs/roadmap.md) and [docs/sangam-rv64i-pipeline-roadmap.md.pdf](docs/sangam-rv64i-pipeline-roadmap.md.pdf) for the staged plan to `v0.2-rv64i` (March 16, 2027) and the subsequent M-extension, caches, and GPU integration.
