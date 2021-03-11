`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2021 02:53:29 PM
// Design Name: 
// Module Name: ColorSensor
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


module ColorSensor(
    input clock,
    input colorinput,frqdone,divdone,
    output s2,s3,
    output LED0,LED1,LED2,LED3,LED4,
    input[19:0] FRQ,
    input[31:0] tempquo,
    output JA4,JA5,JA6
    );
    
    reg FRQenable = 1;
    reg DIVenable = 0;
    reg tempCorbo0 = 0;
    reg tempCorbo1 = 0;
    reg tempCorbo2 = 0;
    reg temps2 = 1;
    reg temps3 = 0;
    reg [31:0] TEMPFRQ;
    reg [31:0] TEMPFRQ2;
    reg [1:0] colorsetting = 2'd0;
    reg [31:0] TEMPRED,TEMPBLUE,TEMPGREEN,TEMPWHITE;
    reg done = 1;
    reg TLED0 = 0,TLED1 = 0,TLED2 = 0,TLED3 = 0;
    reg[16:0] count; 
    reg[16:0] count2;
    reg done1=0,done2=0,done3=0,done4=0;
    reg [6:0] redThresh = 7'd55;
    reg [6:0] blueThresh = 7'd30;
    reg [6:0] greenThresh = 7'd20;
    
ReadFrequency Readthis(
     .CLK(clock),        
     .enable(FRQenable),       
     .IN(colorinput),         
     .freq(FRQ),
     .done(frqdone) 
     );
     
IntegerDivision DivideByClear(
.enable(DIVenable),
.done(divdone),
.Dividend(TEMPFRQ2),
.Divisor(TEMPWHITE),
.clock(clock),
.Quotient(tempquo),
.Remainder()
);
     
 always @(posedge clock)
 begin
    if(frqdone)
    begin
        if(colorsetting == 2'd0)
        begin
            //tempCorbo2 = 1;
            //if (FRQ == 0)
                //tempCorbo2 = 1;
            TEMPFRQ = FRQ;
            if (TEMPFRQ == 0)
                tempCorbo0 = 1;
            FRQenable = 0;
            done1 =1;    
        end
        else
            begin
                TEMPFRQ2 = FRQ;
                FRQenable = 0;
                if (TEMPWHITE == 0)
                    tempCorbo1 = 1;
                else
                    tempCorbo2 = 1;
 
                    //tempCorbo0 = 1;
                    done3 = 1;
               // DIVenable = 1;
            end
        
     end
        if(divdone)
            begin 
                //if (tempquo == 0)
                    //tempCorbo2 = 1;
                TEMPFRQ = tempquo;
                DIVenable = 0;
                done1 = 1;
            end
            
     
    
    
    //Need a buffer, not sure why
    if (count2 > 2)
    begin
        done4 = 1;
        count2 <= 0;
        done3 = 0;
    end
    else if (done3)
        count2 <= count2 +1;
        
        
    //Need a buffer, not sure why
    if (count > 5)
    begin
        done2 = 1;
        count <= 0;
        done1 = 0;
    end
    else if (done1)
        count <= count +1;
        
    if(done2 & done)
    begin
     

             //initial value at white   
             case(colorsetting)
             2'd0 : begin //white to red
             //if (TEMPFRQ == 0)
                //tempCorbo2 = 1;
             TEMPWHITE = TEMPFRQ;
             temps2 = 0;
             temps3 = 0;
             colorsetting = 2'd1;
             FRQenable = 1;
             end
             2'd1 : begin //red to green
             //tempCorbo0 = 1;
             TEMPRED = TEMPFRQ;
             temps2 = 1;
             temps3 = 1;
             colorsetting = 2'd2;
             FRQenable = 1;
             end
             2'd2 : begin //green to blue
             //tempCorbo0 = 1;
             TEMPGREEN = TEMPFRQ;
             temps2 = 0;
             temps3 = 1;
             colorsetting = 2'd3;
             FRQenable = 1;
             end
             2'd3 : begin //blue to white
             TEMPBLUE = TEMPFRQ;
             temps2 = 1;
             temps3 = 0;
             colorsetting = 2'd0;
             done = 0;
             end
             default: colorsetting = 2'd0;
             endcase
             
             
             done2 = 0;
    end    
    
    if(done4)
        begin
        DIVenable = 1;
        done4 = 0;
        end
        
    if(~done)
    begin
    FRQenable = 0;
        if(TEMPRED > redThresh)
        begin
        TLED0 = 1;
//        TLED1 = 0;
//        TLED2 = 0;
//        TLED3 = 0;
        end
        else
            TLED0 = 0;
        if (TEMPGREEN > greenThresh)
        begin
//        TLED0 = 0;
        TLED1 = 1;
//        TLED2 = 0;
//        TLED3 = 0;
        end
        else
            TLED1 = 0;
        if (TEMPBLUE > blueThresh)
        begin
//        TLED0 = 0;
//        TLED1 = 0;
        TLED2 = 1;
//        TLED3 = 0;
        end
        else
            TLED2 = 0;
        if (~(TLED0 & TLED1 & TLED2))
        begin
//        TLED0 = 0;
//        TLED1 = 0;
//        TLED2 = 0;
        TLED3 = 1;
        end
            
    
    done = 1;
    FRQenable = 1;
    end
 end
assign JA4 = TLED0;
assign JA5 = TLED1;
assign JA6 = TLED2;
assign LED0 = tempCorbo0;
assign LED1 = tempCorbo1;
assign LED2 = tempCorbo2;
assign LED3 = TLED3;
assign s2 = temps2;
assign s3 = temps3;
endmodule