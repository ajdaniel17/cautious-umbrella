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
module Prometheus(
    //TODO: Review all variables, are all of them neccesary?
    //TODO: Add more coments so I can remember what any of this does
    input clock,
    input in0,in1,in2,in3,in4,in5,in6,in7,
    input btnC,btnU,
    output PWM,
    input wire control1,control2,
    input testport,
    output JC1,JC2,JC3,JC4,JC5,JC6,
    output s0,s1,s2,s3,s4,s5,s6,dp,
    output LED0,LED1,LED2,LED3,LED4,LED5,LED12,LED14,LED15,
    input Encoder1A,Encoder1B,Encoder2A,Encoder2B,
    //LED12,LED13,LED14,LED15,
    input colorinput,

    output [3:0] an,
    //output testfrq,
    output trigger1,
    input echo1,
    input JB2,
    input JB3,
    input JX1,JX1n,JX2,JX2n,JX3,JX3n,JX4,JX4n,
    input IRSense1, IRSense2
    //input L0 ,led1,led2,led3,led4,led5

    //input[4:0] D1,D2,D3,D4,
    //output reg [4:0] oD1,oD2,oD3,oD4
    );
    //reg [4:0] tempD1,tempD2,tempD3,tempD4;
    wire [4:0]D1,D2,D3,D4;
    wire signed [15:0] tic_count;
    reg [31:0] count1 = 0;
    reg [31:0] count2 = 0;
    reg counter1 = 1;
    reg counter2 = 0;
    reg clk2 = 0;
    reg [3:0] clockCounter = 0;
    wire signed[31:0] bridge1,bridge2,bridge3;
    
    
    always @ (posedge clock) begin
    
     if (clockCounter > 9) begin
      clockCounter <= 0;
      clk2 <= ~clk2;
     end
     else begin
     clockCounter <= clockCounter + 1;
     end
     
    end


Search_Algorithm Brain(
.clock(clock),
.JA5(echo1),
.JA4(trigger1),
.Distance1(),
.in1(JC3),
.in2(JC4),
.in3(JC5),
.in4(JC6),
.enA(JC1),
.enB(JC2),
.D1(),
.D2(),
.D3(),
.D4(),
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
.LED12(LED12),
.Encoder1A(Encoder1A),
.Encoder1B(Encoder1B),
.Encoder2A(Encoder2A),
.Encoder2B(Encoder2B),
.IRSense1(IRSense1),
.IRSense2(IRSense2)
);

/*assign L0  = L0 ;
assign LED1 = led1;
assign LED2 = led2;
assign LED3 = led3;
assign LED4 = led4;
assign LED5 = led5;*/

/*
Distance_Sensor readDistance(
.JX1(JX1),
.JX1n(JX1n),
.JX2(JX2),
.JX2n(JX2n),
.JX3(JX3),
.JX3n(JX3n),
.JX4(JX4),
.JX4n(JX4n),
.clock(clock),
.vp_in(),
.vn_in(),
.D1(D1),
.D2(D2),
.D3(D3),
.D4(D4)
);
*/
/*
Encoder_Reader readEncoder(
    .signalA(JB2),
    .signalB(JB3),
    .clock(clock),
    .tic_count(tic_count),
    .D1(D1),
    .D2(D2),
    .D3(D3),
    .D4(D4),  
    .divdone1(),
    .divdone2(),
    .divdone3(),
    .divdone4(),   
    .tempD1(),
    .tempD2(),
    .tempD3(),
    .tempD4()
    );*/
    /*
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
    );   */
   /*
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
    );*/
    
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