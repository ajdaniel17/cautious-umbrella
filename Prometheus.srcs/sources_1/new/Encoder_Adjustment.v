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
    
    output led0,led1,led2,led3,led4,led5,led6,led15,led14
    );
    localparam ABSOLUTE = 0,
               COMPARE  = 1,
               SC1      = 2,
               SC2      = 3,
               RESTART  = 4;
    
    reg signed [31:0] negativeOne = -1;
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
    
    reg [31:0] counter3 = 0;
    reg [31:0] counter4 = 0;
    reg timeout = 0;
    reg buffer = 0;
    
    
    
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
.Dividend(width1*(8'd100)),
.Divisor(Percent1local),
.clock(clock),
.Quotient(NewWidth1),
.Remainder(),
.Percentagemode(1'b0)
);

IntegerDivision SC2_FinalValue(
.enable(DIVenable4),
.done(divdone4),
.Dividend(width2*(8'd100)),
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
    /*
        if(width1 < 1000) begin
        width1 <= width;
        end
        if(width2 < 1000) begin 
        width2 <= width;
        end
      */  
      
      if(counter4 > 25000000) begin
      buffer <= 1;
      end
      else begin
      counter4 <= counter4 + 1;
      end
      
      
        if(counter3 > 100000000) begin
            state <= 0;
            counter2 <= 0;
            counter3 <= 0;        
        end
        else if(timeout) begin
        counter3 <= counter3 +1;
        end
        
        
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
                    timeout <= 1;
                    LED0 <= 1;
                    if((tic_count1-ticPoint1) > 0) begin
                    ticdiff1 <= (tic_count1-ticPoint1);
                    end
                    else
                    ticdiff1 <= ((tic_count1-ticPoint1)*negativeOne);
                    
                    if((tic_count2-ticPoint2) > 0) begin
                    ticdiff2 <= (tic_count2-ticPoint2);
                    end
                    else
                    ticdiff2 <= ((tic_count2-ticPoint2)*negativeOne);
                    
                   // ticdiff1 <= (((tic_count1-ticPoint1) >= 0) || ((tic_count1-ticPoint1) < 0)) ? (tic_count1-ticPoint1) : ((tic_count1-ticPoint1)*negativeOne);
                   // ticdiff2 <= (((tic_count2-ticPoint2) >= 0) || ((tic_count2-ticPoint2) < 0)) ? (tic_count2-ticPoint2) : ((tic_count2-ticPoint2)*negativeOne);
                    state <= COMPARE;
                end
                COMPARE: 
                begin
                    LED1 <= 1;
                    if((ticdiff1+4'd10) < ticdiff2) begin
                        state <= SC1;
                        DIVenable1 <= 1;
                    end
                    else if (ticdiff1 > (ticdiff2+4'd10)) begin
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
                        width1 <= NewWidth1;
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
                        width2 <= NewWidth2;
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
                    buffer <= 0;
                    counter4 <= 0;
                    counter2 <= 0;
                    ticdiff1 <= 0;
                    ticdiff2 <= 0;
                    
                end
            endcase
        end
        else if(buffer) begin
            counter2 <= counter2 + 1;
            ticPoint1 <= tic_count1;
            ticPoint2 <= tic_count2;
            timeout <= 0;
            counter3 <= 0;
            state <= 0;
            LED0 <= 0;
            LED1 <= 0;
            LED2 <= 0;
            LED3 <= 0;
            LED4 <= 0;
            LED5 <= 0;
            LED6 <= 0;
        end
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
