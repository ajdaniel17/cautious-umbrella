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
    output led0 ,led1,led2,led3,led4,led5,
    output reg trigger = 1,
    output reg [31:0]distance = 0,
    output reg [31:0] timecount = 0,
    input [31:0] tempdistance,
    input divdone,
    output reg lastecho,
    output reg [4:0] D1 = 0,D2 = 0,D3 = 0,D4 =0,
    input divdone1,divdone2,divdone3,divdone4,   
    input [31:0] tempD1,tempD2,tempD3,tempD4
    );
    
    localparam START = 4'd1,
               WAITING = 4'd2,
               COUNTTIME= 4'd3,
               CONVERTING = 4'd4,
               DISPLAY = 4'd5,
               BUFFER = 4'd6;
    //reg DIVenable = 0;           
    reg [3:0]state = START;
    reg [31:0] count = 0;
    reg [31:0] count2 = 0;
    reg [31:0] count3 = 0;
    reg [31:0] count4 = 0;
    reg [31:0] divisorZ = 32'd1480;
    wire signed[31:0] bridge1,bridge2,bridge3;
    reg DIVenable = 0, DIVenable1 = 0,DIVenable2 = 0,DIVenable3 = 0,DIVenable4 = 0;
    reg [31:0]tempdistance2;
    reg L0,L1,L2,L3,L4,L5;
    reg CorboVar0 = 1'b1;
    
    
    
    
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
.Dividend(tempdistance2*100),
.Divisor(32'd100000),
.clock(clock),
.Quotient(tempD1),
.Remainder(bridge1),
.Percentagemode(0)
);

IntegerDivision Hun(
.enable(DIVenable2),
.done(divdone2),
.Dividend(bridge1),
.Divisor(32'd10000),
.clock(clock),
.Quotient(tempD2),
.Remainder(bridge2),
.Percentagemode(0)
);

IntegerDivision Ten(
.enable(DIVenable3),
.done(divdone3),
.Dividend(bridge2),
.Divisor(32'd1000),
.clock(clock),
.Quotient(tempD3),
.Remainder(bridge3),
.Percentagemode(0)
);

IntegerDivision Uno(
.enable(DIVenable4),
.done(divdone4),
.Dividend(bridge3),
.Divisor(32'd100),
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
        L0  = 1'b1;
        L1 = 1'b0;
        L2 = 1'b0;
        L3 = 1'b0;
        L4 = 1'b0;
        L5 = 1'b0;
            if(count > 'd1000)
            begin
                timecount <= 0;
                count <= 0;
                state <= WAITING;
                trigger <= 0;
            end
            else
                count <= count + 1;
        end
        WAITING: begin
        L0  = 1'b0;
        L1 = 1'b1;
        L2 = 1'b0;
        L3 = 1'b0;
        L4 = 1'b0;
        L5 = 1'b0;
            if (echo != lastecho) begin
                state <= COUNTTIME;
                //count = 0;
            end
            
            if(count2 > 'd50000000)
            begin
                count2 <= 0;
                state <= START;
                trigger <= 1;
            end
            else
                count2 <= count2 + 1;
        end
        COUNTTIME: begin
        L0  = 1'b0;
        L1 = 1'b0;
        L2 = 1'b1;
        L3 = 1'b0;
        L4 = 1'b0;
        L5 = 1'b0;
            if(echo == lastecho)
            begin
                timecount <= timecount + 1;
            end
            else
            begin  
                timecount <= timecount + 1;
                state <= CONVERTING;
                //count = 0;
                DIVenable <= 1;
            end
            
            if(count3 > 'd50000000)
            begin
                count3 <= 0;
                state <= START;
                trigger <= 1;
            end
            else
                count3 <= count3 + 1;
        end
        CONVERTING: begin
        L0  = 1'b0;
        L1 = 1'b0;
        L2 = 1'b0;
        L3 = 1'b1;
        L4 = 1'b0;
        L5 = 1'b0;
        if(divdone) begin
            distance <= tempdistance;
            tempdistance2 <= tempdistance;
            DIVenable <= 0;
            DIVenable1 <= 1;
            state <= DISPLAY;
            end
        else if(DIVenable == 0) begin
            DIVenable <= 1;
        end
        end
        DISPLAY: begin //OPTIONAL CASE, CHANGE PREVIOUS CASE STATE TO 0 if you dont wantt
        L0  = 1'b0;
        L1 = 1'b0;
        L2 = 1'b0;
        L3 = 1'b0;
        L4 = 1'b1;
        L5 = 1'b0;
        if(divdone1)
        begin 
            D1 <= tempD1;
            DIVenable1 <= 0;
            DIVenable2 <= 1;
        end
        
        if(divdone2)
        begin 
            D2 <= tempD2;
            DIVenable2 <= 0;
            DIVenable3 <= 1;
        end
        
        if(divdone3)
        begin 
            D3 <= tempD3;
            DIVenable3 <= 0;
            DIVenable4 <= 1;
        end
        
        if(divdone4)
        begin 
            D4 <= tempD4;
            DIVenable4 <= 0;
            timecount <= 0;
            state <= BUFFER;
            
        end
        
        
        end
        BUFFER: begin
        L0  = 1'b0;
        L1 = 1'b0;
        L2 = 1'b0;
        L3 = 1'b0;
        L4 = 1'b0;
        L5 = 1'b1;
            if(count4 > 'd10000000)
            begin
                count4 <= 0;
                state <= START;
                trigger <= 1;
            end
            else
                count4 <= count4 + 1;
        
        end
        endcase
        
    
    end
    
    assign led0 = L0;
    assign led1 = L1;
    assign led2 = L2;
    assign led3 = L3;
    assign led4 = L4;
    assign led5 = L5;
    
 
endmodule