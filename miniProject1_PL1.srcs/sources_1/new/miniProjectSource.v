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
    output a,b,c,d,e,f,
    output s0,s1,s2,s3,s4,s5,s6,dp,
    output reg LED0,LED1,LED2,LED3,LED4,
    input colorinput,
    output colors2,colors3,
    output [3:0] an,
    output testfrq,
    output JA4,JA5,JA6,
    input JB2,
    input JB3

    //input[4:0] D1,D2,D3,D4,
    //output reg [4:0] oD1,oD2,oD3,oD4
    );
    //reg [4:0] tempD1,tempD2,tempD3,tempD4;
    wire [4:0]D1,D2,D3,D4;
    wire signed [15:0] tic_count;
    reg count = 0;
    reg clk2 = 0;
    
always @ (posedge clock)
begin
if(count > 1)
begin
count = 0;
clk2 = ~clk2;
end
else
    count = count + 1;

end

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

always @ (posedge clock)
begin
if(tic_count > 5)
    LED0 = 1;
else
    LED0 = 0;
    
if(tic_count < -5)
    LED1 = 1;
else 
    LED1 = 0;
end
endmodule
