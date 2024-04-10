#include "../Include/lcd.h"
//向LCD写入一个字节的命令或数据。is_cmd:1命令 0数据 
void write_cmd_or_data(u8 data,bool is_cmd)
{
    u8 i;
    if(is_cmd)
    Clr_LCD_DC;
    else
    Set_LCD_DC;
    for(i=0;i<8;i++)
    {
        Clr_LCD_SCL;

        if(data&0x80)
            Set_LCD_SDA;
        else
            Clr_LCD_SDA;
        Set_LCD_SCL;
        data<<=1;
    }
}


//写十六位数据
void write_data_u16(u16 data)
{
	write_cmd_or_data((data >> 8),is_data);	
	write_cmd_or_data((data & 0x0f),is_data);	
}

void LCD_Init(void)
{
    //复位.主函数默认已经初始化过delay函数
    Clr_LCD_RST;
    delay_ms(1); //1ms
    Set_LCD_RST;
    delay_ms(120); //120ms

    //LCD Init For 1.44Inch LCD Panel with ST7735R.
	write_cmd_or_data(0x11,is_cmd);//Sleep exit 
	delay_ms(120);
		
	//ST7735R Frame Rate	 4
	write_cmd_or_data(0xB1,is_cmd); 
	write_cmd_or_data(0x01,is_data); 
	write_cmd_or_data(0x2C,is_data); 
	write_cmd_or_data(0x2D,is_data); 
									
	write_cmd_or_data(0xB2,is_cmd); 
	write_cmd_or_data(0x01,is_data); 
	write_cmd_or_data(0x2C,is_data); 
	write_cmd_or_data(0x2D,is_data); 

	write_cmd_or_data(0xB3,is_cmd); 
	write_cmd_or_data(0x01,is_data); 
	write_cmd_or_data(0x2C,is_data); 
	write_cmd_or_data(0x2D,is_data); 
	write_cmd_or_data(0x01,is_data); 
	write_cmd_or_data(0x2C,is_data); 
	write_cmd_or_data(0x2D,is_data); 
	
	write_cmd_or_data(0xB4,is_cmd); //Column inversion 
	write_cmd_or_data(0x07,is_data); 
	
	//ST7735R Power Sequence
	write_cmd_or_data(0xC0,is_cmd); 
	write_cmd_or_data(0xA2,is_data); 
	write_cmd_or_data(0x02,is_data); 
	write_cmd_or_data(0x84,is_data); 
	write_cmd_or_data(0xC1,is_cmd); 
	write_cmd_or_data(0xC5,is_data); 

	write_cmd_or_data(0xC2,is_cmd); 
	write_cmd_or_data(0x0A,is_data); 
	write_cmd_or_data(0x00,is_data); 

	write_cmd_or_data(0xC3,is_cmd); 
	write_cmd_or_data(0x8A,is_data); 
	write_cmd_or_data(0x2A,is_data); 
	write_cmd_or_data(0xC4,is_cmd); 
	write_cmd_or_data(0x8A,is_data); 
	write_cmd_or_data(0xEE,is_data); 
	
	write_cmd_or_data(0xC5,is_cmd); //VCOM 
	write_cmd_or_data(0x0E,is_data); 
	
	write_cmd_or_data(0x36,is_cmd); //MX, MY, RGB mode 
	write_cmd_or_data(0xA0,is_data); //竖屏C8 横屏08 A8
//	write_cmd_or_data(0xC0); //竖屏C8 横屏08 A8 
	
	//ST7735R Gamma Sequence
	write_cmd_or_data(0xe0,is_cmd); 
	write_cmd_or_data(0x0f,is_data); 
	write_cmd_or_data(0x1a,is_data); 
	write_cmd_or_data(0x0f,is_data); 
	write_cmd_or_data(0x18,is_data); 
	write_cmd_or_data(0x2f,is_data); 
	write_cmd_or_data(0x28,is_data); 
	write_cmd_or_data(0x20,is_data); 
	write_cmd_or_data(0x22,is_data); 
	write_cmd_or_data(0x1f,is_data); 
	write_cmd_or_data(0x1b,is_data); 
	write_cmd_or_data(0x23,is_data); 
	write_cmd_or_data(0x37,is_data); 
	write_cmd_or_data(0x00,is_data); 	
	write_cmd_or_data(0x07,is_data); 
	write_cmd_or_data(0x02,is_data); 
	write_cmd_or_data(0x10,is_data); 


	write_cmd_or_data(0xe1,is_cmd); 
	write_cmd_or_data(0x0f,is_data); 
	write_cmd_or_data(0x1b,is_data); 
	write_cmd_or_data(0x0f,is_data); 
	write_cmd_or_data(0x17,is_data); 
	write_cmd_or_data(0x33,is_data); 
	write_cmd_or_data(0x2c,is_data); 
	write_cmd_or_data(0x29,is_data); 
	write_cmd_or_data(0x2e,is_data); 
	write_cmd_or_data(0x30,is_data); 
	write_cmd_or_data(0x30,is_data); 
	write_cmd_or_data(0x39,is_data); 
	write_cmd_or_data(0x3f,is_data); 
	write_cmd_or_data(0x00,is_data); 
	write_cmd_or_data(0x07,is_data); 
	write_cmd_or_data(0x03,is_data); 
	write_cmd_or_data(0x10,is_data);  
	
	write_cmd_or_data(0x2a,is_cmd);
	write_cmd_or_data(0x00,is_data);
	write_cmd_or_data(0x00+2,is_data);
	write_cmd_or_data(0x00,is_data);
	write_cmd_or_data(0x80+2,is_data);

	write_cmd_or_data(0x2b,is_cmd);
	write_cmd_or_data(0x00,is_data);
	write_cmd_or_data(0x00+3,is_data);
	write_cmd_or_data(0x00,is_data);
	write_cmd_or_data(0x80+3,is_data);
	
	write_cmd_or_data(0xF0,is_cmd); //Enable test command  
	write_cmd_or_data(0x01,is_data); 
	write_cmd_or_data(0xF6,is_cmd); //Disable ram power save mode 
	write_cmd_or_data(0x00,is_data); 
	
	write_cmd_or_data(0x3A,is_cmd); //65k mode 
	write_cmd_or_data(0x05,is_data); 
	
	
	write_cmd_or_data(0x29,is_cmd);//Display on

}
//清除所有屏幕
void LCD_clear(void)
{
    write_cmd_or_data(0x01,is_cmd);
}

void LCD_Display_off(void)
{
    write_cmd_or_data(0x28,is_cmd);
}

void LCD_Display_on(void)
{
    write_cmd_or_data(0x29,is_cmd);
}
//写入屏幕地址函数 起始点坐标，终止点坐标
void LCD_write_address(u8 x_start,u8 y_start,u8 x_end,u8 y_end)
{
	write_cmd_or_data(0x2a,is_cmd);
	write_cmd_or_data(x_start >> 8,is_data);
	write_cmd_or_data(x_start,is_data);
	write_cmd_or_data(x_end >> 8,is_data);
	write_cmd_or_data(x_end,is_data);
	
	write_cmd_or_data(0x2b,is_cmd);
	write_cmd_or_data(y_start >> 8,is_data);
	write_cmd_or_data(y_start,is_data);
	write_cmd_or_data(y_end >> 8,is_data);
	write_cmd_or_data(y_end,is_data);	
	
	write_cmd_or_data(0x2c,is_cmd);
}

//全屏颜色填充
void LCD_set_color(u16 color)
{
	LCD_write_address(0,0,159,127);//像素160*128
	for(int i = 0; i < 160; i++)
	{
		for(int j = 0; j < 128; j++)
		{
			lcd_write_data_u16(RED_color);
		}
	}
} 
