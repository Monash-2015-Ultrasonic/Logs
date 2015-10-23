//=================================================
// ULTRASONIC TRANSMITTER MODULE
//=================================================
module ultrasonicTransmitter (
	input 			SYS_CLK,
	input 			CLK_40,
	input 			RST, ON,

	output reg		burstStart,
	output reg		roundTripFlag,
	output [1:0] 	pulseOutput
);

	// Generate 40.21139746kHz pulse for the Ultrasonic Transmitter:
	reg [9:0] usonic;
	always @(posedge CLK_40)
		usonic <= ~RST & ON ? usonic + 1 : 0;
		
	// Generate a burst of 32 pulses, then wait approx 33ms:
	localparam burst32 			= 32768;			// burst amount * 2^10;
	localparam wait33ms 			= 1350000;
	localparam wait32_5735ms 	= 1341261;
	reg [20:0] counter_burst;
	reg usonicpulse;
	always @(posedge CLK_40) begin	
		counter_burst <= (counter_burst < (burst32 + wait32_5735ms)) & ~RST & ON ? counter_burst + 1 : 0;
		usonicpulse <= usonic[9] & (counter_burst < burst32);
	end		
	
	// Output pulse to H-Bridge:
	assign pulseOutput = {usonicpulse & ~RST & ON, ~usonicpulse & ~RST & ON};
	
	// Burst started at negedge of counter_burst, i.e., counter_burst increments:
	wire START_SIGNAL;
		assign START_SIGNAL = (counter_burst == 0);
	
	// Restart timer for new burst, to do single target detection:
	reg startPREV;
	always @(posedge SYS_CLK) begin
		startPREV 	<= START_SIGNAL;
		burstStart 	<= startPREV & ~START_SIGNAL & ~RST & ON ? 1 : 0;	
	end
	
	// Desired range of system is 2m. Giving the signal up to 5m of flight time (2.5m range):
	wire ROUNDTRIP;
		assign ROUNDTRIP = (counter_burst > 584);
		
	reg roundTripPREV;
	always @(posedge SYS_CLK) begin
		roundTripPREV 	<= ROUNDTRIP;
		roundTripFlag 	<= ~roundTripPREV & ROUNDTRIP & ~RST & ON ? 1 : 0;
	end
	
endmodule
