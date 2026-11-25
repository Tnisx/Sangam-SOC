module data_mem (
    input  logic        clk,
    input  logic        mem_write,
/* verilator lint_off UNUSEDSIGNAL */
    input  logic [31:0] addr,
/* verilator lint_on UNUSEDSIGNAL */
    input  logic [31:0] wdata,
    input  logic [1:0]  lsmem,
    input  logic        lsmem_signed,
    output logic [31:0] rdata
);

localparam int DEPTH = 16384;
localparam int AW    = $clog2(DEPTH);

logic [7:0]    ram [0:DEPTH-1];
logic [AW-1:0] a0, a1, a2, a3;

assign a0 = addr[AW-1:0];
assign a1 = a0 + AW'(1);
assign a2 = a0 + AW'(2);
assign a3 = a0 + AW'(3);

always_ff @(posedge clk) begin
    if (mem_write) begin
        case (lsmem)
            2'b01: ram[a0] <= wdata[7:0];
            2'b10: begin
                ram[a0] <= wdata[7:0];
                ram[a1] <= wdata[15:8];
            end
            2'b11: begin
                ram[a0] <= wdata[7:0];
                ram[a1] <= wdata[15:8];
                ram[a2] <= wdata[23:16];
                ram[a3] <= wdata[31:24];
            end
            default: ;
        endcase
    end
end

always_comb begin
    case (lsmem)
        2'b01:   rdata = lsmem_signed ? {{24{ram[a0][7]}}, ram[a0]} : {24'b0, ram[a0]};
        2'b10:   rdata = lsmem_signed ? {{16{ram[a1][7]}}, ram[a1], ram[a0]} : {16'b0, ram[a1], ram[a0]};
        2'b11:   rdata = {ram[a3], ram[a2], ram[a1], ram[a0]};
        default: rdata = 32'b0;
    endcase
end

endmodule
