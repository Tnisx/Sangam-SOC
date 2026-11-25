`timescale 1ns/1ps

module tb_sum;

logic clk;
logic rst;
logic [31:0] pc_debug;
logic [31:0] result_debug;

top #(.HEX_FILE("programs/sum.hex")) dut (
    .clk         (clk),
    .rst         (rst),
    .pc_debug    (pc_debug),
    .result_debug(result_debug)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("sim/sum.vcd");
    $dumpvars(0, tb_sum);

    clk = 1'b0;
    rst = 1'b1;
    #12;
    rst = 1'b0;

    #700;

    $display("Final: x8 (sum) = %0d, x9 (bound) = %0d, x19 (i) = %0d",
             dut.topreg.regs[8], dut.topreg.regs[9], dut.topreg.regs[19]);

    if (dut.topreg.regs[8] == 210)
        $display("PASS: sum 1..20 = 210");
    else
        $display("FAIL: expected 210, got %0d", dut.topreg.regs[8]);

    $finish;
end

endmodule
