module bit4_sub (
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [3:0] Salida
);

    wire [3:0] B_comp1;

    not g0 (B_comp1[0], B[0]);
    not g1 (B_comp1[1], B[1]);
    not g2 (B_comp1[2], B[2]);
    not g3 (B_comp1[3], B[3]);

    wire [3:0] salida1;

    bit4_adder g4 (salida1, A, B_comp1);

    wire [3:0] binario1;

    assign binario1 = 4'b0001;

    bit4_adder g5 (Salida, salida1, binario1);

endmodule
