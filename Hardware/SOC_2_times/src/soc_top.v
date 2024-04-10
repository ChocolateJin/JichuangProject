module soc_top( 
    input clk,
    input rst_n,
    input swclk,
    inout swdio,
    output reg led_1s,
    inout [15:0] gpio0,
    /* UART0 */
    input  uart0_rxd,
    output uart0_txd,
    input [3:0]btn,
    output [3:0]btn_interrupt_debug

);

//------------------------------------------------------------------------------
// PLL模块例化
//------------------------------------------------------------------------------
wire soc_clk;
wire adc_clk;
wire dac_clk;
pll pll_u0(
	.refclk(clk),
	.reset(~rst_n),
	.clk0_out(soc_clk)
);

//------------------------------------------------------------------------------
// SoC例化
//------------------------------------------------------------------------------
soc_cm0 soc_cm0_u0(
    // 时钟和复位
    .sysclk(soc_clk),
    .rst_n(rst_n),
    // 调试接口
    .swclk(swclk),
    .swdio(swdio),
    .gpio0(gpio0),
    /* UART0 */
    .uart0_rxd(uart0_rxd),
    .uart0_txd(uart0_txd),
    .btn(btn),
    .btn_interrupt_debug(btn_interrupt_debug)
);
 
//------------------------------------------------------------------------------
// LED每秒闪动一次的逻辑
//------------------------------------------------------------------------------
reg [31:0] cnt1;
always @(posedge soc_clk or negedge rst_n) begin
    if (~rst_n) begin 
        led_1s<=0;
	cnt1<=0;
    end
    else if (cnt1==32'd50000000-1) begin 	
        cnt1<=0;
        led_1s<=~led_1s;	
    end	
    else begin 
        cnt1<=cnt1+1'b1;
    end	
end


endmodule
