module registro4 (
    input wire [3:0] dato_in,  
    input wire ejecutar,       
    output reg [3:0] q         
);

    always @(posedge ejecutar) begin
        q <= dato_in;
    end

endmodule