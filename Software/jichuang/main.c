#include "CMSDK_CM0.h"
#include "delay.h"
#include "CMSDK_driver.h"
#include "stdio.h"
#include "btn_intr_driver.h"
#include "lcd.h"
#include "ISPController_driver.h"
void WaterLight(){
    CMSDK_gpio_SetOutEnable(CMSDK_GPIO0,0xffff);
	  int delay_ms_count;
	delay_ms_count=2000;
    CMSDK_GPIO0->DATAOUT=0x0100;
    delay_ms(delay_ms_count);
    CMSDK_GPIO0->DATAOUT=0x0200;
    delay_ms(delay_ms_count);
    CMSDK_GPIO0->DATAOUT=0x0400;
    delay_ms(delay_ms_count);

}
          
int main(){
		CMSDK_gpio_SetOutEnable(CMSDK_GPIO0,0xffff);
		CMSDK_GPIO0->DATAOUT=0x0000;
    delay_init();
		btn_init();
		ISPController->LED=0x0007;
		/*Set_LCD_VDD;
		Set_LCD_BLK;
	
		LCD_Init2();
		LCD_write_cmd(0x01);
		LCD_set_color(RED_color);*/
	printf("ISPController_LED data:0x%0x",(ISPController->LED));
		while(1)
		{
		ISPController->LED=0x0000;
		delay_ms(200);
		delay_ms(200);
		delay_ms(100);
		ISPController->LED=0x0001;
		printf("ISPController_LED data:0x%0x",(ISPController->LED));
		delay_ms(200);
		delay_ms(200);
		delay_ms(100);
		ISPController->LED=0x0002;
		printf("ISPController_LED data:0x%0x",(ISPController->LED));
		delay_ms(200);
		delay_ms(200);
		delay_ms(100);
		ISPController->TO_BE_USED_REG=0x0003;
		printf("ISPController_TO_BE_USED data:0x%0x",(ISPController->TO_BE_USED_REG));
		delay_ms(200);
		delay_ms(200);
		delay_ms(100);
		};
}
