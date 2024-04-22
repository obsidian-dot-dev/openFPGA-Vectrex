
//
// User core top-level
//
// Instantiated by the real top-level: apf_top
//

`default_nettype none

module core_top (

//
// physical connections
//

///////////////////////////////////////////////////
// clock inputs 74.25mhz. not phase aligned, so treat these domains as asynchronous

input   wire            clk_74a, // mainclk1
input   wire            clk_74b, // mainclk1 

///////////////////////////////////////////////////
// cartridge interface
// switches between 3.3v and 5v mechanically
// output enable for multibit translators controlled by pic32

// GBA AD[15:8]
inout   wire    [7:0]   cart_tran_bank2,
output  wire            cart_tran_bank2_dir,

// GBA AD[7:0]
inout   wire    [7:0]   cart_tran_bank3,
output  wire            cart_tran_bank3_dir,

// GBA A[23:16]
inout   wire    [7:0]   cart_tran_bank1,
output  wire            cart_tran_bank1_dir,

// GBA [7] PHI#
// GBA [6] WR#
// GBA [5] RD#
// GBA [4] CS1#/CS#
//     [3:0] unwired
inout   wire    [7:4]   cart_tran_bank0,
output  wire            cart_tran_bank0_dir,

// GBA CS2#/RES#
inout   wire            cart_tran_pin30,
output  wire            cart_tran_pin30_dir,
// when GBC cart is inserted, this signal when low or weak will pull GBC /RES low with a special circuit
// the goal is that when unconfigured, the FPGA weak pullups won't interfere.
// thus, if GBC cart is inserted, FPGA must drive this high in order to let the level translators
// and general IO drive this pin.
output  wire            cart_pin30_pwroff_reset,

// GBA IRQ/DRQ
inout   wire            cart_tran_pin31,
output  wire            cart_tran_pin31_dir,

// infrared
input   wire            port_ir_rx,
output  wire            port_ir_tx,
output  wire            port_ir_rx_disable, 

// GBA link port
inout   wire            port_tran_si,
output  wire            port_tran_si_dir,
inout   wire            port_tran_so,
output  wire            port_tran_so_dir,
inout   wire            port_tran_sck,
output  wire            port_tran_sck_dir,
inout   wire            port_tran_sd,
output  wire            port_tran_sd_dir,
 
///////////////////////////////////////////////////
// cellular psram 0 and 1, two chips (64mbit x2 dual die per chip)

output  wire    [21:16] cram0_a,
inout   wire    [15:0]  cram0_dq,
input   wire            cram0_wait,
output  wire            cram0_clk,
output  wire            cram0_adv_n,
output  wire            cram0_cre,
output  wire            cram0_ce0_n,
output  wire            cram0_ce1_n,
output  wire            cram0_oe_n,
output  wire            cram0_we_n,
output  wire            cram0_ub_n,
output  wire            cram0_lb_n,

output  wire    [21:16] cram1_a,
inout   wire    [15:0]  cram1_dq,
input   wire            cram1_wait,
output  wire            cram1_clk,
output  wire            cram1_adv_n,
output  wire            cram1_cre,
output  wire            cram1_ce0_n,
output  wire            cram1_ce1_n,
output  wire            cram1_oe_n,
output  wire            cram1_we_n,
output  wire            cram1_ub_n,
output  wire            cram1_lb_n,

///////////////////////////////////////////////////
// sdram, 512mbit 16bit

output  wire    [12:0]  dram_a,
output  wire    [1:0]   dram_ba,
inout   wire    [15:0]  dram_dq,
output  wire    [1:0]   dram_dqm,
output  wire            dram_clk,
output  wire            dram_cke,
output  wire            dram_ras_n,
output  wire            dram_cas_n,
output  wire            dram_we_n,

///////////////////////////////////////////////////
// sram, 1mbit 16bit

output  wire    [16:0]  sram_a,
inout   wire    [15:0]  sram_dq,
output  wire            sram_oe_n,
output  wire            sram_we_n,
output  wire            sram_ub_n,
output  wire            sram_lb_n,

///////////////////////////////////////////////////
// vblank driven by dock for sync in a certain mode

input   wire            vblank,

///////////////////////////////////////////////////
// i/o to 6515D breakout usb uart

output  wire            dbg_tx,
input   wire            dbg_rx,

///////////////////////////////////////////////////
// i/o pads near jtag connector user can solder to

output  wire            user1,
input   wire            user2,

///////////////////////////////////////////////////
// RFU internal i2c bus 

inout   wire            aux_sda,
output  wire            aux_scl,

///////////////////////////////////////////////////
// RFU, do not use
output  wire            vpll_feed,


//
// logical connections
//

///////////////////////////////////////////////////
// video, audio output to scaler
output  wire    [23:0]  video_rgb,
output  wire            video_rgb_clock,
output  wire            video_rgb_clock_90,
output  wire            video_de,
output  wire            video_skip,
output  wire            video_vs,
output  wire            video_hs,
    
output  wire            audio_mclk,
input   wire            audio_adc,
output  wire            audio_dac,
output  wire            audio_lrck,

///////////////////////////////////////////////////
// bridge bus connection
// synchronous to clk_74a
output  wire            bridge_endian_little,
input   wire    [31:0]  bridge_addr,
input   wire            bridge_rd,
output  reg     [31:0]  bridge_rd_data,
input   wire            bridge_wr,
input   wire    [31:0]  bridge_wr_data,

///////////////////////////////////////////////////
// controller data
// 
// key bitmap:
//   [0]    dpad_up
//   [1]    dpad_down
//   [2]    dpad_left
//   [3]    dpad_right
//   [4]    face_a
//   [5]    face_b
//   [6]    face_x
//   [7]    face_y
//   [8]    trig_l1
//   [9]    trig_r1
//   [10]   trig_l2
//   [11]   trig_r2
//   [12]   trig_l3
//   [13]   trig_r3
//   [14]   face_select
//   [15]   face_start
// joy values - unsigned
//   [ 7: 0] lstick_x
//   [15: 8] lstick_y
//   [23:16] rstick_x
//   [31:24] rstick_y
// trigger values - unsigned
//   [ 7: 0] ltrig
//   [15: 8] rtrig
//
input   wire    [31:0]  cont1_key,
input   wire    [31:0]  cont2_key,
input   wire    [31:0]  cont3_key,
input   wire    [31:0]  cont4_key,
input   wire    [31:0]  cont1_joy,
input   wire    [31:0]  cont2_joy,
input   wire    [31:0]  cont3_joy,
input   wire    [31:0]  cont4_joy,
input   wire    [15:0]  cont1_trig,
input   wire    [15:0]  cont2_trig,
input   wire    [15:0]  cont3_trig,
input   wire    [15:0]  cont4_trig
    
);

// not using the IR port, so turn off both the LED, and
// disable the receive circuit to save power
assign port_ir_tx = 0;
assign port_ir_rx_disable = 1;

// bridge endianness
assign bridge_endian_little = 0;

// cart is unused, so set all level translators accordingly
// directions are 0:IN, 1:OUT
assign cart_tran_bank3 = 8'hzz;
assign cart_tran_bank3_dir = 1'b0;
assign cart_tran_bank2 = 8'hzz;
assign cart_tran_bank2_dir = 1'b0;
assign cart_tran_bank1 = 8'hzz;
assign cart_tran_bank1_dir = 1'b0;
assign cart_tran_bank0 = 4'hf;
assign cart_tran_bank0_dir = 1'b1;
assign cart_tran_pin30 = 1'b0;      // reset or cs2, we let the hw control it by itself
assign cart_tran_pin30_dir = 1'bz;
assign cart_pin30_pwroff_reset = 1'b0;  // hardware can control this
assign cart_tran_pin31 = 1'bz;      // input
assign cart_tran_pin31_dir = 1'b0;  // input

// link port is input only
assign port_tran_so = 1'bz;
assign port_tran_so_dir = 1'b0;     // SO is output only
assign port_tran_si = 1'bz;
assign port_tran_si_dir = 1'b0;     // SI is input only
assign port_tran_sck = 1'bz;
assign port_tran_sck_dir = 1'b0;    // clock direction can change
assign port_tran_sd = 1'bz;
assign port_tran_sd_dir = 1'b0;     // SD is input and not used

// tie off the rest of the pins we are not using
assign cram0_a = 'h0;
assign cram0_dq = {16{1'bZ}};
assign cram0_clk = 0;
assign cram0_adv_n = 1;
assign cram0_cre = 0;
assign cram0_ce0_n = 1;
assign cram0_ce1_n = 1;
assign cram0_oe_n = 1;
assign cram0_we_n = 1;
assign cram0_ub_n = 1;
assign cram0_lb_n = 1;

assign cram1_a = 'h0;
assign cram1_dq = {16{1'bZ}};
assign cram1_clk = 0;
assign cram1_adv_n = 1;
assign cram1_cre = 0;
assign cram1_ce0_n = 1;
assign cram1_ce1_n = 1;
assign cram1_oe_n = 1;
assign cram1_we_n = 1;
assign cram1_ub_n = 1;
assign cram1_lb_n = 1;

//assign dram_a = 'h0;
//assign dram_ba = 'h0;
//assign dram_dq = {16{1'bZ}};
//assign dram_dqm = 'h0;
//assign dram_clk = 'h0;
//assign dram_cke = 'h0;
//assign dram_ras_n = 'h1;
//assign dram_cas_n = 'h1;
//assign dram_we_n = 'h1;

//assign sram_a = 'h0;
//assign sram_dq = {16{1'bZ}};
//assign sram_oe_n  = 1;
//assign sram_we_n  = 1;
//assign sram_ub_n  = 1;
//assign sram_lb_n  = 1;

assign dbg_tx = 1'bZ;
assign user1 = 1'bZ;
assign aux_scl = 1'bZ;
assign vpll_feed = 1'bZ;


// for bridge write data, we just broadcast it to all bus devices
// for bridge read data, we have to mux it
// add your own devices here
always @(*) begin
    casex(bridge_addr)
    default: begin
        bridge_rd_data <= 0;
    end
    32'h10xxxxxx: begin
        // example
        // bridge_rd_data <= example_device_data;
        bridge_rd_data <= 0;
    end
    32'hF8xxxxxx: begin
        bridge_rd_data <= cmd_bridge_rd_data;
    end
    endcase
end


//
// host/target command handler
//
    wire            reset_n;                // driven by host commands, can be used as core-wide reset
    wire    [31:0]  cmd_bridge_rd_data;
    
// bridge host commands
// synchronous to clk_74a
    wire            status_boot_done = pll_core_locked; 
    wire            status_setup_done = pll_core_locked; // rising edge triggers a target command
    wire            status_running = reset_n; // we are running as soon as reset_n goes high

    wire            dataslot_requestread;
    wire    [15:0]  dataslot_requestread_id;
    wire            dataslot_requestread_ack = 1;
    wire            dataslot_requestread_ok = 1;

    wire            dataslot_requestwrite;
    wire    [15:0]  dataslot_requestwrite_id;
    wire            dataslot_requestwrite_ack = 1;
    wire            dataslot_requestwrite_ok = 1;

    wire            dataslot_allcomplete;

    wire            savestate_supported;
    wire    [31:0]  savestate_addr;
    wire    [31:0]  savestate_size;
    wire    [31:0]  savestate_maxloadsize;

    wire            savestate_start;
    wire            savestate_start_ack;
    wire            savestate_start_busy;
    wire            savestate_start_ok;
    wire            savestate_start_err;

    wire            savestate_load;
    wire            savestate_load_ack;
    wire            savestate_load_busy;
    wire            savestate_load_ok;
    wire            savestate_load_err;
    
    wire            osnotify_inmenu;

// bridge target commands
// synchronous to clk_74a


// bridge data slot access

    wire    [9:0]   datatable_addr;
    wire            datatable_wren;
    wire    [31:0]  datatable_data;
    wire    [31:0]  datatable_q;

core_bridge_cmd icb (

    .clk                ( clk_74a ),
    .reset_n            ( reset_n ),

    .bridge_endian_little   ( bridge_endian_little ),
    .bridge_addr            ( bridge_addr ),
    .bridge_rd              ( bridge_rd ),
    .bridge_rd_data         ( cmd_bridge_rd_data ),
    .bridge_wr              ( bridge_wr ),
    .bridge_wr_data         ( bridge_wr_data ),
    
    .status_boot_done       ( status_boot_done ),
    .status_setup_done      ( status_setup_done ),
    .status_running         ( status_running ),

    .dataslot_requestread       ( dataslot_requestread ),
    .dataslot_requestread_id    ( dataslot_requestread_id ),
    .dataslot_requestread_ack   ( dataslot_requestread_ack ),
    .dataslot_requestread_ok    ( dataslot_requestread_ok ),

    .dataslot_requestwrite      ( dataslot_requestwrite ),
    .dataslot_requestwrite_id   ( dataslot_requestwrite_id ),
    .dataslot_requestwrite_ack  ( dataslot_requestwrite_ack ),
    .dataslot_requestwrite_ok   ( dataslot_requestwrite_ok ),

    .dataslot_allcomplete   ( dataslot_allcomplete ),

    .savestate_supported    ( savestate_supported ),
    .savestate_addr         ( savestate_addr ),
    .savestate_size         ( savestate_size ),
    .savestate_maxloadsize  ( savestate_maxloadsize ),

    .savestate_start        ( savestate_start ),
    .savestate_start_ack    ( savestate_start_ack ),
    .savestate_start_busy   ( savestate_start_busy ),
    .savestate_start_ok     ( savestate_start_ok ),
    .savestate_start_err    ( savestate_start_err ),

    .savestate_load         ( savestate_load ),
    .savestate_load_ack     ( savestate_load_ack ),
    .savestate_load_busy    ( savestate_load_busy ),
    .savestate_load_ok      ( savestate_load_ok ),
    .savestate_load_err     ( savestate_load_err ),

    .osnotify_inmenu        ( osnotify_inmenu ),
    
    .datatable_addr         ( datatable_addr ),
    .datatable_wren         ( datatable_wren ),
    .datatable_data         ( datatable_data ),
    .datatable_q            ( datatable_q ),

);



////////////////////////////////////////////////////////////////////////////////////////

wire clk_mem;
wire clk_48;
wire clk_24;
wire clk_24_90deg;

wire    pll_core_locked;
    
mf_pllbase mp1 (
    .refclk         ( clk_74a ),
    .rst            ( 0 ),
    
    .outclk_0       ( clk_48 ),
    .outclk_1       ( clk_24 ),
	 .outclk_2       ( clk_24_90deg ),    
	 .outclk_3		  ( clk_mem ), // 96MHz

    .locked         ( pll_core_locked )
);

///////////////////////////////////////////////
// Core Settings
///////////////////////////////////////////////

reg [3:0] cs_persistence = 0;
reg cs_overburn = 0;
reg cs_show_bg = 0;
reg cs_audio_lpf = 1;

always @(posedge clk_74a) begin
  if(bridge_wr) begin
    casex(bridge_addr)
      32'h80000000: cs_persistence   <= bridge_wr_data[3:0];
      32'h90000000: cs_overburn <= bridge_wr_data[0];      
	  32'hA0000000: cs_show_bg <= bridge_wr_data[0];      
      32'hB0000000: cs_audio_lpf <= bridge_wr_data[0];
    endcase
  end
end

///////////////////////////////////////////////
// Core Audio
///////////////////////////////////////////////

wire [9:0] audio;

reg signed [15:0] signed_audio;
wire signed [15:0] lpf_audio;

always @(clk_24) begin
  signed_audio   <= $signed({2'b0,audio,audio[9:6]}) - 16'sd8196;    
end

// Apply 5kHz 2nd-order butterworth low-pass filter to approximate 
// frequency response of a 3" midrange driver.  The enclosure also
// impacts the frequency response, but we're not going to go that
// far down the rabbit-hole.  
wire signed [15:0] speech_lpf;
iir_2nd_order #(
    .COEFF_WIDTH(22),
    .COEFF_SCALE(15),
    .DATA_WIDTH(16),
    .COUNT_BITS(12)
)  speech_lpf_iir (
	.clk(clk_24), // 24MHz
	.reset(~reset_n),
	.div(12'd512), // 24MHz / 512 ~= 48kHz.
	.A2(-22'sd50214),
	.A3(22'sd20403),
	.B1(22'sd739),
	.B2(22'sd1479),
	.B3(22'sd739),
  .in(signed_audio),
	.out(lpf_audio)
);

sound_i2s #(
    .CHANNEL_WIDTH(16),
    .SIGNED_INPUT (1)
) sound_i2s (
    .clk_74a(clk_74a),
    .clk_audio(clk_24),
    
    .audio_l(cs_audio_lpf ? lpf_audio : signed_audio),
    .audio_r(cs_audio_lpf ? lpf_audio : signed_audio),

    .audio_mclk(audio_mclk),
    .audio_lrck(audio_lrck),
    .audio_dac(audio_dac)
);

///////////////////////////////////////////////
// Core Video
///////////////////////////////////////////////

assign video_rgb_clock = clk_24;
assign video_rgb_clock_90 = clk_24_90deg;

wire hblank_core, vblank_core;
wire hblank_s, vblank_s;

wire [7:0] r,g,b;

reg video_de_reg;
reg [23:0] video_rgb_reg;
reg video_skip_reg;

assign video_de = video_de_reg;
assign video_hs = video_hs_reg;
assign video_vs = video_vs_reg;
assign video_rgb = video_rgb_reg;
assign video_skip = video_skip_reg;

reg video_vs_reg;
reg video_hs_reg;
reg hs_prev;
reg vs_prev;
reg de_prev;

always @(posedge clk_24) begin
  
  video_de_reg <= 0;
  video_rgb_reg <= 24'h0;

  if (~(vblank_core || hblank_core)) begin
    video_de_reg <= 1;
	
    video_rgb_reg[23:16] <= new_r;
    video_rgb_reg[15:8]  <= new_g;
    video_rgb_reg[7:0]   <= new_b;
  end

  video_hs_reg <= ~hs_prev && hblank_core;
  video_vs_reg <= ~vs_prev && vblank_core;
  hs_prev <= hblank_core;
  vs_prev <= vblank_core;

end

wire fg = |{r,g,b};
wire bg = |{bg_r,bg_g,bg_b};

//
// if fg is non zero, then the beam is at this pixel
//    make the color either:
//       -- the background color (no alpha) if pixel is dark
//       -- the background color tinted towards white if the beam is bright
// if fg is zero, we use the background after an alpha * black has been applied

wire [7:0] new_r = fg  ? bbrw : bga_r;
wire [7:0] new_g = fg  ? bbgw : bga_g;
wire [7:0] new_b = fg  ? bbbw : bga_b;

wire [7:0] bbrw = blend_r_w; // : blend_r;
wire [7:0] bbgw = blend_g_w; // : blend_g;
wire [7:0] bbbw = blend_b_w; //  : blend_b;

// tint it towards white when it is brighter, otherwise use the background
// color (no alpha)
// r + (255-r)*tint
// to simplify we want tint ~ 3/4 =  ( 1/4 + 1/2 )
wire [7:0] blend_r_w = r > 108 ? (blend_r + ((8'd255-blend_r)>>1) + ((8'd255-blend_r)>>2) ) : blend_r;
wire [7:0] blend_g_w = r > 108 ? (blend_g + ((8'd255-blend_g)>>1) + ((8'd255-blend_g)>>2) ) : blend_g;
wire [7:0] blend_b_w = r > 108 ? (blend_b + ((8'd255-blend_b)>>1) + ((8'd255-blend_b)>>2) ) : blend_b;


wire [7:0] blend_r = bg ? { bg_r << 2 | bg_r[0] , bg_r << 2 | bg_r[0]} : r;
wire [7:0] blend_g = bg ? { bg_g << 2 | bg_g[0] , bg_g << 2 | bg_g[0]} : g;
wire [7:0] blend_b = bg ? { bg_b << 2 | bg_b[0] , bg_b << 2 | bg_b[0]} : b;


///////////////////////////////////////////////
// Core Instance
///////////////////////////////////////////////

wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;

reg ioctl_download;
always @(posedge clk_74a) begin
	if (dataslot_requestwrite) ioctl_download <= 1;
	else if (dataslot_allcomplete) ioctl_download <= 0;
end

data_loader #(
    .WRITE_MEM_CLOCK_DELAY(4),
	 .ADDRESS_MASK_UPPER_4(0)
) rom_loader (
    .clk_74a(clk_74a),
    .clk_memory(clk_24),

    .bridge_wr(bridge_wr),
    .bridge_endian_little(bridge_endian_little),
    .bridge_addr(bridge_addr),
    .bridge_wr_data(bridge_wr_data),

    .write_en(ioctl_wr),
    .write_addr(ioctl_addr),
    .write_data(ioctl_dout)
);

wire [31:0] cont1_key_s;
wire [31:0] cont2_key_s;
wire [31:0] cont1_joy_s;
wire [31:0] cont2_joy_s;

synch_2 #(
  .WIDTH(32)
) cont1_s (
  cont1_key,
  cont1_key_s,
  clk_24
);

synch_2 #(
  .WIDTH(32)
) cont2_s (
  cont2_key,
  cont2_key_s,
  clk_24
);

synch_2 #(
  .WIDTH(32)
) cont1j_s (
  cont1_joy,
  cont1_joy_s,
  clk_24
);

synch_2 #(
  .WIDTH(32)
) cont2j_s (
  cont2_joy,
  cont2_joy_s,
  clk_24
);

wire frame_line;
wire [9:0] width;
wire [9:0] height;
wire [9:0] hcnt;
wire [9:0] vcnt;

assign width = 10'd540;
assign height = 10'd720;

// Support analog joysticks in dock.
reg [7:0] m_joy1_px;
reg [7:0] m_joy1_py;
reg [7:0] m_joy2_px;
reg [7:0] m_joy2_py;

always @(posedge clk_24) begin	
	m_joy1_px <= (cont1_joy_s[7:0] + 8'b10000000);
	m_joy1_py <= (cont1_joy_s[15:8] + 8'b10000000) ^ 8'b11111111;
	
	m_joy2_px <= (cont2_joy_s[7:0] + 8'b10000000);
	m_joy2_py <= (cont2_joy_s[15:8] + 8'b10000000) ^ 8'b11111111;
end

wire m_joy1_a;
wire m_joy1_b; 
wire m_joy1_x;
wire m_joy1_y;
wire [7:0] m_joy1_potx;
wire [7:0] m_joy1_poty;

assign m_joy1_a = cont1_key_s[4];
assign m_joy1_b = cont1_key_s[5];
assign m_joy1_x = cont1_key_s[6];
assign m_joy1_y = cont1_key_s[7];

// Joystick has analog x/y axis if at least one axis has a non-zero value
wire m_joy1_has_analog = (cont1_joy_s[15:0] != 0);

assign m_joy1_potx = (m_joy1_has_analog) ? ((cont1_key_s[3:2] != 0) ? {cont1_key_s[2], {7{cont1_key_s[3]}}} : m_joy1_px) : {cont1_key_s[2], {7{cont1_key_s[3]}}};
assign m_joy1_poty = (m_joy1_has_analog) ? ((cont1_key_s[1:0] != 0) ? {cont1_key_s[1], {7{cont1_key_s[0]}}} : m_joy1_py) : {cont1_key_s[1], {7{cont1_key_s[0]}}};

wire m_joy2_a;
wire m_joy2_b; 
wire m_joy2_x;
wire m_joy2_y;
wire [7:0] m_joy2_potx;
wire [7:0] m_joy2_poty;

assign m_joy2_a = cont2_key_s[4];
assign m_joy2_b = cont2_key_s[5];
assign m_joy2_x = cont2_key_s[6];
assign m_joy2_y = cont2_key_s[7];

wire m_joy2_has_analog = (cont2_joy_s[15:0] != 0);

assign m_joy2_potx = (m_joy2_has_analog) ? ((cont2_key_s[3:2] != 0) ? {cont2_key_s[2], {7{cont2_key_s[3]}}} : m_joy2_px) : {cont2_key_s[2], {7{cont2_key_s[3]}}};
assign m_joy2_poty = (m_joy2_has_analog) ? ((cont2_key_s[1:0] != 0) ? {cont2_key_s[1], {7{cont2_key_s[0]}}} : m_joy2_py) : {cont2_key_s[1], {7{cont2_key_s[0]}}};


vectrex vectrex_dut (
	.clock(clk_24), 	
	.reset(~reset_n), 
	.cpu(0), // 0 --> Use "cpu09", 1 --> use "mc6809is" sync/cycle-accurate, but sound is terrible.
	
	.bios_data(ioctl_dout),
	.bios_addr(ioctl_addr[12:0]),
	.bios_wr(ioctl_wr && (ioctl_addr[24] == 1'b0) && (ioctl_addr[16] == 1'b1)), // BIOS loaded from address 0x10000

	.cart_data(ioctl_dout), 		
	.cart_addr(ioctl_addr[14:0]),	
	.cart_mask(15'h7FFF),
	.cart_wr(ioctl_wr && (ioctl_addr[24] == 1'b0) && (ioctl_addr[16] == 1'b0)), // CART loaded from address 0

	.video_r(r), 
	.video_g(g), 
	.video_b(b), 

	.frame_line(frame_line),   
	.pers({cs_persistence, 1'b0}),
	.color(0),        				
	.overburn(cs_overburn),     	

	.v_orient(0),		
	.v_width(width),   
	.v_height(height),  

	.video_hblank(hblank_core), 
	.video_vblank(vblank_core), 
	.video_hcnt(hcnt),
	.video_vcnt(vcnt),

	.speech_mode(0),  	
	.audio_out(audio),   

	.up_1(m_joy1_x), 
	.dn_1(m_joy1_b), 
	.lf_1(m_joy1_y), 
	.rt_1(m_joy1_a), 
	.pot_x_1(m_joy1_potx), 
	.pot_y_1(m_joy1_poty), 

	.up_2(m_joy2_x), 
	.dn_2(m_joy2_b), 
	.lf_2(m_joy2_y), 
	.rt_2(m_joy2_a), 
	.pot_x_2(m_joy2_potx),
	.pot_y_2(m_joy2_poty),
	
   .sram_a(sram_a),
   .sram_dq(sram_dq),
   .sram_oe_n(sram_oe_n),
   .sram_we_n(sram_we_n),
   .sram_ub_n(sram_ub_n),
	.sram_lb_n(sram_lb_n)
);


//////////////////////////////////////////////////////////////
//
//
// Load 16bit color data from the ioctl as a file load
//
// the format is RBGA with each channel taking 4 bits
//

reg        dl_wr;					// "write", "data', and "address" registers for image download
reg [15:0] dl_data;
reg [23:0] dl_addr;

wire [19:0] wm = 539*720;		// Pixel count constant, used in address indexing below.

always @(posedge clk_24) begin
	reg [7:0] ioctl_dout_r;		// Local copy of the data byte read from ioctl.
	reg [19:0] y;					// pixel Y address
	reg [9:0]  x;					// Pixel X Address
	reg [9:0] vcnt;				// vcnt == remaining pixels to count this row
	
	dl_wr <= 0;						// "Download Write" signal is 0 unless activated by the block below.
	
	// Trigger a load if ioctl_wr is high, and ioctl_addr corresponds to the address of the overlay
	// data.
	
	// This block copies data *columnwise*, starting at the bottom left.
	// Columns are copied bottom-to-top, left-to-right
	// Pixels are read into a single 16-bit word, that is then written to SDRAM.
	if(ioctl_wr && (ioctl_addr[24] == 1)) begin								// !! ONLY SEND DATA TO SDRAM WHEN IOCTL_WR HIGH !!
		img_used <= 1;									// Set register indicating that we're using the background
		dl_wr <= 1;										// Set write flag
		dl_addr <= {1'b0, ioctl_addr[23:1]};	// Set base DL address to word address of pixel
		
		if(~ioctl_addr[0]) begin					// Phase 1 -- low byte of 16-bit word
			ioctl_dout_r <= ioctl_dout;			// Copy high data byte into temporary register
			if(!dl_addr) begin							// --- first write in the frame...
				vcnt <= width - 1'd1;					// set vcnt = image width
				x <= 0;										// set x working reg to 0
				y <= wm - height;							// set y working register to "total pixels - height"
				dl_addr <= wm + 24'h100000;			// Set base DL addr to 100000 (leading 1 indicates loading's started?)
			end
			else begin										// --- all other writes in the frame
				y <= y - height;							// Decrease the vertical address by "height" pixels.
				dl_addr <= y + x + 24'h100000;		// Set address to x + y + base address.  
				vcnt <= vcnt - 1'd1;						// Decrement row count by 1
				if(!vcnt) begin								// At the end of the row...
					vcnt <= width - 1'd1;					// reset the row count back to width -1
					x <= x + 1'd1;								// Increment the *column*
					y <= wm - height;							// set y back to "total pixels - height"
					dl_addr <= wm + x + 24'h100001;		// Set address to "total number of pixels" + x + 1
				end
			end
		end
		else begin											// Phase 2 -- high byte of 16-bit word
			dl_data <= {ioctl_dout, ioctl_dout_r};	// set 16-bit dl_data to be written using current byte + cached previous byte.
		end
	end
end

reg  img_used = 0;
wire img_download = ioctl_download && (ioctl_addr[24] == 1'b1);
wire [31:0] sd_data;		// 32-bit data word containing data *read out* of SDRAM.

// If image is being downloaded, SDRAM address is the *download* address, otherwise it's the *read* address of the image.
wire [24:0] sdram_addr = (img_download) ? dl_addr : {1'b0, pic_addr2[19:0]};  

sdram sdram (
	.SDRAM_DQ(dram_dq),    		// 16 bit bidirectional data bus
	.SDRAM_A(dram_a),     		// 13 bit multiplexed address bus
	.SDRAM_DQML(dram_dqm[0]),  		// two byte masks
	.SDRAM_DQMH(dram_dqm[1]),  		// two byte masks
	
	.SDRAM_BA(dram_ba),    		// two banks
	.SDRAM_nWE(dram_we_n),   	// write enable
	.SDRAM_nRAS(dram_ras_n),  	// row address select
	.SDRAM_nCAS(dram_cas_n),  	// columns address select
	.SDRAM_CKE(dram_cke),   	// clock enable
	.SDRAM_CLK(dram_clk),   	// clock for chip

	.clk(clk_mem),
	.init(~pll_core_locked),
	
	.ch1_addr({sdram_addr[19:1],sdram_addr[20],sdram_addr[0]}),
	.ch1_dout(sd_data),
	.ch1_din(dl_data),
	.ch1_req(img_download ? dl_wr : pic_req),
	.ch1_rnw(~img_download),
);

//
// Alpha Blend is a table lookup to mix the color with black
//
// we can't hardcode it, because when the light comes through
// the overlay we need the original color
//
wire [7:0] bga_r,bga_g,bga_b;
alphablend alphablend(
	.clk(clk_48),
	.bg_a(bg_a),
	.bg_r(bg_r),
	.bg_g(bg_g),
	.bg_b(bg_b),
	.bga_r(bga_r),
	.bga_g(bga_g),
	.bga_b(bga_b)
);

wire[23:0] pic_addr2 = {pic_addr[24:2],1'b0};	// 32-bit address for data read from SDRAM

reg [15:0] pic_data[2];	// 2x16-bit data-words for pixel reads from SDRAM. (SDRAM reads are 32-bit)
reg        pic_req;		// Bit that determines whether or not we want a fresh pixel
reg [24:1] pic_addr;		// Address of the pixel.
reg  [3:0] bg_r,bg_g,bg_b,bg_a;	// 4-bit BG pixels...

// pixel clock set to 1/2 of clk_48... synchronized to that clock.
reg ce_pix;
always @(posedge clk_48) ce_pix <= !ce_pix;

// Copy background pixels and alpha-blend with active pixels...

always @(posedge clk_48) begin	// At 48MHz (2x system freq)
	reg old_vs;				// Previous vsync
	reg [1:0] cnt;			// 2-bit counter
	
	pic_req <= 0;								// Deassert pixel request by default.

	if(~img_download && img_used) begin	// If we're using the bg and download is complete...
		if(ce_pix) begin						// Pixel enable is high
			
			cnt <= cnt >> 1;					// Shift counter down by 1 "Decrement" counter
			if(cnt[0]) {pic_data[1],pic_data[0]} <= sd_data;	// if count[0] is set, load pic_data from sd_data....
			
			old_vs <= vblank_core;													// stash vsync
			if(~(hblank_core|vblank_core)) begin							// If in the active frame...
				if (cs_show_bg) begin
					{bg_a,bg_b,bg_g,bg_r} <= pic_data[~pic_addr[1]];		// Load the background pixels from the pic_data registers
				end
				else begin
					{bg_a,bg_b,bg_g,bg_r} <= 0;								// Disable output of background pixels if overlay disabled (but refresh sdram)
				end
				
				pic_addr <= pic_addr + 2'd1;									// Increment the read address
				if(pic_addr[1]) begin											// If lower bit of address is set...
					pic_req <= 1;														// Assert the pixel request signal
					cnt <= 2;															// Reset the counter to 2x
				end
			end
	
			if(old_vs & ~vblank_core) begin	// If there's a *fresh* vsync
				pic_addr <= 4;						// Reset read address- account for delay in reading.
				pic_req <= 1;						// Set pixel request
				cnt <= 2;							// reset counter.
			end
		end
	end
	else begin
		{bg_a,bg_b,bg_g,bg_r} <= 0;		// Not using background / background not loaded?  Set to 0.
	end
end

endmodule


