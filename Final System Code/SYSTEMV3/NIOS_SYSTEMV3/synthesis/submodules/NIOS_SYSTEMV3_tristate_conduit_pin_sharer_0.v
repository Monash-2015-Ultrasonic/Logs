// NIOS_SYSTEMV3_tristate_conduit_pin_sharer_0.v

// This file was auto-generated from altera_tristate_conduit_pin_sharer_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 13.0sp1 232 at 2015.10.21.10:55:06

`timescale 1 ps / 1 ps
module NIOS_SYSTEMV3_tristate_conduit_pin_sharer_0 (
		input  wire        clk_clk,                  //   clk.clk
		input  wire        reset_reset,              // reset.reset
		output wire        request,                  //   tcm.request
		input  wire        grant,                    //      .grant
		output wire [0:0]  CS_N,                     //      .CS_N_out
		output wire [3:0]  ByteEnable_N,             //      .ByteEnable_N_out
		output wire [0:0]  OutputEnable_N,           //      .OutputEnable_N_out
		output wire [0:0]  Write_N,                  //      .Write_N_out
		output wire [31:0] data,                     //      .data_out
		input  wire [31:0] data_in,                  //      .data_in
		output wire        data_outen,               //      .data_outen
		output wire [18:0] addr,                     //      .addr_out
		output wire [0:0]  rst_N,                    //      .rst_N_out
		output wire [0:0]  begin_N,                  //      .begin_N_out
		input  wire        tcs0_request,             //  tcs0.request
		output wire        tcs0_grant,               //      .grant
		input  wire [0:0]  tcs0_chipselect_n_out,    //      .chipselect_n_out
		input  wire [3:0]  tcs0_byteenable_n_out,    //      .byteenable_n_out
		input  wire [0:0]  tcs0_outputenable_n_out,  //      .outputenable_n_out
		input  wire [0:0]  tcs0_write_n_out,         //      .write_n_out
		input  wire [31:0] tcs0_data_out,            //      .data_out
		output wire [31:0] tcs0_data_in,             //      .data_in
		input  wire        tcs0_data_outen,          //      .data_outen
		input  wire [18:0] tcs0_address_out,         //      .address_out
		input  wire [0:0]  tcs0_reset_n_out,         //      .reset_n_out
		input  wire [0:0]  tcs0_begintransfer_n_out  //      .begintransfer_n_out
	);

	wire  [0:0] arbiter_grant_data;        // arbiter:next_grant -> pin_sharer:next_grant
	wire        arbiter_grant_ready;       // pin_sharer:ack -> arbiter:ack
	wire        pin_sharer_tcs0_arb_valid; // pin_sharer:arb_SRAM_tcm -> arbiter:sink0_valid

	NIOS_SYSTEMV3_tristate_conduit_pin_sharer_0_pin_sharer pin_sharer (
		.clk                          (clk_clk),                   //      clk.clk
		.reset                        (reset_reset),               //    reset.reset
		.request                      (request),                   //      tcm.request
		.grant                        (grant),                     //         .grant
		.CS_N                         (CS_N),                      //         .CS_N_out
		.ByteEnable_N                 (ByteEnable_N),              //         .ByteEnable_N_out
		.OutputEnable_N               (OutputEnable_N),            //         .OutputEnable_N_out
		.Write_N                      (Write_N),                   //         .Write_N_out
		.data                         (data),                      //         .data_out
		.data_in                      (data_in),                   //         .data_in
		.data_outen                   (data_outen),                //         .data_outen
		.addr                         (addr),                      //         .addr_out
		.rst_N                        (rst_N),                     //         .rst_N_out
		.begin_N                      (begin_N),                   //         .begin_N_out
		.tcs0_request                 (tcs0_request),              //     tcs0.request
		.tcs0_grant                   (tcs0_grant),                //         .grant
		.tcs0_tcm_chipselect_n_out    (tcs0_chipselect_n_out),     //         .chipselect_n_out
		.tcs0_tcm_byteenable_n_out    (tcs0_byteenable_n_out),     //         .byteenable_n_out
		.tcs0_tcm_outputenable_n_out  (tcs0_outputenable_n_out),   //         .outputenable_n_out
		.tcs0_tcm_write_n_out         (tcs0_write_n_out),          //         .write_n_out
		.tcs0_tcm_data_out            (tcs0_data_out),             //         .data_out
		.tcs0_tcm_data_in             (tcs0_data_in),              //         .data_in
		.tcs0_tcm_data_outen          (tcs0_data_outen),           //         .data_outen
		.tcs0_tcm_address_out         (tcs0_address_out),          //         .address_out
		.tcs0_tcm_reset_n_out         (tcs0_reset_n_out),          //         .reset_n_out
		.tcs0_tcm_begintransfer_n_out (tcs0_begintransfer_n_out),  //         .begintransfer_n_out
		.ack                          (arbiter_grant_ready),       //    grant.ready
		.next_grant                   (arbiter_grant_data),        //         .data
		.arb_SRAM_tcm                 (pin_sharer_tcs0_arb_valid)  // tcs0_arb.valid
	);

	NIOS_SYSTEMV3_tristate_conduit_pin_sharer_0_arbiter arbiter (
		.clk         (clk_clk),                   //       clk.clk
		.reset       (reset_reset),               // clk_reset.reset
		.ack         (arbiter_grant_ready),       //     grant.ready
		.next_grant  (arbiter_grant_data),        //          .data
		.sink0_valid (pin_sharer_tcs0_arb_valid)  //     sink0.valid
	);

endmodule
