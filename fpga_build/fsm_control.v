module fsm_control (
    input  wire clk,
    input  wire reset,             // opcional: activo en alto. Si no lo usas, amárralo a 0.
    input  wire btn_inc,           //activo en alto = presionado
    input  wire btn_dec,
    input  wire btn_confirm,
    input  wire btn_use_prev,

    output reg  [2:0] opcode,
    output reg  [3:0] op1,
    output reg  [3:0] op2,
    output reg  selector_op2,
    output reg  ejecutar,
    output reg  [1:0] estado       
);

    // --- Estados ---
    localparam ST_OP   = 2'b00;  // ingresando código de operación
    localparam ST_OP1  = 2'b01;  // ingresando op1
    localparam ST_OP2  = 2'b10;  // ingresando op2
    localparam ST_EJEC = 2'b11;  // ejecutando / mostrando resultado

    // --- Detección de flanco de subida (pulso de un ciclo por presión) ---
    reg btn_inc_d, btn_dec_d, btn_confirm_d, btn_use_prev_d;

    always @(posedge clk) begin
        btn_inc_d      <= btn_inc;
        btn_dec_d      <= btn_dec;
        btn_confirm_d  <= btn_confirm;
        btn_use_prev_d <= btn_use_prev;
    end

    wire inc_pulse      = btn_inc      & ~btn_inc_d;
    wire dec_pulse      = btn_dec      & ~btn_dec_d;
    wire confirm_pulse  = btn_confirm  & ~btn_confirm_d;
    wire use_prev_pulse = btn_use_prev & ~btn_use_prev_d;

    // --- Valores iniciales (útil en simulación; en la FPGA, Yosys/iCE40
    //     los usa como valores de power-on-reset) ---
    initial begin
        estado       = ST_OP;
        opcode       = 3'b000;
        op1          = 4'b0000;
        op2          = 4'b0000;
        selector_op2 = 1'b0;
        ejecutar     = 1'b0;
    end

    // --- Máquina de estados ---
    always @(posedge clk) begin
        if (reset) begin
            estado       <= ST_OP;
            opcode       <= 3'b000;
            op1          <= 4'b0000;
            op2          <= 4'b0000;
            selector_op2 <= 1'b0;
            ejecutar     <= 1'b0;
        end else begin
            case (estado)

                ST_OP: begin
                    ejecutar <= 1'b0;
                    if (inc_pulse)
                        opcode <= opcode + 1'b1;
                    else if (dec_pulse)
                        opcode <= opcode - 1'b1;
                    else if (confirm_pulse)
                        estado <= ST_OP1;
                end

                ST_OP1: begin
                    if (inc_pulse)
                        op1 <= op1 + 1'b1;
                    else if (dec_pulse)
                        op1 <= op1 - 1'b1;
                    else if (confirm_pulse)
                        estado <= ST_OP2;
                end

                ST_OP2: begin
                    if (inc_pulse)
                        op2 <= op2 + 1'b1;
                    else if (dec_pulse)
                        op2 <= op2 - 1'b1;
                    else if (use_prev_pulse)
                        selector_op2 <= ~selector_op2;   // alterna: usar op2 tecleado vs. resultado anterior
                    else if (confirm_pulse) begin
                        ejecutar <= 1'b1;                // flanco de subida -> dispara registro4
                        estado   <= ST_EJEC;
                    end
                end

                ST_EJEC: begin
                    if (confirm_pulse) begin
                        ejecutar     <= 1'b0;
                        opcode       <= 3'b000;
                        op1          <= 4'b0000;
                        op2          <= 4'b0000;
                        selector_op2 <= 1'b0;
                        estado       <= ST_OP;
                    end
                end

                default: estado <= ST_OP;

            endcase
        end
    end

endmodule