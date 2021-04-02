`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2021 11:09:53 PM
// Design Name: 
// Module Name: ColorTestbench
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


module ColorTestbench(

    
    );
    reg clock;
    reg colorinput,frqdone,divdone;
    wire s2,s3;
    wire LED0,LED1,LED2,LED3,LED4;
    reg[19:0] FRQ;
    reg[31:0] tempquo;
    wire JA4,JA5,JA6;

    
    ColorSensor UUT (clock,colorinput,frqdone,divdone,s2,s3,LED0,LED1,LED2,LED3,LED4,FRQ,tempquo,JA4,JA5,JA6);
    
    initial 
    begin
    FRQ = 5000;
    frqdone = 1;
    #10;
    FRQ = 3000;
    frqdone = 1;
    #10;
    FRQ = 2000;
    frqdone = 1;
    #10;
    FRQ = 1000;
    frqdone = 1;
    #10;
    end
    
    always begin
    #1 clock = ~clock;
    end
endmodule
