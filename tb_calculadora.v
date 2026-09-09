`timescale 1ns/1ps

module tb_calculadora;

    
    reg [3:0] op1;
    reg [3:0] op2;
    reg selector_op2;
    reg [2:0] opcode;
    reg ejecutar;

    wire [3:0] resultado;

    
    
    calculadora dut (
        .op1(op1),
        .op2(op2),
        .selector_op2(selector_op2),
        .opcode(opcode),
        .ejecutar(ejecutar),
        .resultado(resultado)
    );

    
    initial begin
        $dumpfile("tb_calculadora.vcd");
        $dumpvars(0, dut);
    end

    
    initial begin
        
        op1 = 4'b0000;
        op2 = 4'b0000;
        selector_op2 = 0;
        opcode = 3'b000;
        ejecutar = 0;

        
        #10;

        
        opcode = 3'b000;
        op1 = 4'b1010; 
        op2 = 4'b1101; 
        selector_op2 = 0;
        #10;
        ejecutar = 1; 
        #10;
        ejecutar = 0;
        #10;
        $display("Caso 1 - Reinicio: op1=%b, op2=%b, opcode=%b, resultado=%b (esperado: 0000)",
                 op1, op2, opcode, resultado);

        // --- Caso 2: Suma (opcode = 001) ---
        opcode = 3'b001;
        op1 = 4'b0011; // 3
        op2 = 4'b0100; // 4
        selector_op2 = 0;
        #10;
        ejecutar = 1;
        #10;
        ejecutar = 0;
        #10;
        $display("Caso 2 - Suma: op1=%b (%d), op2=%b (%d), resultado=%b (%d, esperado: 0111 = 7)",
                 op1, $signed(op1), op2, $signed(op2), resultado, $signed(resultado));

        // --- Caso 3: Resta (opcode = 010) ---
        opcode = 3'b010;
        op1 = 4'b0101; // 5
        op2 = 4'b0011; // 3
        selector_op2 = 0;
        #10;
        ejecutar = 1;
        #10;
        ejecutar = 0;
        #10;
        $display("Caso 3 - Resta: op1=%b (%d), op2=%b (%d), resultado=%b (%d, esperado: 0010 = 2)",
                 op1, $signed(op1), op2, $signed(op2), resultado, $signed(resultado));

        // --- Caso 4: Resta inversa (opcode = 011) ---
        opcode = 3'b011;
        op1 = 4'b0010; // 2
        op2 = 4'b0100; // 4
        selector_op2 = 0;
        #10;
        ejecutar = 1;
        #10;
        ejecutar = 0;
        #10;
        $display("Caso 4 - Resta inversa: op1=%b (%d), op2=%b (%d), resultado=%b (%d, esperado: 0010 = 2)",
                 op1, $signed(op1), op2, $signed(op2), resultado, $signed(resultado));

        // --- Caso 5: Shift left (opcode = 100) ---
        opcode = 3'b100;
        op1 = 4'b0001; // 1
        op2 = 4'b0010; // 2 (B[1:0] = 10, shift de 2 posiciones)
        selector_op2 = 0;
        #10;
        ejecutar = 1;
        #10;
        ejecutar = 0;
        #10;
        $display("Caso 5 - Shift left: op1=%b (%d), op2=%b (shift=%d), resultado=%b (%d, esperado: 0100 = 4)",
                 op1, $signed(op1), op2, op2[1:0], resultado, $signed(resultado));

        // --- Caso 6: Shift right (opcode = 101) ---
        opcode = 3'b101;
        op1 = 4'b1000; // -8 en complemento a dos
        op2 = 4'b0001; // 1 (B[1:0] = 01, shift de 1 posición)
        selector_op2 = 0;
        #10;
        ejecutar = 1;
        #10;
        ejecutar = 0;
        #10;
        $display("Caso 6 - Shift right: op1=%b (%d), op2=%b (shift=%d), resultado=%b (%d, esperado: 1100 = -4)",
                 op1, $signed(op1), op2, op2[1:0], resultado, $signed(resultado));

        // --- Caso 7: Usar resultado anterior como segundo operando (selector_op2 = 1) ---
        opcode = 3'b001; // Suma
        op1 = 4'b0011; // 3
        op2 = 4'b0100; // 4
        selector_op2 = 0;
        #10;
        ejecutar = 1;
        #10;
        ejecutar = 0;
        #10;
        $display("Caso 7a - Suma inicial: op1=%b, op2=%b, resultado=%b", op1, op2, resultado);

        // Ahora usa el resultado anterior (R) como segundo operando
        selector_op2 = 1; // Usar R como op2
        op1 = 4'b0010; // 2
        opcode = 3'b001; // Suma de nuevo
        #10;
        ejecutar = 1;
        #10;
        ejecutar = 0;
        #10;
        $display("Caso 7b - Suma con R: op1=%b, op2=R=%b, resultado=%b (esperado: 0111 + 0010 = 1001 = 9)",
                 op1, resultado, resultado);

        // --- Caso 8: Número negativo en complemento a dos ---
        opcode = 3'b010; // Resta
        op1 = 4'b0010; // 2
        op2 = 4'b1101; // -3 en complemento a dos
        selector_op2 = 0;
        #10;
        ejecutar = 1;
        #10;
        ejecutar = 0;
        #10;
        $display("Caso 8 - Resta con negativo: op1=%b (%d), op2=%b (%d), resultado=%b (%d, esperado: 0111 = 5)",
                 op1, $signed(op1), op2, $signed(op2), resultado, $signed(resultado));

        // --- Finalizar simulación ---
        #100;
        $display("Simulación terminada.");
        $finish;
    end

endmodule
