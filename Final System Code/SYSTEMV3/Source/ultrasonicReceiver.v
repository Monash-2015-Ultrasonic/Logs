//=================================================
// ULTRASONIC RECEIVER MODULE
//=================================================
module ultrasonicReceiver # (
	parameter sampler_BITS = 8, 
	parameter subtractor_OFFSET = 12'h7FF,
	parameter FIR_BANK = 3'b000)(
	// Essential signals:
	input 							SYS_CLK,
	input 							RST, RSTbar,
	
	input 							ADC_MISO,
	output  							ADC_MOSI,
	output  							ADC_CSbar,
	output 							ADC_SCK,
	
	input								TIMER_RST,
	input 							ABS_PEAK_FLAG,

	input								NIOS_FIFO_RST,
	input 							NIOS_TIMER_RST,
	input 							NIOS_ADC_ON,
	input								SUBTRACTOR_ON,
	input								NIOS_FIFO_ADC_DATA_VALID,
	input 	[15:0]				NIOS_FIFO_ADC_DATA,
	input		[23:0]				NIOS_THRESHOLD,
	
	input 							NIOS_RD_PEAK,
	output 							NIOS_PEAK_FOUND,
	output 	[109:0]			 	NIOS_YN1, NIOS_YN2, NIOS_YN3,
	output 	[13:0]				NIOS_TIME,
	
	// Debug signals:
	output 							FIFO_ADC_EMPTY,
	output 							FIFO_ADC_FULL,
	output	[15:0]				FIFO_ADC_OUTPUT,
	output	[12:0]				FIR_INPUT
);





//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// TIMER Module:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	wire [13:0] TIMER;
	COUNTER	COUNTER_instant (
		.clock 		( SYS_CLK														),
		.aclr 		( RST | NIOS_TIMER_RST | NIOS_FIFO_RST	| TIMER_RST	), 
		.cnt_en 		( FIFO_ADC_WR													),
		.q 			( TIMER )
	);




//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// ADC Module:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// Command sent to ADC:
	wire	[15:0]	ADC_CMD = {4'b0001, 1'b1, 2'b0, 2'b00, 7'b1000000}; 
	
	// Auto-sample at 68.359375 (10bits) / 273.4375 (8bits) kHz:
	localparam sampler_topbit = sampler_BITS - 1;
	reg [sampler_topbit:0] clk_sample;
	always @(posedge SYS_CLK)
		clk_sample <= ~RST & NIOS_ADC_ON ? clk_sample + 1 : 0;
				
	wire ADC_EN = ~clk_sample[sampler_topbit] & NIOS_ADC_ON & ~RST;
	
	wire 		[15:0] 	ADC_DATA;
	wire					ADC_FIN;	
	// ADC SPI Master Module:
	SPI_MASTER_ADC #(.outBits (16)) ADC_instant(
		.SYS_CLK 	( SYS_CLK							),
		.ENA 			( ADC_EN 							),  	
		.DATA_MOSI 	( ADC_CMD 							),		// Command written to ADC
		.MISO 		( ADC_MISO 							),		// MISO  = SDO 		= 3
		.MOSI 		( ADC_MOSI							),		// MOSI  = SDI 		= 4
		.SCK 			( ADC_SCK							),		// SCK   = SCLK 		= 5
		.CSbar 		( ADC_CSbar 						),		// CSbar = CSbar 	   = 6
		.FIN 			( ADC_FIN 							),		
		.DATA_MISO 	( ADC_DATA 							)		// Sample from ADC
	);	

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// ADC FIFO: 16-bits width, 16-words depth
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	// Edge Detector for WR sinal to FIFO:
	reg FIFO_ADC_WR, FIFO_ADC_WR_PREV;
	wire FIFO_ADC_WR_SIGNAL;
		assign FIFO_ADC_WR_SIGNAL = (ADC_FIN & NIOS_ADC_ON) | (NIOS_FIFO_ADC_DATA_VALID & ~NIOS_ADC_ON);
	always @(posedge SYS_CLK) begin
		FIFO_ADC_WR_PREV 	<= FIFO_ADC_WR_SIGNAL;
		FIFO_ADC_WR 		<= ~FIFO_ADC_WR_PREV & FIFO_ADC_WR_SIGNAL & ~RST;
	end
	
	wire [12:0] SUB_OUTPUT_ADC;	
	assign SUB_OUTPUT_ADC = ADC_DATA[11:0] - subtractor_OFFSET;
	
	wire [12:0] SUB_OUTPUT_NIOS;	
	assign SUB_OUTPUT_NIOS = NIOS_FIFO_ADC_DATA[11:0] - subtractor_OFFSET;

	// MUX between taking data from NIOS or ADC:
	reg	[15:0] FIFO_ADC_DATA;
	always @(posedge SYS_CLK) begin
		if (RST) begin
			FIFO_ADC_DATA <= 16'b0;
		end
		else begin
			case (NIOS_ADC_ON) 
			1'b1: begin														// Take data from ADC Module
				if (ADC_DATA[15:12] == 4'b0)
					FIFO_ADC_DATA <= SUBTRACTOR_ON ? SUB_OUTPUT_ADC : ADC_DATA;
			end
			1'b0: begin														// Take data from NIOS
				FIFO_ADC_DATA <= SUBTRACTOR_ON ? SUB_OUTPUT_NIOS : NIOS_FIFO_ADC_DATA;
			end
			endcase
		end
	end
	
	// Altera IP FIFO Module:
	FIFO_ADC	FIFO_ADC_instant (
		.clock 	( SYS_CLK 								),
		.sclr 	( RST | NIOS_FIFO_RST 				),				// Synchronous Clear
`ifdef VERIFY_FIFO_ADC_MANUAL
		.rdreq 	( MANUAL_RD								),
`else
		.rdreq 	( FIFO_ADC_RD							),				
`endif
		.wrreq 	( FIFO_ADC_WR							),				// Write when a sample is ready
		.data 	( FIFO_ADC_DATA						),				
		.empty 	( FIFO_ADC_EMPTY						),
		.full 	( FIFO_ADC_FULL						),
		.q 		( FIFO_ADC_OUTPUT						)
	);	
	
	assign FIR_INPUT[12:0] = FIFO_ADC_OUTPUT[12:0];




	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// FIR FILTER: Matched Filter - 65 Taps
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
`ifdef VERIFY_FIR_OUTPUT
	always @(posedge SYS_CLK) begin
		FIR_OUTPUT <= FIR_OUTPUT_VALID ? FIR_OUTPUT_RAW : FIR_OUTPUT;
	end
`endif

	localparam FIRtaps = 7'd65;
	
	// Read ADC FIFO when data is available to pass to FIR Filter:
	wire FIFO_ADC_RD;
		assign FIFO_ADC_RD = ~FIFO_ADC_EMPTY & ~RST ;
	
	wire [29:0] FIR_OUTPUT_RAW;
	wire FIR_OUTPUT_VALID;
	FIR FIR_instant(
		.clk					( SYS_CLK					),		//		clk.clk
		.reset_n				( RSTbar						),		//		rst.reset_n
		
		.ast_sink_data		( {FIR_BANK, FIR_INPUT}	),		//		avalon_streaming_sink.data
		.ast_sink_valid	( FIFO_ADC_RD				),		//		.valid
		.ast_sink_error	( 2'b00						),		//		.error
		
		.ast_source_data	( FIR_OUTPUT_RAW			),		//		avalon_streaming_source.data
		.ast_source_valid	( FIR_OUTPUT_VALID		),		//		.valid
		.ast_source_error	( )  									//		.error
	);
	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// FIR FIFO: 30-bits width, 16-words depth
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	wire FIFO_FIR_EMPTY, FIFO_FIR_FULL;
	wire [29:0] FIFO_FIR_OUTPUT;
	FIFO_FIR	FIFO_FIR_instant (
		.clock 	( SYS_CLK 								),
		.sclr 	( RST | NIOS_FIFO_RST				),
		.rdreq 	( FIFO_RD_DETECTION			 		),			
		.wrreq 	( FIR_OUTPUT_VALID 					),
		.data 	( FIR_OUTPUT_RAW						),
		.empty 	( FIFO_FIR_EMPTY 						),
		.full 	( FIFO_FIR_FULL 						),
		.q 		( FIFO_FIR_OUTPUT 					)
	);




//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// SUM FIR INPUT SQUARED: 
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	wire [25:0] FIR_INPUT_SQ;
	MULT	MULT_Xsq_instant (
		.dataa 		( FIR_INPUT  						),
		.result 		( FIR_INPUT_SQ						)
	);	
	
	wire [25:0] sumXsq_RAW;
	ADDSUBWIDE	ADDSUBWIDE_sumXsqRAW_instant (
		.add_sub 	( 1'b1 								),
		.dataa 		( FIR_INPUT_SQ 					),
		.datab 		( sumXsq 							),
		.result 		( sumXsq_RAW 						)
	);
	
	
	

	wire [12:0] FIR_TAP_POP;
	SHIFTREGRAM	SHIFTREGRAM_instant (
		.clken 		( FIFO_ADC_RD 						),
		.clock 		( SYS_CLK 							),
		.shiftin 	( FIR_INPUT 						),
		.shiftout 	( FIR_TAP_POP 						),
		.taps 		( )
	);
	
	wire [25:0] FIR_TAP_POPsq;
	MULT	MULT_XprevSq_instant (
		.dataa 		( FIR_TAP_POP  					),
		.result 		( FIR_TAP_POPsq 					)
	);
	
	
	

	wire [25:0] sumXsq_RESULT;
	ADDSUBWIDE	ADDSUBWIDE_sumXsq_instant (
		.add_sub 	( 1'b0 								),
		.dataa 		( sumXsq_RAW 						),
		.datab 		( FIR_TAP_POPsq 					),
		.result 		( sumXsq_RESULT 					)
	);
	
	reg [25:0] sumXsq;
	always @(negedge SYS_CLK) begin
		if (RST | NIOS_FIFO_RST)
			sumXsq <= 0;
		else
			sumXsq <= FIFO_ADC_RD ? sumXsq_RESULT : sumXsq;
	end
	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// SUM X SQUARED FIFO: 26-bits width, 16-words depth
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	wire [25:0] FIFO_sumXsq_OUTPUT;

	wire FIFO_sumXsq_EMPTY, FIFO_sumXsq_FULL;
	FIFO_SUM_IN_SQUARED	FIFO_sumXsq_instant (
		.clock 			( SYS_CLK 						),
		.sclr 			( RST | NIOS_FIFO_RST 		),
		.rdreq 			( FIFO_RD_DETECTION			),
		.wrreq 			( FIFO_ADC_RD					),
		.data 			( sumXsq				 			),
		.empty 			( FIFO_sumXsq_EMPTY 			),
		.full 			( FIFO_sumXsq_FULL 			),
		.q 				( FIFO_sumXsq_OUTPUT 		)
	);	
	
	


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// DETECTION Module
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	wire FIFO_RD_DETECTION;
		assign FIFO_RD_DETECTION = ~FIFO_FIR_EMPTY & ~FIFO_sumXsq_EMPTY;
	
	wire [59:0] Yn_NUM;
	wire [49:0]	Yn_DEN;
	wire DETECTION;
	DETECTOR DETECTOR_instant (	
		.SYS_CLK				( SYS_CLK					),
		.RST					( RST | NIOS_FIFO_RST	),
		.TIME					( TIMER						),

		.THRESHOLD			( NIOS_THRESHOLD			),
	
		.Y						( FIFO_FIR_OUTPUT			),
		.sumXsq				( FIFO_sumXsq_OUTPUT		),

		.Yn_NUM				( Yn_NUM						),
		.Yn_DEN				( Yn_DEN						),
		.DETECTION			( DETECTION					)
	);



	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// PEAK FINDER
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	PEAKFINDER #(
		.taps(65)) 
	PEAKFINDER_instant (
		.SYS_CLK				( SYS_CLK					),
		.RST					( RST | NIOS_FIFO_RST | TIMER_RST	),
		.NIOS_ADC_ON		( NIOS_ADC_ON				),
		
		.CLK_EN				( FIFO_RD_DETECTION		),
		.DETECTION			( DETECTION					),
		
		
		.Yn_NUM				( Yn_NUM						),
		.Yn_DEN				( Yn_DEN						),
		
		.TIMER				( TIMER						),
		.ABS_PEAK_FLAG 	( ABS_PEAK_FLAG			),
	
		.NIOS_RD_PEAK		( NIOS_RD_PEAK				),
	
		.VALID_PEAK_FOUND 				( NIOS_PEAK_FOUND		),
		.FIFO_DETECTION_YN1_OUTPUT 	( NIOS_YN1				), 
		.FIFO_DETECTION_YN2_OUTPUT 	( NIOS_YN2				), 
		.FIFO_DETECTION_YN3_OUTPUT 	( NIOS_YN3				),
		.FIFO_DETECTION_TIME_OUTPUT 	( NIOS_TIME				)
	);

endmodule
//=================================================
// END ULTRASONIC RECEIVER MODULE
//=================================================
