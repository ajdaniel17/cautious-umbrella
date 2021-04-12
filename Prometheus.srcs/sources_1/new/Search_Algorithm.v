`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2021 10:26:09 PM
// Design Name: 
// Module Name: Search_Algorithm
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


module Search_Algorithm(
    input clock,JA5,JA4,
    input [31:0] Distance1,
    output reg in1,in2,in3,in4,enA,enB,
    input led0,led1,led2,led3,led4,led5,led12,
    output LED0, LED1, LED2, LED3, LED4, LED5, LED12,
    input [4:0] D1,D2,D3,D4,
    output[4:0] D1o,D2o,D3o,D4o,
    input distanceDone
    );
 
    reg [21:0] counter = 0;
    reg [31:0] counter2 = 0;
    reg [31:0] counter3 = 0;
    reg [31:0] width;
    reg temp_PWM = 0;
    reg Distance1ENA = 0;
    reg [31:0]lastDistance = 0;
    reg ANGRYFLAG = 0;
    reg [31:0] target = 300;
    reg [31:0] trueDistance = 0;
    
    assign LED0 = led0;
    assign LED1 = led1;
    assign LED2 = led2;
    assign LED3 = led3;
    assign LED4 = led4;
    assign LED5 = led5;
    assign LED12 = led12;
    
UltraSonic_DistanceSensor FindDistance1(
.led0(led0),
.led1(led1),
.led2(led2),
.led3(led3),
.led4(led4),
.led5(led5),
.led12(led12),
.btnU(1'b1),/*
.led12(led12)
.led13(LED13),
.led14(LED14),
.led15(LED15),*/
.clock(clock),
.echo(JA5),
.trigger(JA4),
.distance(Distance1),
.timecount(),
.divdone(),
.lastecho(),
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
.tempD4(),
.done(distanceDone)
); 

always @ (posedge clock) begin
if(distanceDone)
    trueDistance = Distance1;
end

always @ (posedge clock) begin
    lastDistance <= Distance1;
end

always @ (posedge clock) begin


        if(trueDistance  > (target+200) || trueDistance  < (target- 200)) begin
        width <= 866666;
        end
        else if ((trueDistance < (target+50)) & (trueDistance > (target-50))) begin
        width <= 250000;
        
        end
        else if ((trueDistance < (target+100)) & (trueDistance > (target-100))) begin
        width <= 500000;
        end
        
        if (counter > 1666666)
            counter <= 0;
        else
            counter <= counter +1;
            
        if((Distance1>(trueDistance+50)) || (Distance1<(trueDistance - 50))) begin
        ANGRYFLAG <= 1;
        end
        else 
            ANGRYFLAG <= 0;
        
        if(counter < width)
           temp_PWM <= 1;
        else 
           temp_PWM <= 0;   
       
       if (counter2 > 1000000) begin
        Distance1ENA <= 1;
        counter2 <= 0;
       end
       else if (distanceDone)begin
         Distance1ENA <= 0;
        counter2 <= counter2 + 1;
       end           
       
       //if (counter3 > 10000000) begin
       if (trueDistance < 50 || ANGRYFLAG == 1) begin
        counter3 = 0;
        enA = 0;
        enB = 0;
       end
       else if(trueDistance < (target-10)) begin
       counter3 = 0;
       in1 = 0;
       in2 = 1;
       in3 = 1;
       in4 = 0;
       enA = temp_PWM;
       enB = temp_PWM;
       end
      else if (trueDistance > (target+10)) begin
       counter3 = 0;
       in1 = 1;
       in2 = 0;
       in3 = 0;
       in4 = 1;
       enA = temp_PWM;
       enB = temp_PWM;
      end
      else begin
      counter3 = 0;
      enA = 0;
      enB = 0;
      end
      //end
      //else begin 
      //  counter3 = counter3 + 1;
      //end
end

assign D1o = D1;
assign D2o = D2;
assign D3o = D3;
assign D4o = D4;
endmodule
