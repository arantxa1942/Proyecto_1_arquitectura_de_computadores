// --- Decodificador binario -> 7 segmentos (para el display de magnitud) ---
// Convención de bits de salida: seg = {g,f,e,d,c,b,a}
// Convención de polaridad: ACTIVE_LOW=1 => 0 enciende el segmento (típico en displays de cátodo común
// controlados por lógica activa en bajo, como suele venir en la Go Board). Ajusta el parámetro si es al revés.
module seg7_decoder #(
    parameter ACTIVE_LOW = 1
) (
    input  wire [3:0] hex,
    output reg  [6:0] seg   // {g,f,e,d,c,b,a}
);

    reg [6:0] patron;

    always @(*) begin
        case (hex)
            4'h0: patron = 7'b0111111;
            4'h1: patron = 7'b0000110;
            4'h2: patron = 7'b1011011;
            4'h3: patron = 7'b1001111;
            4'h4: patron = 7'b1100110;
            4'h5: patron = 7'b1101101;
            4'h6: patron = 7'b1111101;
            4'h7: patron = 7'b0000111;
            4'h8: patron = 7'b1111111;
            4'h9: patron = 7'b1101111;
            4'hA: patron = 7'b1110111;
            4'hB: patron = 7'b1111100;
            4'hC: patron = 7'b0111001;
            4'hD: patron = 7'b1011110;
            4'hE: patron = 7'b1111001;
            4'hF: patron = 7'b1110001;
            default: patron = 7'b0000000;
        endcase
    end

    always @(*) begin
        seg = ACTIVE_LOW ? ~patron : patron;
    end

endmodule


// --- Driver completo: recibe el valor en complemento a dos, calcula signo+magnitud ---
module seg7_driver #(
    parameter ACTIVE_LOW = 1
) (
    input  wire [3:0] valor,        // valor en complemento a dos (op1, op2 o resultado)
    output wire [6:0] seg_signo,    // display 1: solo segmento central si es negativo
    output wire [6:0] seg_valor     // display 2: magnitud en hex
);

    wire        negativo = valor[3];
    wire [3:0]  magnitud = negativo ? (~valor + 4'b0001) : valor;  // complemento a dos si es negativo

    seg7_decoder #(.ACTIVE_LOW(ACTIVE_LOW)) dec_valor (
        .hex(magnitud),
        .seg(seg_valor)
    );

    // Signo: solo el segmento 'g' (el del medio) prendido cuando es negativo.
    // Patrón activo-alto: {g,f,e,d,c,b,a} = 1000000 -> g=1
    wire [6:0] patron_signo = negativo ? 7'b1000000 : 7'b0000000;
    assign seg_signo = ACTIVE_LOW ? ~patron_signo : patron_signo;

endmodule