`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2021 03:56:48 PM
// Design Name: 
// Module Name: miniProjectSource
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
// Switch 0 : Speed Control 0 25%
// Switch 1 : Speed Control 1 25%
// Switch 2 : Speed Control 2 25%
// Switch 3 : Speed Control 3 25%
// Switch 4 : Left Motor Forward/Backward
// Switch 5 : Right Motor Forward/Backward
// Switch 6 : Left motor on
// Switch 7 : Right motor on
// 7 seg display: 
//////////////////////////////////////////////////////////////////////////////////
//GENERAL THINGS I WISH TO KNOW
// 1. Are functions a thing in verilog, are classes?
// 2. Can I make this in C instead of verilog, I dont like verilog.
// 3. TODO: Dont let corbin touch the code
// 4. Figure out how to get rid of the critical warnings in the Synthesis and Implementation, it seems
// to be related to the amount of set_properties being used, "set_property expects at least one object"

//Period 60Hz
module miniProjectSource(
    //TODO: Review all variables, are all of them neccesary?
    //TODO: Add more coments so I can remember what any of this does
    input clock,
    input in0,in1,in2,in3,in4,in5,in6,in7,
    input btnC,
    output PWM,
    input wire control1,control2,
    output reg a,b,c,d,e,f,
    output s0,s1,s2,s3,s4,s5,s6,dp,
    output [3:0] an
    );
    
    localparam N = 18;
    
    //TODO: Review all regs used, are all of them neccesary?
    reg temp = 1;
    reg temp2 = 0;
    
    //100000000/60 = 1666666.667
    //log    (1666666.67) = 20.6 round up to 21
    //   (2)
    reg [21:0] counter;
    reg [21:0] width;
    reg [27:0] safety_count;
    reg temp_PWM;
    reg temp_curr;
    integer speed;
    reg [7:0]sseg;
    integer safety;
    
    initial begin
    safety = 0;
    safety_count = 0;
    counter = 0;
    width = 0;
    temp_PWM = 0;
    //safety_count = 0;
    end
    
    reg [N-1:0] count;
    reg [6:0] sseg_temp;    
    reg [3:0] an_temp;
    
    
    
    always@(posedge clock) begin
        
        if (counter > 1666666)
            counter <= 0;
        else if (safety == 0)
            counter <= counter +1;
            
        if(counter < width)
           temp_PWM <= 1;
        else 
           temp_PWM <= 0;   
              
            
        //If Current is over 1Amp for over .07 seconds, change the safety state
        if (control1 || control2) begin
        //Counts to make sure motors are pulling more than 1 Amp for .07 seconds
         if(safety_count > 7000000)
            safety=1; 
         else 
            safety_count <= safety_count +1;     
        end
          
        else begin 
            safety_count = 0;
            //reset safety state
            if(btnC) 
                safety = 0;
        end
        
            
    end
    

always @ (*)
begin
 //TODO: Move multiplexing to somewhere else, its ugly
  case(count[N-1:N-2]) //using only the 2 MSB's of the counter 
   2'b00 :  //When the 2 MSB's are 00 enable the fourth display
    begin
        if (safety == 1) begin
            sseg = 10;
            end
        else begin
            sseg = 5;
            //safety = 1;
            end         
     an_temp = 4'b1110;
    end
   
   2'b01:  //When the 2 MSB's are 01 enable the third display
    begin
        if (safety == 1) begin
            sseg = 1;
            end
        else begin
            sseg = 5;           
            end
     an_temp = 4'b1101;
    end
   
   2'b10:  //When the 2 MSB's are 10 enable the second display
    begin
     sseg = 0;
     an_temp = 4'b1011;
    end
    
   2'b11:  //When the 2 MSB's are 11 enable the first display
    begin
      sseg = 0;    
     an_temp = 4'b0111;
    end
  endcase
 end
assign an = an_temp;

//Do we really need multiple always @ (*) , I think we can just put it all under one
always @ (*)
 begin
  case(sseg)
   4'd0 : sseg_temp = 7'b1000000; //to display 0
   4'd1 : sseg_temp = 7'b1111001; //to display 1
   4'd2 : sseg_temp = 7'b0100100; //to display 2
   4'd3 : sseg_temp = 7'b0110000; //to display 3
   4'd4 : sseg_temp = 7'b0011001; //to display 4
   4'd5 : sseg_temp = 7'b0010010; //to display 5
   4'd6 : sseg_temp = 7'b0000010; //to display 6
   4'd7 : sseg_temp = 7'b1111000; //to display 7
   4'd8 : sseg_temp = 7'b0000000; //to display 8
   4'd9 : sseg_temp = 7'b0010000; //to display 9
   4'd10 : sseg_temp = 7'b0001000; //to display A
   default : sseg_temp = 7'b1111111; //dash
  endcase
 end
assign {s6, s5, s4, s3, s2, s1, s0} = sseg_temp;


    // 100% duty cycle is 1666666.67
    //  75% duty cycle is 1250000
    //  50% duty cycle is 833333.33
    //  25% duty cycle is 416666.67 
    always @ (*)
    begin
    speed = (in0 + in1 + in2 + in3);
    
    case (speed)
    1 : width = 416666;     
    2 : width = 833333;
    3 : width = 1250000;
    4 : width = 1666666;
    default : width = 0;    
    endcase
    
    if(in4) begin
        a = temp;
        b = temp2;
        end
    else begin
        a = temp2;
        b = temp;
        end
    if(in5) begin
        c = temp;
        d = temp2;
        end
    else begin
        c = temp2;
        d = temp;
        end  
        
    if (in6 && safety == 0) begin
        e = temp_PWM;
        end
    else begin
        e = temp2;
        end
        
    if (in7 && safety == 0) begin
        f = temp_PWM;
        end
    else begin
        f = temp2;
        end
        
        
    end
   
assign PWM = temp_PWM;


endmodule
