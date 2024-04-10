module btn_interupt_generator(
	input wire sysclk,
    input wire rst_n,
    input wire [3:0]btn, //上下左右
    output wire [3:0]btn_interrupt
 );
 
 reg [7:0] btn_deb;
 reg [31:0]reg_cnt;
 always@(posedge sysclk or negedge rst_n)
	if(~rst_n)
    	reg_cnt<=32'b0;
    else if (reg_cnt ==32'd144000) //主频48M，隔3ms检测一次按键状态
    	reg_cnt<=32'b0;
    else
    	reg_cnt<=reg_cnt+1;
always@(posedge sysclk or negedge rst_n)
	if(~rst_n)
    	btn_deb<=8'b11111111;
    else if (reg_cnt ==32'd144000)
    	btn_deb<={btn_deb[3:0],btn};
    else
    	btn_deb<=btn_deb;
        
reg [3:0]btn_neg_flag;
reg [3:0]btn_neg_flag_delay;
always@(posedge sysclk or negedge rst_n)
	if(~rst_n)
    	btn_neg_flag<=4'b0;
    else if (btn_neg_flag !=4'b0)
    	btn_neg_flag <=4'b0;
    else
    	btn_neg_flag<= btn_deb[7:4]&(~btn_deb[3:0]);
        
always@(posedge sysclk or negedge rst_n)
	if(~rst_n)
    	btn_neg_flag_delay<=4'b0;
    else
    	btn_neg_flag_delay<=btn_neg_flag;
   
//assign btn_interrupt = btn_neg_flag && btn_neg_flag_delay;    
assign btn_interrupt = btn_deb[7:4]&(~btn_deb[3:0]); //按下时触发


endmodule
