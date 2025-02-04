`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module uart_top (
    input  clk,
    input  btn,
    input  rx_line,
    output tx_line
);

    logic transfer;
    logic rx_data_valid;
    logic [7:0] rx_data, tx_data;
    
    debouncer db (.clk(clk),
                  .bouncy_signal(btn),
                  .clean_signal(transfer));

    rx rx_inst (.clk(clk),
                .din(rx_line),
                .data_valid(rx_data_valid),
                .data(rx_data));
    
    tx tx_inst (.clk(clk),
                .send(transfer),
                .dout(tx_line),
                .data(tx_data));
    
    reg_block device_reg (.clk(clk),
                          .wr_req(rx_data_valid),
                          .din(rx_data),
                          .dout(tx_data));

endmodule
