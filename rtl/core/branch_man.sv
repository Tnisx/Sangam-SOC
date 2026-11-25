module branch_man (
    input  logic [2:0] in,
    input  logic       zero,
    input  logic       result,
    output logic       branch_cond
);

always_comb begin
    case (in)
        3'b000:  branch_cond = zero;
        3'b001:  branch_cond = ~zero;
        3'b100:  branch_cond = result;
        3'b101:  branch_cond = ~result;
        3'b110:  branch_cond = result;
        3'b111:  branch_cond = ~result;
        default: branch_cond = 1'b0;
    endcase
end

endmodule
