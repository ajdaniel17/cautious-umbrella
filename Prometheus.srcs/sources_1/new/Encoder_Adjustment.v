`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2021 08:03:06 PM
// Design Name: 
// Module Name: Encoder_Adjustment
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


module Encoder_Adjustment(
    input clock,
    input signed[31:0] tic_count1,tic_count2,
    input [31:0] width,
    output reg PWM_1,PWM_2,
    input [31:0] Percent1,Percent2,
    
    
    input divdone1,divdone2,divdone3,divdone4,
    input [31:0] NewWidth1, NewWidth2,
    
    output led0,led1,led2,led3,led4,led5,led6
    );
    localparam ABSOLUTE = 0,
               COMPARE  = 1,
               SC1      = 2,
               SC2      = 3,
               RESTART  = 4;
    
    reg signed [2:0] negativeOne = -1;
    reg[31:0] width1,width2;
    reg[31:0] counter = 0;
    reg[31:0] prevWidth = 0;
    reg[31:0] counter2 = 0;
    reg signed [31:0] ticPoint1 = 0,ticPoint2 = 0;
    reg signed [31:0] ticdiff1 = 0,ticdiff2 = 0;
    reg [3:0] state = 0;
    reg DIVenable1 = 0,DIVenable2 = 0,DIVenable3 = 0,DIVenable4 = 0;
    reg initialize = 1;
    
    reg LED0 = 0,LED1 = 0,LED2 = 0, LED3 = 0, LED4 = 0, LED5 = 0, LED6 = 0;
    reg [31:0]Percent1local,Percent2local;
    
    reg corboVar1 = 0;
    reg corboVar2 = 0;
    
    
    
    
IntegerDivision SC1_Divider(
.enable(DIVenable1),
.done(divdone1),
.Dividend(ticdiff1),
.Divisor(ticdiff2),
.clock(clock),
.Quotient(Percent1),
.Remainder(),
.Percentagemode(1'b1)
);

IntegerDivision SC2_Divider(
.enable(DIVenable2),
.done(divdone2),
.Dividend(ticdiff2),
.Divisor(ticdiff1),
.clock(clock),
.Quotient(Percent2),
.Remainder(),
.Percentagemode(1'b1)
);

IntegerDivision SC1_FinalValue(
.enable(DIVenable3),
.done(divdone3),
.Dividend(width1),
.Divisor(Percent1local),
.clock(clock),
.Quotient(NewWidth1),
.Remainder(),
.Percentagemode(1'b0)
);

IntegerDivision SC2_FinalValue(
.enable(DIVenable4),
.done(divdone4),
.Dividend(width2),
.Divisor(Percent2local),
.clock(clock),
.Quotient(NewWidth2),
.Remainder(),
.Percentagemode(1'b0)
);
    //Run PWM signals
    always @ (posedge clock) begin
      if (counter > 1666666)
        counter <= 0;
      else
        counter <= counter +1;
                    
    if(counter < width1)
       PWM_1 <= 1;
    else 
       PWM_1 <= 0;  
       
    if(counter < width2)
       PWM_2 <= 1;
    else 
       PWM_2 <= 0;   
     
    end
    
    //Grab Previous width
    always @ (posedge clock)
    prevWidth <= width;

    //PWM adjustment code
    always @ (posedge clock)
    begin
        if(initialize == 1) begin
            width1 <= width;
            width2 <= width;
            initialize <= 0;
        end
        else if(prevWidth != width) begin
            width1 <= width;
            width2 <= width;
            ticPoint1 <= tic_count1;
            ticPoint2 <= tic_count2;
        end
        else begin
        if(counter2 > 10000000) begin
            case(state)
                ABSOLUTE:
                begin
                    LED0 <= 1;
                    ticdiff1 <= (((tic_count1-ticPoint1) >= 0) || ((tic_count1-ticPoint1) < 0)) ? (tic_count1-ticPoint1) : ((tic_count1-ticPoint1)*negativeOne);
                    ticdiff2 <= (((tic_count2-ticPoint2) >= 0) || ((tic_count2-ticPoint2) < 0)) ? (tic_count2-ticPoint2) : ((tic_count2-ticPoint2)*negativeOne);
                    state <= COMPARE;
                end
                COMPARE: 
                begin
                    LED1 <= 1;
                    if(ticdiff1 < ticdiff2) begin
                        state <= SC1;
                        DIVenable1 <= 1;
                    end
                    else if (ticdiff1 > ticdiff2) begin
                        state <= SC2;
                        DIVenable2 <= 1;
                    end
                    else begin
                        state <= RESTART;
                    end
                end
                SC1: 
                begin
                    LED2 <= 1;
                    if(divdone1) begin
                        LED3 <= 1;
                        DIVenable1 <= 0;
                        DIVenable3 <= 1;
                        corboVar1 <= 1;
                        Percent1local <= Percent1;
                    end
                    if(divdone3) begin
                        LED5 <= 1;
                        width1 <= NewWidth1*100;
                        DIVenable3 <= 0;
                        state <= RESTART;
                        corboVar1 <= 0;
                        //LED0 <= 1;
                    end
                    else if(corboVar1 == 1) begin
                        LED4 <= 1;
                        DIVenable3 <= 1;
                    end
                end
                SC2:
                begin
                    //LED3 <= 1;
                    if(divdone2) begin
                        DIVenable2 <= 0;
                        DIVenable4 <= 1;
                        corboVar2 <= 1;
                        Percent2local <= Percent2;
                    end
                    if(divdone4) begin 
                        width2 <= NewWidth2*100;
                        DIVenable4 <= 0;
                        state <= RESTART;
                        corboVar2 <= 0;
                        //LED1 <= 1;
                    end
                    else if(corboVar2 == 1) begin
                        DIVenable4 <= 1;
                    end
                end
                RESTART:
                begin
                    LED6 <= 1;
                    ticPoint1 <= tic_count1;
                    ticPoint2 <= tic_count2;
                    counter2 <= 0;
                    state <= 0;
                end
            endcase
        end
        else
            counter2 <= counter2 + 1;
        
        end
    end
    
    assign led0 = LED0;
    assign led1 = LED1;
    assign led2 = LED2;
    assign led3 = LED3;
    assign led4 = LED4;
    assign led5 = LED5;
    assign led6 = LED6;
    
endmodule
