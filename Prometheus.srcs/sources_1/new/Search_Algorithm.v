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
    input clock,
    //input JA5,JA4,echo2,trigger2,
    input JA5, echo2,
    output JA4, trigger2,
    input S0,S1,S2,S3,
    //wire [31:0] Distance1,
    //wire [31:0] Distance2,
    output reg in1,in2,in3,in4,enA,enB,
    //wire led0,led1,led2,led3,led4,led5,led12,
    output LED0, LED1, LED2, LED3, LED4, LED5, LED7, LED8, LED9, LED12,
    //wire [4:0] D1s0,D2s0,D3s0,D4s0,D1s1,D2s1,D3s1,D4s1,D1s2,D2s2,D3s2,D4s2,D1s3,D2s3,D3s3,D4s3,
    output reg [5:0] D1o,D2o,D3o,D4o,
    //wire distanceDone,distance2Done,
    //wire signed [31:0] tic_count_L,tic_count_R,
    //input Encoder1A,Encoder1B,Encoder2A,Encoder2B,
    input IRSense1, IRSense2,
    input colorinput,
    output colors2, colors3
    //input colorinput2,
    //output color2s2, color2s3
    );
    localparam IDLE = 0,
               ALIGN = 1,
               SEARCH = 2;
    
    wire [31:0] Distance1;
    wire [31:0] Distance2;
    wire led0,led1,led2,led3,led4,led5,led12;
    wire led0_2,led1_2,led2_2,led3_2,led4_2,led5_2,led12_2;
    wire [5:0] D1s0,D2s0,D3s0,D4s0,D1s3,D2s3,D3s3,D4s3;
    wire distanceDone,distance2Done;
    //wire signed [31:0] tic_count_L,tic_count_R;
    wire RED, GREEN, BLUE;
    wire RED2, GREEN2, BLUE2;
    
    reg reset1 = 0, reset2 = 0;
    reg [31:0] resetCount = 0;
    reg [31:0] Distance2Pre;
    reg [21:0] counter = 0;
    reg [31:0] counter2 = 0;
    reg [31:0] counter3 = 0;
    reg [31:0] counter4 = 0;
    reg [31:0] width1;
    reg [31:0] width2;
    reg temp_PWM = 0;
    reg temp_PWM2 = 0;
    //reg Distance1ENA = 1;
    //reg Distance2ENA = 0;
    reg switch = 0;
    //reg [31:0]lastDistance = 0;
    reg ANGRYFLAG = 0;
    reg [31:0] target = 60;
    reg [31:0] target2 = 55;
    reg [3:0] turnNUM = 0;
    reg lengthstart = 0;
    reg incrementONCE = 1;
    reg increment2ONCE = 0;
    reg [3:0] AidanVars = 0;
    reg rightShoveStart = 0;
    reg rightShoveDone = 0;
    reg leftShoveStart = 0;
    reg leftShoveDone = 0;
    reg [31:0] shoveCount = 0;
    reg [31:0] REDcount = 0;
    reg [31:0] GREENcount = 0;
    reg [31:0] BLUEcount = 0;
    reg [31:0] RED2count = 0;
    reg [31:0] GREEN2count = 0;
    reg [31:0] BLUE2count = 0;
    reg redLED = 0;
    reg greenLED = 0;
    reg blueLED = 0;
    reg [31:0] colorRESET = 0;
    
    reg [31:0] trueDistance1 = 0;
    reg [31:0] trueDistance2 = 0;
    reg debug = 0;
    reg [3:0] state = 0;
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
    reg turnBuffer = 0;
    reg [31:0] turnCounter = 0;
    reg colorflag = 0;
    reg [31:0]colorstop = 0;
    reg colorbuffer = 0;
    reg [31:0] colorbuffercounter = 0;
    
    reg trueled0,trueled1,trueled2,trueled3,trueled4,trueled5,trueled12;
    
    //assign truedistance1 = Distance1;
    
    assign LED0 = trueled0;
    assign LED1 = trueled1;
    assign LED2 = trueled2;
    assign LED3 = trueled3;
    assign LED4 = trueled4;
    assign LED5 = trueled5;
    
    /*assign LED7 = redLED;
    assign LED8 = greenLED;
    assign LED9 = blueLED;*/
    assign LED7 = RED;
    assign LED8 = GREEN;
    assign LED9 = BLUE;
    
    assign LED12 = trueled12;
    
UltraSonic_DistanceSensor FindDistance1(
.led0(led0),
.led1(led1),
.led2(led2),
.led3(led3),
.led4(led4),
.led5(led5),
.led12(led12),
.btnU(1'b1),
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

UltraSonic_DistanceSensor SecondFindDistance(
.led0(led0_2),
.led1(led1_2),
.led2(led2_2),
.led3(led3_2),
.led4(led4_2),
.led5(led5_2),
.led12(led12_2),
.btnU(1'b1),
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


/*HyperSonic FindDistance2(
.btnU(1'b1),
.clock(clock),
.echo(echo2),
.trigger(trigger2),
.distance2(Distance2),
.D1(D1s3),
.D2(D2s3),
.D3(D3s3),
.D4(D4s3),  
.done(distance2Done)
); */

/*Encoder_Reader Left_Side(
    .signalA(Encoder1A),
    .signalB(Encoder1B),
    .clock(clock),
    .tic_count(tic_count_L),
    .D1(D1s1),
    .D2(D2s1),
    .D3(D3s1),
    .D4(D4s1),
    .reset(reset1)
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
    .reset(reset2)
    );*/
    
ColorSensor sensecolor(
    .clock(clock),
    .colorinput(colorinput),
    .s2(colors2),
    .s3(colors3),
    .RED(RED),
    .GREEN(GREEN),
    .BLUE(BLUE)
    );
    /*
ColorSensor sensecolor2(
    .clock(clock),
    .colorinput(color2input2),
    .s2(color2s2),
    .s3(color2s3),
    .RED(RED2),
    .GREEN(GREEN2),
    .BLUE(BLUE2)
    );
*/

always @ (posedge clock) begin
if(S0) begin
trueled0 <= led0;
trueled1 <= led1;
trueled2 <= led2;
trueled3 <= led3;
trueled4 <= led4;
trueled5 <= led5;
trueled12 <= led12;
D1o <= D1s0;
D2o <= D2s0;
D3o <= D3s0;
D4o <= D4s0;
end
else if(S3) begin
trueled0 <= led0_2;
trueled1 <= led1_2;
trueled2 <= led2_2;
trueled3 <= led3_2;
trueled4 <= led4_2;
trueled5 <= led5_2;
trueled12 <= led12_2;
D1o <= D1s3;
D2o <= D2s3;
D3o <= D3s3;
D4o <= D4s3;
end
else begin 
if(redLED) begin
D1o <= 5'd18;
D2o <= 5'd17;
D3o <= 5'd16;
D4o <= 5'd24;
end
else if(blueLED) begin
D1o <= 5'd17;
D2o <= 5'd23;
D3o <= 5'd22;
D4o <= 5'd21;
end
else if(greenLED) begin
D1o <= 5'd20;
D2o <= 5'd16;
D3o <= 5'd19;
D4o <= 5'd24;
end
else begin
    D1o <= 5'd24;
    D2o <= 5'd24;
    D3o <= 5'd24;
    D4o <= 5'd24;
end
end

end

/*always @ (posedge clock) begin
if(distanceDone)
    trueDistance <= Distance1;
    previousShortestDistance <= shortestDistance;
end*/

/*always @ (posedge clock) begin
    lastDistance <= trueDistance;
end*/

always @ (posedge clock) begin
    
    /*if(colorstop > 250000000) begin
        colorstop <= 0;
        //colorflag <= 0;
        colorbuffer <= 1;
    end
    else if(colorflag) begin
        colorstop <= colorstop + 1;
        colorRESET <= 0;
        REDcount <= 0;
        GREENcount <= 0;
        BLUEcount <= 0;
        RED2count <= 0;
        GREEN2count <= 0;
        BLUE2count <= 0;
        enA <= 0;
        enB <= 0;
        in1 <= 0;
        in2 <= 0;
        in3 <= 0;
        in4 <= 0;
    end
    
    if(colorbuffercounter > 200000000) begin
        colorbuffercounter <= 0;
        colorbuffer <= 0;
    end
    else if(colorbuffer) begin
        colorbuffercounter <= colorbuffercounter + 1;
        redLED <= 0;
        greenLED <= 0;
        blueLED <= 0;
    end
    
    if(colorbuffercounter == 1) begin
        colorflag <= 0;
    end*/
    
    if(distanceDone) begin
        trueDistance1 <= Distance1;
    end
    if(distance2Done) begin
        if(AidanVars == 1) begin
        Distance2Pre <= trueDistance2;
        AidanVars <= 0;
        trueDistance2 <= Distance2;
        end
        else
            AidanVars <= AidanVars + 1;
    end
    
    
                if (counter > 1666666)
                    counter <= 0;
                else
                    counter <= counter +1;
                    
                if(counter < width1 )
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
                   
//               if (counter2 > 2000) begin
//                 Distance1ENA <= 1;
//                 counter2 <= 0;       
//               end
//               else if (distanceDone)begin
//                 Distance1ENA <= 0;
//                 Distance2ENA <= 1;
//               end
//               else if(distance2Done) begin
//               Distance2ENA <= 0;
//               counter2 <= 0;
//               end 
//               else if (distanceDone & distance2Done) begin
//                counter2 <= counter2 + 1;
//               end
//               else begin
//                counter2 <= 0;
//               end

if(rightShoveStart & ~colorflag) begin
    width1 <= 450000;
    width2 <= 1666666;
    enA <= temp_PWM;
    enB <= temp_PWM2;
    
    if(shoveCount > 40000000) begin
        in1 <= 0;
        in2 <= 0;
        in3 <= 0;
        in4 <= 0;
        rightShoveStart <= 0;
        rightShoveDone <= 1;
        shoveCount <= 0;
    end
    else begin
        in1 <= 0;
        in2 <= 1;
        in3 <= 1;
        in4 <= 0;
        shoveCount <= shoveCount + 1;
    end
end 

if(leftShoveStart & ~colorflag) begin
    width1 <= 1666666;
    width2 <= 450000;
    enA <= temp_PWM;
    enB <= temp_PWM2;
    
    if(shoveCount > 40000000) begin
        in1 <= 0;
        in2 <= 0;
        in3 <= 0;
        in4 <= 0;
        rightShoveStart <= 0;
        leftShoveDone <= 1;
        shoveCount <= 0;
    end
    else begin
        in1 <= 0;
        in2 <= 1;
        in3 <= 1;
        in4 <= 0;
        shoveCount <= shoveCount + 1;
    end
end                 
               
if(turn & ~colorflag) begin
    width1 <= 800000;
    width2 <= 800000;
    enA <= temp_PWM;
    enB <= temp_PWM2;
    
    if(turncounter > 145000000) begin
    turncounter <= 0;
    turndone <= 1; 
    in1 <= 0;
    in2 <= 0;
    in3 <= 0;
    in4 <= 0;
    turn <= 0;
    end
    else begin
    turncounter <= turncounter + 1;
    in1 <= 1;
    in2 <= 0;
    in3 <= 1;
    in4 <= 0;
    end
end
/*
    if((state == SEARCH) & (~colorflag) & (~colorbuffer)) begin
        if(RED) begin
            REDcount <= REDcount + 1;
        end
        if(GREEN) begin
            GREENcount <= GREENcount + 1;
        end
        if(BLUE) begin
            BLUEcount <= BLUEcount + 1;
        end
        
        if(RED2) begin
            RED2count <= RED2count + 1;
        end
        if(GREEN2) begin
            GREEN2count <= GREEN2count + 1;
        end
        if(BLUE2) begin
            BLUE2count <= BLUE2count + 1;
        end
        
        if(colorRESET > 10000001) begin
            colorRESET <= 0;
            REDcount <= 0;
            GREENcount <= 0;
            BLUEcount <= 0;
            RED2count <= 0;
            GREEN2count <= 0;
            BLUE2count <= 0;
        end    
        else begin
            colorRESET <= colorRESET + 1;
        end
        
        if(REDcount > 7000000 & colorRESET > 10000000) begin
            redLED <= 1;
            colorflag <= 1;
        end
        else if(REDcount < 7000000 & colorRESET > 10000000) begin
            redLED <= 0;
        end
        
        if(GREENcount > 7000000 & colorRESET > 10000000) begin
            greenLED <= 1;
            colorflag <= 1;
        end
        else if(GREENcount < 7000000 & colorRESET > 10000000) begin
            greenLED <= 0;
        end
        
        if(BLUEcount > 7000000 & colorRESET > 10000000) begin
            blueLED <= 1;
            colorflag <= 1;
        end
        else if(BLUEcount < 7000000 & colorRESET > 10000000) begin
            blueLED <= 0;
        end
        
        if(RED2count > 7000000 & colorRESET > 10000000) begin
            redLED <= 1;
            colorflag <= 1;
        end
        else if(RED2count < 7000000 & colorRESET > 10000000) begin
            redLED <= 0;
        end
        
        if(GREEN2count > 7000000 & colorRESET > 10000000) begin
            greenLED <= 1;
            colorflag <= 1;
        end
        else if(GREEN2count < 7000000 & colorRESET > 10000000) begin
            greenLED <= 0;
        end
        
        if(BLUE2count > 7000000 & colorRESET > 10000000) begin
            blueLED <= 1;
            colorflag <= 1;
        end
        else if(BLUE2count < 7000000 & colorRESET > 10000000) begin
            blueLED <= 0;
        end  
          
    end
*/
    /*if(turndone) begin
    in1 <= 0;
    in2 <= 0;
    in3 <= 0;
    in4 <= 0;
    turn <= 0;
    end*/
    /*if (resetCount > 1000) begin
        reset1 <= 0;
        reset2 <= 0;
        if(tic_count_L < 450 & tic_count_R > -450) begin
            in1 <= 1;
            in2 <= 0;
            in3 <= 1;
            in4 <= 0;
        end
        else begin
            in1 <= 0;
            in2 <= 0;
            in3 <= 0;
            in4 <= 0;
            turndone <= 1;
            turn <= 0;
            resetCount <= 0;
        end
    end
    else begin
        resetCount <= resetCount + 1;
        reset1 <= 1;
        reset2 <= 1;
        in1 <= 0;
        in2 <= 0;
        in3 <= 0;
        in4 <= 0;
    end*/
    
    /*if(turncounter > 175000000) begin
    turncounter <= 0;
    turndone <= 1; 
    in1 <= 0;
    in2 <= 0;
    in3 <= 0;
    in4 <= 0;
    turn <= 0;
    end
    else begin
    turncounter <= turncounter + 1;
    in1 <= 1;
    in2 <= 0;
    in3 <= 1;
    in4 <= 0;
    end*/
    
    /*if(turndone) begin
    in1 <= 0;
    in2 <= 0;
    in3 <= 0;
    in4 <= 0;
    turn <= 0;
    end*/


    case(state)
    IDLE:
    begin
        
        /*if(RED) begin
            if(REDcount > 1666666) begin
                redLED <= 1;
                REDcount <= 0;
                
            end
            else begin
                REDcount <= REDcount + 1;
            end
        end
        else begin
            REDcount <= 0;
        end
        if(GREEN) begin
            GREENcount <= GREENcount + 1;
        end
        if(BLUE) begin
            BLUEcount <= BLUEcount + 1;
        end*/
        
        if(RED) begin
            redLED <= 1;
        end
        else
            redLED <= 0;
        if(GREEN) begin
            greenLED <= 1;
        end
        else
            greenLED <= 0;
        if(BLUE) begin
            blueLED <= 1;
        end
        else
            blueLED <= 0;
        
        /*if(RED) begin
            REDcount <= REDcount + 1;
        end
        if(GREEN) begin
            GREENcount <= GREENcount + 1;
        end
        if(BLUE) begin
            BLUEcount <= BLUEcount + 1;
        end
        
        if(colorRESET > 10000001) begin
            colorRESET <= 0;
            REDcount <= 0;
            GREENcount <= 0;
            BLUEcount <= 0;
        end    
        else begin
            colorRESET <= colorRESET + 1;
        end
        
        if(REDcount > 7000000 & colorRESET > 10000000) begin
            redLED <= 1;
        end
        else if(REDcount < 7000000 & colorRESET > 10000000) begin
            redLED <= 0;
        end
        
        if(GREENcount > 7000000 & colorRESET > 10000000) begin
            greenLED <= 1;
        end
        else if(GREENcount < 7000000 & colorRESET > 10000000) begin
            greenLED <= 0;
        end
        
        if(BLUEcount > 7000000 & colorRESET > 10000000) begin
            blueLED <= 1;
        end
        else if(BLUEcount < 7000000 & colorRESET > 10000000) begin
            blueLED <= 0;
        end*/
        
        
    end
    ALIGN:
    begin    
    
    if(start) begin
        enA <= temp_PWM;
        enB <= temp_PWM2;
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
            else if(IRSense1 == 1) begin
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
            else if(IRSense2 == 1) begin
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
    enA <= temp_PWM;
    enB <= temp_PWM2;
    width1 <= 500000;
    width2 <= 500000;
    if(firstturn == 1) begin
        if(IRcount1 > 1666666) begin
            in1 <= 0;
            in2 <= 0;
            in3 <= 0;
            in4 <= 0;
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
            in3 <= 0;
            in4 <= 0;
        end
        
    end
    
    if (firstturn == 2) begin
        if(IRcount2 > 1666666) begin
            in1 <= 0;
            in2 <= 0;
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
            in1 <= 0;
            in2 <= 0;
            in3 <= 0;
            in4 <= 1;
            IRcount2 <= 0;
        end
    end
    end
    
      if(turndone) begin
        
        enA <= temp_PWM;
        enB <= temp_PWM2;
      
        if(trueDistance1 > (target+125)) begin
            if(trueDistance2 < 88) begin
            width1 <= 400000;
            width2 <= 700000;
            end
            else if(trueDistance2 > 92) begin
            width1 <= 700000;
            width2 <= 400000;
            end
            else begin
            width1 <= 700000;
            width2 <= 700000;
            end
        end
        else if ((trueDistance1 < (target+75)) & (trueDistance1 > (target-75))) begin
            width1 <= 300000;
            width2 <= 300000;
        end
        else if ((trueDistance1 < (target+125))) begin
            if(trueDistance2 < 87) begin
              width1 <= 300000;
              width2 <= 500000;
            end
            else if(trueDistance2 > 93) begin
              width1 <= 500000;
              width2 <= 300000;
            end
            else begin
              width1 <= 500000;
              width2 <= 500000;
            end

        end
        
        if(trueDistance1 < (target-10)) begin
           counter3 <= 0;
           in1 <= 1;
           in2 <= 0;
           in3 <= 0;
           in4 <= 1;
           enA <= temp_PWM;
           enB <= temp_PWM2;
       end
       else if (trueDistance1 > (target+10)) begin
           counter3 <= 0;
           in1 <= 0;
           in2 <= 1;
           in3 <= 1;
           in4 <= 0;
           enA <= temp_PWM;
           enB <= temp_PWM2;
       end
       else begin
           state <= 2;
           turndone <= 0;
           counter3 <= 0;
           enA <= 0;
           enB <= 0;
       end
    end
               
end
    
    SEARCH:
    begin
        
        if(turnCounter > 4) begin
            turnBuffer <= 1;
            turn <= 1;
            turnCounter <= 0;
        end
        else if(~turnBuffer) begin
            turnCounter <= turnCounter + 1;
        end
        
        
    if(turnBuffer & ~colorflag) begin
    
        if(turndone) begin
            turndone <= 0;
            lengthstart <= 1;
            
            if(turnNUM == 5) begin
                 //turnNUM <= 1;
                 if(incrementONCE) begin
                 increment2ONCE <= 1;
                 incrementONCE <= 0;
                 target <= target + 60;
                 turnNUM <= 1;
                 end
             end
             if(turnNUM == 2) begin
                if(increment2ONCE) begin
                incrementONCE <= 1;
                increment2ONCE <= 0;
                target2 <= target2 + 60;
                end
             end
            
        end
        
        if(lengthstart & ~colorflag) begin
            
            if(trueDistance1 > (target+50)) begin
                if (trueDistance2 < (target2+6) & trueDistance2 > (target2-6))begin
                rightShoveDone <= 0;
                leftShoveDone <= 0;
                in1 <= 0;
                in2 <= 1;
                in3 <= 1;
                in4 <= 0; 
                    if(trueDistance2 < (Distance2Pre-2)) begin
                       width1 <= 300000;
                       width2 <= (Distance2Pre - trueDistance2)* 300000;
                    end
                    else if (trueDistance2 > (Distance2Pre+2)) begin
                        width1 <= (trueDistance2 - Distance2Pre)* 300000;
                        width2 <= 300000;
                    end 
                    else begin
                        width1 <= 700000;
                        width2 <= 700000; 
                    end
                end  
                else if(trueDistance2 > (target2+6)) begin
                    if(rightShoveDone) begin
                        in1 <= 0;
                        in2 <= 1;
                        in3 <= 1;
                        in4 <= 0;
                        width1 <= 700000;
                        width2 <= 300000;
                    end
                    else begin
                        rightShoveStart <= 1;
                    end    
                end
                else if(trueDistance2 < (target2 - 6)) begin
                    if(leftShoveDone) begin
                        in1 <= 0;
                        in2 <= 1;
                        in3 <= 1;
                        in4 <= 0;
                        width1 <= 300000;
                        width2 <= 700000;
                    end
                    else begin
                        leftShoveStart <= 1;
                    end
                end
            end
            else if (trueDistance1 < (target+50)) begin
                width1 <= 300000;
                width2 <= 300000;
            end
            /*else if ((trueDistance1 < (target+125))) begin
                if(trueDistance2 < (target2-3)) begin
                    width1 <= 350000;
                    width2 <= 600000;
                end
                else if(trueDistance2 > (target+3)) begin
                    width1 <= 600000;
                    width2 <= 350000;
                end
                else begin
                    width1 <= 500000;
                    width2 <= 500000;
                end
            end*/
            
            /*if(trueDistance1 < (target-10)) begin
               counter3 <= 0;
               in1 <= 1;
               in2 <= 0;
               in3 <= 0;
               in4 <= 1;
               enA <= temp_PWM;
               enB <= temp_PWM2;
               //turndone <= 0;
           end*/
           if (trueDistance1 > (target+10)) begin
               counter3 <= 0;
               //turndone <= 0;
               in1 <= 0;
               in2 <= 1;
               in3 <= 1;
               in4 <= 0;
               enA <= temp_PWM;
               enB <= temp_PWM2;
           end
           else begin
               width1 <= 0;
               width2 <= 0; 
               counter3 <= 0;
               in1 <= 0;
               in2 <= 0;
               in3 <= 0;
               in4 <= 0;
               lengthstart <= 0;
               turnNUM <= turnNUM + 1;
               turn <= 1;
           end
        end
    end
        
    end  
       /*if (Distance1 < 50 ) begin
           turndone <= 0;
           counter3 = 0;
           enA = 0;
           enB = 0;
       end*/
       
          

    
    endcase
        /*if(debug) begin
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
              end*/
end


endmodule
