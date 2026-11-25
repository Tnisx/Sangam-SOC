# Sangam: RV64I Pipeline Roadmap (to Mar 16, 2027)

Goal: an RV64I 5-stage pipelined CPU built from the existing RV32I single-cycle core by Mar 16, 2027, followed by the M extension, caches, bus, and GPU integration.

## Phases

| Dates | Weeks | Goal | Exit Criterion |
|---|---|---|---|
| Nov 20 - Dec 8 | 2.5 | Test harness on RV32I: Verilator/Icarus flow, `riscv-tests`, Spike trace comparison, missing CSRs (`misa`, `mhartid`, `mcycle`, `minstret`, `mie`/`mip`) | RV32 `rv32ui` and `rv32mi` pass; one-command harness |
| Dec 9 - Dec 22 | 2 | Spec freeze: pipeline diagram, interface signals, memory map (RAM at `0x8000_0000`, UART at `0x1000_0000`), trap rules, CI, riscv64 toolchain & linker script | Spec reviewed by all 4 members; CI green |
| Dec 23 - Jan 12 | 3 | RV64I single-cycle: parameterize `XLEN`, `LD`/`LWU`/`SD`, W-ops, 6-bit shifts, 64-bit CSRs and `ctrl_t` | `rv64ui` passes; RV32 passes with `XLEN=32` |
| Jan 13 - Feb 9 | 4 | 5-stage pipeline: IF/ID/EX/MEM/WB, EX/MEM & MEM/WB forwarding, 1-cycle load-use stall, EX branch resolution (2-cycle flush), synchronous memories | `rv64ui` passes on pipeline; trace matches Spike |
| Feb 10 - Mar 2 | 3 | Traps and memory: precise commit exceptions, illegal/misaligned traps, `ecall`/`ebreak`/`mret`, UART status register, shared RAM with I/D arbiter & stalls | `rv64mi` passes; C "Hello Sangam" prints over UART |
| Mar 3 - Mar 16 | 2 | Hardening: CI regression, CPI benchmark, Yosys + OpenSTA area/frequency, README block diagram & waveforms, release tag | Tag `v0.2-rv64i` with results table |

## Team Split

- **Pipeline lead:** core datapath and hazards
- **Verification lead:** test harness, `riscv-tests`, Spike trace comparison
- **Memory & SoC lead:** memory map, I/D arbiter, UART, bus interface
- **GPU lead:** GPU ISA spec and simulator-level model in `gpu/`
