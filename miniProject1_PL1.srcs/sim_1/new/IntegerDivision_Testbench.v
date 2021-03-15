`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2021 02:25:14 PM
// Design Name: 
// Module Name: IntegerDivision_Testbench
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


module IntegerDivision_Testbench(

    );
    
    reg enable;
    wire done;
    
    //Division Variables
    reg [31:0]Dividend, Divisor;
    reg clock;
    wire[31:0] Quotient,Remainder;
 
    
    IntegerDivision UUT (enable,done,Dividend,Divisor,clock,Quotient,Remainder);
    
    initial
        begin
        clock = 0;
        enable = 0;
        Dividend = 32'd10500;
        Divisor = 32'd30000;
        #10;
        enable = 1;
        while (~done) begin
        #1;
        end
        
        enable = 0;
        
        #10;
        Dividend = 32'd1000;
        Divisor = 32'd64;
        #10;
        enable = 1;
        while (~done) begin
        #1;
        end
        #10;
        enable = 0;


    end
    always begin
    #1 clock = ~clock;
    end
endmodule
