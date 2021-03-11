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
<<<<<<< HEAD
    input colorinput,
    output s2,s3,
    output LED0,LED1,LED2,LED3,LED4
    );
    
    localparam ticrate = 100;
    integer redFRQ,blueFRQ,grnFRQ;
    integer count;
    integer i;
    reg [1:0] colorsetting;
    integer timeperiod;
    integer frequency;
    reg temps2,temps3;
    integer red,blue,green;
    reg freqON,freqOFF;
    
    initial begin
    red = 0;
    blue = 0;
    green = 0;
    count = 0;
    colorsetting = 0;
    i = 0;
    timeperiod = 0;
    frequency = 0;
    redFRQ = 0;
    blueFRQ = 0;
    grnFRQ = 0;
    freqON = 0;
    freqOFF = 0;
    end
    
    always @ (posedge clock) 
    begin
        if(frequency > ticrate) 
        begin 
            timeperiod <= count;
            count <= 0;
            i = 1;
            freqON = 1;
        end
        else
            count <= count + 1;

        
        if(i == 1)
        begin
<<<<<<< HEAD
            case(colorsetting)
                2'd0:redFRQ  = timeperiod;
                2'd1:blueFRQ = timeperiod;
                2'd2:grnFRQ  = timeperiod;
                default : redFRQ = 100;
            endcase
            i = 0;
            frequency = 0;
            case(colorsetting)
                2'd0:colorsetting = 2'd1;
                2'd1:colorsetting = 2'd2;
                2'd2:colorsetting = 2'd0;
            endcase
        end  
=======
            if(colorsetting == 0)
            begin
                TEMPFRQ = FRQ;
                FRQenable = 0;
                done1 =1;    
            end
            else if (~DIVenable)
                begin
                    TEMPFRQ2 = FRQ;
                    FRQenable = 0;
                    done3 = 1;
                   // DIVenable = 1;
                end
            
         end
            if(divdone)
                begin 
                    TEMPFRQ = tempquo;
                    DIVenable = 0;
                    done4 = 0;
                    done1 = 1;
                end
                
         
>>>>>>> parent of 4e1b925 (updagte)
        
        
        if(colorsetting == 0)
        begin
<<<<<<< HEAD
            temps2 = 0;
            temps3 = 0;
        end
        else if (colorsetting == 1)
        begin 
            temps2 = 0;
            temps3 = 1;
=======
            done4 = 1;
            count <= 0;
>>>>>>> parent of 4e1b925 (updagte)
        end
        else if (colorsetting == 2)
        begin 
            temps2 = 1;
            temps3 = 1;
        end
        
        
        if(redFRQ > blueFRQ && redFRQ > grnFRQ)
        begin 
        red = 1;
        blue = 0;
        green = 0;
        end
        else if (blueFRQ > redFRQ && blueFRQ > grnFRQ)
=======
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
>>>>>>> parent of d3dc704 (Re)
        begin
        red = 0;
        blue = 1;
        green = 0;
        end  
        else if (grnFRQ > redFRQ && grnFRQ > blueFRQ)
        begin 
        red = 0;
        blue = 0;
        green = 1;
        end
        else
        begin
        red = 1;
        blue = 1;
        green = 1;
        end
    end
    
    always @ (*)
    begin 
        if(colorinput)
        begin
            frequency = frequency +1;

<<<<<<< HEAD

        end
        else
=======
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
>>>>>>> parent of 4e1b925 (updagte)
        begin
<<<<<<< HEAD

        end
=======
        enable = 0;
>>>>>>> parent of d3dc704 (Re)
        
        
<<<<<<< HEAD
        
        
        
        
    end
    
    assign LED0 = red;
    assign LED1 = blue;
    assign LED2 = green;
    assign LED3 = freqON;
    assign LED4 = freqOFF;
    assign s2 = temps2;
    assign s3 = temps3;
=======
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
>>>>>>> parent of d3dc704 (Re)
endmodule
