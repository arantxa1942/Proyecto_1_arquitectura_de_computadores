'timescale 1ns/1ps 

module tb_bit4_inv_sub;
    reg[3:0] A;   //declara dos vectores de 4 bit se pueden asignar valores dentro de un 
    reg [3:0] B;    
    wire [3:0] Salida;

    bit4_inv_sub dut (.A(A), .B(B), .Salida(Salida)); 

    initial begin
        $dumpfile ("tb_bit4_inv_sub.vcd"); 
        $dumpvars (0, tb_bit4_inv_sub);
        $monitor("t=%0t A=%b(%0d) B=%b(%0d) | Salida=%b(%0d)  (B-A)",
                  $time, A, A, B, B, Salida, Salida);

        //01 resta de 5 y 2
         A = 4'b0011; B = 4'b0001; #10;

        //02 negativo -3 y 2 
        A = 4'b1101; B = 4'b0001;  #10;

        //03 negativos -1 y -1
        A = 4'b1111; B = 4'b1111; #10;

        $finish;

    end
endmodule






