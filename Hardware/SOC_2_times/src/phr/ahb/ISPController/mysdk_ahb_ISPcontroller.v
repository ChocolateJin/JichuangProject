//-----------------------------------------------------------------------------
// Abstract : Simple AHB ISPcontroller devices
//-----------------------------------------------------------------------------
//-------------------------------------
// Programmer's model 
// To be modified
// 0x00 R     reg_key_val[3:0] keyboard code value
// 0x04 W     LED 
// 0x08 W     To be used in SD card control
// 0x0C W     reg_seg_digital[31:0]
// 0x10 W     reg_buzzer_cycle[31:0]
// 0x14 W     reg_buzzer_duty[31:0]
//-------------------------------------
module mysdk_ahb_ISPcontroller
// ----------------------------------------------------------------------------
// Port Definitions
// ----------------------------------------------------------------------------
  (// AHB Inputs
   input  wire                 HCLK,      // system bus clock
   input  wire                 HRESETn,   // system bus reset
   input  wire                 HSEL,      // AHB peripheral select
   input  wire                 HREADY,    // AHB ready input
   input  wire  [1:0]          HTRANS,    // AHB transfer type
   input  wire  [2:0]          HSIZE,     // AHB hsize
   input  wire                 HWRITE,    // AHB hwrite
   input  wire [11:0]          HADDR,     // AHB address bus
   input  wire [31:0]          HWDATA,    // AHB write data bus

   // IOP Inputs
   input wire [31:0]           IORDATA,    // I/0 read data bus

   // AHB Outputs
   output wire                 HREADYOUT, // AHB ready output to S->M mux
   output wire                 HRESP,     // AHB response
   output wire [31:0]          HRDATA,

   // IOP Outputs
   output reg                  IOSEL,      // Decode for peripheral
   output reg  [11:0]          IOADDR,     // I/O transfer address
   output reg                  IOWRITE,    // I/O transfer direction
   output reg  [1:0]           IOSIZE,     // I/O transfer size
   output reg                  IOTRANS,    // I/O transaction
   output wire [31:0]          IOWDATA,
   output wire [31:0]			LED_DEBUG
   );   // I/O write data bus

  always @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOSEL <= 1'b0;
    else
      IOSEL <= HSEL & HREADY;
  end

  // registered address, update only if selected to reduce toggling
  always @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOADDR <= {12{1'b0}};
    else
      IOADDR <= HADDR[11:0];
  end

  // Data phase write control
  always @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOWRITE <= 1'b0;
    else
      IOWRITE <= HWRITE;
  end

  // registered hsize, update only if selected to reduce toggling
  always @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOSIZE <= {2{1'b0}};
    else
      IOSIZE <= HSIZE[1:0];
  end

  // registered HTRANS, update only if selected to reduce toggling
  always @(posedge HCLK or negedge HRESETn)
  begin
    if (~HRESETn)
      IOTRANS <= 1'b0;
    else
      IOTRANS <= HTRANS[1];
  end

  assign IOWDATA   = HWDATA;
  assign HREADYOUT = 1'b1;
  assign HRESP     = 1'b0;

  //reg read_enable;
  assign read_enable = HSEL & (~HWRITE);
  assign write_enable = HSEL &(HWRITE)&HREADY;
  assign  write_enable04 = write_enable & (HADDR[11:2] == 10'h001);
  assign  write_enable08 = write_enable & (HADDR[11:2] == 10'h002);
  assign  write_enable0C = write_enable & (HADDR[11:2] == 10'h003);
  assign  write_enable10 = write_enable & (HADDR[11:2] == 10'h004);
  assign  write_enable14 = write_enable & (HADDR[11:2] == 10'h005);
  reg [31:0] led_light;
  reg [31:0] TO_BE_USED_REG;
  always @(posedge HCLK or negedge HRESETn) 
  if (~HRESETn)
    led_light <= 32'b0;
  else if (write_enable04)
    led_light <= HWDATA;
  else
    led_light<=led_light;
    
  always @(posedge HCLK or negedge HRESETn) 
  if (~HRESETn)
    TO_BE_USED_REG <= 32'b0;
  else if (write_enable08)
    TO_BE_USED_REG <= HWDATA;
  else
    TO_BE_USED_REG<=TO_BE_USED_REG;
    
      
  reg [31:0]HRDATA_reg;
  always @(posedge HCLK or negedge HRESETn) 
  if (~HRESETn)
  	HRDATA_reg<=1'b0;
  else if(read_enable)
  	case(HADDR[11:2])
      10'h001:HRDATA_reg<=led_light;
      10'h002:HRDATA_reg<=TO_BE_USED_REG;
      default:HRDATA_reg<=32'b0;
   	endcase
  else
  	HRDATA_reg<=HRDATA_reg;
   assign HRDATA[31:0] = HRDATA_reg;
   //assign HRDATA[31:0] = (read_enable) ? led_light : 32'b0;
   assign LED_DEBUG[31:0] = led_light;
endmodule