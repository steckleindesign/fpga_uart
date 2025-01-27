`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module uart_top(
    input  clk,
    input  rx_line,
    output tx_line
);

    logic transfer;
    logic rx_data_valid;
    logic [7:0] rx_data, tx_data;

    rx rx_inst (.clk(clk),
                .din(rx_line),
                .data_valid(rx_data_valid),
                .data(rx_data));
    
    tx tx_inst (.clk(clk),
                .send(transfer),
                .dout(tx_line),
                .data(tx_data));

endmodule
