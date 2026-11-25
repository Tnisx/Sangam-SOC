`timescale 1ns/1ps

module tb_regfile;

logic        clk;
logic        rst;
logic        we;
logic [4:0]  rs1;
logic [4:0]  rs2;
logic [4:0]  rd;
logic [31:0] ddata;
logic [31:0] rdata1;
logic [31:0] rdata2;

regfile dut (
    .clk   (clk),
    .rst   (rst),
    .we    (we),
    .rs1   (rs1),
    .rs2   (rs2),
    .rd    (rd),
    .ddata (ddata),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst = 1'b1;
    we  = 1'b0;
    rs1 = 5'd0;
    rs2 = 5'd0;
    rd  = 5'd0;
    ddata = 32'd0;
    #10;
    rst = 1'b0;

    @(posedge clk);
    we    = 1'b1;
    rd    = 5'd1;
    ddata = 32'd5;

    @(posedge clk);
    we  = 1'b0;
    rs1 = 5'd1;
    #1;
    $display("x%0d = %0d", rs1, rdata1);

    @(posedge clk);
    we    = 1'b1;
    rd    = 5'd2;
    ddata = 32'd6;

    @(posedge clk);
    we  = 1'b0;
    rs2 = 5'd2;
    #1;
    $display("x%0d = %0d", rs2, rdata2);

    $finish;
end

endmodule
