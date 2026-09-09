module tb_half_adder;
    reg Bit1, Bit2;
    wire Salida, Carry;

    half_adder uut (.Bit1(Bit1), .Bit2(Bit2), .Salida(Salida), .Carry(Carry));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_half_adder);

        $display("Bit1 Bit2 | Salida Carry");
        Bit1 = 0; Bit2 = 0; #10;
        $display("  %b    %b  |   %b     %b", Bit1, Bit2, Salida, Carry);
        Bit1 = 0; Bit2 = 1; #10;
        $display("  %b    %b  |   %b     %b", Bit1, Bit2, Salida, Carry);
        Bit1 = 1; Bit2 = 0; #10;
        $display("  %b    %b  |   %b     %b", Bit1, Bit2, Salida, Carry);
        Bit1 = 1; Bit2 = 1; #10;
        $display("  %b    %b  |   %b     %b", Bit1, Bit2, Salida, Carry);

        $finish;
    end
endmodule