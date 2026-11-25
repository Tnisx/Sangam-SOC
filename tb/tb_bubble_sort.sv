`timescale 1ns/1ps

module tb_bubble_sort;

logic clk;
logic rst;
logic [31:0] pc_debug;
logic [31:0] result_debug;

localparam int N = 8;

top #(.HEX_FILE("programs/bubble_sort.hex")) dut (
    .clk         (clk),
    .rst         (rst),
    .pc_debug    (pc_debug),
    .result_debug(result_debug)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst = 1'b1;
    #50;
    rst = 1'b0;
end

initial begin
    $dumpfile("sim/bubble_sort.vcd");
    $dumpvars(0, tb_bubble_sort);
end

logic [31:0] pc_prev;
int          stable_count;

initial begin
    stable_count = 0;
    pc_prev      = 32'hFFFF_FFFF;

    @(negedge rst);

    forever begin
        @(posedge clk);
        if (dut.pc === pc_prev)
            stable_count++;
        else
            stable_count = 0;

        pc_prev = dut.pc;

        if (stable_count == 3) begin
            $display("[%0t] pc stable at 0x%0h -> program finished", $time, dut.pc);
            check_results();
            $finish;
        end
    end
end

initial begin
    #100_000;
    $display("[%0t] TIMEOUT: never reached done_sort loop", $time);
    $finish;
end

task automatic check_results();
    logic [31:0] arr [0:N-1];
    bit          sorted;
    begin
        sorted = 1'b1;
        for (int i = 0; i < N; i++) begin
            arr[i] = { dut.topdata.ram[i*4+3], dut.topdata.ram[i*4+2],
                       dut.topdata.ram[i*4+1], dut.topdata.ram[i*4+0] };
            $display("  arr[%0d] = %0d", i, arr[i]);
        end

        for (int i = 0; i < N-1; i++) begin
            if (arr[i] > arr[i+1])
                sorted = 1'b0;
        end

        if (sorted)
            $display("PASS: array is sorted in ascending order");
        else
            $display("FAIL: array is NOT sorted");
    end
endtask

endmodule
