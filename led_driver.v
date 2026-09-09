module led_driver (
    input  wire [2:0] opcode,
    output wire [2:0] leds
);

    // Conexión directa: cada bit del opcode a un LED.
    // Si tus LEDs son activos en bajo (se prenden con 0), invierte con `not`.
    assign leds = opcode;

endmodule