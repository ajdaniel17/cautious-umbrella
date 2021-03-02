`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2021 03:43:02 PM
// Design Name: 
// Module Name: SevenSegmentDisplay
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


module SevenSegmentDisplay(
    input clock,
    output s0,s1,s2,s3,s4,s5,s6,dp,
    input [3:0] Display1,Display2,Display3,Display4
    );
 
     localparam N = 18;   
    reg [6:0] sseg_temp; 
    reg [3:0] an_temp;
    reg [N-1:0] count;
    reg [7:0]sseg;

SevenSegAssigner DigitAssign(
    .in(Display1),
    .out(sseg_temp)
);

always @ (*)
begin

  case(count[N-1:N-2]) //using only the 2 MSB's of the counter 
    2'b00 :  //When the 2 MSB's are 00 enable the fourth display
    begin
        sseg = d1;  //Display item      
        an_temp = 4'b1110;
    end
   
 2'b01:  //When the 2 MSB's are 01 enable the third display
    begin
        sseg = d2; //Display item
        
        an_temp = 4'b1101;
    end
    2'b10:  //When the 2 MSB's are 10 enable the second display
    begin
        sseg = d3; //Display item
        an_temp = 4'b1011;
    end
    2'b11:  //When the 2 MSB's are 11 enable the first display
    begin
        sseg = d4; //Display item    
        an_temp = 4'b0111;
    end
  endcase
  
  

end
    assign an = an_temp;
    assign {s6, s5, s4, s3, s2, s1, s0} = sseg_temp;
    
endmodule
