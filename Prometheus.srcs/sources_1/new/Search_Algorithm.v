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
    output[4:0] D1o,D2o,D3o,D4o
    );
 
    reg [21:0] counter = 0;
    reg [31:0] counter2 = 0;
    reg [21:0] width = 450000;
    reg temp_PWM = 0;
    reg Distance1ENA = 0;
    reg [31:0]lastDistance = 0;
    reg ANGRYFLAG = 0;
    
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
.tempD4()
); 

always @ (posedge clock) begin
    lastDistance <= Distance1;
end

always @ (posedge clock) begin

        if (counter > 1666666)
            counter <= 0;
        else
            counter <= counter +1;
            
        if(lastDistance > (Distance1+50) || lastDistance < (Distance1 - 50)) begin
        ANGRYFLAG = 1;
        end
        else 
            ANGRYFLAG = 0;
        
        if(counter < width)
           temp_PWM <= 1;
        else 
           temp_PWM <= 0;   
       
       if (counter2 > 10000000) begin
        Distance1ENA <= 1;
        counter2 <= 0;
       end
       else begin
         Distance1ENA <= 0;
        counter2 <= counter2 + 1;
       end           
       
       if (Distance1 == 0 || ANGRYFLAG == 1) begin
        enA = 0;
        enB = 0;
       end
       else if(Distance1 < 695) begin
       in1 = 1;
       in2 = 0;
       in3 = 0;
       in4 = 1;
       enA = temp_PWM;
       enB = temp_PWM;
       end
      else if (Distance1 > 705) begin
       in1 = 0;
       in2 = 1;
       in3 = 1;
       in4 = 0;
       enA = temp_PWM;
       enB = temp_PWM;
      end
      else begin
      enA = 0;
      enB = 0;
      end
end

assign D1o = D1;
assign D2o = D2;
assign D3o = D3;
assign D4o = D4;
endmodule