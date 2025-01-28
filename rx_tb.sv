`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module rx_tb();
    
    // inputs (stimulus)
    logic       clk;
    logic       din;
    // outputs
    logic       data_valid;
    logic [7:0] data;
    
    localparam CLK_PERIOD  = 10; // ns
    // baud rate lines us with OVSR for now
    localparam BAUD_PERIOD = 16*10;
    
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    initial begin
        din = 1;
        repeat (5) @(posedge clk);
        din = 0;
        #(BAUD_PERIOD)
        din = 1;
        #(BAUD_PERIOD)
        din = 0;
        #(BAUD_PERIOD)
        din = 1;
        #(BAUD_PERIOD)
        din = 0;
        #(BAUD_PERIOD)
        din = 1;
        #(BAUD_PERIOD)
        din = 0;
        #(BAUD_PERIOD)
        din = 1;
        #(BAUD_PERIOD)
        din = 0;
        #(BAUD_PERIOD)
        // Stop bit
        din = 1;
        #(BAUD_PERIOD)
        din = 1;
        #250
        $finish;
    end
    
    rx DUT (.*);

endmodule