`timescale 1ns/1ps

module tb_fibonacci;

logic clk;
logic rst;
logic [31:0] pc_debug;
logic [31:0] result_debug;

top #(.HEX_FILE("programs/fibonacci.hex")) dut (
    .clk         (clk),
    .rst         (rst),
    .pc_debug    (pc_debug),
    .result_debug(result_debug)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("sim/fibonacci.vcd");
    $dumpvars(0, tb_fibonacci);

    clk = 1'b0;
    rst = 1'b1;
    #50;
    rst = 1'b0;

    #900;

    $display("Fibonacci Sequence:");
    for (int i = 0; i < 10; i = i + 1) begin
        logic [31:0] word;
        word = {dut.topdata.ram[i*4+3], dut.topdata.ram[i*4+2],
                dut.topdata.ram[i*4+1], dut.topdata.ram[i*4]};
        $display("FS[%0d] = %0d", i, word);
    end
    $finish;
end

endmodule
