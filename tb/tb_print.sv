`timescale 1ns/1ps

module tb_print;
logic clk;
logic rst;
logic [31:0] pc_debug;
logic [31:0] result_debug;

top #(.HEX_FILE("programs/print.hex")) dut (
    .clk         (clk),
    .rst         (rst),
    .pc_debug    (pc_debug),
    .result_debug(result_debug)
);

initial clk = 1'b0;
always #5 clk = ~clk;

initial begin
    rst = 1'b1;
    #25;
    rst = 1'b0;
    #5000;
    $finish;
end

endmodule
