#include "CMSDK_CM0.h"
typedef struct
{
    __I     uint32_t    KEYBD_VAL;
    __IO     uint32_t    LED;
		__IO    uint32_t		TO_BE_USED_REG;
}ISPController_TypeDef;

/* 地址定义 */
#define ISPController_BASE					(CMSDK_AHB_BASE + 0x10000UL)
#define ISPController                       ((ISPController_TypeDef *)ISPController_BASE)
