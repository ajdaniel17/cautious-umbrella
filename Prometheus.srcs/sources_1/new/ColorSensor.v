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
    //wire frqdone,divdone,
    output s2,s3,
    //wire[19:0] FRQ,
    //wire [31:0] tempquo,
    output RED,GREEN,BLUE
    );
    
    wire[19:0] FRQ;
    wire [31:0] tempquo;
    wire frqdone,divdone;
    
    reg FRQenable = 1;
    reg DIVenable = 0;
    reg temps2 = 1;
    reg temps3 = 0;
    reg [31:0] TEMPFRQ;
    reg [31:0] TEMPFRQ2;
    reg [1:0] colorsetting = 2'd0;
    reg [31:0] TEMPRED,TEMPBLUE,TEMPGREEN,TEMPWHITE;
    reg enableStore1 = 1;
    reg TLED0 = 0,TLED1 = 0,TLED2 = 0,TLED3 = 0;
    reg[16:0] divToStoreCount; 
    reg[16:0] frqToDivCount;
    reg doneWithDiv=0,enableStore2=0,doneWithReadFrq=0,turnOnDiv=0;
    reg [6:0] redThresh = 7'd55;
    reg [6:0] blueThresh = 7'd45;
    reg [6:0] greenThresh = 7'd40;
    
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
.Remainder(),
.Percentagemode(1)
);
     
 always @(posedge clock)
 begin
 
    //Frequency has finished reading
    if(frqdone)
    begin
        if(colorsetting == 2'd0)
        begin
            TEMPFRQ = FRQ;
            FRQenable = 0;
            doneWithDiv =1;    
        end
        else
        begin
            TEMPFRQ2 = FRQ;
            FRQenable = 0;
            doneWithReadFrq = 1;
        end
    end
    
    
    //Divider has finished dividing
    if(divdone)
    begin 
        TEMPFRQ = tempquo;
        DIVenable = 0;
        doneWithDiv = 1;
    end
            
     
   
    //Frequency counter buffer
    if (frqToDivCount > 2)
    begin
        turnOnDiv = 1;
        frqToDivCount <= 0;
        doneWithReadFrq = 0;
    end
    else if (doneWithReadFrq)
        frqToDivCount <= frqToDivCount +1;
        
        
    //Divider Buffer
    if (divToStoreCount > 5)
    begin
        enableStore2 = 1;
        divToStoreCount <= 0;
        doneWithDiv = 0;
    end
    else if (doneWithDiv)
        divToStoreCount <= divToStoreCount +1;
     
        
    if(enableStore2 & enableStore1)
    begin
     
         //initial value at white   
        case(colorsetting)
            2'd0 : 
            begin //white to red
                TEMPWHITE = TEMPFRQ;
                temps2 = 0;
                temps3 = 0;
                colorsetting = 2'd1;
                FRQenable = 1;
            end
            2'd1 : 
            begin //red to green
                TEMPRED = TEMPFRQ;
                temps2 = 1;
                temps3 = 1;
                colorsetting = 2'd2;
                FRQenable = 1;
            end
            2'd2 : 
            begin //green to blue
                TEMPGREEN = TEMPFRQ;
                temps2 = 0;
                temps3 = 1;
                colorsetting = 2'd3;
                FRQenable = 1;
            end
            2'd3 : 
            begin //blue to white
                TEMPBLUE = TEMPFRQ;
                temps2 = 1;
                temps3 = 0;
                colorsetting = 2'd0;
                enableStore1 = 0;
            end
            
        endcase
        enableStore2 = 0;
    end    
    
    if(turnOnDiv)
    begin
        DIVenable = 1;
        turnOnDiv = 0;
    end
        
    if(~enableStore1)
    begin
        FRQenable = 0;
    
        if(TEMPRED > redThresh)
            TLED0  = 1;

        else
            TLED0  = 0;
            
        if (TEMPGREEN > greenThresh)

            TLED1 = 1;

        else
            TLED1 = 0;
            
        if (TEMPBLUE > blueThresh)
 
            TLED2 = 1;

      
        else
            TLED2 = 0;
  
        enableStore1 = 1;
        FRQenable = 1;
    end
    
end

assign RED = TLED0 ;
assign GREEN = TLED1;
assign BLUE = TLED2;

assign s2 = temps2;
assign s3 = temps3;
endmodule