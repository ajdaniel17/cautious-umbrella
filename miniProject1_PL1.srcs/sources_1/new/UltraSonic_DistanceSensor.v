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
    output reg [31:0] distance,
    output reg [31:0] timecount = 32'b0,
    input [31:0] tempdistance,
    input divdone,
    output reg lastecho,
    output reg done,
   // input start,
    input[4:0] D1 ,D2 ,D3 ,D4,
    input FourBitDone,
    output[4:0] D1o,D2o,D3o,D4o
    );
    
    localparam
               IDLE = 0, 
               START = 1,
               WAITING = 2,
               COUNTTIME= 3,
               CONVERTING =4,
               DONE = 5;
    //reg DIVenable = 0;           
    reg [3:0]state = 0;
    reg [31:0] count = 0;
    reg [31:0] count2 = 0;
    reg [31:0] count3 = 0;
    reg [31:0] divisorZ = 32'd148000;
    reg DIVenable = 0;
    reg L0,L1,L2,L3,L4,L5;
    wire FourBitEnable;
    reg start = 1;
    reg i;
    
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
    
FourBitIntegerShower Magic(
.clock(clock),
.start(done),
.D1(D1),
.D2(D2),
.D3(D3),
.D4(D4),
.tempD1(),
.tempD2(),
.tempD3(),
.tempD4(),
.Original(Distanceout),
.done(FourBitdone)
);
    always @ (posedge clock)

    begin 
 if(FourBitdone == 1 & ~i)
 begin
    start = 0;
    i = 1;
 end
 if (count2 >10000000)
    begin
    count2 <= 0;
    start = 1;
    i = 0;
    end
    else if (i)
        count2 <= count2 + 1;
    end
    
    always @ (posedge clock)
    lastecho <= echo;
    
    
    always @ (posedge clock)
    begin

        case(state)
            IDLE: 
            begin
            L0 = 1;
            L1 = 0;
            L2 = 0;
            L3 = 0;
            L4 = 0;
            L5 = 0;
                if(start) 
                begin
                    state = START;
                    distance = 0;
                    trigger = 1;
                    timecount = 0;
                    done = 0;
                end
            end
        
            START: 
            begin
            L0 = 0;
            L1 = 1;
            L2 = 0;
            L3 = 0;
            L4 = 0;
            L5 = 0;
                if(count > 1000)
                begin
                    state = WAITING;
                    count = 0;
                    trigger = 0;
                end
                else
                    count <= count + 1;
            end
            
            WAITING: 
            begin
            L0 = 0;
            L1 = 0;
            L2 = 1;
            L3 = 0;
            L4 = 0;
            L5 = 0;
             //   if(count > 5) begin
                    if (echo != lastecho) begin
                        state = COUNTTIME;
                        count = 0;
                    end
                    else
                        count <= count + 1;
                    
                    if(count > 10000000) begin
                    trigger = 1;
                    state = START;
                    count = 0;
                    end
         //   end 
                 
//                if(count > 200000000)
//                begin
//                    count = 0;
//                    state = 1;  
//                end
//                else
//                    count <= count + 1;
            end
            COUNTTIME: 
            begin
            L0 = 0;
            L1 = 0;
            L2 = 0;
            L3 = 1;
            L4 = 0;
            L5 = 0;
                if(echo == lastecho)
                begin
                    timecount = timecount + 1;
                end
                else
                begin  
                    timecount = timecount + 1;
                    state = 4;
                    DIVenable = 1;
                end
                
                if(timecount > 10000000) begin
                    trigger = 1;
                    state = 1;
                    timecount = 0;
                end
                    
                
            end
            CONVERTING: 
            begin
            L0 = 0;
            L1 = 0;
            L2 = 0;
            L3 = 0;
            L4 = 1;
            L5 = 0;
                if(divdone) 
                begin
                    distance = tempdistance;
                    DIVenable = 0;
                    state = DONE;
                    done = 1;
                end
                else if(DIVenable == 0) 
                begin
                    DIVenable = 1;
                end
            end
        
            DONE: 
            begin
            L0 = 0;
            L1 = 0;
            L2 = 0;
            L3 = 0;
            L4 = 0;
            L5 = 1;
                if(~start)
                begin
                    state = IDLE;
                end
            end
    endcase
end
    
    
assign led0 = L0;
assign led1 = L1;
assign led2 = L2;
assign led3 = L3;
assign led4 = L4;
assign led5 = L5;

assign D1o = D1;
assign D2o = D2;
assign D3o = D3;
assign D4o = D4;
endmodule
