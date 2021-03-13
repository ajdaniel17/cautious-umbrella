`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2021 01:11:59 PM
// Design Name: 
// Module Name: MovementModule
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


module MovementModule(
    input clock,
    input in0, in1, in2, in3, in4, in5, in6, in7,
    input btnC,
    output PWM,
    input wire control1, control2,
    output reg a,b,c,d,e,f
    );
    
    localparam N = 18;
    
    //TODO: Review all regs used, are all of them neccesary?
    reg temp = 1;
    reg temp2 = 0;
    
    //100000000/60 = 1666666.667
    //log    (1666666.67) = 20.6 round up to 21
    //   (2)
    
    
    //100000000/9600 = 10416.667
    //log (base 2) (10416.667) = 14 (rounded up)
   
    reg [21:0] counter;
    reg [21:0] counter2;
    reg [21:0] width;
    reg [27:0] safety_count;
    reg temp_PWM;
    reg temptest;
    integer speed;
    reg [7:0]sseg;
    integer safety;
    integer i;
    reg testFRQ;
    
    initial begin
    testFRQ = 0;
    safety = 0;
    safety_count = 0;
    counter = 0;
    width = 0;
    temp_PWM = 0;
    end
    
    
    //baudrate of color sensor 9600
    always@(posedge clock) begin
        
        if (counter2 > 5000)
        begin
            counter2 <= 0;
            testFRQ = ~testFRQ;
        end
        else
            counter2 <= counter2 +1;
                
        if (counter > 1666666)
            counter <= 0;
        else if (safety == 0)
            counter <= counter +1;
            
        
        if(counter < width)
           temp_PWM <= 1;
        else 
           temp_PWM <= 0;   
              
            
//        //If Current is over 1Amp for over .07 seconds, change the safety state
//        if (control1 || control2) begin
//        //Counts to make sure motors are pulling more than 1 Amp for .07 seconds
//         if(safety_count > 7000000)
//            safety=1; 
//         else 
//            safety_count <= safety_count +1;     
//        end
          
//        else begin 
//            safety_count = 0;
//            //reset safety state
//            if(btnC) 
//                safety = 0;
//        end
        
            
    end

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
    
    
    temptest = in0;
    
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
    
assign testfrq = testFRQ;
assign PWM = temp_PWM;
    
endmodule
