`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module rx(
    input              clk,
    input              din,
    output             data_valid,
    output logic [7:0] data
);

    logic [3:0] baud_rate_cnt;
    logic [3:0] bit_cnt;
    logic [7:0] data_sr;
    logic       valid;

    typedef enum logic [1:0] {
        IDLE, SAMPLE, PROCESS
    } state_t;
    state_t state;
    
    always_ff @(posedge clk) begin
        case(state)
            IDLE: begin
                valid <= 0;
                baud_rate_cnt <= 4'b1000;
                bit_cnt       <=  'b0;
                if (~din) begin
                    state <= SAMPLE;
                end
            end
            SAMPLE: begin
                baud_rate_cnt <= baud_rate_cnt + 1;
                if (baud_rate_cnt == 4'b1111) begin
                    bit_cnt <= bit_cnt + 1;
                    data_sr <= {data_sr[6:0], din};
                    if (bit_cnt == 4'd8) begin
                        data  <= data_sr;
                    end
                end else if (bit_cnt == 4'd9 && baud_rate_cnt == 4'b0111) begin
                    valid <= 1;
                    state <= PROCESS;
                end
            end
            PROCESS: begin
                state <= IDLE;
            end
            default: begin
                valid <= 0;
                data  <= 0;
                state <= IDLE;
            end
        endcase
    end
    
    assign data_valid = valid;

endmodule
