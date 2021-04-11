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
    output reg in1,in2,in3,in4,enA,enB
    );
 
    reg [21:0] counter = 0;
    reg [31:0] counter2 = 0;
    reg [21:0] width = 500000;
    reg temp_PWM =0 ;
    reg Distance1ENA = 0;
    
UltraSonic_DistanceSensor FindDistance1(
.led0(),
.led1(),
.led2(),
.led3(),
.led4(),
.led5(),
.btnU(1'b1),
.led12(),/*
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

        if (counter > 1666666)
            counter <= 0;
        else
            counter <= counter +1;
            
        
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
       
       if (Distance1 == 0) begin
      enA = 0;
      enB = 0;;
       end
       else if(Distance1 < 98) begin
       in1 = 1;
       in2 = 0;
       in3 = 0;
       in4 = 1;
       enA = temp_PWM;
       enB = temp_PWM;
       end
      else if (Distance1 > 102) begin
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


endmodule
