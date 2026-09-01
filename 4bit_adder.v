module 4bit_adder (
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [3:0] Salida
);

    wire carry1, carry2, carry3, carry4, salida1, salida2, salida3, salida4;

    half_adder g1 (salida1, carry1, A[0], B[0]);
    full_adder g2 (salida2, carry2, A[1], B[1], carry1);
    full_adder g3 (salida3, carry3, A[2], B[2], carry2);
    full_adder g4 (salida4, carry4, A[3], B[3], carry3);

    assign Salida = {salida4, salida3, salida2, salida1};

endmodule
