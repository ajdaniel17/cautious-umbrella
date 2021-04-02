`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2021 08:27:36 PM
// Design Name: 
// Module Name: Encoder_Reader_Testbench
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


module Encoder_Reader_Testbench(

    );
    
    
    reg signalA,signalB;
    reg clock;
    wire [15:0] tic_count;
    wire [4:0] D1,D2,D3,D4;
    reg divdone1,divdone2,divdone3,divdone4;
    reg [15:0] tempD1,tempD2,tempD3,tempD4;
    
Encoder_Reader UUT (signalA,signalB,clock,tic_count,D1,D2,D3,D4,divdone1,divdone2,divdone3,divdone4,tempD1,tempD2,tempD3,tempD4);

    initial 
    begin
    clock = 0;
    signalA = 0;
    signalB = 0;
    divdone1 = 0;
    divdone2 = 0;
    divdone3 = 0;
    divdone4 = 0;
    tempD1 = 0;
    tempD2 = 0;
    tempD3 = 0;
    tempD4 = 0;
    #10;
    signalB = 1;
    #2;
    signalB = 0;
    #2;
    signalA = 1;
    #2;
    signalA = 0;
    #2;
    signalA = 1;
    #2;
    signalB = 1;
    #2
    signalA = 0;
    #2;
    signalB = 0;
    #2;
    signalB = 1;
    #2;
    signalA = 1;
    #2;
    signalB = 0;
    #2;
    signalA = 0;
    end
   
    
    always begin
    #1 clock = ~clock;
    end
endmodule
