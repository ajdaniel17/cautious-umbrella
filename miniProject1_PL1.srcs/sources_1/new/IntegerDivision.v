`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2021 02:08:19 PM
// Design Name: 
// Module Name: IntegerDivision
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


module IntegerDivision(
    //state machine input/output
    input enable,
    output reg done,
    
    //Division Variables
    input signed[31:0] Dividend, Divisor,
    input clock,
    output reg [31:0] Quotient,
    output reg signed [31:0] Remainder,
    input Percentagemode
    );
   reg signed[31:0]tempvar;
   
    always @ (posedge clock)
        begin
        
        
            
        if(~enable)
        begin
            done = 0;
            Quotient = 0;
            Remainder = 0;
            if(Percentagemode)
                if(Dividend > $signed(32'd0))
                tempvar = Dividend*100;
                else
                tempvar = Dividend*-100;
            else 
                if(Dividend > $signed(32'd0))
                tempvar = Dividend;
                else
                tempvar = Dividend*-1;

        end
        else
        begin
                if(tempvar >= Divisor)
                begin
                    Quotient = Quotient + 1;
                    tempvar = tempvar - Divisor;
                end
                else
                begin
                    Remainder = tempvar;
                    done = 1;
                end
            
        end
    end
    
endmodule
