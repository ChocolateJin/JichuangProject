#include "stdio.h"
#include "delay.h"
#include "btn_intr_driver.h"
void btn_init(void){
    NVIC_EnableIRQ(BTN_R_IRQn);
    NVIC_EnableIRQ(BTN_L_IRQn);
    NVIC_EnableIRQ(BTN_D_IRQn);
    NVIC_EnableIRQ(BTN_U_IRQn);
};

void BTN_R_Handler(void){
	printf("BTN_R pressed!");
	delay_ms(3);
}

void BTN_L_Handler(void){
	printf("BTN_L pressed!");
	delay_ms(3);
}

void BTN_D_Handler(void){
	printf("BTN_D pressed!");
	delay_ms(3);
}

void BTN_U_Handler(void){
	printf("BTN_U pressed!");
	delay_ms(3);
}

