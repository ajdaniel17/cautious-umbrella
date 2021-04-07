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
    output reg trigger,
    output [31:0] distance,
    output reg [31:0] timecount = 32'b0,
    input [31:0] tempdistance,
    input divdone,
    output reg lastecho,
    output reg done,
    input enable
    );
    
    localparam START = 0,
               WAITING = 1,
               COUNTTIME= 2,
               CONVERTING = 3,
               DISPLAY = 4,
               BUFFER = 5;
    //reg DIVenable = 0;           
    reg [3:0]state = 0;
    reg [31:0] count = 0;
    reg [31:0] divisorZ = 32'd148000;
    reg DIVenable = 0;
    reg L0,L1,L2,L3,L4,L5;
    
    
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
    
    always @ (posedge clock)
    lastecho <= echo;
    
    
    always @ (posedge clock)
    begin
    if(~enable)begin
        //distance = 32'b0;
        done = 0;
        trigger = 0;
    end
    else
    begin
        case(state)
        START: begin
        L0  = 1'b1;
        L1 = 1'b0;
        L2 = 1'b0;
        L3 = 1'b0;
        L4 = 1'b0;
        L5 = 1'b0;
            if(count > 1000)
            begin
                timecount = 0;
                count = 0;
                state = 1;
                trigger = 0;
            end
            else
                count <= count + 1;
        end
        WAITING: begin
        trigger = 0;
        L0  = 1'b0;
        L1 = 1'b1;
        L2 = 1'b0;
        L3 = 1'b0;
        L4 = 1'b0;
        L5 = 1'b0;
            if(count > 5) begin
                if (echo != lastecho) begin
                    state = 2;
                    count = 0;
                end
                else
                    count <= count + 1;
            end
            
            if(count > 2000000)
            begin
                count = 0;
                state = 5;
                
            end
            else
                count <= count + 1;
        end
        COUNTTIME: begin
        trigger = 0;
        L0  = 1'b0;
        L1 = 1'b0;
        L2 = 1'b1;
        L3 = 1'b0;
        L4 = 1'b0;
        L5 = 1'b0;
            if(echo == lastecho)
            begin
                timecount = timecount + 1;
            end
            else
            begin  
                timecount = timecount + 1;
                state = 3;
                count = 0;
                DIVenable = 1;
            end
             if(timecount == 2220000) begin
                state = 0;
                count = 0;
                trigger = 1;
                //distance = 0;
             end
            if(count > 5000000)
            begin
                count = 0;
                state = 0;
                trigger = 1;
            end
            else
                count <= count + 1;
        end
        CONVERTING: begin
        trigger = 0;
        L0  = 1'b0;
        L1 = 1'b0;
        L2 = 1'b0;
        L3 = 1'b1;
        L4 = 1'b0;
        L5 = 1'b0;
        if(divdone) begin
            //distance = tempdistance;
            DIVenable = 0;
            state = 5;
            //done = 1;
            end
        else if(DIVenable == 0) begin
            DIVenable = 1;
        end
        end
        
        BUFFER: begin
        L0  = 1'b0;
        L1 = 1'b0;
        L2 = 1'b0;
        L3 = 1'b0;
        L4 = 1'b0;
        L5 = 1'b1;
            if(count > 10000000)
            begin
                count = 0;
                state = 0;
                trigger = 1;
            end
            else
                count <= count + 1;
        
        end
        endcase
        
    
    end
    end
    assign led0 = L0;
    assign led1 = L1;
    assign led2 = L2;
    assign led3 = L3;
    assign led4 = L4;
    assign led5 = L5;
    
 
endmodule
