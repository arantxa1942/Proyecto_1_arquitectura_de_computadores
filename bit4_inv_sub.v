module bit4_inv_sub (
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [3:0] Salida
);

    bit4_sub g1 (Salida, B, A);

endmodule