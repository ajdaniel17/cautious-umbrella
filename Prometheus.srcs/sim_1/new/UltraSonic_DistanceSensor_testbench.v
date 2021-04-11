`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 02:21:49 PM
// Design Name: 
// Module Name: UltraSonic_DistanceSensor_testbench
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


module UltraSonic_DistanceSensor_testbench(

    );
    reg clock,echo;
    wire trigger;
    wire [31:0]distance;
    wire [31:0]timecount;
    reg divdone;
   
    reg [31:0] tempdistance;

    wire lastecho;
    wire DIVenable;
    /*reg enable;
    wire done;
    
    //Division Variables
    reg signed[31:0] Dividend, Divisor;
    reg clock;
    wire [31:0] Quotient;
    wire signed [31:0] Remainder;
    reg Percentagemode;*/
    

    UltraSonic_DistanceSensor UUT (clock,echo,trigger,distance,timecount,tempdistance,divdone,lastecho,DIVenable);
    //IntegerDivision SoundToInch (enable, done, Dividend, Divisor, clock, Quotient, Remainder, Percentagemode);
    
    initial 
    begin
    clock = 0;
    divdone = 0;
    tempdistance = 0;
    echo = 0;
    #10;
    while(trigger)
    #1;
    #10;
    echo = 1;
    #740000;
    echo = 0;
    if(~divdone)
    #1;
    
    end
    
    always begin
    #1 clock = ~clock;
    end
    
endmodule
