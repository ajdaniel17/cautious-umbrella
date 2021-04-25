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

module Prometheus(
    input clock,
    input in0,in1,in2,in3,
    input btnC,btnU,
    output JC1,JC2,JC3,JC4,JC5,JC6,
    output s0,s1,s2,s3,s4,s5,s6,dp,
    output LED0,LED1,LED2,LED3,LED4,LED5,LED7,LED8,LED9,LED12,LED14,LED15,
    //input Encoder1A,Encoder1B,Encoder2A,Encoder2B,
    //LED12,LED13,LED14,LED15,
    input colorinput,
    output colors2, colors3,
    //input colorinput2,
    //output color2s2, color2s3,

    output trigger1,trigger2,
    input echo1,echo2,
    input IRSense1, IRSense2,
    output [3:0] an
    );

    wire [5:0]D1,D2,D3,D4;

    

Search_Algorithm Brain(
.clock(clock),
.JA5(echo1),
.JA4(trigger1),
.echo2(echo2),
.trigger2(trigger2),
.S0(in0),
.S1(in1),
.S2(in2),
.S3(in3),
.in1(JC3),
.in2(JC4),
.in3(JC5),
.in4(JC6),
.enA(JC1),
.enB(JC2),
.D1o(D1),
.D2o(D2),
.D3o(D3),
.D4o(D4),
.LED0(LED0),
.LED1(LED1),
.LED2(LED2),
.LED3(LED3),
.LED4(LED4),
.LED5(LED5),
.LED7(LED7),
.LED8(LED8),
.LED9(LED9),
.LED12(LED12),
.IRSense1(IRSense1),
.IRSense2(IRSense2),
.colorinput(colorinput),
.colors2(colors2),
.colors3(colors3)
//.colorinput2(colorinput2),
//.color2s2(color2s2),
//.color2s3(color2s3)
);

//D4,D3,D2,D1 are what get displayed, in that order 
SevenSegmentDisplay SevenDisplay(
.clock(clock),
.reset(),
.s0(s0),
.s1(s1),
.s2(s2),
.s3(s3),
.s4(s4),
.s5(s5),
.s6(s6),
.dp(dp),
.input0(D4),
.input1(D3),
.input2(D2),
.input3(D1),
.an(an)
);
    assign LED14 = IRSense1;
    assign LED15 = IRSense2;
endmodule