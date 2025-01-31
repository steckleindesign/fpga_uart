`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module debouncer (
    input        clk,
    input        bouncy_signal,
    output logic clean_signal
);

    typedef enum logic [0:0] {
        LISTEN, HOLD
    } state_t;
    state_t state;
    
    logic signal_lvl;
    
    logic [15:0] hold_cnt;
    
    always_ff @(posedge clk) begin
        clean_signal <= 0;
        case(state)
            LISTEN: begin
                if (bouncy_signal != signal_lvl) begin
                    hold_cnt   <= 0;
                    signal_lvl <= ~signal_lvl;
                    // Only pulse clean signal for 1 cycle
                    // TODO: maybe change the name its a bit misleading
                    if (bouncy_signal) clean_signal <= 1;
                    state      <= HOLD;
                end
            end
            HOLD: begin
                hold_cnt <= hold_cnt + 1;
                if (hold_cnt == 16'hFFFF) begin
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

endmodule
