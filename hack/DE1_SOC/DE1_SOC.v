
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE1_SOC(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		     [7:0]		VGA_B,
	output		          		VGA_BLANK_N,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire sys_clk; 
pll pll_inst(
    .refclk(CLOCK_50),
    .rst(!KEY[0]), 
    .outclk_0(VGA_CLK), // 25 MHz
    .outclk_1(sys_clk) // 100 MHz
);

//=======================================================
//  Structural coding
//=======================================================

// If it is not required to encode sync
// information onto the ADV7123, the SYNC input should be tied
// to logic low. datasheet p.18
assign VGA_SYNC_N = 1'b0;

vga_controller vga_ins(
    .reset(!KEY[0]),
    .sys_clk(sys_clk),
    .vga_clk(VGA_CLK),
    .blank_n(VGA_BLANK_N),
    .HS(VGA_HS),
    .VS(VGA_VS),
    .red(VGA_R),
    .green(VGA_G),
    .blue(VGA_B)
);

endmodule