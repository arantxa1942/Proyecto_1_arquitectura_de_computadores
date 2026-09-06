`timescale 1ns/1ps

module tb_full_adder;
    reg Bit1, Bit2, CarryIn;
    wire Salida, CarryOut;

    full_adder uut (
        .Bit1(Bit1),
        .Bit2(Bit2),
        .CarryIn(CarryIn),
        .Salida(Salida),
        .CarryOut(CarryOut)
    );

    initial begin
        $dumpfile("tb_full_adder.vcd");
        $dumpvars(0, tb_full_adder);
        $monitor("t=%0t Bit1=%b Bit2=%b CarryIn=%b | Salida=%b CarryOut=%b",
                  $time, Bit1, Bit2, CarryIn, Salida, CarryOut);

        // 000
        Bit1 = 0; Bit2 = 0; CarryIn = 0; #10;
        // 001
        Bit1 = 0; Bit2 = 0; CarryIn = 1; #10;
        // 010
        Bit1 = 0; Bit2 = 1; CarryIn = 0; #10;
        // 011
        Bit1 = 0; Bit2 = 1; CarryIn = 1; #10;
        // 100
        Bit1 = 1; Bit2 = 0; CarryIn = 0; #10;
        // 101
        Bit1 = 1; Bit2 = 0; CarryIn = 1; #10;
        // 110
        Bit1 = 1; Bit2 = 1; CarryIn = 0; #10;
        // 111
        Bit1 = 1; Bit2 = 1; CarryIn = 1; #10;

        $finish;
    end
endmodule