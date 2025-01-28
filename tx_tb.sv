`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module tx_tb();

    // inputs (stimulus)
    logic       clk;
    logic       send;
    logic [7:0] data;
    // output
    logic       dout;
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        send = 0;
        #22
        send = 1;
        #30
        send = 0;
    end
    
    initial begin
        data = 0;
        #10
        data = 8'h6c;
        #20
        data = 0;
        repeat (16*10) @(posedge clk);
        data = 8'hFF;
        $finish;
    end
    
    tx DUT (.*);

endmodule
