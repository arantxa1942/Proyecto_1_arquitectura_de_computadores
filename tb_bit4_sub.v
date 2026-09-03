'timescale 1ns/1ps 

module tb_bit4_sub; 
    reg[3:0] A;
    reg[3:0] B;  //solo se declaran señales en el testebench
    wire [3:0] Salida;

    bit4_sub dut (.A(A), .B(B), .Salida(Salida));

    initial begin
        $dumpfile("tb_bit4_sub.vcd");
        $dumpvars(0, tb_bit4_sub);
        $monitor("t=%0t A=%b(%0d) B=%b(%0d) | Salida=%b(%0d)  (A-B)",
                  $time, A, A, B, B, Salida, Salida);
        //01 resta de 5 y 3 
        A = 4'b0101; B = 4'b0011; #10;

        //02 negativo de 3 y -5 
        A = 4'b0011; B = 4'b0101; #10;

        //03 negativos de -3 -(-2)
        A = 4'b1101; B = 4'b1110; #10;

        //04 ceros 0-0
        A = 4'b0000; B = 4'b0000; #10;

        //05 overflow -8-1 
        A = 4'b1000; B = 4'b0001; #10;

        $finish; 
    end
endmodule



