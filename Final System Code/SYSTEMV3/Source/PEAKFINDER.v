//=================================================
// PEAK FINDER MODULE
//=================================================
// Returns true detection @ absolute peak, instead of at threshold
// Results are stored in FIFO buffers
module PEAKFINDER # (
	parameter taps = 7'd65)(
	input 					SYS_CLK,
	input 					RST,
	input						NIOS_ADC_ON,
	
	input 					CLK_EN,
	input 					DETECTION,

	input [59:0] 			Yn_NUM,
	input [49:0]			Yn_DEN,
	
	input [13:0]			TIMER,
	input 					ABS_PEAK_FLAG,
		
	input 					NIOS_RD_PEAK,
	
	output 					VALID_PEAK_FOUND,
	output [109:0]			FIFO_DETECTION_YN1_OUTPUT, FIFO_DETECTION_YN2_OUTPUT, FIFO_DETECTION_YN3_OUTPUT,
	output [13:0]			FIFO_DETECTION_TIME_OUTPUT
);


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// LOCAL PEAK FINDER
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	// Peak is when Yn2 > Yn1, & Yn2 > Yn3:
	// Order of point: n1 -> n2 -> n3
	wire LOCAL_PEAK, LOCAL_PEAK_Yn2_Yn1, LOCAL_PEAK_Yn2_Yn3;
		assign LOCAL_PEAK_Yn2_Yn1 	= Shift1Ynum > Shift0Ynum;//( (Shift1Ynum*Shift0Ydensmall) > (Shift1Ydensmall*Shift0Ynum) );
		assign LOCAL_PEAK_Yn2_Yn3 	= Shift1Ynum > Shift2Ynum;//( (Shift1Ynum*Shift2Ydensmall) > (Shift1Ydensmall*Shift2Ynum) );
		assign LOCAL_PEAK 			= LOCAL_PEAK_Yn2_Yn1 & LOCAL_PEAK_Yn2_Yn3 & DETECTION;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// ABSOLUTE PEAK FINDER
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	// If the current peak is greater than the previous peak, this is the new Absolute Peak:
	wire ABSPeak;
		assign ABSPeak = LOCAL_PEAK & (Shift1Ynum > AbsPeak1Num);

		
		
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// Shift Register:
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~			
	// CLK 		= SYS_CLK
	// CLK_EN 	= FIFO_ADC_RD 
	// [-->Shift2][Shift1][Shift0-->]
	//      Yn3      Yn2      Yn1
	reg [13:0] TIME_DETECTION, TIME;
	
	reg [59:0] Shift2Ynum, Shift1Ynum, Shift0Ynum;
	reg [49:0] Shift2Yden, Shift1Yden, Shift0Yden;
		
	reg [59:0] AbsPeak2Num, AbsPeak1Num, AbsPeak0Num;
	reg [49:0] AbsPeak2Den, AbsPeak1Den, AbsPeak0Den;
	always @(posedge SYS_CLK) begin
		if (RST) begin			
			Shift2Ynum 			<= 0;
			Shift2Yden 			<= 0;
			
			Shift1Ynum 			<= 0;
			Shift1Yden 			<= 0;
			
			Shift0Ynum 			<= 0;
			Shift0Yden 			<= 0;
			
			TIME_DETECTION		<= 0;
			
			AbsPeak2Num			<= 0;
			AbsPeak2Den			<= 0;
			AbsPeak1Num			<= 0;
			AbsPeak1Den 		<= 0;
			AbsPeak0Num			<= 0;
			AbsPeak0Den			<= 0;
		end
		else begin
			Shift2Ynum 			<= CLK_EN 	? Yn_NUM 		: Shift2Ynum;
			Shift2Yden 			<= CLK_EN 	? Yn_DEN 		: Shift2Yden;
			
			Shift1Ynum 			<= CLK_EN 	? Shift2Ynum 	: Shift1Ynum;
			Shift1Yden 			<= CLK_EN 	? Shift2Yden 	: Shift1Yden;
			
			Shift0Ynum 			<= CLK_EN 	? Shift1Ynum 	: Shift0Ynum;
			Shift0Yden 			<= CLK_EN 	? Shift1Yden 	: Shift0Yden;
			
			TIME_DETECTION		<= CLK_EN 	? TIMER			: TIME_DETECTION;
			
			AbsPeak2Num 		<= ABSPeak 	? Shift2Ynum 	: AbsPeak2Num;
			AbsPeak2Den			<= ABSPeak 	? Shift2Yden 	: AbsPeak2Den;
			AbsPeak1Num 		<= ABSPeak 	? Shift1Ynum 	: AbsPeak1Num;
			AbsPeak1Den			<= ABSPeak 	? Shift1Yden 	: AbsPeak1Den;
			AbsPeak0Num 		<= ABSPeak 	? Shift0Ynum 	: AbsPeak0Num;
			AbsPeak0Den			<= ABSPeak 	? Shift0Yden 	: AbsPeak0Den;
			TIME					<= ABSPeak 	? TIME_DETECTION+1-taps : TIME;
		end
	end
	
	
	wire valid_peak_logic1 = ~FIFO_DETECTION_YN1_EMPTY & ~FIFO_DETECTION_YN2_EMPTY;
	wire valid_peak_logic2 = ~FIFO_DETECTION_YN3_EMPTY & ~FIFO_DETECTION_TIME_EMPTY;
		assign VALID_PEAK_FOUND = valid_peak_logic1 & valid_peak_logic2;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// DETECTION FIFO - Yn: 110-bits wide, 8 words depth
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	wire FIFO_DETECTION_YN1_EMPTY, FIFO_DETECTION_YN1_FULL;
	FIFO_DETECTION_YN	FIFO_DETECTION_YN1_instant (
		.clock 		( SYS_CLK 							),
		.sclr 		( RST   								),
		.rdreq 		( NIOS_RD_PEAK 					),
		.wrreq 		( ABS_PEAK_FLAG 					),
		.data 		( {AbsPeak0Num, AbsPeak0Den} 	), 
		.empty 		( FIFO_DETECTION_YN1_EMPTY 	),
		.full 		( FIFO_DETECTION_YN1_FULL 		),
		.q 			( FIFO_DETECTION_YN1_OUTPUT 	)
	);
	
	wire FIFO_DETECTION_YN2_EMPTY, FIFO_DETECTION_YN2_FULL;
	FIFO_DETECTION_YN	FIFO_DETECTION_YN2_instant (
		.clock 		( SYS_CLK 							),
		.sclr 		( RST  								),
		.rdreq 		( NIOS_RD_PEAK						),
		.wrreq 		( ABS_PEAK_FLAG 					),
		.data 		( {AbsPeak1Num, AbsPeak1Den} 	),
		.empty 		( FIFO_DETECTION_YN2_EMPTY 	),
		.full 		( FIFO_DETECTION_YN2_FULL 		),
		.q 			( FIFO_DETECTION_YN2_OUTPUT 	)
	);
	
	wire FIFO_DETECTION_YN3_EMPTY, FIFO_DETECTION_YN3_FULL;
	FIFO_DETECTION_YN	FIFO_DETECTION_YN3_instant (
		.clock 		( SYS_CLK 							),
		.sclr 		( RST  								),
		.rdreq 		( NIOS_RD_PEAK 					),
		.wrreq 		( ABS_PEAK_FLAG 					),
		.data 		( {AbsPeak2Num, AbsPeak2Den} 	),
		.empty 		( FIFO_DETECTION_YN3_EMPTY 	),
		.full 		( FIFO_DETECTION_YN3_FULL 		),
		.q 			( FIFO_DETECTION_YN3_OUTPUT 	)
	);
	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
// DETECTION FIFO - Time: 14-bits wide, 8 words depth
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	wire FIFO_DETECTION_TIME_EMPTY, FIFO_DETECTION_TIME_FULL;
	FIFO_DETECTION_TIME	FIFO_DETECTION_TIME_instant (
		.clock 		( SYS_CLK 							),
		.sclr 		( RST  								),
		.rdreq 		( NIOS_RD_PEAK 					),
		.wrreq 		( ABS_PEAK_FLAG 					),
		.data 		( TIME 								),
		.empty 		( FIFO_DETECTION_TIME_EMPTY 	),
		.full 		( FIFO_DETECTION_TIME_FULL 	),
		.q 			( FIFO_DETECTION_TIME_OUTPUT 	)
	);

endmodule
//=================================================
// END PEAK FINDER MODULE
//=================================================
