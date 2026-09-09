module half_adder (
    input wire Bit1,
    input wire Bit2,
    output wire Salida,
    output wire Carry
);

    xor g1 (Salida, Bit1, Bit2);
    and g2 (Carry, Bit1, Bit2);

endmodule