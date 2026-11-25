module csr (
    input  logic        clk,
    input  logic        rst,
    input  logic [11:0] csr_addr,
    input  logic [1:0]  funct3_lo,
    input  logic        csr_en,
    input  logic        ecall,
    input  logic        mret,
    input  logic        ebreak,
    input  logic [31:0] pc,
    input  logic [31:0] csr_wdata,
    input  logic        rs1_x0,
    output logic [31:0] csr_rdata,
    output logic [31:0] mtvec,
    output logic [31:0] mepc
);

logic [31:0] mscratch;
logic [31:0] mcause;
logic [31:0] mtval;
logic [31:0] mstatus;
logic [31:0] csr_new;
logic        mie;
logic        mpie;
logic        csr_we;

assign csr_we = csr_en && !(funct3_lo[1] && rs1_x0);

always_comb begin
    case (funct3_lo)
        2'b01:   csr_new = csr_wdata;
        2'b10:   csr_new = csr_rdata | csr_wdata;
        2'b11:   csr_new = csr_rdata & (~csr_wdata);
        default: csr_new = csr_rdata;
    endcase
end

assign mstatus = {19'd0, 2'b11, 3'd0, mpie, 3'd0, mie, 3'd0};

always_ff @(posedge clk) begin
    if (rst) begin
        mtvec    <= 32'd0;
        mepc     <= 32'd0;
        mscratch <= 32'd0;
        mcause   <= 32'd0;
        mtval    <= 32'd0;
        mie      <= 1'b0;
        mpie     <= 1'b0;
    end else if (csr_we) begin
        case (csr_addr)
            12'h300: begin
                mie  <= csr_new[3];
                mpie <= csr_new[7];
            end
            12'h305: mtvec    <= csr_new;
            12'h340: mscratch <= csr_new;
            12'h341: mepc     <= csr_new;
            12'h342: mcause   <= csr_new;
            12'h343: mtval    <= csr_new;
            default: ;
        endcase
    end else if (ecall) begin
        mepc   <= pc;
        mcause <= 32'd11;
        mtval  <= 32'd0;
        mpie   <= mie;
        mie    <= 1'b0;
    end else if (ebreak) begin
        mepc   <= pc;
        mcause <= 32'd3;
        mtval  <= 32'd0;
        mpie   <= mie;
        mie    <= 1'b0;
    end else if (mret) begin
        mie  <= mpie;
        mpie <= 1'b1;
    end
end

always_comb begin
    case (csr_addr)
        12'h300: csr_rdata = mstatus;
        12'h305: csr_rdata = mtvec;
        12'h340: csr_rdata = mscratch;
        12'h341: csr_rdata = mepc;
        12'h342: csr_rdata = mcause;
        12'h343: csr_rdata = mtval;
        default: csr_rdata = 32'd0;
    endcase
end

endmodule
