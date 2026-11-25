RTL_INC := rtl/include
RTL_SRCS := \
	rtl/core/pc_reg.sv \
	rtl/core/control_unit.sv \
	rtl/core/imm_gen.sv \
	rtl/core/regfile.sv \
	rtl/core/alu.sv \
	rtl/core/branch_man.sv \
	rtl/core/csr.sv \
	rtl/core/top.sv \
	rtl/mem/instr_mem.sv \
	rtl/mem/data_mem.sv \
	rtl/mem/addr_decode.sv \
	rtl/periph/uart_sim.sv

.PHONY: lint clean sim-print sim-sum sim-fib sim-sort

lint:
	verilator --lint-only -Wall -I$(RTL_INC) $(RTL_SRCS) --top-module top

sim-print:
	mkdir -p sim
	iverilog -g2012 -I$(RTL_INC) -o sim/print.vvp $(RTL_SRCS) tb/tb_print.sv
	vvp sim/print.vvp

sim-sum:
	mkdir -p sim
	iverilog -g2012 -I$(RTL_INC) -o sim/sum.vvp $(RTL_SRCS) tb/tb_sum.sv
	vvp sim/sum.vvp

sim-fib:
	mkdir -p sim
	iverilog -g2012 -I$(RTL_INC) -o sim/fib.vvp $(RTL_SRCS) tb/tb_fibonacci.sv
	vvp sim/fib.vvp

sim-sort:
	mkdir -p sim
	iverilog -g2012 -I$(RTL_INC) -o sim/sort.vvp $(RTL_SRCS) tb/tb_bubble_sort.sv
	vvp sim/sort.vvp

clean:
	rm -rf sim/*.vvp sim/*.vcd obj_dir
