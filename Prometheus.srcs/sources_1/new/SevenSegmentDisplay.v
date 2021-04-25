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
 input clock, reset,
 input [5:0] input0, input1, input2, input3,  //the 4 inputs for each display
 output s0, s1, s2, s3, s4, s5, s6, dp, //the individual LED output for the seven segment along with the digital point
 output [3:0] an   // the 4 bit enable signal
 );

localparam N = 18;

reg [N-1:0]count; //the 18 bit counter which allows us to multiplex at 1000Hz
reg dudePerfect;

always @ (posedge clock or posedge reset)
 begin
  if (reset)
   count <= 0;
  else
   count <= count + 1;
 end

reg [6:0]sseg; //the 7 bit register to hold the data to output
reg [3:0]an_temp; //register for the 4 bit enable

always @ (*)
 begin
  case(count[N-1:N-2]) //using only the 2 MSB's of the counter 
   
   2'b00 :  //When the 2 MSB's are 00 enable the fourth display
    begin
     sseg <= input0;
     an_temp <= 4'b1110;
     dudePerfect <= 1;
    end
   
   2'b01:  //When the 2 MSB's are 01 enable the third display
    begin
     sseg <= input1;
     an_temp <= 4'b1101;
     dudePerfect <= 0;
    end
   
   2'b10:  //When the 2 MSB's are 10 enable the second display
    begin
     sseg <= input2;
     an_temp <= 4'b1011;
     dudePerfect <= 1;
    end
    
   2'b11:  //When the 2 MSB's are 11 enable the first display
    begin
     sseg <= input3;
     an_temp <= 4'b0111;
     dudePerfect <= 1;
    end
  endcase
 end
assign an = an_temp;


reg [6:0] sseg_temp; // 7 bit register to hold the binary value of each input given

always @ (*)
 begin
  case(sseg)
   5'd0 : sseg_temp <= 7'b1000000; //to display 0
   5'd1 : sseg_temp <= 7'b1111001; //to display 1
   5'd2 : sseg_temp <= 7'b0100100; //to display 2
   5'd3 : sseg_temp <= 7'b0110000; //to display 3
   5'd4 : sseg_temp <= 7'b0011001; //to display 4
   5'd5 : sseg_temp <= 7'b0010010; //to display 5
   5'd6 : sseg_temp <= 7'b0000010; //to display 6
   5'd7 : sseg_temp <= 7'b1111000; //to display 7
   5'd8 : sseg_temp <= 7'b0000000; //to display 8
   5'd9 : sseg_temp <= 7'b0010000; //to display 9
   5'd10 : sseg_temp <= 7'b0001000; //to display A
   5'd11 : sseg_temp <= 7'b0000011; //to display b
   5'd12 : sseg_temp <= 7'b1000110; //to display C
   5'd13 : sseg_temp <= 7'b0100001; //to display d
   5'd14 : sseg_temp <= 7'b0000110; //to display E
   5'd15 : sseg_temp <= 7'b0001110; //to display F
   5'd16 : sseg_temp <= 7'b0101111; //to display r
   5'd17 : sseg_temp <= 7'b0000110; //to display E
   5'd18 : sseg_temp <= 7'b0100001; //to display d
   5'd19 : sseg_temp <= 7'b1000010; //to display G
   5'd20 : sseg_temp <= 7'b0101011; //to display n
   5'd21 : sseg_temp <= 7'b0000011; //to display b
   5'd22 : sseg_temp <= 7'b1001111; //to display l
   5'd23 : sseg_temp <= 7'b1000001; //to display U
   5'd24 : sseg_temp <= 7'b1111111; //to display nothing
   default : sseg_temp <= 7'b0111111; //dash
  endcase
 end
 

assign {s6, s5, s4, s3, s2, s1, s0} = sseg_temp; //concatenate the outputs to the register, this is just a more neat way of doing this.

// I could have done in the case statement: 4'd0 : {g, f, e, d, c, b, a} = 7'b1000000; 
// its the same thing.. write however you like it

assign dp = dudePerfect; //since the decimal point is not needed, all 4 of them are turned off

endmodule
