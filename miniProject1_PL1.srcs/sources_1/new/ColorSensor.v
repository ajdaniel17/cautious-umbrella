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
        if(frequency > 100) 
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
        
        
        if(colorsetting == 0)
        begin
            temps2 = 0;
            temps3 = 0;
        end
        else if (colorsetting == 1)
        begin 
            temps2 = 0;
            temps3 = 1;
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
            frequency <= frequency +1;


        end
        else
        begin

        end
        
        
        
        
        
        
    end
    
    assign LED0 = red;
    assign LED1 = blue;
    assign LED2 = green;
    assign LED3 = freqON;
    assign LED4 = freqOFF;
    assign s2 = temps2;
    assign s3 = temps3;
endmodule