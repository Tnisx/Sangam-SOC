module regfile (
    input  logic        clk,
    input  logic        rst,
    input  logic        we,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] ddata,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2
);

logic [31:0] regs[32];

assign rdata1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
assign rdata2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

always_ff @(posedge clk) begin
    if (rst) begin
        regs <= '{default: 32'd0};
    end else if (we && (rd != 5'd0)) begin
        regs[rd] <= ddata;
    end
end

endmodule
