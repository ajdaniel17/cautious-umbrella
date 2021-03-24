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
    output [4:0] D1,D2,D3,D4
    );
    wire enable;
    reg [7:0] Address_in = 8'h16;
    wire [15:0] data;
    reg [32:0] count;
    localparam S_IDLE = 0;
    localparam S_FRAME_WAIT = 1;
    localparam S_CONVERSION = 2;
    reg [1:0] state = S_IDLE;
    reg [15:0] sseg_data;

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
    
    always @ (posedge(clock)) begin
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
    end


    bin2dec m_b2d (
        .clk(clock),
        .start(b2d_start),
        .din(b2d_din),
        .done(b2d_done),
        .dout(b2d_dout)
    );
    
assign D1 = sseg_data[15:12];
assign D2 = sseg_data[11:8];
assign D3 = sseg_data[7:4];
assign D4 = sseg_data[3:0];



endmodule
