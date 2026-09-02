module half_adder (
    input wire Bit1,
    input wire Bit2,
    input wire CarryIn,
    output wire Salida,
    output wire CarryOut
);

    wire x1, x2, x3;

    xor g1 (x1, Bit1, Bit2);
    and g2 (x2, Bit1, Bit2);
    xor g3 (Salida, CarryIn, x1);
    and g4 (x3, CarryIn, x1);
    or g5 (CarryOut, x2, x3);

endmodule