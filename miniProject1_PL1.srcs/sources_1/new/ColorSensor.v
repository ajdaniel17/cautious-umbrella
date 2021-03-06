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
    input colorinput,frqdone,
    output s2,s3,
    output LED0,LED1,LED2,LED3,LED4,
    input[19:0] FRQ
    );
    
    reg enable = 1;
    reg temps2 = 1;
    reg temps3 = 0;
    reg [19:0] TEMPFRQ;
    reg [1:0] colorsetting = 2'd0;
    reg [19:0] TEMPRED,TEMPBLUE,TEMPGREEN,TEMPWHITE;
    reg done = 1;
    reg TLED0 = 0,TLED1 = 0,TLED2 = 0,TLED3 = 0;
    reg[16:0] count; 
    reg done1=0,done2=0;
    
ReadFrequency Readthis(
     .CLK(clock),        
     .enable(enable),       
     .IN(colorinput),         
     .freq(FRQ),
     .done(frqdone) 
     );
     
     always @(posedge clock)
     begin
        if(frqdone)
        begin
            TEMPFRQ = FRQ;
            enable = 0;
            done1 =1;    
        end
        
        if (count > 1000)
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
                 TEMPWHITE = TEMPFRQ;
                 temps2 = 0;
                 temps3 = 0;
                 colorsetting = 2'd1;
                 enable = 1;
                 end
                 2'd1 : begin //red to green
                 TEMPRED = TEMPFRQ;
                 temps2 = 1;
                 temps3 = 1;
                 colorsetting = 2'd2;
                 enable = 1;
                 end
                 2'd2 : begin //green to blue
                 TEMPGREEN = TEMPFRQ;
                 temps2 = 0;
                 temps3 = 1;
                 colorsetting = 2'd3;
                 enable = 1;
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
        
        if(~done)
        begin
        enable = 0;
        
            if(TEMPRED > TEMPBLUE & TEMPRED > TEMPGREEN)
            begin
            TLED0 = 1;
            TLED1 = 0;
            TLED2 = 0;
            TLED3 = 0;
            end
            else if (TEMPGREEN > TEMPRED & TEMPGREEN > TEMPBLUE)
            begin
            TLED0 = 0;
            TLED1 = 1;
            TLED2 = 0;
            TLED3 = 0;
            end
            else if (TEMPBLUE > TEMPRED & TEMPBLUE > TEMPGREEN)
            begin
            TLED0 = 0;
            TLED1 = 0;
            TLED2 = 1;
            TLED3 = 0;
            end
            else
            begin
            TLED0 = 0;
            TLED1 = 0;
            TLED2 = 0;
            TLED3 = 1;
            end
                
        
        done = 1;
        enable = 1;
        end
     end
assign LED0 = TLED0;
assign LED1 = TLED1;
assign LED2 = TLED2;
assign LED3 = TLED3;
assign s2 = temps2;
assign s3 = temps3;
endmodule
