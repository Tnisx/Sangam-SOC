`include "cpu_defs.svh"

module top #(
    parameter string HEX_FILE = "programs/print.hex"
) (
    input  logic        clk,
    input  logic        rst,
    output logic [31:0] pc_debug,
    output logic [31:0] result_debug
);

logic        zero;
logic [31:0] result;
logic [31:0] rdata1, rdata2, imm_ext;
logic [31:0] mem_rdata;
ctrl_t       ctrl;

logic [31:0] pc, pc_next, pc_4;
logic        branch_taken;
logic [31:0] auipc_val;
logic [31:0] csr_rdata;
logic [31:0] mtvec;
logic [31:0] mepc;
logic        uart_en;
logic [31:0] instr;
logic        branch_cond;

assign pc_4      = pc + 32'd4;
assign auipc_val = pc + imm_ext;

instr_mem #(
    .HEX_FILE(HEX_FILE)
) topinstr (
    .clk  (clk),
    .we   (ctrl.mem_write & ~uart_en),
    .waddr(result),
    .wdata(rdata2),
    .lsmem(ctrl.lsmem),
    .addr (pc),
    .instr(instr)
);

imm_gen topgen (
    .instr  (instr),
    .imm_ext(imm_ext)
);

control_unit topcu (
    .opcode  (instr[6:0]),
    .funct3  (instr[14:12]),
    .funct7_6(instr[30]),
    .funct12 (instr[31:20]),
    .ctrl    (ctrl)
);

regfile topreg (
    .clk   (clk),
    .rst   (rst),
    .we    (ctrl.we),
    .rs1   (instr[19:15]),
    .rs2   (instr[24:20]),
    .rd    (instr[11:7]),
    .ddata (ctrl.csr_en     ? csr_rdata :
            (ctrl.jal || ctrl.jalr) ? pc_4 :
            ctrl.lui        ? imm_ext :
            ctrl.auipc      ? auipc_val :
            ctrl.mem_to_reg ? mem_rdata : result),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

alu topalu (
    .a     (rdata1),
    .b     (ctrl.alu_src ? imm_ext : rdata2),
    .op    (ctrl.alu_op),
    .result(result),
    .zero  (zero)
);

data_mem topdata (
    .clk         (clk),
    .mem_write   (ctrl.mem_write & ~uart_en),
    .addr        (result),
    .wdata       (rdata2),
    .lsmem       (ctrl.lsmem),
    .lsmem_signed(ctrl.lsmem_signed),
    .rdata       (mem_rdata)
);

pc_reg toppc (
    .clk    (clk),
    .rst    (rst),
    .pc_next(pc_next),
    .pc     (pc)
);

branch_man topbranch (
    .in         (instr[14:12]),
    .zero       (zero),
    .result     (result[0]),
    .branch_cond(branch_cond)
);

csr topcsr (
    .clk      (clk),
    .rst      (rst),
    .csr_addr (instr[31:20]),
    .funct3_lo(instr[13:12]),
    .csr_en   (ctrl.csr_en),
    .ecall    (ctrl.ecall),
    .mret     (ctrl.mret),
    .ebreak   (ctrl.ebreak),
    .pc       (pc),
    .csr_wdata(instr[14] == 1'b0 ? rdata1 : {27'b0, instr[19:15]}),
    .rs1_x0   (instr[19:15] == 5'd0),
    .csr_rdata(csr_rdata),
    .mtvec    (mtvec),
    .mepc     (mepc)
);

addr_decode topaddec (
    .addr   (result),
    .uart_en(uart_en)
);

uart_sim topuart (
    .clk (clk),
    .we  (ctrl.mem_write & uart_en),
    .data(rdata2[7:0])
);

assign branch_taken = ctrl.branch & branch_cond;

always_comb begin
    if (ctrl.jal)
        pc_next = pc + imm_ext;
    else if (ctrl.jalr)
        pc_next = {result[31:1], 1'b0};
    else if (branch_taken)
        pc_next = pc + imm_ext;
    else if (ctrl.ecall | ctrl.ebreak)
        pc_next = mtvec;
    else if (ctrl.mret)
        pc_next = mepc;
    else
        pc_next = pc + 32'd4;
end

assign pc_debug     = pc;
assign result_debug = result;

endmodule
