
'timescale 1ns/1ps 

module tb_bit4_adder; 
    reg [3:0] A; 
    reg [3:0] B;
    wire [3:0] Salida; 

    bit4_adder dut (.A(A), .B(B), .Salida(Salida));

    initial begin

        $dumpfile("tb_bit4_adder.vcd");
        $dumpvars(0, tb_bit4_adder);
        $monitor("t=%0t A=%b(%0d) B=%b(%0d) | Salida=%b(%0d)",
                  $time, A, A, B, B, Salida, Salida);

        //01 suma de 3 y 2
        A = 4'b0011; B = 4'b0001;  #10;

        //02 resta de  3 y 2
        A = 4'b0011; B = 4'b0001;   #10;

        //03 overflow 
        A = 4'b1111; B = 4'b0001;   #10;

        //04 Negativo con -1 y -1 
        A = 4'b1111; B = 4'b1111; #10;

       //05 negativo con positivo -3 y 2
        A = 4'b1101; B = 4'b0001;  #10;

        $finish;
    end

endmodule



