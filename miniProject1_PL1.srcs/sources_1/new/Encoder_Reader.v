`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 05:45:38 PM
// Design Name: 
// Module Name: Encoder_Reader
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


module Encoder_Reader(
    input signal,clock,
    output reg [15:0] tic_count = 0,
    output reg [4:0] D1 = 0,D2 = 0,D3 = 0,D4 = 0,
    input divdone1,divdone2,divdone3,divdone4,   
    input [15:0] tempD1,tempD2,tempD3,tempD4
        );
        
    wire[31:0] bridge1,bridge2,bridge3;
    reg last = 0;
    reg DIVenable1 = 0,DIVenable2 = 0,DIVenable3 = 0,DIVenable4 = 0;
   // reg [15:0] temp2D1,temp2D2,temp2D3,temp2D4;

        
IntegerDivision Thou(
.enable(DIVenable1),
.done(divdone1),
.Dividend(tic_count),
.Divisor(10'd1000),
.clock(clock),
.Quotient(tempD1),
.Remainder(bridge1),
.Percentagemode(0)
);

IntegerDivision Hun(
.enable(DIVenable2),
.done(divdone2),
.Dividend(bridge1),
.Divisor(10'd100),
.clock(clock),
.Quotient(tempD2),
.Remainder(bridge2),
.Percentagemode(0)
);

IntegerDivision Ten(
.enable(DIVenable3),
.done(divdone3),
.Dividend(bridge2),
.Divisor(10'd10),
.clock(clock),
.Quotient(tempD3),
.Remainder(bridge3),
.Percentagemode(0)
);

IntegerDivision Uno(
.enable(DIVenable4),
.done(divdone4),
.Dividend(bridge3),
.Divisor(10'd1),
.clock(clock),
.Quotient(tempD4),
.Remainder(),
.Percentagemode(0)
);
    always @ (posedge clock)
        last <= signal;
        
   
    
    always @ (posedge clock)
    begin
        if(signal != last)
        begin
            tic_count <= tic_count + 1;
            DIVenable1 = 1;
        end
    
    
        if(divdone1)
        begin 
            D1 = tempD1;
            DIVenable1 = 0;
            DIVenable2 = 1;
        end
        
        if(divdone2)
        begin 
            D2 = tempD2;
            DIVenable2 = 0;
            DIVenable3 = 1;
        end
        
        if(divdone3)
        begin 
            D3 = tempD3;
            DIVenable3 = 0;
            DIVenable4 = 1;
        end
        
        if(divdone4)
        begin 
            D4 = tempD4;
            DIVenable4 = 0;
        end
   
            
    end


endmodule
