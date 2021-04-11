`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2021 07:13:48 PM
// Design Name: 
// Module Name: bin2dec_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bin2dec_testbench(

    );
    
    
    reg clk;
    reg start;
    reg [15:0] din;
    wire done;
    wire [15:0] dout;
    wire [31:0] data;
    bin2dec UUT (clk,start,din,done,dout,data);
    
    initial 
    begin
    clk = 0;
    din = 16'h7FFF;
    start = 0;
    #10;
    start = 1;
    while(done)
    #1;
    start = 0;
    end
    
    always begin
    #1 clk = ~clk;
    end
    
endmodule
