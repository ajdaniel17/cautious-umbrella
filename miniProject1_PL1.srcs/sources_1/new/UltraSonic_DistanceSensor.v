`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2021 02:03:01 PM
// Design Name: 
// Module Name: UltraSonic_DistanceSensor
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


module UltraSonic_DistanceSensor(
    input clock,echo,
    output reg trigger = 1,
    output reg [31:0]distance = 0,
    output reg [31:0] timecount = 0,
    input [31:0] tempdistance,
    input divdone,
    output reg lastecho,
    output reg [4:0] D1 = 0,D2 = 0,D3 = 0,D4 =0,
    input divdone1,divdone2,divdone3,divdone4,   
    input [31:0] tempD1,tempD2,tempD3,tempD4,
    output reg DIVenable = 0
    );
    
    localparam START = 0,
               WAITING = 1,
               COUNTTIME= 2,
               CONVERTING = 3,
               DISPLAY = 4;
    //reg DIVenable = 0;           
    reg [3:0]state = 0;
    reg [31:0] count = 0;
    reg [31:0] divisorZ = 32'd148;
    wire signed[31:0] bridge1,bridge2,bridge3;
    reg DIVenable1 = 0,DIVenable2 = 0,DIVenable3 = 0,DIVenable4 = 0;
    reg [31:0]tempdistance2;
    


    
IntegerDivision SoundToInch(
.enable(DIVenable),
.done(divdone),
.Dividend(timecount),
.Divisor(divisorZ),
.clock(clock),
.Quotient(tempdistance),
.Remainder(),
.Percentagemode(1'b0)
);



IntegerDivision Thou(
.enable(DIVenable1),
.done(divdone1),
.Dividend(tempdistance2*1000),
.Divisor(32'd1000),
.clock(clock),
.Quotient(tempD1),
.Remainder(bridge1),
.Percentagemode(0)
);

IntegerDivision Hun(
.enable(DIVenable2),
.done(divdone2),
.Dividend(bridge1),
.Divisor(32'd100),
.clock(clock),
.Quotient(tempD2),
.Remainder(bridge2),
.Percentagemode(0)
);

IntegerDivision Ten(
.enable(DIVenable3),
.done(divdone3),
.Dividend(bridge2),
.Divisor(32'd10),
.clock(clock),
.Quotient(tempD3),
.Remainder(bridge3),
.Percentagemode(0)
);

IntegerDivision Uno(
.enable(DIVenable4),
.done(divdone4),
.Dividend(bridge3),
.Divisor(32'd1),
.clock(clock),
.Quotient(tempD4),
.Remainder(),
.Percentagemode(0)
);
    always @ (posedge clock)
    lastecho <= echo;
    
    
    always @ (posedge clock)
    begin
        case(state)
        START: begin
            if(count > 1000)
            begin
                count = 0;
                state = 1;
                trigger = 0;
            end
            else
                count <= count + 1;
        end
        WAITING: begin
            if (echo != lastecho)
                state = 2;
        end
        
        
        COUNTTIME: begin
            if(echo == lastecho)
            begin
                timecount = timecount + 1;
            end
            else
            begin
              //  timecount = timecount + 1;
                state = 3;
                DIVenable = 1;
            end
        end
        CONVERTING: begin
        if(divdone) begin
            distance = tempdistance;
            tempdistance2 = tempdistance;
            DIVenable = 0;
            DIVenable1 = 1;
            state = 4;
            end
        end
        DISPLAY: begin //OPTIONAL CASE, CHANGE PREVIOUS CASE STATE TO 0 if you dont wantt
            
        if(divdone1)
        begin 
            D1 = tempD1;
            DIVenable1 = 0;
            DIVenable2 = 1;
        end
        
        if(divdone2)
        begin 
            D2 = tempD2;
            DIVenable2 = 0;
            DIVenable3 = 1;
        end
        
        if(divdone3)
        begin 
            D3 = tempD3;
            DIVenable3 = 0;
            DIVenable4 = 1;
        end
        
        if(divdone4)
        begin 
            D4 = tempD4;
            DIVenable4 = 0;
            timecount = 0;
            state = 0;
        end
        
        
        end
        endcase
        
    
    end
    
    
    
    
endmodule
