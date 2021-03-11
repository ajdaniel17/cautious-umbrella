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
    
    localparam N = 18;
    
    //TODO: Review all regs used, are all of them neccesary?
    reg temp = 1;
    reg temp2 = 0;
    
    //100000000/60 = 1666666.667
    //log    (1666666.67) = 20.6 round up to 21
    //   (2)
    
    
    //100000000/9600 = 10416.667
    //log (base 2) (10416.667) = 14 (rounded up)
   
    reg [21:0] counter;
    reg [21:0] counter2;
    reg [21:0] width;
    reg [27:0] safety_count;
    reg temp_PWM;
    reg temptest;
    integer speed;
    reg [7:0]sseg;
    integer safety;
    integer D1,D2,D3,D4;
    integer i;
    reg testFRQ;
    
    initial begin
    testFRQ = 0;
    safety = 0;
    safety_count = 0;
    counter = 0;
    width = 0;
    temp_PWM = 0;
    D1 = 0;
    D2 = 1;
    D3 = 2;
    D4 = 3;
    end
    
    
    //baudrate of color sensor 9600
    always@(posedge clock) begin
        
        if (counter2 > 5000)
        begin
            counter2 <= 0;
            testFRQ = ~testFRQ;
        end
        else
            counter2 <= counter2 +1;
                
        if (counter > 1666666)
            counter <= 0;
        else if (safety == 0)
            counter <= counter +1;
            
        
        if(counter < width)
           temp_PWM <= 1;
        else 
           temp_PWM <= 0;   
              
            
        //If Current is over 1Amp for over .07 seconds, change the safety state
        if (control1 || control2) begin
        //Counts to make sure motors are pulling more than 1 Amp for .07 seconds
         if(safety_count > 7000000)
            safety=1; 
         else 
            safety_count <= safety_count +1;     
        end
          
        else begin 
            safety_count = 0;
            //reset safety state
            if(btnC) 
                safety = 0;
        end
        
            
    end

    // 100% duty cycle is 1666666.67
    //  75% duty cycle is 1250000
    //  50% duty cycle is 833333.33
    //  25% duty cycle is 416666.67 
    always @ (*)
    begin
    speed = (in0 + in1 + in2 + in3);
    
    case (speed)
    1 : width = 416666;     
    2 : width = 833333;
    3 : width = 1250000;
    4 : width = 1666666;
    default : width = 0;    
    endcase
    
    
    temptest = in0;
    
//    if(in4) begin
//        a = temp;
//        b = temp2;
//        end
//    else begin
//        a = temp2;
//        b = temp;
//        end
//    if(in5) begin
//        c = temp;
//        d = temp2;
//        end
//    else begin
//        c = temp2;
//        d = temp;
//        end  
        
//    if (in6 && safety == 0) begin
//        e = temp_PWM;
//        end
//    else begin
//        e = temp2;
//        end
        
//    if (in7 && safety == 0) begin
//        f = temp_PWM;
//        end
//    else begin
//        f = temp2;
//        end
        
        
    end
    
assign testfrq = testFRQ;
assign PWM = temp_PWM;

ColorSensor sensecolor(
    .clock(clock),
    .colorinput(colorinput),
    .s2(colors2),
    .s3(colors3),
    .LED0(LED0),
    .LED1(LED1),
    .LED2(LED2),
    .LED3(LED3),
    .LED4(LED4),
    .frqdone(),
    .divdone(),
    .FRQ(),
    .tempquo(),
    .JA4(JA4),
    .JA5(JA5),
    .JA6(JA6)
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
