// megafunction wizard: %FIR Compiler II v13.0%
// GENERATION: XML
// FIR.v

// Generated using ACDS version 13.0sp1 232 at 2015.10.21.00:24:27

`timescale 1 ps / 1 ps
module FIR (
		input  wire        clk,              //                     clk.clk
		input  wire        reset_n,          //                     rst.reset_n
		input  wire [15:0] ast_sink_data,    //   avalon_streaming_sink.data
		input  wire        ast_sink_valid,   //                        .valid
		input  wire [1:0]  ast_sink_error,   //                        .error
		output wire [29:0] ast_source_data,  // avalon_streaming_source.data
		output wire        ast_source_valid, //                        .valid
		output wire [1:0]  ast_source_error  //                        .error
	);

	FIR_0002 fir_inst (
		.clk              (clk),              //                     clk.clk
		.reset_n          (reset_n),          //                     rst.reset_n
		.ast_sink_data    (ast_sink_data),    //   avalon_streaming_sink.data
		.ast_sink_valid   (ast_sink_valid),   //                        .valid
		.ast_sink_error   (ast_sink_error),   //                        .error
		.ast_source_data  (ast_source_data),  // avalon_streaming_source.data
		.ast_source_valid (ast_source_valid), //                        .valid
		.ast_source_error (ast_source_error)  //                        .error
	);

endmodule
// Retrieval info: <?xml version="1.0"?>
//<!--
//	Generated by Altera MegaWizard Launcher Utility version 1.0
//	************************************************************
//	THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//	************************************************************
//	Copyright (C) 1991-2015 Altera Corporation
//	Any megafunction design, and related net list (encrypted or decrypted),
//	support information, device programming or simulation file, and any other
//	associated documentation or information provided by Altera or a partner
//	under Altera's Megafunction Partnership Program may be used only to
//	program PLD devices (but not masked PLD devices) from Altera.  Any other
//	use of such megafunction design, net list, support information, device
//	programming or simulation file, or any other related documentation or
//	information is prohibited for any other purpose, including, but not
//	limited to modification, reverse engineering, de-compiling, or use with
//	any other silicon devices, unless such use is explicitly licensed under
//	a separate agreement with Altera or a megafunction partner.  Title to
//	the intellectual property, including patents, copyrights, trademarks,
//	trade secrets, or maskworks, embodied in any such megafunction design,
//	net list, support information, device programming or simulation file, or
//	any other related documentation or information provided by Altera or a
//	megafunction partner, remains with Altera, the megafunction partner, or
//	their respective licensors.  No other licenses, including any licenses
//	needed under any third party's intellectual property, are provided herein.
//-->
// Retrieval info: <instance entity-name="altera_fir_compiler_ii" version="13.0" >
// Retrieval info: 	<generic name="deviceFamily" value="Cyclone II" />
// Retrieval info: 	<generic name="filterType" value="Single Rate" />
// Retrieval info: 	<generic name="interpFactor" value="1" />
// Retrieval info: 	<generic name="decimFactor" value="1" />
// Retrieval info: 	<generic name="L_bandsFilter" value="All taps" />
// Retrieval info: 	<generic name="clockRate" value="70" />
// Retrieval info: 	<generic name="clockSlack" value="0" />
// Retrieval info: 	<generic name="speedGrade" value="Medium" />
// Retrieval info: 	<generic name="coeffReload" value="false" />
// Retrieval info: 	<generic name="baseAddress" value="0" />
// Retrieval info: 	<generic name="readWriteMode" value="Read/Write" />
// Retrieval info: 	<generic name="backPressure" value="false" />
// Retrieval info: 	<generic name="symmetryMode" value="Non Symmetry" />
// Retrieval info: 	<generic name="delayRAMBlockThreshold" value="20" />
// Retrieval info: 	<generic name="dualMemDistRAMThreshold" value="1280" />
// Retrieval info: 	<generic name="mRAMThreshold" value="1000000" />
// Retrieval info: 	<generic name="hardMultiplierThreshold" value="-1" />
// Retrieval info: 	<generic name="inputRate" value="0.273" />
// Retrieval info: 	<generic name="inputChannelNum" value="1" />
// Retrieval info: 	<generic name="inputType" value="Signed Binary" />
// Retrieval info: 	<generic name="inputBitWidth" value="13" />
// Retrieval info: 	<generic name="inputFracBitWidth" value="0" />
// Retrieval info: 	<generic name="coeffSetRealValue" value="0.244071,0.141787,-0.113977,-0.232884,-0.204786,-0.0225185,0.192516,0.241645,0.125623,-0.13334,-0.229299,-0.193922,0.00304137,0.187374,0.221098,0.112259,-0.124533,-0.218408,-0.177944,0.011294,0.173282,0.202265,0.0980707,-0.118572,-0.193214,-0.154191,0.0148849,0.152119,0.174184,0.0767349,-0.114838,-0.158876,-0.12453,0.0118619,0.125849,0.14105,0.0557348,-0.101021,-0.124814,-0.0938667,0.0185207,0.0924022,0.1008,0.0413365,-0.0681749,-0.0861659,-0.0613104,0.0186249,0.0619798,0.0654723,0.023523,-0.0492182,-0.0557951,-0.0371067,0.016661,0.0399565,0.0382857,0.00752456,-0.0157408,-0.0235637,-0.015232,0.00532852,0.00466478,0.0044306,0.00158585,0.222663,0.158473,-0.0497887,-0.215495,-0.221308,-0.0715816,0.153469,0.230759,0.158048,-0.0603832,-0.218759,-0.220178,-0.0603576,0.207096,0.226817,0.14759,-0.077538,-0.205577,-0.200986,-0.0571094,0.184259,0.209336,0.13273,-0.075669,-0.187039,-0.179842,-0.0389825,0.12803,0.177116,0.111689,-0.0617232,-0.159779,-0.150956,-0.0295705,0.103103,0.142186,0.0868352,-0.0539451,-0.123403,-0.113695,-0.0180965,0.0775264,0.102347,0.0540839,-0.052773,-0.0840246,-0.0737999,-0.00761055,0.0826754,0.063411,0.0288272,-0.0401256,-0.0523284,-0.0416592,0.00177931,0.0265251,0.0313897,0.0134517,-0.0192922,-0.0203379,-0.020641,-0.0122048,0.00177402,0.00402898,0.00854134,0.242759,0.118378,-0.149745,-0.237538,-0.191544,0.00983257,0.205144,0.234655,0.0967488,-0.171298,-0.233415,-0.174226,0.0417575,0.199122,0.212927,0.0813843,-0.163754,-0.218533,-0.154683,0.0514085,0.187013,0.192227,0.0595563,-0.125661,-0.189169,-0.130321,0.0458741,0.163728,0.164482,0.0431251,-0.154777,-0.160413,-0.103652,0.0532066,0.133005,0.129153,0.0337876,-0.120131,-0.12501,-0.0759358,0.0486883,0.101932,0.0938568,0.0127291,-0.0665242,-0.0875034,-0.0505797,0.0366486,0.072329,0.0641463,0.00606095,-0.0448285,-0.0568754,-0.0285212,0.0308628,0.0439808,0.0365314,-1.77677E-5,-0.0253431,-0.0280353,-0.00725551,0.0248056,0.0144398,-0.00116367,-0.00983009,0.223903,0.115935,-0.127726,-0.221065,-0.18557,-0.00540825,0.188027,0.226335,0.109777,-0.137754,-0.22036,-0.183166,-0.00341814,0.185432,0.221967,0.105048,-0.137791,-0.213193,-0.176277,-0.00189639,0.173698,0.207161,0.0961039,-0.13066,-0.196752,-0.160091,0.0111792,0.154663,0.179159,0.0877074,-0.102923,-0.168281,-0.136655,0.00875863,0.125852,0.148738,0.0774562,-0.0767404,-0.136618,-0.113716,0.0025507,0.0986421,0.119234,0.0636553,-0.0566399,-0.100304,-0.0858944,-0.00362399,0.0634957,0.0812586,0.048,-0.0303019,-0.0645256,-0.0571169,-0.00360911,0.0386759,0.0508261,0.0313297,-0.0157507,-0.0363825,-0.0338675,-0.003464,0.027668,0.0352735,0.0200315,0.222663,0.158473,-0.0497887,-0.215495,-0.221308,-0.0715816,0.153469,0.230759,0.158048,-0.0603832,-0.218759,-0.220178,-0.0603576,0.207096,0.226817,0.14759,-0.077538,-0.205577,-0.200986,-0.0571094,0.184259,0.209336,0.13273,-0.075669,-0.187039,-0.179842,-0.0389825,0.12803,0.177116,0.111689,-0.0617232,-0.159779,-0.150956,-0.0295705,0.103103,0.142186,0.0868352,-0.0539451,-0.123403,-0.113695,-0.0180965,0.0775264,0.102347,0.0540839,-0.052773,-0.0840246,-0.0737999,-0.00761055,0.0826754,0.063411,0.0288272,-0.0401256,-0.0523284,-0.0416592,0.00177931,0.0265251,0.0313897,0.0134517,-0.0192922,-0.0203379,-0.020641,-0.0122048,0.00177402,0.00402898,0.00854134" />
// Retrieval info: 	<generic name="coeffType" value="Signed Binary" />
// Retrieval info: 	<generic name="coeffScaling" value="Auto" />
// Retrieval info: 	<generic name="coeffBitWidth" value="10" />
// Retrieval info: 	<generic name="coeffFracBitWidth" value="0" />
// Retrieval info: 	<generic name="outType" value="Signed Binary" />
// Retrieval info: 	<generic name="outMSBRound" value="Truncation" />
// Retrieval info: 	<generic name="outMsbBitRem" value="0" />
// Retrieval info: 	<generic name="outLSBRound" value="Truncation" />
// Retrieval info: 	<generic name="outLsbBitRem" value="0" />
// Retrieval info: 	<generic name="resoureEstimation" value="1000,1200,10" />
// Retrieval info: 	<generic name="bankCount" value="5" />
// Retrieval info: 	<generic name="bankDisplay" value="4" />
// Retrieval info: </instance>
// IPFS_FILES : FIR.vo
// RELATED_FILES: FIR.v, altera_avalon_sc_fifo.v, auk_dspip_math_pkg_hpfir.vhd, auk_dspip_lib_pkg_hpfir.vhd, auk_dspip_avalon_streaming_controller_hpfir.vhd, auk_dspip_avalon_streaming_sink_hpfir.vhd, auk_dspip_avalon_streaming_source_hpfir.vhd, auk_dspip_roundsat_hpfir.vhd, dspba_library_package.vhd, dspba_library.vhd, FIR_0002_rtl.vhd, FIR_0002_ast.vhd, FIR_0002.vhd