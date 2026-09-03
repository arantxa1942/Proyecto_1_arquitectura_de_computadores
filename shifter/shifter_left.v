module shifter_left (
    input wire [3:0] A,
    input wire [1:0] B,
    output wire [3:0] C
);

    wire x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32;

//Primer dígito
    nor g1 (x1, B[0], B[1]);
    and g2 (C[0], A[0], x1);

//Segundo dígito
    and g3 (x3, A[0], B[0]);
    not g4 (x4, B[0]);
    and g5 (x5, A[1], x4);
    xor g6 (x6, x3, x5);
    not g7 (x7, B[1]);
    and g8 (C[1], x7, x6);

//Tercer dígito
    not g9 (x8, B[0]);
    and g90 (x9, x8, B[1]);
    and g10 (x10, x9, A[0]);
    not g11 (x11, B[1]);
    and g12 (x12, B[0], x11);
    and g13 (x13, A[1], x12);
    nor g14 (x14, B[0], B[1]);
    and g15 (x15, A[2], x14);
    or g16 (x16, x15, x13);
    or g17 (C[2], x16, x10);

//Cuarto dígito
    nor g21 (x21, B[0], B[1]);
    and g22 (x22, A[3], x21);
    not g23 (x23, B[1]);
    and g24 (x24, B[0], x23);
    and g25 (x25, x24, A[2]);
    or g26 (x26, x22, x25);
    not g27 (x27, B[0]);
    and g28 (x28, x27, B[1]);
    and g29 (x29, x28, A[1]);
    and g30 (x30, B[0], B[1]);
    and g31 (x31, x30, A[0]);
    or g32 (x32, x31, x29);
    or g33 (C[3], x26, x32);



endmodule