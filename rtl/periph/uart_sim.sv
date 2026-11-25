module uart_sim (
    input logic       clk,
    input logic       we,
    input logic [7:0] data
);

always_ff @(posedge clk) begin
    if (we)
        $write("%c", data);
end

endmodule
