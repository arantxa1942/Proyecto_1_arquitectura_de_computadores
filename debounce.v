module debounce #(
    parameter DELAY_COUNT = 250000  // ~10ms a 25MHz (ajustable)
) (
    input  wire clk,
    input  wire boton_in,   // señal cruda del botón (activo en bajo)
    output reg  boton_out   // señal limpia (activo en bajo también, o invierte si prefieres activo en alto)
);

    reg [17:0] contador = 0;
    reg boton_sync_0 = 1;
    reg boton_sync_1 = 1;   // doble flip-flop para evitar metaestabilidad
    reg estado_anterior = 1;

    always @(posedge clk) begin
        // Sincronizar la entrada asíncrona
        boton_sync_0 <= boton_in;
        boton_sync_1 <= boton_sync_0;

        if (boton_sync_1 != estado_anterior) begin
            // Cambió: reiniciar el contador
            contador <= 0;
            estado_anterior <= boton_sync_1;
        end else if (contador < DELAY_COUNT) begin
            contador <= contador + 1;
        end else begin
            // Se mantuvo estable el tiempo suficiente: aceptar el nuevo valor
            boton_out <= boton_sync_1;
        end
    end

endmodule