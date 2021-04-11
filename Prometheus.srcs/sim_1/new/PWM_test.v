`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2021 03:44:30 PM
// Design Name: 
// Module Name: PWM_test
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


module PWM_test(
    );
    reg clock;
    reg speed;
    reg reset;
    wire PWM;  
    
    //Instence
    miniProjectSource UUT(clock,reset,speed);
    
    initial begin
        clock = 0;
        speed = 0;
        reset = 0;
        #10;

 
        speed = 1;
        reset = 0;
        #300; 


        speed = 2;
        reset = 0;
        #300;

  
        speed = 3;
        reset = 0;
        #300;

        speed = 0;
        reset = 1;
        #300;
      
    end
    
    always begin
    #1 clock = -clock;
    end
endmodule
