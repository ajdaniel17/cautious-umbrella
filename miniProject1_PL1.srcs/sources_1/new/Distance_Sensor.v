`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2021 02:18:38 PM
// Design Name: 
// Module Name: Distance_Sensor
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


module Distance_Sensor(
    input JX1,JX1n,JX2,JX2n,JX3,JX3n,JX4,JX4n,
    input clock,
    input vp_in,vn_in,
    output reg [4:0] D1 = 0,D2 = 0,D3 = 0,D4 =0,
    input divdone1,divdone2,divdone3,divdone4,   
    input [15:0] tempD1,tempD2,tempD3,tempD4,
    input [15:0] data
    );
    wire signed[31:0] bridge1,bridge2,bridge3;
    reg DIVenable1 = 0,DIVenable2 = 0,DIVenable3 = 0,DIVenable4 = 0;
    wire enable;
    reg countstart;
    reg [7:0] Address_in = 8'h16;
    
    reg [11:0] datain;
    reg [32:0] count;
    localparam S_IDLE = 0;
    localparam S_FRAME_WAIT = 1;
    localparam S_CONVERSION = 2;
    reg [1:0] state = S_IDLE;
    reg [15:0] sseg_data;
    reg [31:0] fucker;
    reg [31:0] fucker2;
    reg [31:0] counter = 0;
    reg startdivide;

    //binary to decimal converter signals
    reg b2d_start;
    reg [15:0] b2d_din;
    wire [15:0] b2d_dout;
    wire b2d_done;
    
 xadc_wiz_0_1  XLXI_7 (
        .daddr_in(Address_in), //addresses can be found in the artix 7 XADC user guide DRP register space
        .dclk_in(clock), 
        .den_in(enable), 
        .di_in(0), 
        .dwe_in(0), 
        .busy_out(),                    
        .vauxp6(JX1),
        .vauxn6(JX1n),
        .vauxp7(JX2),
        .vauxn7(JX2n),
        .vauxp14(JX3),
        .vauxn14(JX3n),
        .vauxp15(JX4),
        .vauxn15(JX4n),
        .vn_in(vn_in), 
        .vp_in(vp_in), 
        .alarm_out(), 
        .do_out(data), 
        //.reset_in(),
        .eoc_out(enable),
        .channel_out(),
        .drdy_out(ready)   
    );
    
IntegerDivision Thou(
.enable(DIVenable1),
.done(divdone1),
.Dividend(fucker),
.Divisor($signed(32'd1000000)),
.clock(clock),
.Quotient(tempD1),
.Remainder(bridge1),
.Percentagemode(0)
);

IntegerDivision Hun(
.enable(DIVenable2),
.done(divdone2),
.Dividend(bridge1),
.Divisor($signed(32'd100000)),
.clock(clock),
.Quotient(tempD2),
.Remainder(bridge2),
.Percentagemode(0)
);

IntegerDivision Ten(
.enable(DIVenable3),
.done(divdone3),
.Dividend(bridge2),
.Divisor($signed(32'd10000)),
.clock(clock),
.Quotient(tempD3),
.Remainder(bridge3),
.Percentagemode(0)
);

IntegerDivision Uno(
.enable(DIVenable4),
.done(divdone4),
.Dividend(bridge3),
.Divisor($signed(32'd1000)),
.clock(clock),
.Quotient(tempD4),
.Remainder(),
.Percentagemode(0)
);
    
    always @ (posedge(clock)) begin
    
 
    
    if (counter > 10000000)
    begin
        datain = data[15:4];
        fucker = (datain * 32'd244);
        DIVenable1 = 1;
        
    end
    else
        counter <= counter +1;
        
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
            counter = 0;
        end
    
    /*
        case (state)
        S_IDLE: begin
            state <= S_FRAME_WAIT;
            count <= 'b0;
        end
        S_FRAME_WAIT: begin
            if (count >= 10000000) begin
                if (data > 16'hFFD0) begin
                    sseg_data <= 16'h1000;
                    state <= S_IDLE;
                end else begin
                    b2d_start <= 1'b1;
                    b2d_din <= data;
                    state <= S_CONVERSION;
                end
            end else
                count <= count + 1'b1;
        end
        S_CONVERSION: begin
            b2d_start <= 1'b0;
            if (b2d_done == 1'b1) begin
                sseg_data <= b2d_dout;
                state <= S_IDLE;
            end
        end
        endcase
        */
    end

/*
    bin2dec m_b2d (
        .clk(clock),
        .start(b2d_start),
        .din(b2d_din),
        .done(b2d_done),
        .dout(b2d_dout)
    );
    */




endmodule
