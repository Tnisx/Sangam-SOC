module addr_decode (
    input  logic [31:0] addr,
    output logic        uart_en
);

assign uart_en = (addr == 32'h10000000);

endmodule
