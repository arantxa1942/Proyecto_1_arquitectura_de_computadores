module calculadora (
    input wire [3:0] op1,          // Primer operando
    input wire [3:0] op2,          // Segundo operando externo
    input wire selector_op2,      // 0: usar op2, 1: usar resultado anterior (R)
    input wire [2:0] opcode,       // Código de operación (3 bits)
    input wire ejecutar,          // Señal para ejecutar/capturar el resultado
    output wire [3:0] resultado    // Resultado final (salida del registro)
);

    // --- Señales internas ---
    wire [3:0] op2_seleccionado;  // Segundo operando (op2 o R)
    wire [3:0] resultado_combinacional; // Resultado de la operación seleccionada

    // --- MUX para seleccionar el segundo operando ---
    // Si selector_op2 = 1, usa el resultado anterior (R); si no, usa op2.
    // Implementación del MUX con compuertas (sin usar ? :)
    wire [3:0] R; // Salida del registro (retroalimentación)
    assign op2_seleccionado = (selector_op2) ? R : op2;
    // NOTA: Si no puedes usar el operador ternario, reemplázalo con:
    // assign op2_seleccionado = {4{selector_op2}} & R | {~4{selector_op2}} & op2;

    // --- Instanciar los módulos de operaciones ---
    // Suma
    wire [3:0] suma_result;
    bit4_adder suma (
        .A(op1),
        .B(op2_seleccionado),
        .Salida(suma_result)
    );

    // Resta (A - B)
    wire [3:0] resta_result;
    bit4_sub resta (
        .A(op1),
        .B(op2_seleccionado),
        .Salida(resta_result)
    );

    // Resta inversa (B - A)
    wire [3:0] resta_inv_result;
    bit4_inv_sub resta_inv (
        .A(op1),
        .B(op2_seleccionado),
        .Salida(resta_inv_result)
    );

    // Shift left
    wire [3:0] shift_left_result;
    shifter_left shift_left (
        .A(op1),
        .B(op2_seleccionado[1:0]), // Usamos B[1:0] para el shift (0 a 3)
        .C(shift_left_result)
    );

    // Shift right
    wire [3:0] shift_right_result;
    shifter_right shift_right (
        .A(op1),
        .B(op2_seleccionado[1:0]),
        .C(shift_right_result)
    );

    // --- MUX para seleccionar la operación según el opcode ---
    // Implementación con compuertas (sin usar case o if)
    // Decodificar el opcode:
    wire opcode_000 = ~opcode[2] & ~opcode[1] & ~opcode[0]; // Reinicio
    wire opcode_001 = ~opcode[2] & ~opcode[1] & opcode[0];   // Suma
    wire opcode_010 = ~opcode[2] & opcode[1] & ~opcode[0];  // Resta
    wire opcode_011 = ~opcode[2] & opcode[1] & opcode[0];   // Resta inversa
    wire opcode_100 = opcode[2] & ~opcode[1] & ~opcode[0];   // Shift left
    wire opcode_101 = opcode[2] & ~opcode[1] & opcode[0];    // Shift right

    // Asignar el resultado combinacional según el opcode
    // Usamos AND/OR para seleccionar la operación activa
    assign resultado_combinacional =
        (opcode_000) ? 4'b0000 : // Reinicio
        (opcode_001) ? suma_result :
        (opcode_010) ? resta_result :
        (opcode_011) ? resta_inv_result :
        (opcode_100) ? shift_left_result :
        (opcode_101) ? shift_right_result :
        4'b0000; // Default (por seguridad)

    // NOTA: Si no puedes usar el operador ternario, implementa un MUX con compuertas:
    // Ejemplo para 2 operaciones (extiende para 6):
    // wire [3:0] mux_out = (opcode_001 & suma_result) | (opcode_010 & resta_result) | ...;

    // --- Registro para guardar el resultado ---
    registro4 reg_result (
        .dato_in(resultado_combinacional),
        .ejecutar(ejecutar),
        .q(R)
    );

    // --- Salida del módulo ---
    assign resultado = R;

endmodule