`define FULL_SCALE

//=================================================
// TOPLEVEL MODULE
//=================================================
module main(
	input 				iCLK_50,
	
	input		[17:0]	iSW,
	input 	[3:0]		iKEY,
	
	output	[17:0]	oLEDR,
	output	[8:0]		oLEDG,
	
	output	[6:0]		oHEX0_D, oHEX1_D, oHEX2_D, oHEX3_D, oHEX4_D, oHEX5_D, oHEX6_D, oHEX7_D,
	
	inout		[31:0]	GPIO_0, GPIO_1,
	
	output				oLCD_ON,					//	LCD Power ON/OFF
	output				oLCD_BLON,				//	LCD Back Light ON/OFF
	output				oLCD_EN,					//	LCD Enable
	output				oLCD_RW,					//	LCD Read/Write Select, 0 = Write, 1 = Read
	output				oLCD_RS,					//	LCD Command/Data Select, 0 = Command, 1 = Data
	inout		[7:0]		LCD_D,					//	LCD Data bus 8 bits
	
	inout		[31:0]	SRAM_DQ,					//	SRAM Data Bus 32 Bits
	inout		[3:0]		SRAM_DPA, 				// SRAM Parity Data Bus
	output	[20:0]	oSRAM_A,					//	SRAM Address bus 21 Bits
	output				oSRAM_ADSC_N,       	//	SRAM Controller Address Status 	
	output				oSRAM_ADSP_N,        //	SRAM Processor Address Status
	output				oSRAM_ADV_N,         //	SRAM Burst Address Advance
	output	[3:0]		oSRAM_BE_N,          //	SRAM Byte Write Enable
	output				oSRAM_CE1_N,        	//	SRAM Chip Enable
	output				oSRAM_CE2,          	//	SRAM Chip Enable
	output				oSRAM_CE3_N,        	//	SRAM Chip Enable
	output				oSRAM_CLK,           //	SRAM Clock
	output				oSRAM_GW_N,        	// SRAM Global Write Enable
	output				oSRAM_OE_N,         	//	SRAM Output Enable
	output				oSRAM_WE_N         	//	SRAM Write Enable
);
	
	
	
	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// Clocks:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	// 70MHz and 41.176471MHz clock:
	wire 					CLK_FAST, CLK_SRAM, CLK_40;
	
	CLKPLL				CLKPLL_inst (
		.inclk0 			( iCLK_50 						),
		.c0 				( CLK_FAST 						),
		.c1				( CLK_SRAM						),
		.c2				( CLK_40							)
	);
		

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// SSRAM:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	assign	oSRAM_ADSP_N = 1'b1;                //	SRAM Processor Address Status
	assign	oSRAM_ADV_N = 1'b1;                 //	SRAM Burst Address Advance
	assign	oSRAM_CE2 = ~oSRAM_CE1_N;//1'b1;    //	SRAM Chip Enable
	assign	oSRAM_CE3_N = oSRAM_CE1_N;//1'b0;   //	SRAM Chip Enable
	assign	oSRAM_GW_N = 1'b1;         		   //   SRAM Global Write Enable
	wire [1:0]SRAM_DUMMY_ADDR;                   //   used to ignore the A0/A1 pin from Cypress SSRAM IP core
	assign  	oSRAM_CLK = CLK_FAST;


	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// I/O:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	// Turn on LCD:
	assign oLCD_ON = 		~RST;
	assign oLCD_BLON = 	RST;
	
	// HARD Reset:
	reg RST, RSTbar;
	always @(posedge CLK_FAST) begin
		RST 		<= ~iKEY[0];
		RSTbar 	<= iKEY[0];
	end
	
	reg ON;
	always @(posedge CLK_FAST) begin
		ON 		<= iSW[0];
	end
			
	// Impedance Matching for Enable/CSbar pin:
	assign 				GPIO_1[31:26] = 6'bzzzzzz;	

	
	// 7-Seg Displays:
	// Upper 4:
//	HEX_ENCODER hex7(CHANNEL0_OUTPUT[29:28],			oHEX7_D);
//	HEX_ENCODER hex6(CHANNEL0_OUTPUT[27:24],			oHEX6_D);
//	HEX_ENCODER hex5(CHANNEL0_OUTPUT[23:20],			oHEX5_D);
//	HEX_ENCODER hex4(CHANNEL0_OUTPUT[19:16],			oHEX4_D);
//	// Lower 4:
//	HEX_ENCODER hex3(CHANNEL0_OUTPUT[15:12],			oHEX3_D);
//	HEX_ENCODER hex2(CHANNEL0_OUTPUT[11:8],			oHEX2_D);
//	HEX_ENCODER hex1(CHANNEL0_OUTPUT[7:4],				oHEX1_D);
//	HEX_ENCODER hex0(CHANNEL0_OUTPUT[3:0],				oHEX0_D);

	HEX_ENCODER hex7(5'b11111,		oHEX7_D);
	HEX_ENCODER hex6(5'b11111,		oHEX6_D);
	HEX_ENCODER hex5(5'b11111,		oHEX5_D);
	HEX_ENCODER hex4(5'b11111,		oHEX4_D);
	HEX_ENCODER hex3(5'b11111,		oHEX3_D);
	HEX_ENCODER hex2(5'b11111,		oHEX2_D);
	HEX_ENCODER hex1(5'b11111,		oHEX1_D);
	HEX_ENCODER hex0(5'b11111,		oHEX0_D);
	
	
	
	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// NIOS II/e CPU:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// Essential SYSTEM Signals:
	wire NIOS_ADC_ON, NIOS_SUBTRACTOR_ON, NIOS_DETECTOR_ON, NIOS_FIFO_ADC_DATA_VALID, NIOS_FIFO_RST;
	wire [15:0] NIOS_FIFO_ADC_DATA;
	
	// CHANNEL0 Specific Signals:
	wire NIOS_TIMER_CH0_RST, NIOS_CHANNEL0_RD_PEAK, NIOS_CHANNEL0_PEAK_FOUND;
	wire [23:0] NIOS_CHANNEL0_THRESHOLD;
	wire [13:0] NIOS_CHANNEL0_TIME;
	wire [109:0] NIOS_CHANNEL0_YN1, NIOS_CHANNEL0_YN2, NIOS_CHANNEL0_YN3;
	
	// CHANNEL1 Specific Signals:
	wire NIOS_TIMER_CH1_RST, NIOS_CHANNEL1_RD_PEAK, NIOS_CHANNEL1_PEAK_FOUND;
	wire [23:0] NIOS_CHANNEL1_THRESHOLD;
	wire [13:0] NIOS_CHANNEL1_TIME;
	wire [109:0] NIOS_CHANNEL1_YN1, NIOS_CHANNEL1_YN2, NIOS_CHANNEL1_YN3;
	
	// CHANNEL2 Specific Signals:
	wire NIOS_TIMER_CH2_RST, NIOS_CHANNEL2_RD_PEAK, NIOS_CHANNEL2_PEAK_FOUND;
	wire [23:0] NIOS_CHANNEL2_THRESHOLD;
	wire [13:0] NIOS_CHANNEL2_TIME;
	wire [109:0] NIOS_CHANNEL2_YN1, NIOS_CHANNEL2_YN2, NIOS_CHANNEL2_YN3;
	
	// CHANNEL3 Specific Signals:
	wire NIOS_TIMER_CH3_RST, NIOS_CHANNEL3_RD_PEAK, NIOS_CHANNEL3_PEAK_FOUND;
	wire [23:0] NIOS_CHANNEL3_THRESHOLD;
	wire [13:0] NIOS_CHANNEL3_TIME;
	wire [109:0] NIOS_CHANNEL3_YN1, NIOS_CHANNEL3_YN2, NIOS_CHANNEL3_YN3;
	
	// CHANNEL4 Specific Signals:
	wire NIOS_TIMER_CH4_RST, NIOS_CHANNEL4_RD_PEAK, NIOS_CHANNEL4_PEAK_FOUND;
	wire [23:0] NIOS_CHANNEL4_THRESHOLD;
	wire [13:0] NIOS_CHANNEL4_TIME;
	wire [109:0] NIOS_CHANNEL4_YN1, NIOS_CHANNEL4_YN2, NIOS_CHANNEL4_YN3;
	
	NIOS_SYSTEMV3 NIOS_instant (
		.clk_clk									( CLK_FAST							),		//		clk.clk
		.reset_reset_n							( RSTbar								),		//		reset.reset_n
		
		.lcd_RS									( oLCD_RS							),		//		lcd.RS
		.lcd_RW									( oLCD_RW							),		//		.RW
		.lcd_data								( LCD_D								),		//		.data
		.lcd_E									( oLCD_EN							),		//		.E
		
		.tristate_bridge_ssram_bwe_n_to_the_ssram 				(oSRAM_WE_N),		// tristate_bridge_ssram.bwe_n_to_the_ssram
		.tristate_bridge_ssram_reset_n_to_the_ssram 				( ),		//                      .reset_n_to_the_ssram
		.tristate_bridge_ssram_chipenable1_n_to_the_ssram 		(oSRAM_CE1_N),		//		.chipenable1_n_to_the_ssram
		.tristate_bridge_ssram_bw_n_to_the_ssram 					(oSRAM_BE_N),		//		.bw_n_to_the_ssram
		.tristate_bridge_ssram_outputenable_n_to_the_ssram 	(oSRAM_OE_N),		//		.outputenable_n_to_the_ssram
		.tristate_bridge_ssram_adsc_n_to_the_ssram 				(oSRAM_ADSC_N),	//		.adsc_n_to_the_ssram
		.tristate_bridge_ssram_address_to_the_ssram 				({oSRAM_A[17:0],SRAM_DUMMY_ADDR}),		//                      .address_to_the_ssram
		.tristate_bridge_ssram_data_to_and_from_the_ssram 		((SRAM_DQ)),		//		.data_to_and_from_the_ssram
		
		.subtractor_on_export				( NIOS_SUBTRACTOR_ON				),		//		subtractor_on.export
		.detector_on_export					( NIOS_DETECTOR_ON				),		//		detector_on.export
		.fifo_rst_export						( NIOS_FIFO_RST					),		//		fifo_rst.export
		
		.adc_on_export							( NIOS_ADC_ON						),		//		adc_on.export
		
		.fifo_adc_data_export				( NIOS_FIFO_ADC_DATA 			),		//		fifo_adc_data.export
		.fifo_adc_data_valid_export		( NIOS_FIFO_ADC_DATA_VALID		),		//		fifo_adc_data_valid.export

		.ch0_timer_rst_export        		( NIOS_TIMER_CH0_RST				),		//		timer_ch0_rst.export
		.ch0_thresh_export          		( NIOS_CHANNEL0_THRESHOLD		),		//		ch0_thresh.export
		.ch0_rd_peak_export					( NIOS_CHANNEL0_RD_PEAK			),		//		ch0_rd_peak.export
		.ch0_peak_found_export				( NIOS_CHANNEL0_PEAK_FOUND		),		//		ch0_peak_found.export
		.ch0_time_export						( NIOS_CHANNEL0_TIME				),		//		ch0_time.export
		.ch0_yn1_u_export						( NIOS_CHANNEL0_YN1[109:96]	),		//		ch0_yn1_u.export
		.ch0_yn1_mu_export					( NIOS_CHANNEL0_YN1[95:64]		),		//		ch0_yn1_mu.export
		.ch0_yn1_ml_export					( NIOS_CHANNEL0_YN1[63:32]		),		//		ch0_yn1_ml.export
		.ch0_yn1_l_export						( NIOS_CHANNEL0_YN1[31:0]		),		//		ch0_yn1_l.export
		.ch0_yn2_u_export						( NIOS_CHANNEL0_YN2[109:96]	),		//		ch0_yn2_u.export
		.ch0_yn2_mu_export					( NIOS_CHANNEL0_YN2[95:64] 	),		//		ch0_yn2_mu.export
		.ch0_yn2_ml_export					( NIOS_CHANNEL0_YN2[63:32] 	),		//		ch0_yn2_ml.export
		.ch0_yn2_l_export						( NIOS_CHANNEL0_YN2[31:0] 		),		//		ch0_yn2_l.export
		.ch0_yn3_u_export						( NIOS_CHANNEL0_YN3[109:96]	),		//    ch0_yn3_u.export
		.ch0_yn3_mu_export					( NIOS_CHANNEL0_YN3[95:64]		),		//		ch0_yn3_mu.export
		.ch0_yn3_ml_export					( NIOS_CHANNEL0_YN3[63:32]		),		//		ch0_yn3_ml.export
`ifdef FULL_SCALE
		.ch0_yn3_l_export						( NIOS_CHANNEL0_YN3[31:0]		),		//		ch0_yn3_l.export
`else
		.ch0_yn3_l_export						( NIOS_CHANNEL0_YN3[31:0]		)
`endif
		
`ifdef FULL_SCALE
		.ch1_timer_rst_export				( NIOS_TIMER_CH1_RST				),		//		ch1_timer_rst.export
		.ch1_thresh_export					( NIOS_CHANNEL1_THRESHOLD		),		//		ch1_thresh.export
		.ch1_rd_peak_export					( NIOS_CHANNEL1_RD_PEAK			),		//		ch1_rd_peak.export
		.ch1_peak_found_export				( NIOS_CHANNEL1_PEAK_FOUND		),		//		ch1_peak_found.export
		.ch1_time_export						( NIOS_CHANNEL1_TIME				),		//		ch1_time.export
		.ch1_yn1_u_export						( NIOS_CHANNEL1_YN1[109:96]	),		//		ch1_yn1_u.export
		.ch1_yn1_mu_export					( NIOS_CHANNEL1_YN1[95:64]		),		//		ch1_yn1_mu.export
		.ch1_yn1_ml_export					( NIOS_CHANNEL1_YN1[63:32]		),		//		ch1_yn1_ml.export
		.ch1_yn1_l_export						( NIOS_CHANNEL1_YN1[31:0]		),		//		ch1_yn1_l.export
		.ch1_yn2_u_export						( NIOS_CHANNEL1_YN2[109:96]	),		//		ch1_yn2_u.export
		.ch1_yn2_mu_export					( NIOS_CHANNEL1_YN2[95:64]		),		//		ch1_yn2_mu.export
		.ch1_yn2_ml_export					( NIOS_CHANNEL1_YN2[63:32]		),		//		ch1_yn2_ml.export
		.ch1_yn2_l_export						( NIOS_CHANNEL1_YN2[31:0]		),		//		ch1_yn2_l.export
		.ch1_yn3_u_export						( NIOS_CHANNEL1_YN3[109:96]	),		//		ch1_yn3_u.export
		.ch1_yn3_mu_export					( NIOS_CHANNEL1_YN3[95:64]		),		//		ch1_yn3_mu.export
		.ch1_yn3_ml_export					( NIOS_CHANNEL1_YN3[63:32]		),		//		ch1_yn3_ml.export
		.ch1_yn3_l_export						( NIOS_CHANNEL1_YN3[31:0]		),		//		ch1_yn3_l.export
		
		.ch2_timer_rst_export				( NIOS_TIMER_CH2_RST				),		//		ch2_timer_rst.export
		.ch2_thresh_export					( NIOS_CHANNEL2_THRESHOLD		),		//		ch2_thresh.export
		.ch2_rd_peak_export					( NIOS_CHANNEL2_RD_PEAK			),		//		ch2_rd_peak.export
		.ch2_peak_found_export				( NIOS_CHANNEL2_PEAK_FOUND		),		//		ch2_peak_found.export
		.ch2_time_export						( NIOS_CHANNEL2_TIME				),		//		ch2_time.export
		.ch2_yn1_u_export						( NIOS_CHANNEL2_YN1[109:96]	),		//		ch2_yn1_u.export
		.ch2_yn1_mu_export					( NIOS_CHANNEL2_YN1[95:64]		),		//		ch2_yn1_mu.export
		.ch2_yn1_ml_export					( NIOS_CHANNEL2_YN1[63:32]		),		//		ch2_yn1_ml.export
		.ch2_yn1_l_export						( NIOS_CHANNEL2_YN1[31:0]		),		//		ch2_yn1_l.export
		.ch2_yn2_u_export						( NIOS_CHANNEL2_YN2[109:96]	),		//		ch2_yn2_u.export
		.ch2_yn2_mu_export					( NIOS_CHANNEL2_YN2[95:64]		),		//		ch2_yn2_mu.export
		.ch2_yn2_ml_export					( NIOS_CHANNEL2_YN2[63:32]		),		//		ch2_yn2_ml.export
		.ch2_yn2_l_export						( NIOS_CHANNEL2_YN2[31:0]		),		//		ch2_yn2_l.export
		.ch2_yn3_u_export						( NIOS_CHANNEL2_YN3[109:96]	),		//		ch2_yn3_u.export
		.ch2_yn3_mu_export					( NIOS_CHANNEL2_YN3[95:64]		),		//		ch2_yn3_mu.export
		.ch2_yn3_ml_export					( NIOS_CHANNEL2_YN3[63:32]		),		//		ch2_yn3_ml.export
		.ch2_yn3_l_export						( NIOS_CHANNEL2_YN3[31:0]		),		//		ch2_yn3_l.export
		
		.ch3_timer_rst_export				( NIOS_TIMER_CH3_RST				),		//		ch3_timer_rst.export
		.ch3_thresh_export					( NIOS_CHANNEL3_THRESHOLD		),		//		ch3_thresh.export
		.ch3_rd_peak_export					( NIOS_CHANNEL3_RD_PEAK			),		//		ch3_rd_peak.export
		.ch3_peak_found_export				( NIOS_CHANNEL3_PEAK_FOUND 	),		//		ch3_peak_found.export
		.ch3_time_export						( NIOS_CHANNEL3_TIME				),		//		ch3_time.export
		.ch3_yn1_u_export						( NIOS_CHANNEL3_YN1[109:96]	),		//		ch3_yn1_u.export
		.ch3_yn1_mu_export					( NIOS_CHANNEL3_YN1[95:64]		),		//		ch3_yn1_mu.export
		.ch3_yn1_ml_export					( NIOS_CHANNEL3_YN1[63:32]		),		//		ch3_yn1_ml.export
		.ch3_yn1_l_export						( NIOS_CHANNEL3_YN1[31:0]		),		//		ch3_yn1_l.export
		.ch3_yn2_u_export						( NIOS_CHANNEL3_YN2[109:96]	),		//		ch3_yn2_u.export
		.ch3_yn2_mu_export					( NIOS_CHANNEL3_YN2[95:64]		),		//		ch3_yn2_mu.export
		.ch3_yn2_ml_export					( NIOS_CHANNEL3_YN2[63:32]		),		//		ch3_yn2_ml.export
		.ch3_yn2_l_export						( NIOS_CHANNEL3_YN2[31:0]		),		//		ch3_yn2_l.export
		.ch3_yn3_u_export						( NIOS_CHANNEL3_YN3[109:96]	),		//		ch3_yn3_u.export
		.ch3_yn3_mu_export					( NIOS_CHANNEL3_YN3[95:64]		),		//		ch3_yn3_mu.export
		.ch3_yn3_ml_export					( NIOS_CHANNEL3_YN3[63:32]		),		//		ch3_yn3_ml.export
		.ch3_yn3_l_export						( NIOS_CHANNEL3_YN3[31:0]		),		//		ch3_yn3_l.export
		
		.ch4_timer_rst_export				( NIOS_TIMER_CH4_RST				),		//		ch4_timer_rst.export
		.ch4_thresh_export					( NIOS_CHANNEL4_THRESHOLD		),		//		ch4_thresh.export
		.ch4_rd_peak_export					( NIOS_CHANNEL4_RD_PEAK			),		//		ch4_rd_peak.export
		.ch4_peak_found_export				( NIOS_CHANNEL4_PEAK_FOUND		),		//		ch4_peak_found.export
		.ch4_time_export						( NIOS_CHANNEL4_TIME				),		//		ch4_time.export
		.ch4_yn1_u_export						( NIOS_CHANNEL4_YN1[109:96]	),		//		ch4_yn1_u.export
		.ch4_yn1_mu_export					( NIOS_CHANNEL4_YN1[95:64]		),		//		ch4_yn1_mu.export
		.ch4_yn1_ml_export					( NIOS_CHANNEL4_YN1[63:32]		),		//		ch4_yn1_ml.export
		.ch4_yn1_l_export						( NIOS_CHANNEL4_YN1[31:0]		),		//		ch4_yn1_l.export
		.ch4_yn2_u_export						( NIOS_CHANNEL4_YN2[109:96]	),		//		ch4_yn2_u.export
		.ch4_yn2_mu_export					( NIOS_CHANNEL4_YN2[95:64]		),		//		ch4_yn2_mu.export
		.ch4_yn2_ml_export					( NIOS_CHANNEL4_YN2[63:32]		),		//		ch4_yn2_ml.export
		.ch4_yn2_l_export						( NIOS_CHANNEL4_YN2[31:0]		),		//		ch4_yn2_l.export
		.ch4_yn3_u_export						( NIOS_CHANNEL4_YN3[109:96]	),		//		ch4_yn3_u.export
		.ch4_yn3_mu_export					( NIOS_CHANNEL4_YN3[95:64]		),		//		ch4_yn3_mu.export
		.ch4_yn3_ml_export					( NIOS_CHANNEL4_YN3[63:32]		),		//		ch4_yn3_ml.export
		.ch4_yn3_l_export						( NIOS_CHANNEL4_YN3[31:0]		)		//		ch4_yn3_l.export
`endif
	);
	

		
		
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// Ultrasonic Transmitter:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	wire usonicTXStart, usonicTXroundTripFlag;
	ultrasonicTransmitter usonicTX_inst(
		.SYS_CLK			( CLK_FAST					),
		.CLK_40 			( CLK_40 					),
		.RST				( RST 						), 
		.ON				( NIOS_ADC_ON & ON		),
		.burstStart		( usonicTXStart			),
		.roundTripFlag	( usonicTXroundTripFlag	),
		.pulseOutput	( GPIO_1[25:24]  			)
	);

	
	
	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// Ultrasonic Receiver CHANNEL0:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	wire [12:0]	CHANNEL0_FIR_INPUT;
	
	ultrasonicReceiver #( .sampler_BITS(8), .subtractor_OFFSET(12'h7C2), .FIR_BANK(3'b000) ) 		
	usonicRX_CH0_instant (
		// Essential Signals:
		.SYS_CLK									( CLK_FAST								), //*
		.RST										( RST										), //*
		.RSTbar									( RSTbar									), //*
		.ADC_MISO								( GPIO_0[0]								), //* // MISO = SDO 		= 3
		.ADC_MOSI								( GPIO_0[1]								),	//* // MOSI = SDI 		= 4
		.ADC_SCK									( GPIO_0[3]								), //* // SCK = SCLK 		= 5
		.ADC_CSbar								( GPIO_0[5]								), //* // CSbar = CSbar 	= 6
		
		.TIMER_RST								( usonicTXStart						), //*
		.ABS_PEAK_FLAG							( usonicTXroundTripFlag				), //*
		
		.NIOS_FIFO_RST							( NIOS_FIFO_RST						), //*
		.NIOS_ADC_ON 							( NIOS_ADC_ON							), //*
		.SUBTRACTOR_ON							( NIOS_SUBTRACTOR_ON					), //*
		
		.NIOS_FIFO_ADC_DATA_VALID 			( NIOS_FIFO_ADC_DATA_VALID			), //*
		.NIOS_FIFO_ADC_DATA					( NIOS_FIFO_ADC_DATA					), //*
		
		// CHANNEL Specific Signals:
		.NIOS_TIMER_RST						( NIOS_TIMER_CH0_RST					), //*
		.NIOS_THRESHOLD						( NIOS_CHANNEL0_THRESHOLD			), //*
		.NIOS_RD_PEAK							( NIOS_CHANNEL0_RD_PEAK				), //*
		.NIOS_PEAK_FOUND						( NIOS_CHANNEL0_PEAK_FOUND			), //* 
		.NIOS_YN1								( NIOS_CHANNEL0_YN1					), //*
		.NIOS_YN2								( NIOS_CHANNEL0_YN2					), //*
		.NIOS_YN3								( NIOS_CHANNEL0_YN3					), //*
		.NIOS_TIME								( NIOS_CHANNEL0_TIME					), //*
		
		// Debug Signals:				
		.FIR_INPUT								( CHANNEL0_FIR_INPUT					)	
	);
	
	reg CH0_DETECTION_HOLD;
	always @(posedge CLK_FAST) begin
		if (RST | ~NIOS_DETECTOR_ON)
			CH0_DETECTION_HOLD <= 0;
		else
			CH0_DETECTION_HOLD <= NIOS_CHANNEL0_PEAK_FOUND ? 1 : CH0_DETECTION_HOLD;
	end
	
	assign oLEDG[0] 		= CH0_DETECTION_HOLD;
	
	assign oLEDR[12:0] 	= CHANNEL0_FIR_INPUT;

	
`ifdef FULL_SCALE

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// Ultrasonic Receiver CHANNEL1:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ultrasonicReceiver #( .sampler_BITS(8), .subtractor_OFFSET(12'h7BD), .FIR_BANK(3'b001) ) 		
	usonicRX_CH1_instant (
		// Essential Signals:
		.SYS_CLK									( CLK_FAST								), //*
		.RST										( RST										), //*
		.RSTbar									( RSTbar									), //*
		.ADC_MISO								( GPIO_0[9]								), //* // MISO = SDO 		= 3
		.ADC_MOSI								( GPIO_0[11]							),	//* // MOSI = SDI 		= 4
		.ADC_SCK									( GPIO_0[13]							), //* // SCK = SCLK 		= 5
		.ADC_CSbar								( GPIO_0[14]							), //* // CSbar = CSbar 	= 6
		
		.TIMER_RST								( usonicTXStart						), //*
		.ABS_PEAK_FLAG							( usonicTXroundTripFlag				), //*
		
		.NIOS_FIFO_RST							( NIOS_FIFO_RST						), //*
		.NIOS_ADC_ON 							( NIOS_ADC_ON							), //*
		.SUBTRACTOR_ON							( NIOS_SUBTRACTOR_ON					), //*
		
		.NIOS_FIFO_ADC_DATA_VALID 			( NIOS_FIFO_ADC_DATA_VALID			), //*
		.NIOS_FIFO_ADC_DATA					( NIOS_FIFO_ADC_DATA					), //*
		
		// CHANNEL Specific Signals:
		.NIOS_TIMER_RST						( NIOS_TIMER_CH1_RST					), //*
		.NIOS_THRESHOLD						( NIOS_CHANNEL1_THRESHOLD			), //*
		.NIOS_RD_PEAK							( NIOS_CHANNEL1_RD_PEAK				), //*
		.NIOS_PEAK_FOUND						( NIOS_CHANNEL1_PEAK_FOUND			), //* 
		.NIOS_YN1								( NIOS_CHANNEL1_YN1					), //*
		.NIOS_YN2								( NIOS_CHANNEL1_YN2					), //*
		.NIOS_YN3								( NIOS_CHANNEL1_YN3					), //*
		.NIOS_TIME								( NIOS_CHANNEL1_TIME					), //*
		
		// Debug Signals:				
		.FIR_INPUT								( )	
	);	

	reg CH1_DETECTION_HOLD;
	always @(posedge CLK_FAST) begin
		if (RST | ~NIOS_DETECTOR_ON)
			CH1_DETECTION_HOLD <= 0;
		else
			CH1_DETECTION_HOLD <= NIOS_CHANNEL1_PEAK_FOUND ? 1 : CH1_DETECTION_HOLD;
	end
	
	assign oLEDG[1] 		= CH1_DETECTION_HOLD;


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// Ultrasonic Receiver CHANNEL2:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ultrasonicReceiver #( .sampler_BITS(8), .subtractor_OFFSET(12'h7BD), .FIR_BANK(3'b010) ) 		
	usonicRX_CH2_instant (
		// Essential Signals:
		.SYS_CLK									( CLK_FAST								), //*
		.RST										( RST										), //*
		.RSTbar									( RSTbar									), //*
		.ADC_MISO								( GPIO_0[15]							), //* // MISO = SDO 		= 3
		.ADC_MOSI								( GPIO_0[17]							),	//* // MOSI = SDI 		= 4
		.ADC_SCK									( GPIO_0[19]							), //* // SCK = SCLK 		= 5
		.ADC_CSbar								( GPIO_0[21]							), //* // CSbar = CSbar 	= 6
		
		.TIMER_RST								( usonicTXStart						), //*
		.ABS_PEAK_FLAG							( usonicTXroundTripFlag				), //*
		
		.NIOS_FIFO_RST							( NIOS_FIFO_RST						), //*
		.NIOS_ADC_ON 							( NIOS_ADC_ON							), //*
		.SUBTRACTOR_ON							( NIOS_SUBTRACTOR_ON					), //*
		
		.NIOS_FIFO_ADC_DATA_VALID 			( NIOS_FIFO_ADC_DATA_VALID			), //*
		.NIOS_FIFO_ADC_DATA					( NIOS_FIFO_ADC_DATA					), //*
		
		// CHANNEL Specific Signals:
		.NIOS_TIMER_RST						( NIOS_TIMER_CH2_RST					), //*
		.NIOS_THRESHOLD						( NIOS_CHANNEL2_THRESHOLD			), //*
		.NIOS_RD_PEAK							( NIOS_CHANNEL2_RD_PEAK				), //*
		.NIOS_PEAK_FOUND						( NIOS_CHANNEL2_PEAK_FOUND			), //* 
		.NIOS_YN1								( NIOS_CHANNEL2_YN1					), //*
		.NIOS_YN2								( NIOS_CHANNEL2_YN2					), //*
		.NIOS_YN3								( NIOS_CHANNEL2_YN3					), //*
		.NIOS_TIME								( NIOS_CHANNEL2_TIME					), //*
		
		// Debug Signals:				
		.FIR_INPUT								( )	
	);		

	reg CH2_DETECTION_HOLD;
	always @(posedge CLK_FAST) begin
		if (RST | ~NIOS_DETECTOR_ON)
			CH2_DETECTION_HOLD <= 0;
		else
			CH2_DETECTION_HOLD <= NIOS_CHANNEL2_PEAK_FOUND ? 1 : CH2_DETECTION_HOLD;
	end
	
	assign oLEDG[2] 		= CH2_DETECTION_HOLD;


	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// Ultrasonic Receiver CHANNEL3:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ultrasonicReceiver #( .sampler_BITS(8), .subtractor_OFFSET(12'h7B9), .FIR_BANK(3'b011) ) 		
	usonicRX_CH3_instant (
		// Essential Signals:
		.SYS_CLK									( CLK_FAST								), //*
		.RST										( RST										), //*
		.RSTbar									( RSTbar									), //*
		.ADC_MISO								( GPIO_0[25]							), //* // MISO = SDO 		= 3
		.ADC_MOSI								( GPIO_0[27]							),	//* // MOSI = SDI 		= 4
		.ADC_SCK									( GPIO_0[29]							), //* // SCK = SCLK 		= 5
		.ADC_CSbar								( GPIO_0[31]							), //* // CSbar = CSbar 	= 6
		
		.TIMER_RST								( usonicTXStart						), //*
		.ABS_PEAK_FLAG							( usonicTXroundTripFlag				), //*
		
		.NIOS_FIFO_RST							( NIOS_FIFO_RST						), //*
		.NIOS_ADC_ON 							( NIOS_ADC_ON							), //*
		.SUBTRACTOR_ON							( NIOS_SUBTRACTOR_ON					), //*
		
		.NIOS_FIFO_ADC_DATA_VALID 			( NIOS_FIFO_ADC_DATA_VALID			), //*
		.NIOS_FIFO_ADC_DATA					( NIOS_FIFO_ADC_DATA					), //*
		
		// CHANNEL Specific Signals:
		.NIOS_TIMER_RST						( NIOS_TIMER_CH3_RST					), //*
		.NIOS_THRESHOLD						( NIOS_CHANNEL3_THRESHOLD			), //*
		.NIOS_RD_PEAK							( NIOS_CHANNEL3_RD_PEAK				), //*
		.NIOS_PEAK_FOUND						( NIOS_CHANNEL3_PEAK_FOUND			), //* 
		.NIOS_YN1								( NIOS_CHANNEL3_YN1					), //*
		.NIOS_YN2								( NIOS_CHANNEL3_YN2					), //*
		.NIOS_YN3								( NIOS_CHANNEL3_YN3					), //*
		.NIOS_TIME								( NIOS_CHANNEL3_TIME					), //*
		
		// Debug Signals:				
		.FIR_INPUT								( )	
	);		

	reg CH3_DETECTION_HOLD;
	always @(posedge CLK_FAST) begin
		if (RST | ~NIOS_DETECTOR_ON)
			CH3_DETECTION_HOLD <= 0;
		else
			CH3_DETECTION_HOLD <= NIOS_CHANNEL3_PEAK_FOUND ? 1 : CH3_DETECTION_HOLD;
	end
	
	assign oLEDG[3] 		= CH3_DETECTION_HOLD;

	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// Ultrasonic Receiver CHANNEL4:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ultrasonicReceiver #( .sampler_BITS(8), .subtractor_OFFSET(12'h7BF), .FIR_BANK(3'b100) ) 		
	usonicRX_CH4_instant (
		// Essential Signals:
		.SYS_CLK									( CLK_FAST								), //*
		.RST										( RST										), //*
		.RSTbar									( RSTbar									), //*
		.ADC_MISO								( GPIO_0[24]							), //* // MISO = SDO 		= 3
		.ADC_MOSI								( GPIO_0[26]							),	//* // MOSI = SDI 		= 4
		.ADC_SCK									( GPIO_0[28]							), //* // SCK = SCLK 		= 5
		.ADC_CSbar								( GPIO_0[30]							), //* // CSbar = CSbar 	= 6
		
		.TIMER_RST								( usonicTXStart						), //*
		.ABS_PEAK_FLAG							( usonicTXroundTripFlag				), //*
		
		.NIOS_FIFO_RST							( NIOS_FIFO_RST						), //*
		.NIOS_ADC_ON 							( NIOS_ADC_ON							), //*
		.SUBTRACTOR_ON							( NIOS_SUBTRACTOR_ON					), //*
		
		.NIOS_FIFO_ADC_DATA_VALID 			( NIOS_FIFO_ADC_DATA_VALID			), //*
		.NIOS_FIFO_ADC_DATA					( NIOS_FIFO_ADC_DATA					), //*
		
		// CHANNEL Specific Signals:
		.NIOS_TIMER_RST						( NIOS_TIMER_CH4_RST					), //*
		.NIOS_THRESHOLD						( NIOS_CHANNEL4_THRESHOLD			), //*
		.NIOS_RD_PEAK							( NIOS_CHANNEL4_RD_PEAK				), //*
		.NIOS_PEAK_FOUND						( NIOS_CHANNEL4_PEAK_FOUND			), //* 
		.NIOS_YN1								( NIOS_CHANNEL4_YN1					), //*
		.NIOS_YN2								( NIOS_CHANNEL4_YN2					), //*
		.NIOS_YN3								( NIOS_CHANNEL4_YN3					), //*
		.NIOS_TIME								( NIOS_CHANNEL4_TIME					), //*
		
		// Debug Signals:				
		.FIR_INPUT								( )	
	);
	
	reg CH4_DETECTION_HOLD;
	always @(posedge CLK_FAST) begin
		if (RST | ~NIOS_DETECTOR_ON)
			CH4_DETECTION_HOLD <= 0;
		else
			CH4_DETECTION_HOLD <= NIOS_CHANNEL4_PEAK_FOUND ? 1 : CH4_DETECTION_HOLD;
	end
	
	assign oLEDG[4] 		= CH4_DETECTION_HOLD;
`endif
	
endmodule
//=================================================
// END TOPLEVEL MODULE
//=================================================
