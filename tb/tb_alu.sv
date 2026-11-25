`timescale 1ns/1ps
`include "cpu_defs.svh"

module tb_alu;

logic [31:0] a, b;
alu_op_t     op;
logic [31:0] result;
logic        clk;
logic        zero;

alu dut (
    .a     (a),
    .b     (b),
    .op    (op),
    .result(result),
    .zero  (zero)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    op  = ALU_ADD;
    a   = 32'd0;
    b   = 32'd0;
    #10;

    @(posedge clk);
    op = ALU_ADD; a = 32'd2; b = 32'd4;
    #1;
    $display("ADD: %0d", result);

    @(posedge clk);
    op = ALU_SUB; a = 32'd10; b = 32'd4;
    #1;
    $display("SUB: %0d", result);

    @(posedge clk);
    op = ALU_OR; a = 32'd2; b = 32'd4;
    #1;
    $display("OR:  %0d", result);

    @(posedge clk);
    op = ALU_AND; a = 32'd2; b = 32'd4;
    #1;
    $display("AND: %0d", result);

    #10;
    $finish;
end

endmodule
