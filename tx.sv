`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module tx(
    input        clk,
    input        send,
    input  [7:0] data,
    output       dout
);
    
    logic       tx_line;
    logic [3:0] baud_gen_clk;
    logic [3:0] bit_cnt;
    logic [7:0] data_sr;

    typedef enum logic [0:0] {
        IDLE, SEND
    } state_t;
    state_t state;
    
    always_ff @(posedge clk) begin
        case(state)
            IDLE: begin
                tx_line <= 1;
                if (send) begin
                    tx_line      <= 0;
                    baud_gen_clk <= 0;
                    bit_cnt      <= 0;
                    data_sr      <= data;
                    state        <= SEND;
                end
            end
            SEND: begin
                baud_gen_clk <= baud_gen_clk + 1;
                if (baud_gen_clk == 4'b1111) begin
                    bit_cnt <= bit_cnt + 1;
                    tx_line <= data_sr[7];
                    data_sr <= {data_sr[6:0], 1'b1};
                    if (bit_cnt == 4'd8)
                        state <= IDLE;
                end
            end
            default: begin
                tx_line <= 1;
                state   <= IDLE;
            end
        endcase
    end
    
    assign dout = tx_line;

endmodule
