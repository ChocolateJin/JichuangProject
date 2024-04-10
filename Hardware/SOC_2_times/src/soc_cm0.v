module soc_cm0( 
/* CLOCK & RESET */
    input sysclk,
    input rst_n,
    /* DEBUG */
    input swclk,
    inout swdio,
    /*GPIO0*/
    inout [15:0] gpio0,
    /* UART0 */
    input  uart0_rxd,
    output uart0_txd,
    
    input [3:0]btn,
    output [3:0]btn_interrupt_debug

);
//------------------------------------------------------------------------------
// AHB总线-内部信号线定义
//------------------------------------------------------------------------------
/* 主机信号接口 */
wire        HWRITE,HREADY,HRESP;
wire [1:0]  HTRANS;
wire [2:0]  HSIZE,HBURST;
wire [3:0]  HPROT;
wire [31:0] HADDR,HWDATA,HRDATA;

/* 从机信号接口 */
wire        HSELM0,HWRITEM0,HMASTLOCKM0,HREADYM0,HREADYOUTM0,HRESPM0;
wire [1:0]  HTRANSM0;
wire [2:0]  HSIZEM0,HBURSTM0;
wire [3:0]  HPROTM0;
wire [31:0] HADDRM0,HWDATAM0,HRDATAM0;

wire        HSELM1,HWRITEM1,HMASTLOCKM1,HREADYM1,HREADYOUTM1,HRESPM1;
wire [1:0]  HTRANSM1;
wire [2:0]  HSIZEM1,HBURSTM1;
wire [3:0]  HPROTM1;
wire [31:0] HWDATAM1,HRDATAM1,HADDRM1;

wire        HSELM2,HWRITEM2,HMASTLOCKM2,HREADYM2,HREADYOUTM2,HRESPM2;
wire [1:0]  HTRANSM2;
wire [2:0]  HSIZEM2,HBURSTM2;
wire [3:0]  HPROTM2;
wire [31:0] HWDATAM2,HRDATAM2,HADDRM2;

wire        HSELM3,HWRITEM3,HMASTLOCKM3,HREADYM3,HREADYOUTM3,HRESPM3;
wire [1:0]  HTRANSM3;
wire [2:0]  HSIZEM3,HBURSTM3;
wire [3:0]  HPROTM3;
wire [31:0] HWDATAM3,HRDATAM3,HADDRM3;

wire        HSELM4,HWRITEM4,HMASTLOCKM4,HREADYM4,HREADYOUTM4,HRESPM4;
wire [1:0]  HTRANSM4;
wire [2:0]  HSIZEM4,HBURSTM4;
wire [3:0]  HPROTM4;
wire [31:0] HWDATAM4,HRDATAM4,HADDRM4;

//------------------------------------------------------------------------------
// DEBUG 
//------------------------------------------------------------------------------
wire SWDIO,SWCLK;
assign swdio=SWDIO;
assign SWCLKTCK=swclk;

wire SWDO;
wire SWDOEN;
wire SWDI;


assign SWCLK=swclk;
assign SWDI = SWDIO;
assign SWDIO = (SWDOEN) ?  SWDO : 1'bz;

//------------------------------------------------------------------------------
// IRQ
//------------------------------------------------------------------------------
wire [31:0] IRQ;
wire [31:0] apbsubsys_interrupt;
assign IRQ = {btn_interrupt[3:0],apbsubsys_interrupt[27:0]};


//------------------------------------------------------------------------------
// RESET AND DEBUG（复位与调试）
//------------------------------------------------------------------------------
wire SYSRESETREQ;
reg cpuresetn;
wire RSTn=rst_n;
wire HCLK=sysclk;
wire HRESETn=cpuresetn;
always @(posedge sysclk or negedge RSTn)begin
    if (~RSTn) cpuresetn <= 1'b0;
    else if (SYSRESETREQ) cpuresetn <= 1'b0;
    else cpuresetn <= 1'b1;
end

wire CDBGPWRUPREQ;
reg CDBGPWRUPACK;

always @(posedge sysclk or negedge RSTn)begin
    if (~RSTn) CDBGPWRUPACK <= 1'b0;
    else CDBGPWRUPACK <= CDBGPWRUPREQ;
end

//------------------------------------------------------------------------------
// Instantiate Cortex-M0 processor logic level
//------------------------------------------------------------------------------
CORTEXM0INTEGRATION cm0_u0 (
    // System inputs
    .FCLK           (sysclk),           //FREE running clock 
    .SCLK           (sysclk),           //system clock
    .HCLK           (sysclk),           //AHB clock
    .DCLK           (sysclk),           //Debug clock
    .PORESETn       (RSTn),             //Power on reset
    .HRESETn        (cpuresetn),        //AHB and System reset
    .DBGRESETn      (RSTn),             //Debug Reset
    .RSTBYPASS      (1'b0),             //Reset bypass
    .SE             (1'b0),             // dummy scan enable port for synthesis

    // Power management inputs
    .SLEEPHOLDREQn  (1'b1),             // Sleep extension request from PMU
    .WICENREQ       (1'b0),             // WIC enable request from PMU
    .CDBGPWRUPACK   (CDBGPWRUPACK),     // Debug Power Up ACK from PMU

    // Power management outputs
    .CDBGPWRUPREQ   (CDBGPWRUPREQ),
    .SYSRESETREQ    (SYSRESETREQ),

    // System bus
    .HADDR          (HADDR[31:0]),
    .HTRANS         (HTRANS[1:0]),
    .HSIZE          (HSIZE[2:0]),
    .HBURST         (HBURST[2:0]),
    .HPROT          (HPROT[3:0]),
    .HMASTER        (HMASTER),
    .HMASTLOCK      (HMASTLOCK),
    .HWRITE         (HWRITE),
    .HWDATA         (HWDATA[31:0]),
    .HRDATA         (HRDATA[31:0]),
    .HREADY         (HREADY),
    .HRESP          (HRESP),

    // Interrupts
    .IRQ            (IRQ),          //Interrupt
    .NMI            (1'b0),         //Watch dog interrupt
    .IRQLATENCY     (8'h0),
    .ECOREVNUM      (28'h0),

    // Systick
    .STCLKEN        (1'b1),
    .STCALIB        (26'h0),

    // Debug - JTAG or Serial wire
    // Inputs
    .nTRST          (1'b1),
    .SWDITMS        (SWDI),
    .SWCLKTCK       (SWCLK),
    .TDI            (1'b0),
    // Outputs
    .SWDO           (SWDO),
    .SWDOEN         (SWDOEN),

    .DBGRESTART     (1'b0),

    // Event communication
    .RXEV           (RXEV),         // Generate event when a DMA operation completed.
    .EDBGRQ         (1'b0)          // multi-core synchronous halt request
);


//------------------------------------------------------------------------------
// 总线矩阵
//------------------------------------------------------------------------------
cm0_mtx_lite mtx_lite_u0 (
    // Common AHB signals
    .HCLK(HCLK),
    .HRESETn(HRESETn),

    // System Address Remap control
    .REMAP(4'b0),

    // Input port SI0 (inputs from master 0)
    .HADDRS0(HADDR),
    .HTRANSS0(HTRANS),
    .HWRITES0(HWRITE),
    .HSIZES0(HSIZE),
    .HBURSTS0(HBURST),
    .HPROTS0(HPROT),
    .HWDATAS0(HWDATA),
    .HMASTLOCKS0(1'b0),
    .HAUSERS0(32'b0),
    .HWUSERS0(32'b0),

    // Output port MI0 (inputs from slave 0)
    .HRDATAM0(HRDATAM0),
    .HREADYOUTM0(HREADYOUTM0),
    .HRESPM0(HRESPM0),
    .HRUSERM0(32'b0),

    // Output port MI1 (inputs from slave 1)
    .HRDATAM1(HRDATAM1),
    .HREADYOUTM1(HREADYOUTM1),
    .HRESPM1(HRESPM1),
    .HRUSERM1(32'b0),

    // Output port MI2 (inputs from slave 2)
    .HRDATAM2(HRDATAM2),
    .HREADYOUTM2(HREADYOUTM2),
    .HRESPM2(HRESPM2),
    .HRUSERM2(32'b0),

    // Output port MI3 (inputs from slave 3)
    .HRDATAM3(HRDATAM3),
    .HREADYOUTM3(HREADYOUTM3),
    .HRESPM3(HRESPM3),
    .HRUSERM3(32'b0),

    // Output port MI4 (inputs from slave 4)
    .HRDATAM4(HRDATAM4),
    .HREADYOUTM4(HREADYOUTM4),
    .HRESPM4(HRESPM4),
    .HRUSERM4(32'b0),

    // Scan test dummy signals; not connected until scan insertion
    .SCANENABLE(1'b0),   // Scan Test Mode Enable
    .SCANINHCLK(1'b0),   // Scan Chain Input


    // Output port MI0 (outputs to slave 0)
    .HSELM0(HSELM0),
    .HADDRM0(HADDRM0),
    .HTRANSM0(HTRANSM0),
    .HWRITEM0(HWRITEM0),
    .HSIZEM0(HSIZEM0),
    .HBURSTM0(HBURSTM0),
    .HPROTM0(HPROTM0),
    .HWDATAM0(HWDATAM0),
    .HMASTLOCKM0(HMASTLOCKM0),
    .HREADYMUXM0(HREADYM0),
    .HAUSERM0(),
    .HWUSERM0(),

    // Output port MI1 (outputs to slave 1)
    .HSELM1(HSELM1),
    .HADDRM1(HADDRM1),
    .HTRANSM1(HTRANSM1),
    .HWRITEM1(HWRITEM1),
    .HSIZEM1(HSIZEM1),
    .HBURSTM1(HBURSTM1),
    .HPROTM1(HPROTM1),
    .HWDATAM1(HWDATAM1),
    .HMASTLOCKM1(HMASTLOCKM1),
    .HREADYMUXM1(HREADYM1),
    .HAUSERM1(),
    .HWUSERM1(),

    // Output port MI2 (outputs to slave 2)
    .HSELM2(HSELM2),
    .HADDRM2(HADDRM2),
    .HTRANSM2(HTRANSM2),
    .HWRITEM2(HWRITEM2),
    .HSIZEM2(HSIZEM2),
    .HBURSTM2(HBURSTM2),
    .HPROTM2(HPROTM2),
    .HWDATAM2(HWDATAM2),
    .HMASTLOCKM2(HMASTLOCKM2),
    .HREADYMUXM2(HREADYM2),
    .HAUSERM2(),
    .HWUSERM2(),

    // Output port MI3 (outputs to slave 3)
    .HSELM3(HSELM3),
    .HADDRM3(HADDRM3),
    .HTRANSM3(HTRANSM3),
    .HWRITEM3(HWRITEM3),
    .HSIZEM3(HSIZEM3),
    .HBURSTM3(HBURSTM3),
    .HPROTM3(HPROTM3),
    .HWDATAM3(HWDATAM3),
    .HMASTLOCKM3(HMASTLOCKM3),
    .HREADYMUXM3(HREADYM3),
    .HAUSERM3(),
    .HWUSERM3(),

    // Output port MI4 (outputs to slave 4)
    .HSELM4(HSELM4),
    .HADDRM4(HADDRM4),
    .HTRANSM4(HTRANSM4),
    .HWRITEM4(HWRITEM4),
    .HSIZEM4(HSIZEM4),
    .HBURSTM4(HBURSTM4),
    .HPROTM4(HPROTM4),
    .HWDATAM4(HWDATAM4),
    .HMASTLOCKM4(HMASTLOCKM4),
    .HREADYMUXM4(HREADYM4),
    .HAUSERM4(),
    .HWUSERM4(),

    // Input port SI0 (outputs to master 0)
    .HRDATAS0(HRDATA),
    .HREADYS0(HREADY),
    .HRESPS0(HRESP),
    .HRUSERS0(),

    // Scan test dummy signals; not connected until scan insertion
    .SCANOUTHCLK()   // Scan Chain Output

);

//------------------------------------------------------------------------------
// ITCM和DTCM
//------------------------------------------------------------------------------
/* 存储器所需的内部信号 */
wire [31:0] ITCM_RDATA,ITCM_WDATA,DTCM_RDATA,DTCM_WDATA; // 读写信号线
wire [16:0] ITCM_ADDR,DTCM_ADDR;                         // 地址线
wire [3:0]  ITCM_WRITE,DTCM_WRITE;                       // 写使能
wire        ITCM_CS,DTCM_CS;                             // 片选

/* AHB挂载ITCM */
cmsdk_ahb_to_sram #(
    .AW                                 (32)
) ahb_itcm (
    .HCLK                               (HCLK),
    .HRESETn                            (HRESETn),
    .HSEL                               (HSELM1),
    .HREADY                             (HREADYM1),
    .HTRANS                             (HTRANSM1),
    .HSIZE                              (HSIZEM1),
    .HWRITE                             (HWRITEM1),
    .HADDR                              (HADDRM1),
    .HWDATA                             (HWDATAM1),
    .HREADYOUT                          (HREADYOUTM1),
    .HRESP                              (HRESPM1),
    .HRDATA                             (HRDATAM1),

    .SRAMRDATA                          (ITCM_RDATA),  // 读数据
    .SRAMADDR                           (ITCM_ADDR),   // 地址线
    .SRAMWEN                            (ITCM_WRITE),  // 写使能信号
    .SRAMWDATA                          (ITCM_WDATA),  // 写数据
    .SRAMCS                             (ITCM_CS)      // 片选信号
);

/* ITCM例化 */
itcm itcm_u0(
	.clka                               (HCLK),
    .addra                              (ITCM_ADDR),
    .dia                                (ITCM_WDATA),
    .wea                                (ITCM_WRITE & {4{ITCM_CS}}),
    .doa                                (ITCM_RDATA)    
);

/* AHB挂载DTCM */
cmsdk_ahb_to_sram #(
    .AW                                 (32)
) ahb_dtcm (
    .HCLK                               (HCLK),
    .HRESETn                            (HRESETn),
    .HSEL                               (HSELM0),
    .HREADY                             (HREADYM0),
    .HTRANS                             (HTRANSM0),
    .HSIZE                              (HSIZEM0),
    .HWRITE                             (HWRITEM0),
    .HADDR                              (HADDRM0),
    .HWDATA                             (HWDATAM0),
    .HREADYOUT                          (HREADYOUTM0),
    .HRESP                              (HRESPM0),
    .HRDATA                             (HRDATAM0),

    .SRAMRDATA                          (DTCM_RDATA),  // 读数据
    .SRAMADDR                           (DTCM_ADDR),   // 地址线
    .SRAMWEN                            (DTCM_WRITE),  // 写使能信号
    .SRAMWDATA                          (DTCM_WDATA),  // 写数据
    .SRAMCS                             (DTCM_CS)      // 片选信号
);

/* DTCM例化 */
dtcm dtcm_u0(
	.clka                               (HCLK),
    .addra                              (DTCM_ADDR),
    .dia                                (DTCM_WDATA),
    .wea                                (DTCM_WRITE& {4{DTCM_CS}}),
    .doa                                (DTCM_RDATA)    
);


//------------------------------------------------------------------------------
// GPIO
//------------------------------------------------------------------------------
/* GPIO所需的内部信号 */
wire [15:0] gpio0_out,gpio0_in,gpio0_oen;

/* AHB挂载GPIO */
cmsdk_ahb_gpio cmsdk_ahb_gpio_u0(
    .HCLK                               (HCLK),
    .FCLK				(HCLK),
    .HRESETn                            (HRESETn),
    .HSEL                               (HSELM3),
    .HREADY                             (HREADYM3),
    .HTRANS                             (HTRANSM3),
    .HSIZE                              (HSIZEM3),
    .HWRITE                             (HWRITEM3),
    .HADDR                              (HADDRM3),
    .HWDATA                             (HWDATAM3),
    .HREADYOUT                          (HREADYOUTM3),
    .HRESP                              (HRESPM3),
    .HRDATA                             (HRDATAM3),
    .ECOREVNUM				(4'b0),
    .PORTOUT				(gpio0_out),
    .PORTIN				(gpio0_in),
    .PORTEN				(gpio0_oen),
    .PORTFUNC(),
    .GPIOINT(),
    .COMBINT				(irq_gpio0)
);

genvar i;
generate
    for (i=0;i<16;i=i+1) 
    begin
        assign gpio0[i]   = gpio0_oen[i]?gpio0_out[i]:1'bz;
        assign gpio0_in[i]= gpio0_oen[i]?1'bz:gpio0[i];
    end
endgenerate

//------------------------------------------------------------------------------
// SubSystem
//------------------------------------------------------------------------------
cmsdk_apb_subsystem #(

  // 目前我们只需要UART0，所以，只给INCLUDE_APB_UART0赋值为1，其余为0

  .APB_EXT_PORT12_ENABLE                (0),
  .APB_EXT_PORT13_ENABLE                (0),
  .APB_EXT_PORT14_ENABLE                (0),
  .APB_EXT_PORT15_ENABLE                (0),

  .INCLUDE_IRQ_SYNCHRONIZER             (0),

  .INCLUDE_APB_TEST_SLAVE               (0),

  .INCLUDE_APB_TIMER0                   (0),  
  .INCLUDE_APB_TIMER1                   (0),  
  .INCLUDE_APB_DUALTIMER0               (0),  
  .INCLUDE_APB_UART0                    (1), // PORT4
  .INCLUDE_APB_UART1                    (0),  
  .INCLUDE_APB_UART2                    (0),                                                       
  .INCLUDE_APB_WATCHDOG                 (0), 

  .BE                                   (0)
) cmsdk_apb_subsystem_u0 (
    .HCLK                               (HCLK),
    .HRESETn                            (HRESETn),    
    .HSEL                               (HSELM2),
    .HADDR                              (HADDRM2),
    .HTRANS                             (HTRANSM2),
    .HWRITE                             (HWRITEM2),
    .HSIZE                              (HSIZEM2),
    .HPROT                              (HPROTM2),
    .HREADY                             (HREADYM2),
    .HWDATA                             (HWDATAM2),
    .HREADYOUT                          (HREADYOUTM2),
    .HRDATA                             (HRDATAM2),
    .HRESP                              (HRESPM2), 

    .PCLK                               (HCLK), 
    .PCLKG                              (HCLK),
    .PCLKEN                             (1'b1),
    .PRESETn                            (HRESETn),
    
    .PADDR                              (),
    .PWRITE                             (),
    .PWDATA                             (),
    .PENABLE                            (),

    .ext12_psel                         (),
    .ext13_psel                         (),
    .ext14_psel                         (),
    .ext15_psel                         (),

    .ext12_prdata                       (32'h00000000),
    .ext12_pready                       (1'b0),
    .ext12_pslverr                      (1'b0),
    .ext13_prdata                       (32'h00000000),
    .ext13_pready                       (1'b0),
    .ext13_pslverr                      (1'b0),
    .ext14_prdata                       (32'h00000000),
    .ext14_pready                       (1'b0),
    .ext14_pslverr                      (1'b0),
    .ext15_prdata                       (32'h00000000),
    .ext15_pready                       (1'b0),
    .ext15_pslverr                      (1'b0),

    .APBACTIVE                          (),

    .uart0_rxd                          (uart0_rxd),
    .uart0_txd                          (uart0_txd),
    .uart0_txen                         (),
    .uart1_rxd                          (1'b0),
    .uart1_txd                          (),
    .uart1_txen                         (),
    .uart2_rxd                          (1'b0),
    .uart2_txd                          (),
    .uart2_txen                         (),

    .timer0_extin                       (1'b0),
    .timer1_extin                       (1'b0),

    .apbsubsys_interrupt                (),
    .watchdog_interrupt                 (),
    .watchdog_reset                     ()
);
wire [3:0]btn_interrupt;
btn_interupt_generator btn_interupt_generator_inst(
    .sysclk(sysclk),
    .rst_n(rst_n),
    .btn(btn),
    .btn_interrupt(btn_interrupt)
    
);
assign btn_interrupt_debug = btn_interrupt;

endmodule
