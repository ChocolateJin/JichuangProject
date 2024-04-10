#include "CMSDK_CM0.h"
#include "delay.h"
#include "CMSDK_driver.h"
#include "stdio.h"
#include "btn_intr_driver.h"
void WaterLight(){
    CMSDK_gpio_SetOutEnable(CMSDK_GPIO0,0xffff);
	  int delay_ms_count;
	delay_ms_count=2000;
    CMSDK_GPIO0->DATAOUT=0x0001;
    delay_ms(delay_ms_count);
    CMSDK_GPIO0->DATAOUT=0x0002;
    delay_ms(delay_ms_count);
    CMSDK_GPIO0->DATAOUT=0x0004;
    delay_ms(delay_ms_count);
    CMSDK_GPIO0->DATAOUT=0x0008;
    delay_ms(delay_ms_count);
    CMSDK_GPIO0->DATAOUT=0x0010;
    delay_ms(delay_ms_count);
    CMSDK_GPIO0->DATAOUT=0x0020;
    delay_ms(delay_ms_count);
    CMSDK_GPIO0->DATAOUT=0x0040;
    delay_ms(delay_ms_count);
}
          
int main(){
    delay_init();
		btn_init();
	while(1)
		WaterLight();
		
}
