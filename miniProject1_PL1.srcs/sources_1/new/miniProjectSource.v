`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2021 03:56:48 PM
// Design Name: 
// Module Name: miniProjectSource
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
// Switch 0 : Speed Control 0 25%
// Switch 1 : Speed Control 1 25%
// Switch 2 : Speed Control 2 25%
// Switch 3 : Speed Control 3 25%
// Switch 4 : Left Motor Forward/Backward
// Switch 5 : Right Motor Forward/Backward
// Switch 6 : Left motor on
// Switch 7 : Right motor on
// 7 seg display: 
//////////////////////////////////////////////////////////////////////////////////
//GENERAL THINGS I WISH TO KNOW
// 1. Are functions a thing in verilog, are classes?
// 2. Can I make this in C instead of verilog, I dont like verilog.
// 3. TODO:  let corbin touch the code
// 4. Figure out how to get rid of the critical warnings in the Synthesis and Implementation, it seems
// to be related to the amount of set_properties being used, "set_property expects at least one object"

//Period 60Hz
module miniProjectSource(
    //TODO: Review all variables, are all of them neccesary?
    //TODO: Add more coments so I can remember what any of this does
    input clock,
    input in0,in1,in2,in3,in4,in5,in6,in7,
    input btnC,
    output PWM,
    input wire control1,control2,
    input testport,
    output reg a,b,c,d,e,f,
    output s0,s1,s2,s3,s4,s5,s6,dp,
    output LED0,LED1,LED2,LED3,LED4,
    input colorinput,
    output colors2,colors3,
    output [3:0] an,
    output testfrq,
    output JA4,JA5,JA6
    );
   
MovementModule moveRover(
    .clock(clock),
    .in0(in0),
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .in4(in4),
    .in5(in5),
    .in6(in6),
    .in7(in7),
    .btnC(btnC),
    .PWM(PWM),
    .control1(control1),
    .control2(control2),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f)
    );   
   
ColorSensor sensecolor(
    .clock(clock),
    .colorinput(colorinput),
    .s2(colors2),
    .s3(colors3),
    .frqdone(),
    .divdone(),
    .FRQ(),
    .tempquo(),
    .RED(JA4),
    .GREEN(JA5),
    .BLUE(JA6)
    );
    
//D4,D3,D2,D1 are what get displayed, in that order 
SevenSegmentDisplay SevenDisplay(
.clock(clock),
.reset(),
.a(s0),
.b(s1),
.c(s2),
.d(s3),
.e(s4),
.f(s5),
.g(s6),
.dp(dp),
.in0(D1),
.in1(D2),
.in2(D3),
.in3(D4),
.an(an)
);

endmodule
