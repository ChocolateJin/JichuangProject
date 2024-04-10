#ifndef LCD_H_
#define LCD_H_
#include "delay.h"
typedef uint8_t u8;
typedef uint16_t u16;
#define LCD_GND 0
#define LCD_VDD 1
#define LCD_SCL 2
#define LCD_SDA 3
#define LCD_RST 4
#define LCD_DC 5//1为写0为读
#define LCD_CS 6 //片选，1为选中
//表示写函数当前写入是命令还是数据
#define is_cmd 0
#define is_data 1 //存疑，疑似调换
#define RED_color  		0xf800
//SCL
#define Set_LCD_SCL CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)|(1<<LCD_SCL))
#define Clr_LCD_SCL CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)&(~(1<<LCD_SCL)))
//SDA
#define Set_LCD_SDA CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)|(1<<LCD_SDA))
#define Clr_LCD_SDA CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)&(~(1<<LCD_SDA)))
//RST
#define Set_LCD_RST CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)|(1<<LCD_RST))
#define Clr_LCD_RST CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)&(~(1<<LCD_RST)))
//DC 1命令0数据
#define Set_LCD_DC CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)|(1<<LCD_DC))
#define Clr_LCD_DC CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)&(~(1<<LCD_DC)))
//CS
#define Set_LCD_CS CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)|(1<<LCD_CS))
#define Clr_LCD_CS CMSDK_GPIO0->DATAOUT=((CMSDK_GPIO0->DATAOUT)&(~(1<<LCD_CS)))

//LCD控制用函数
void write_cmd_or_data(u8 data,bool is_cmd);
void LCD_write_address(u8 x_start,u8 y_start,u8 x_end,u8 y_end);
void LCD_Display_On(void);
void LCD_Display_Off(void);
void LCD_Refresh_Gram(void);

void LCD_Init(void);
void LCD_Clear(void);
void LCD_DrawPoint(u8 x,u8 y,u8 t);
void LCD_Fill(u8 x1,u8 y1,u8 x2,u8 y2,u8 dot);
void LCD_ShowChar(u8 x,u8 y,u8 chr,u8 size,u8 mode);
void LCD_ShowNum(u8 x,u8 y,u32 num,u8 len,u8 size);
void LCD_ShowString(u8 x,u8 y,const u8 *p);

#endif /*LCD_H_*/