module instr_mem #(
    parameter string HEX_FILE = "programs/print.hex"
) (
    input  logic        clk,
    input  logic        we,
/* verilator lint_off UNUSEDSIGNAL */
    input  logic [31:0] waddr,
/* verilator lint_on UNUSEDSIGNAL */
    input  logic [31:0] wdata,
    input  logic [1:0]  lsmem,
/* verilator lint_off UNUSEDSIGNAL */
    input  logic [31:0] addr,
/* verilator lint_on UNUSEDSIGNAL */
    output logic [31:0] instr
);

localparam int DEPTH = 4096;
localparam int WIDTH = $clog2(DEPTH);

logic [31:0] mem[0:DEPTH-1];
string hex_path;

initial begin
    if (!$value$plusargs("HEX=%s", hex_path))
        hex_path = HEX_FILE;
    $readmemh(hex_path, mem);
end

always_ff @(posedge clk) begin
    if (we) begin
        case (lsmem)
            2'b01: begin
                case (waddr[1:0])
                    2'b00: mem[waddr[WIDTH+1:2]][7:0]   <= wdata[7:0];
                    2'b01: mem[waddr[WIDTH+1:2]][15:8]  <= wdata[7:0];
                    2'b10: mem[waddr[WIDTH+1:2]][23:16] <= wdata[7:0];
                    2'b11: mem[waddr[WIDTH+1:2]][31:24] <= wdata[7:0];
                endcase
            end
            2'b10: begin
                if (waddr[1])
                    mem[waddr[WIDTH+1:2]][31:16] <= wdata[15:0];
                else
                    mem[waddr[WIDTH+1:2]][15:0]  <= wdata[15:0];
            end
            2'b11: mem[waddr[WIDTH+1:2]] <= wdata;
            default: ;
        endcase
    end
end

assign instr = mem[addr[WIDTH+1:2]];

endmodule
