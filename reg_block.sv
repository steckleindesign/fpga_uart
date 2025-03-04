`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module reg_block(
    input        clk,
    input        wr_req,
    input  [7:0] din,
    output [7:0] dout
);

    logic handshake_ff0, handshake_ff1;
    
    logic [7:0] internal_reg;
    
    always_ff @(posedge clk) begin
        internal_reg <= internal_reg;
        // Handshake CDC
        handshake_ff0 <= wr_req;
        handshake_ff1 <= handshake_ff0;
        if (handshake_ff1 & ~handshake_ff0)
            internal_reg <= din;
    end
    
    assign dout = internal_reg;

endmodule