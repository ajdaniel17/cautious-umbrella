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
    input distanceDone,
    input signed [15:0] tic_count_L,tic_count_R,
    input Encoder1A,Encoder1B,Encoder2A,Encoder2B,
    input IRSense1, IRSense2
    );
    localparam IDLE = 0,
               ALIGN = 1;
    
    reg [21:0] counter = 0;
    reg [31:0] counter2 = 0;
    reg [31:0] counter3 = 0;
    reg [31:0] counter4 = 0;
    reg [31:0] width1;
    reg [31:0] width2;
    reg temp_PWM = 0;
    reg temp_PWM2 = 0;
    reg Distance1ENA = 0;
    reg [31:0]lastDistance = 0;
    reg ANGRYFLAG = 0;
    reg [31:0] target = 200;
    reg [31:0] trueDistance = 0;
    reg debug = 0;
    reg [3:0] state = 1;
    reg aligned = 1;
    reg startalign = 1;
    reg [31:0] shortestDistance = 1000000000;
    reg [31:0] previousShortestDistance = 0;
    reg turn = 0;
    reg doneR = 0;
    reg doneL = 0;
    reg start = 1;
    reg [31:0] IRcount1 = 0;
    reg [31:0] IRcount2 = 0;
    reg IRdone1 = 0;
    reg IRdone2 = 0;
    
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

LightYagami Left_Side(
    .signalA(Encoder1A),
    .signalB(Encoder1B),
    .clock(clock),
    .tic_count(tic_count_L),
    .D1(),
    .D2(),
    .D3(),
    .D4(),  
    .divdone1(),
    .divdone2(),
    .divdone3(),
    .divdone4(),   
    .tempD1(),
    .tempD2(),
    .tempD3(),
    .tempD4()
    );
    
Encoder_Reader Right_Side(
    .signalA(Encoder2A),
    .signalB(Encoder2B),
    .clock(clock),
    .tic_count(tic_count_R),
    .D1(),
    .D2(),
    .D3(),
    .D4(),  
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
if(distanceDone)
    trueDistance <= Distance1;
    previousShortestDistance <= shortestDistance;
end

always @ (posedge clock) begin
    lastDistance <= trueDistance;
end

always @ (posedge clock) begin

                if (counter > 1666666)
                    counter <= 0;
                else
                    counter <= counter +1;
                    
                if(counter < width1)
                   temp_PWM <= 1;
                else 
                   temp_PWM <= 0;
                   
               if (counter4 > 1666666)
                    counter4 <= 0;
                else
                    counter4 <= counter +1;
                    
                if(counter4 < width2)
                   temp_PWM2 <= 1;
                else 
                   temp_PWM2 <= 0;    
                   
               if (counter2 > 1000000) begin
                Distance1ENA <= 1;
                counter2 <= 0;
               end
               else if (distanceDone)begin
                 Distance1ENA <= 0;
                counter2 <= counter2 + 1;
               end 
    case(state)
    IDLE:
    begin
    
    end
    ALIGN:
    begin    
   
    enA <= temp_PWM;
    enB <= temp_PWM2;
    
    if(start) begin
        width1 <= 450000;
        width2 <= 450000;
        if(IRdone1==1 & IRdone2==1) begin
            in1<=0;
            in2<=0;
            in3<=0;
            in4<=0;
            start <= 0;
            turn <= 1;
        end
        else begin
            if(IRcount1 > 1666666) begin
                in1 <= 0;
                in2 <= 0;
                IRdone1 <= 1;
            end 
            else if(IRSense1 == 0) begin
                IRcount1 <= IRcount1 + 1;
                /*in1 <= 0;
                in2 <= 0;*/
            end
            else begin
                IRcount1 <= 0;
                in1 <= 0;
                in2 <= 1;
            end
            
            if(IRcount2 > 1666666) begin
                in3 <= 0;
                in4 <= 0;
                IRdone2 <= 1;
            end 
            else if(IRSense2 == 0) begin
                IRcount2 <= IRcount2 + 1;
                /*in3 <= 0;
                in4 <= 0;*/
            end
            else begin
                IRcount2 <= 0;
                in3 <= 1;
                in4 <= 0;
            end
        end
    end
    
    if(turn) begin
        
        if(tic_count_L < 1800) begin
                in1 <= 1;
                in2 <= 0;
                width1 <= 500000;
            end
            else begin
               in1 <= 0;
               in2 <= 0;
               doneL <= 1;
               //turn <= 1;
               //aligned <= 0;
            end
            
            if(tic_count_R > -1700) begin
               in3 <= 1;
               in4 <= 0;
               width2 <= 500000;
               //width2 <= 500000;
            end
            else begin
               in3 <= 0;
               in4 <= 0;
               doneR <= 1;
               //turn <= 1;
               //aligned <= 0;
               end
  
            if((doneR == 1 || doneL == 1)) begin
                //stuff 
            end
    end
    
    end
        /*if(~turn) begin

            if(shortestDistance > trueDistance & trueDistance > 100)
                shortestDistance <= trueDistance;
                
            //if(tic_count_R < 10000 & tic_count_L < 10000) begin
            
            if(tic_count_L < 1800) begin
                in1 <= 1;
                in2 <= 0;
                width1 <= 420000;
            end
            else begin
               in1 <= 0;
               in2 <= 0;
               doneL <= 1;
               //turn <= 1;
               //aligned <= 0;
            end
            
            if(tic_count_R > -1700) begin
               in3 <= 1;
               in4 <= 0;
               width2 <= 420000;
               //width2 <= 500000;
            end
            else begin
               in3 <= 0;
               in4 <= 0;
               doneR <= 1;
               //turn <= 1;
               //aligned <= 0;
               end
               
            
            if((doneR == 1 || doneL == 1)) begin
                
            end

           end*/
             
               
        
                
        /*if(~aligned) begin
            if((trueDistance > (shortestDistance + 20)) || (trueDistance<100)) begin
               in1 <= 0;
               in2 <= 1;
               in3 <= 0;
               in4 <= 1;
               width1 <= 420000;
               width2 <= 420000;
            end
            else
            begin
               in1 <= 0;
               in2 <= 0;
               in3 <= 0;
               in4 <= 0;
               aligned = 1;
            end
            end*/
//            end
//            if(startalign)
//            begin
//               shortestDistance <= trueDistance;
               
//               startalign = 0;
//            end
//            if(lastDistance > trueDistance) begin
//               in1 <= 1;
//               in2 <= 0;
//               in3 <= 1;
//               in4 <= 0;
//            end
//            if(lastDistance < trueDistance) begin
//               in1 <= 0;
//               in2 <= 1;
//               in3 <= 0;
//               in4 <= 1;
//            end
            
//            if(shortestDistance < trueDistance)
//                shortestDistance <= trueDistance;
//            
//            if(counter > 10000000)
//                begin
//                counter <= 0;
//                end
//            else
//                counter <= counter +1; 
                
          

    
    endcase
        if(debug) begin
                if(trueDistance  > (target+200) || trueDistance  < (target- 200)) begin
                width1 <= 866666;
                end
                else if ((trueDistance < (target+50)) & (trueDistance > (target-50))) begin
                width1 <= 250000;
                
                end
                else if ((trueDistance < (target+100)) & (trueDistance > (target-100))) begin
                width1 <= 500000;
                end
                
                
                    
                if((Distance1>(trueDistance+50)) || (Distance1<(trueDistance - 50))) begin
                ANGRYFLAG <= 1;
                end
                else 
                    ANGRYFLAG <= 0;
                
                
               
                         
               
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
end

assign D1o = D1;
assign D2o = D2;
assign D3o = D3;
assign D4o = D4;
endmodule
