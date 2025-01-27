`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module rx(
    input        clk,
    input        din,
    output       data_valid,
    output logic [7:0] data
);

    logic [3:0] baud_rate_cnt;
    logic [3:0] bit_cnt;
    logic [7:0] data_sr;
    logic       valid;

    typedef enum logic {
        IDLE, SAMPLE
    } state_t;
    state_t state;
    
    always_ff @(posedge clk) begin
        case(state)
            IDLE: begin
                baud_rate_cnt <= 4'b1000;
                bit_cnt       <=  'b0;
                if (~din) begin
                    valid <= 0;
                    state <= SAMPLE;
                end
            end
            SAMPLE: begin
                baud_rate_cnt <= baud_rate_cnt + 1;
                if (baud_rate_cnt == 4'b1111) begin
                    data_sr <= {data_sr[6:0], din};
                    if (bit_cnt == 4'd8) begin
                        valid <= 1;
                        data  <= data_sr;
                        state <= IDLE;
                    end
                end
            end
            default: state <= IDLE;
        endcase
    end
    
    assign data_valid = valid;

endmodule
