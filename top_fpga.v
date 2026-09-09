module top_fpga (
    input  wire i_Clk,         // 25 MHz, pin 15

    // Botones físicos de la Go Board (activo en bajo: reposo=1, presionado=0)
    input  wire i_Switch_1,    // superior izq. -> incrementar
    input  wire i_Switch_2,    // inferior izq. -> decrementar
    input  wire i_Switch_3,    // superior der. -> confirmar/avanzar
    input  wire i_Switch_4,    // inferior der. -> usar resultado anterior

    // LEDs (solo 4 disponibles en la Go Board)
    output wire o_LED_1,
    output wire o_LED_2,
    output wire o_LED_3,
    output wire o_LED_4,       // libre, no se usa por ahora

    // Display 1: signo
    output wire o_Segment1_A,
    output wire o_Segment1_B,
    output wire o_Segment1_C,
    output wire o_Segment1_D,
    output wire o_Segment1_E,
    output wire o_Segment1_F,
    output wire o_Segment1_G,

    // Display 2: valor en hexadecimal
    output wire o_Segment2_A,
    output wire o_Segment2_B,
    output wire o_Segment2_C,
    output wire o_Segment2_D,
    output wire o_Segment2_E,
    output wire o_Segment2_F,
    output wire o_Segment2_G
);

    // --- Debounce de los 4 botones (salida conserva la polaridad de entrada: activo en bajo) ---
    wire w_sw1_deb, w_sw2_deb, w_sw3_deb, w_sw4_deb;

    debounce deb_1 (.clk(i_Clk), .boton_in(i_Switch_1), .boton_out(w_sw1_deb));
    debounce deb_2 (.clk(i_Clk), .boton_in(i_Switch_2), .boton_out(w_sw2_deb));
    debounce deb_3 (.clk(i_Clk), .boton_in(i_Switch_3), .boton_out(w_sw3_deb));
    debounce deb_4 (.clk(i_Clk), .boton_in(i_Switch_4), .boton_out(w_sw4_deb));

    // --- Opción A: invertir a activo en alto para que calcen con fsm_control ---
    wire w_btn_inc, w_btn_dec, w_btn_confirm, w_btn_use_prev;

    not inv_1 (w_btn_inc,      w_sw1_deb);
    not inv_2 (w_btn_dec,      w_sw2_deb);
    not inv_3 (w_btn_confirm,  w_sw3_deb);
    not inv_4 (w_btn_use_prev, w_sw4_deb);

    // --- FSM de control ---
    wire [2:0] w_opcode;
    wire [3:0] w_op1, w_op2;
    wire       w_selector_op2, w_ejecutar;
    wire [1:0] w_estado;

    fsm_control fsm (
        .clk(i_Clk),
        .reset(1'b0),
        .btn_inc(w_btn_inc),
        .btn_dec(w_btn_dec),
        .btn_confirm(w_btn_confirm),
        .btn_use_prev(w_btn_use_prev),
        .opcode(w_opcode),
        .op1(w_op1),
        .op2(w_op2),
        .selector_op2(w_selector_op2),
        .ejecutar(w_ejecutar),
        .estado(w_estado)
    );

    // --- Calculadora (ALU + registro) ---
    wire [3:0] w_resultado;

    calculadora calc (
        .op1(w_op1),
        .op2(w_op2),
        .selector_op2(w_selector_op2),
        .opcode(w_opcode),
        .ejecutar(w_ejecutar),
        .resultado(w_resultado)
    );

    // --- Driver de LEDs: muestra el opcode en 3 de los 4 LEDs ---
    wire [2:0] w_leds;
    led_driver leds_inst (.opcode(w_opcode), .leds(w_leds));

    assign o_LED_1 = w_leds[0];
    assign o_LED_2 = w_leds[1];
    assign o_LED_3 = w_leds[2];
    assign o_LED_4 = 1'b0;   // libre por ahora

    // --- Selección de qué valor mostrar en el display según la etapa de la FSM ---
    // ST_OP=00 (aun sin operandos), ST_OP1=01, ST_OP2=10, ST_EJEC=11
    wire [3:0] w_valor_mostrar =
        (w_estado == 2'b01) ? w_op1 :
        (w_estado == 2'b10) ? w_op2 :
        (w_estado == 2'b11) ? w_resultado :
        4'b0000;

    // --- Driver de 7 segmentos ---
    wire [6:0] w_seg_signo, w_seg_valor;

    seg7_driver #(.ACTIVE_LOW(1)) seg_inst (
        .valor(w_valor_mostrar),
        .seg_signo(w_seg_signo),
        .seg_valor(w_seg_valor)
    );

    // seg = {g,f,e,d,c,b,a}
    assign o_Segment1_A = w_seg_signo[0];
    assign o_Segment1_B = w_seg_signo[1];
    assign o_Segment1_C = w_seg_signo[2];
    assign o_Segment1_D = w_seg_signo[3];
    assign o_Segment1_E = w_seg_signo[4];
    assign o_Segment1_F = w_seg_signo[5];
    assign o_Segment1_G = w_seg_signo[6];

    assign o_Segment2_A = w_seg_valor[0];
    assign o_Segment2_B = w_seg_valor[1];
    assign o_Segment2_C = w_seg_valor[2];
    assign o_Segment2_D = w_seg_valor[3];
    assign o_Segment2_E = w_seg_valor[4];
    assign o_Segment2_F = w_seg_valor[5];
    assign o_Segment2_G = w_seg_valor[6];

endmodule