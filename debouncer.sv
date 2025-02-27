`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module debouncer (
    input        clk,
    input        bouncy_signal,
    output       clean_signal
);

    logic        clean_pulse;
    logic        signal_lvl;
    logic [10:0] hold_cnt;

    typedef enum logic [0:0] {
        LISTEN, HOLD
    } state_t;
    state_t state;
    
    always_ff @(posedge clk) begin
        clean_pulse <= 0;
        case(state)
            LISTEN: begin
                if (bouncy_signal != signal_lvl) begin
                    signal_lvl <= ~signal_lvl;
                    hold_cnt   <= 0;
                    state      <= HOLD;
                    if (bouncy_signal)
                        clean_pulse <= 1;
                end
            end
            HOLD: begin
                hold_cnt <= hold_cnt + 1;
                if (hold_cnt == 8'hFF) begin
                    state <= LISTEN;
                end
            end
            default: begin
                signal_lvl <= 0;
                hold_cnt   <= 0;
                state      <= LISTEN;
            end
        endcase
    end
    
    assign clean_signal = clean_pulse;

endmodule
