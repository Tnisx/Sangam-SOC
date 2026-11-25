`include "cpu_defs.svh"

module control_unit (
    input  logic [6:0]  opcode,
    input  logic [2:0]  funct3,
    input  logic        funct7_6,
    input  logic [11:0] funct12,
    output ctrl_t       ctrl
);

always_comb begin
    ctrl.we           = 1'b0;
    ctrl.alu_op       = ALU_ADD;
    ctrl.alu_src      = 1'b0;
    ctrl.mem_write    = 1'b0;
    ctrl.mem_to_reg   = 1'b0;
    ctrl.branch       = 1'b0;
    ctrl.jal          = 1'b0;
    ctrl.jalr         = 1'b0;
    ctrl.lui          = 1'b0;
    ctrl.auipc        = 1'b0;
    ctrl.lsmem        = 2'b00;
    ctrl.lsmem_signed = 1'b0;
    ctrl.csr_en       = 1'b0;
    ctrl.ecall        = 1'b0;
    ctrl.mret         = 1'b0;
    ctrl.ebreak       = 1'b0;

    case (opcode)
        7'b0110011: begin
            ctrl.we = 1'b1;
            case (funct3)
                3'b000: ctrl.alu_op = funct7_6 ? ALU_SUB : ALU_ADD;
                3'b001: ctrl.alu_op = ALU_SLL;
                3'b010: ctrl.alu_op = ALU_SLT;
                3'b011: ctrl.alu_op = ALU_SLTU;
                3'b100: ctrl.alu_op = ALU_XOR;
                3'b101: ctrl.alu_op = funct7_6 ? ALU_SRA : ALU_SRL;
                3'b110: ctrl.alu_op = ALU_OR;
                3'b111: ctrl.alu_op = ALU_AND;
            endcase
        end

        7'b0010011: begin
            ctrl.we      = 1'b1;
            ctrl.alu_src = 1'b1;
            case (funct3)
                3'b000: ctrl.alu_op = ALU_ADD;
                3'b010: ctrl.alu_op = ALU_SLT;
                3'b011: ctrl.alu_op = ALU_SLTU;
                3'b100: ctrl.alu_op = ALU_XOR;
                3'b110: ctrl.alu_op = ALU_OR;
                3'b111: ctrl.alu_op = ALU_AND;
                3'b001: ctrl.alu_op = ALU_SLL;
                3'b101: ctrl.alu_op = funct7_6 ? ALU_SRA : ALU_SRL;
            endcase
        end

        7'b0000011: begin
            ctrl.we         = 1'b1;
            ctrl.alu_src    = 1'b1;
            ctrl.mem_to_reg = 1'b1;
            ctrl.alu_op     = ALU_ADD;
            case (funct3)
                3'b000: begin ctrl.lsmem = 2'b01; ctrl.lsmem_signed = 1'b1; end
                3'b001: begin ctrl.lsmem = 2'b10; ctrl.lsmem_signed = 1'b1; end
                3'b010:       ctrl.lsmem = 2'b11;
                3'b100: begin ctrl.lsmem = 2'b01; ctrl.lsmem_signed = 1'b0; end
                3'b101: begin ctrl.lsmem = 2'b10; ctrl.lsmem_signed = 1'b0; end
                default: ;
            endcase
        end

        7'b0100011: begin
            ctrl.alu_src   = 1'b1;
            ctrl.mem_write = 1'b1;
            ctrl.alu_op    = ALU_ADD;
            case (funct3)
                3'b000: ctrl.lsmem = 2'b01;
                3'b001: ctrl.lsmem = 2'b10;
                3'b010: ctrl.lsmem = 2'b11;
                default: ;
            endcase
        end

        7'b1100011: begin
            ctrl.branch = 1'b1;
            case (funct3)
                3'b000: ctrl.alu_op = ALU_SUB;
                3'b001: ctrl.alu_op = ALU_SUB;
                3'b100: ctrl.alu_op = ALU_SLT;
                3'b101: ctrl.alu_op = ALU_SLT;
                3'b110: ctrl.alu_op = ALU_SLTU;
                3'b111: ctrl.alu_op = ALU_SLTU;
                default: ;
            endcase
        end

        7'b1101111: begin
            ctrl.jal = 1'b1;
            ctrl.we  = 1'b1;
        end

        7'b1100111: begin
            ctrl.jalr    = 1'b1;
            ctrl.we      = 1'b1;
            ctrl.alu_src = 1'b1;
            ctrl.alu_op  = ALU_ADD;
        end

        7'b0110111: begin
            ctrl.we  = 1'b1;
            ctrl.lui = 1'b1;
        end

        7'b0010111: begin
            ctrl.we    = 1'b1;
            ctrl.auipc = 1'b1;
        end

        7'b1110011: begin
            if (funct3 == 3'b000) begin
                case (funct12)
                    12'h000: ctrl.ecall  = 1'b1;
                    12'h302: ctrl.mret   = 1'b1;
                    12'h001: ctrl.ebreak = 1'b1;
                    default: ;
                endcase
            end else begin
                ctrl.csr_en = 1'b1;
                ctrl.we     = 1'b1;
            end
        end

        default: ;
    endcase
end

endmodule
