module shifter_right (
    input wire [3:0] A,
    input wire [1:0] B,
    output wire [3:0] C
);

    wire [3:0] A_invertido;
    wire [3:0] C_intermedio;

    assign A_invertido = {A[0], A[1], A[2], A[3]};

    shifter_left g_shift_l (
        .A(A_invertido),
        .B(B),
        .C(C_intermedio)
    );


    assign C = {C_intermedio[0], C_intermedio[1], C_intermedio[2], C_intermedio[3]};

endmodule