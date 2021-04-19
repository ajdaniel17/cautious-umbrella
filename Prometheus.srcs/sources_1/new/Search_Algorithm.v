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
    input clock,JA5,JA4,echo2,trigger2,
    input S0,S1,S2,S3,
    input [31:0] Distance1,
    input [31:0] Distance2,
    output reg in1,in2,in3,in4,enA,enB,
    input led0,led1,led2,led3,led4,led5,led12,
    output LED0, LED1, LED2, LED3, LED4, LED5, LED12,
    input [4:0] D1s0,D2s0,D3s0,D4s0,D1s1,D2s1,D3s1,D4s1,D1s2,D2s2,D3s2,D4s2,D1s3,D2s3,D3s3,D4s3,
    output reg [4:0] D1o,D2o,D3o,D4o,
    input distanceDone,distance2Done,
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
    reg Distance1ENA = 1;
    reg Distance2ENA = 0;
    reg switch = 0;
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
    reg align2 = 0;
    reg [1:0]firstturn = 0;
    reg [31:0] turncounter = 0;
    reg turndone = 0;
    
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
.btnU(Distance1ENA),
.clock(clock),
.echo(JA5),
.trigger(JA4),
.distance(Distance1),
.D1(D1s0),
.D2(D2s0),
.D3(D3s0),
.D4(D4s0),  
.done(distanceDone)
);

HyperSonic FindDistance2(
.btnU(Distance2ENA),
.clock(clock),
.echo(echo2),
.trigger(trigger2),
.distance(Distance2),
.D1(D1s3),
.D2(D2s3),
.D3(D3s3),
.D4(D4s3),  
.done(distance2Done)
);  

LightYagami Left_Side(
    .signalA(Encoder1A),
    .signalB(Encoder1B),
    .clock(clock),
    .tic_count(tic_count_L),
    .D1(D1s1),
    .D2(D2s1),
    .D3(D3s1),
    .D4(D4s1),  
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
    .D1(D1s2),
    .D2(D2s2),
    .D3(D3s2),
    .D4(D4s2),  
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
if(S0) begin
D1o = D1s0;
D2o = D2s0;
D3o = D3s0;
D4o = D4s0;
end
else if (S1) begin
D1o = D1s1;
D2o = D2s1;
D3o = D3s1;
D4o = D4s1;
end 
else if (S2) begin
D1o = D1s2;
D2o = D2s2;
D3o = D3s2;
D4o = D4s2;
end
else if(S3) begin
D1o = D1s3;
D2o = D2s3;
D3o = D3s3;
D4o = D4s3;
end
else begin 
D1o = 0;
D2o = 0;
D3o = 0;
D4o = 0;
end

end

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
                   
               if (counter2 > 2000) begin
                 Distance1ENA <= 1;
                 counter2 <= 0;       
               end
               else if (distanceDone)begin
                 Distance1ENA <= 0;
                 Distance2ENA <= 1;
               end
               else if(distance2Done) begin
               Distance2ENA <= 0;
               counter2 <= 0;
               end 
               else if (distanceDone & distance2Done) begin
                counter2 <= counter2 + 1;
               end
               else begin
                counter2 <= 0;
               end
               
               
if(turn) begin
    width1 <= 650000;
    width2 <= 650000;
    enA <= temp_PWM;
    enB <= temp_PWM2;
    if(turncounter > 200000000) begin
    turncounter <= 0;
    turndone <= 1; 
    end
    else begin
    turncounter <= turncounter + 1;
    in1 <= 1;
    in2 <= 0;
    in3 <= 1;
    in4 <= 0;
    end
    
    if(turndone) begin
    in1 <= 0;
    in2 <= 0;
    in3 <= 0;
    in4 <= 0;
    turn <= 0;
    end
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
            align2 <= 1;
        end
        else begin
            if(IRcount1 > 1666666) begin
                in1 <= 0;
                in2 <= 0;
                IRcount1 <= 0;
                IRdone1 <= 1;
                if(firstturn == 0) begin
                firstturn <= 1;
                end
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
                IRcount2 <= 0;
                IRdone2 <= 1;
                if(firstturn == 0) begin
                firstturn <= 2;
                end
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
    
    if(align2) begin
    width1 <= 380000;
    width2 <= 380000;
    if(firstturn == 1) begin
        if(IRcount1 > 1666666) begin
            in1 <= 0;
            in2 <= 0;
            turn <= 1;
            align2 <= 0;
        end
        else if(IRSense1 == 1) begin
            IRcount1 <= IRcount1 + 1 ;
        end
        else
        begin
            IRcount1 <= 0;
            in1 <= 1;
            in2 <= 0;
        end
        
    end
    
    if (firstturn == 2) begin
        if(IRcount2 > 1666666) begin
            in3 <= 0;
            in4 <= 0;
            turn <= 1;
            align2 <= 0;
        end
        else if(IRSense2 == 1) begin
           IRcount2 <= IRcount2 +1; 
        end
        else
        begin
            in3 <= 0;
            in4 <= 1;
            IRcount2 <= 0;
        end
    end
    end
    
      if(turndone) begin
      
      end
//    if(turn) begin
        
//        if(tic_count_L < 1800) begin
//                in1 <= 1;
//                in2 <= 0;
//                width1 <= 500000;
//            end
//            else begin
//               in1 <= 0;
//               in2 <= 0;
//               doneL <= 1;
//               //turn <= 1;
//               //aligned <= 0;
//            end
            
//            if(tic_count_R > -1700) begin
//               in3 <= 1;
//               in4 <= 0;
//               width2 <= 500000;
//               //width2 <= 500000;
//            end
//            else begin
//               in3 <= 0;
//               in4 <= 0;
//               doneR <= 1;
//               //turn <= 1;
//               //aligned <= 0;
//               end
  
//            if((doneR == 1 || doneL == 1)) begin
//                //stuff 
//            end
//    end
    
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


endmodule
