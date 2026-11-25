`ifndef CPU_DEFS_SVH
`define CPU_DEFS_SVH

typedef enum logic [3:0] {
    ALU_ADD, ALU_SUB, ALU_AND, ALU_OR,
    ALU_XOR, ALU_SLL, ALU_SRL, ALU_SRA,
    ALU_SLT, ALU_SLTU
} alu_op_t;

typedef struct packed {
    logic        alu_src;
    logic        we;
    alu_op_t     alu_op;
    logic        mem_write;
    logic        mem_to_reg;
    logic        branch;
    logic        jal;
    logic        jalr;
    logic        lui;
    logic        auipc;
    logic [1:0]  lsmem;
    logic        lsmem_signed;
    logic        csr_en;
    logic        ecall;
    logic        mret;
    logic        ebreak;
} ctrl_t;

`endif
