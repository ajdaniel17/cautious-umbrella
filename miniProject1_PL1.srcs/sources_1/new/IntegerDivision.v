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
    output reg signed[31:0] Quotient,Remainder,
    input Percentagemode
    );
   reg [31:0]tempvar;
   
    always @ (posedge clock)
        begin
        
        
            
        if(~enable)
        begin
            done = 0;
            Quotient = 0;
            Remainder = 0;
            if(Percentagemode)
                tempvar = Dividend*100;
            else 
                tempvar = Dividend;

        end
        else
            begin
            if(Divisor > 0)
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
            else
            begin
                if(tempvar <= -1*Divisor)
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
    end
    
endmodule
