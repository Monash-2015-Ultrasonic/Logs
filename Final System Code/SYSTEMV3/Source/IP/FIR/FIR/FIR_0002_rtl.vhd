----------------------------------------------------------------------------- 
-- Altera DSP Builder Advanced Flow Tools Release Version 13.0sp1
-- Quartus II development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2013 Altera Corporation.  All rights reserved.    
-- Your use of  Altera  Corporation's design tools,  logic functions and other 
-- software and tools,  and its AMPP  partner logic functions, and  any output 
-- files  any of the  foregoing  device programming or simulation files),  and 
-- any associated  documentation or information are expressly subject  to  the 
-- terms and conditions  of the Altera Program License Subscription Agreement, 
-- Altera  MegaCore  Function  License  Agreement, or other applicable license 
-- agreement,  including,  without limitation,  that your use  is for the sole 
-- purpose of  programming  logic  devices  manufactured by Altera and sold by 
-- Altera or its authorized  distributors.  Please  refer  to  the  applicable 
-- agreement for further details.
----------------------------------------------------------------------------- 

-- VHDL created from FIR_0002_rtl
-- VHDL created on Wed Oct 21 00:24:27 2015


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY lpm;
USE lpm.lpm_components.all;

-- Text written from d:/SJ/nightly/13.0sp1/232/w32/p4/ip/aion/src/mip_common/hw_model.cpp:1303
entity FIR_0002_rtl is
    port (
        xIn_v : in std_logic_vector(0 downto 0);
        xIn_c : in std_logic_vector(7 downto 0);
        xIn_0 : in std_logic_vector(12 downto 0);
        bankIn_0 : in std_logic_vector(2 downto 0);
        xOut_v : out std_logic_vector(0 downto 0);
        xOut_c : out std_logic_vector(7 downto 0);
        xOut_0 : out std_logic_vector(29 downto 0);
        clk : in std_logic;
        areset : in std_logic
        );
end;

architecture normal of FIR_0002_rtl is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name NOT_GATE_PUSH_BACK OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410";

    signal GND_q : std_logic_vector (0 downto 0);
    signal VCC_q : std_logic_vector (0 downto 0);
    signal d_xIn_bankIn_0_12_q : std_logic_vector (2 downto 0);
    signal d_xIn_0_12_q : std_logic_vector (12 downto 0);
    signal d_in0_m0_wi0_wo0_assign_data_q_13_q : std_logic_vector (15 downto 0);
    signal d_in0_m0_wi0_wo0_assign_sel_q_12_q : std_logic_vector (0 downto 0);
    signal d_in0_m0_wi0_wo0_assign_sel_q_13_q : std_logic_vector (0 downto 0);
    signal u0_m0_wo0_run_count : std_logic_vector(1 downto 0);
    signal u0_m0_wo0_run_pre_ena_q : std_logic_vector (0 downto 0);
    signal u0_m0_wo0_run_q : std_logic_vector (0 downto 0);
    signal u0_m0_wo0_run_out : std_logic_vector (0 downto 0);
    signal u0_m0_wo0_run_enable_q : std_logic_vector (0 downto 0);
    signal u0_m0_wo0_run_ctrl : std_logic_vector(2 downto 0);
    signal u0_m0_wo0_memread_q : std_logic_vector (0 downto 0);
    signal u0_m0_wo0_compute_q : std_logic_vector (0 downto 0);
    signal d_u0_m0_wo0_compute_q_14_q : std_logic_vector (0 downto 0);
    signal d_u0_m0_wo0_compute_q_15_q : std_logic_vector (0 downto 0);
    signal u0_m0_wo0_wi0_ra0_count0_q : std_logic_vector(7 downto 0);
    signal u0_m0_wo0_wi0_ra0_count0_i : unsigned(6 downto 0);
    signal u0_m0_wo0_wi0_ra0_count0_sc : signed(6 downto 0);
    signal u0_m0_wo0_wi0_ra0_count1_q : std_logic_vector(7 downto 0);
    signal u0_m0_wo0_wi0_ra0_count1_i : unsigned(6 downto 0);
    signal u0_m0_wo0_wi0_ra0_add_0_0_a : std_logic_vector(8 downto 0);
    signal u0_m0_wo0_wi0_ra0_add_0_0_b : std_logic_vector(8 downto 0);
    signal u0_m0_wo0_wi0_ra0_add_0_0_o : std_logic_vector (8 downto 0);
    signal u0_m0_wo0_wi0_ra0_add_0_0_q : std_logic_vector (8 downto 0);
    signal u0_m0_wo0_wi0_wa0_q : std_logic_vector(6 downto 0);
    signal u0_m0_wo0_wi0_wa0_i : unsigned(6 downto 0);
    signal u0_m0_wo0_wi0_delayr0_reset0 : std_logic;
    signal u0_m0_wo0_wi0_delayr0_ia : std_logic_vector (12 downto 0);
    signal u0_m0_wo0_wi0_delayr0_aa : std_logic_vector (6 downto 0);
    signal u0_m0_wo0_wi0_delayr0_ab : std_logic_vector (6 downto 0);
    signal u0_m0_wo0_wi0_delayr0_iq : std_logic_vector (12 downto 0);
    signal u0_m0_wo0_wi0_delayr0_q : std_logic_vector (12 downto 0);
    signal u0_m0_wo0_bank_delayr0_reset0 : std_logic;
    signal u0_m0_wo0_bank_delayr0_ia : std_logic_vector (2 downto 0);
    signal u0_m0_wo0_bank_delayr0_aa : std_logic_vector (0 downto 0);
    signal u0_m0_wo0_bank_delayr0_ab : std_logic_vector (0 downto 0);
    signal u0_m0_wo0_bank_delayr0_iq : std_logic_vector (2 downto 0);
    signal u0_m0_wo0_bank_delayr0_q : std_logic_vector (2 downto 0);
    signal u0_m0_wo0_ca0_q : std_logic_vector(6 downto 0);
    signal u0_m0_wo0_ca0_i : unsigned(6 downto 0);
    signal u0_m0_wo0_ca0_eq : std_logic;
    signal u0_m0_wo0_cm0_q : std_logic_vector(9 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_a : std_logic_vector (9 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_b : std_logic_vector (12 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_s1 : std_logic_vector (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_0_q : std_logic_vector (22 downto 0);
    signal u0_m0_wo0_aseq_q : std_logic_vector(0 downto 0);
    signal u0_m0_wo0_aseq_eq : std_logic;
    signal u0_m0_wo0_accum_a : std_logic_vector(29 downto 0);
    signal u0_m0_wo0_accum_b : std_logic_vector(29 downto 0);
    signal u0_m0_wo0_accum_i : std_logic_vector (29 downto 0);
    signal u0_m0_wo0_accum_o : std_logic_vector (29 downto 0);
    signal u0_m0_wo0_accum_q : std_logic_vector (29 downto 0);
    signal u0_m0_wo0_oseq_q : std_logic_vector(0 downto 0);
    signal u0_m0_wo0_oseq_eq : std_logic;
    signal u0_m0_wo0_oseq_gated_reg_q : std_logic_vector (0 downto 0);
    signal xIn_bankIn_0_q : std_logic_vector (15 downto 0);
    signal data_u0_m0_wi0_wo0_in : std_logic_vector (12 downto 0);
    signal data_u0_m0_wi0_wo0_b : std_logic_vector (12 downto 0);
    signal u0_m0_wo0_oseq_gated_a : std_logic_vector(0 downto 0);
    signal u0_m0_wo0_oseq_gated_b : std_logic_vector(0 downto 0);
    signal u0_m0_wo0_oseq_gated_q : std_logic_vector(0 downto 0);
    signal u0_m0_wo0_wi0_ra0_resize_in : std_logic_vector (6 downto 0);
    signal u0_m0_wo0_wi0_ra0_resize_b : std_logic_vector (6 downto 0);
    signal u0_m0_wo0_cab0_q : std_logic_vector (9 downto 0);
    signal bank_u0_m0_wi0_wo0_in : std_logic_vector (15 downto 0);
    signal bank_u0_m0_wi0_wo0_b : std_logic_vector (2 downto 0);
begin


	--VCC(CONSTANT,1)@0
    VCC_q <= "1";

	--xIn(PORTIN,2)@10

	--u0_m0_wo0_run(ENABLEGENERATOR,8)@10
    u0_m0_wo0_run_ctrl <= u0_m0_wo0_run_out & xIn_v & u0_m0_wo0_run_enable_q;
    u0_m0_wo0_run: PROCESS (clk, areset)
        variable u0_m0_wo0_run_enable_c : signed(6 downto 0);
        variable u0_m0_wo0_run_inc : signed(1 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_run_q <= "0";
            u0_m0_wo0_run_enable_c := TO_SIGNED(63,7);
            u0_m0_wo0_run_enable_q <= "0";
            u0_m0_wo0_run_count <= "00";
            u0_m0_wo0_run_inc := (OTHERS => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_run_out = "1") THEN
                IF (u0_m0_wo0_run_enable_c(6) = '1') THEN
                    u0_m0_wo0_run_enable_c := u0_m0_wo0_run_enable_c - (-64);
                ELSE
                    u0_m0_wo0_run_enable_c := u0_m0_wo0_run_enable_c + (-1);
                END IF;
                u0_m0_wo0_run_enable_q <= STD_LOGIC_VECTOR(u0_m0_wo0_run_enable_c(6 DOWNTO 6));
            ELSE
                u0_m0_wo0_run_enable_q <= "0";
            END IF;
            CASE u0_m0_wo0_run_ctrl is
                WHEN "000" | "001" =>
                    u0_m0_wo0_run_inc := "00";
                WHEN "010" | "011" =>
                    u0_m0_wo0_run_inc := "11";
                WHEN "100" =>
                    u0_m0_wo0_run_inc := "00";
                WHEN "101" =>
                    u0_m0_wo0_run_inc := "01";
                WHEN "110" =>
                    u0_m0_wo0_run_inc := "11";
                WHEN "111" =>
                    u0_m0_wo0_run_inc := "00";
                WHEN OTHERS =>
            END CASE;
            u0_m0_wo0_run_count <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_run_count) + SIGNED(u0_m0_wo0_run_inc));
            u0_m0_wo0_run_q <= u0_m0_wo0_run_out;
        END IF;
    END PROCESS;
    u0_m0_wo0_run_pre_ena_q <= u0_m0_wo0_run_count(1 downto 1);
    u0_m0_wo0_run_out <= u0_m0_wo0_run_pre_ena_q AND VCC_q;

	--u0_m0_wo0_memread(DELAY,9)@12
    u0_m0_wo0_memread : dspba_delay
    GENERIC MAP ( width => 1, depth => 1 )
    PORT MAP ( xin => u0_m0_wo0_run_q, xout => u0_m0_wo0_memread_q, clk => clk, aclr => areset );

	--u0_m0_wo0_compute(DELAY,10)@12
    u0_m0_wo0_compute : dspba_delay
    GENERIC MAP ( width => 1, depth => 2 )
    PORT MAP ( xin => u0_m0_wo0_memread_q, xout => u0_m0_wo0_compute_q, clk => clk, aclr => areset );

	--d_u0_m0_wo0_compute_q_14(DELAY,39)@12
    d_u0_m0_wo0_compute_q_14 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2 )
    PORT MAP ( xin => u0_m0_wo0_compute_q, xout => d_u0_m0_wo0_compute_q_14_q, clk => clk, aclr => areset );

	--u0_m0_wo0_aseq(SEQUENCE,25)@14
    u0_m0_wo0_aseq: PROCESS (clk, areset)
        variable u0_m0_wo0_aseq_c : signed (8 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_aseq_c := "000000000";
            u0_m0_wo0_aseq_q <= "0";
            u0_m0_wo0_aseq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_14_q = "1") THEN
                IF (u0_m0_wo0_aseq_c = "000000000") THEN
                    u0_m0_wo0_aseq_eq <= '1';
                ELSE
                    u0_m0_wo0_aseq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_aseq_eq = '1') THEN
                    u0_m0_wo0_aseq_c := u0_m0_wo0_aseq_c + 64;
                ELSE
                    u0_m0_wo0_aseq_c := u0_m0_wo0_aseq_c - 1;
                END IF;
                u0_m0_wo0_aseq_q <= std_logic_vector(u0_m0_wo0_aseq_c(8 DOWNTO 8));
            END IF;
        END IF;
    END PROCESS;


	--d_u0_m0_wo0_compute_q_15(DELAY,40)@14
    d_u0_m0_wo0_compute_q_15 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1 )
    PORT MAP ( xin => d_u0_m0_wo0_compute_q_14_q, xout => d_u0_m0_wo0_compute_q_15_q, clk => clk, aclr => areset );

	--d_xIn_bankIn_0_12(DELAY,35)@10
    d_xIn_bankIn_0_12 : dspba_delay
    GENERIC MAP ( width => 3, depth => 2 )
    PORT MAP ( xin => bankIn_0, xout => d_xIn_bankIn_0_12_q, clk => clk, aclr => areset );

	--d_xIn_0_12(DELAY,34)@10
    d_xIn_0_12 : dspba_delay
    GENERIC MAP ( width => 13, depth => 2 )
    PORT MAP ( xin => xIn_0, xout => d_xIn_0_12_q, clk => clk, aclr => areset );

	--xIn_bankIn_0(BITJOIN,3)@12
    xIn_bankIn_0_q <= d_xIn_bankIn_0_12_q & d_xIn_0_12_q;

	--d_in0_m0_wi0_wo0_assign_data_q_13(DELAY,36)@12
    d_in0_m0_wi0_wo0_assign_data_q_13 : dspba_delay
    GENERIC MAP ( width => 16, depth => 1 )
    PORT MAP ( xin => xIn_bankIn_0_q, xout => d_in0_m0_wi0_wo0_assign_data_q_13_q, clk => clk, aclr => areset );

	--data_u0_m0_wi0_wo0(BITSELECT,7)@13
    data_u0_m0_wi0_wo0_in <= d_in0_m0_wi0_wo0_assign_data_q_13_q(12 downto 0);
    data_u0_m0_wi0_wo0_b <= data_u0_m0_wi0_wo0_in(12 downto 0);

	--u0_m0_wo0_wi0_wa0(COUNTER,15)@13
    -- every=1, low=0, high=127, step=1, init=1
    u0_m0_wo0_wi0_wa0: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_wa0_i <= TO_UNSIGNED(1,7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_in0_m0_wi0_wo0_assign_sel_q_13_q = "1") THEN
                    u0_m0_wo0_wi0_wa0_i <= u0_m0_wo0_wi0_wa0_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_wa0_q <= STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_wa0_i,7));


	--d_in0_m0_wi0_wo0_assign_sel_q_12(DELAY,37)@10
    d_in0_m0_wi0_wo0_assign_sel_q_12 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2 )
    PORT MAP ( xin => xIn_v, xout => d_in0_m0_wi0_wo0_assign_sel_q_12_q, clk => clk, aclr => areset );

	--d_in0_m0_wi0_wo0_assign_sel_q_13(DELAY,38)@12
    d_in0_m0_wi0_wo0_assign_sel_q_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1 )
    PORT MAP ( xin => d_in0_m0_wi0_wo0_assign_sel_q_12_q, xout => d_in0_m0_wi0_wo0_assign_sel_q_13_q, clk => clk, aclr => areset );

	--u0_m0_wo0_wi0_ra0_count1(COUNTER,12)@12
    -- every=1, low=0, high=127, step=1, init=0
    u0_m0_wo0_wi0_ra0_count1: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_ra0_count1_i <= TO_UNSIGNED(0,7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                    u0_m0_wo0_wi0_ra0_count1_i <= u0_m0_wo0_wi0_ra0_count1_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_ra0_count1_q <= STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_ra0_count1_i,8));


	--u0_m0_wo0_wi0_ra0_count0(COUNTER,11)@12
    -- every=65, low=0, high=127, step=64, init=65
    u0_m0_wo0_wi0_ra0_count0: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_ra0_count0_i <= TO_UNSIGNED(65,7);
            u0_m0_wo0_wi0_ra0_count0_sc <= TO_SIGNED(63,7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                IF (u0_m0_wo0_wi0_ra0_count0_sc(6) = '1') THEN
                    u0_m0_wo0_wi0_ra0_count0_sc <= u0_m0_wo0_wi0_ra0_count0_sc - (-64);
                ELSE
                    u0_m0_wo0_wi0_ra0_count0_sc <= u0_m0_wo0_wi0_ra0_count0_sc + (-1);
                END IF;
                IF (u0_m0_wo0_wi0_ra0_count0_sc(6) = '1') THEN
                    u0_m0_wo0_wi0_ra0_count0_i <= u0_m0_wo0_wi0_ra0_count0_i + 64;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_ra0_count0_q <= STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_ra0_count0_i,8));


	--u0_m0_wo0_wi0_ra0_add_0_0(ADD,13)@12
    u0_m0_wo0_wi0_ra0_add_0_0_a <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_ra0_count0_q);
    u0_m0_wo0_wi0_ra0_add_0_0_b <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_ra0_count1_q);
    u0_m0_wo0_wi0_ra0_add_0_0: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_ra0_add_0_0_o <= (others => '0');
        ELSIF(clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_wi0_ra0_add_0_0_o <= STD_LOGIC_VECTOR(UNSIGNED(u0_m0_wo0_wi0_ra0_add_0_0_a) + UNSIGNED(u0_m0_wo0_wi0_ra0_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_ra0_add_0_0_q <= u0_m0_wo0_wi0_ra0_add_0_0_o(8 downto 0);


	--u0_m0_wo0_wi0_ra0_resize(BITSELECT,14)@13
    u0_m0_wo0_wi0_ra0_resize_in <= u0_m0_wo0_wi0_ra0_add_0_0_q(6 downto 0);
    u0_m0_wo0_wi0_ra0_resize_b <= u0_m0_wo0_wi0_ra0_resize_in(6 downto 0);

	--u0_m0_wo0_wi0_delayr0(DUALMEM,16)@13
    u0_m0_wo0_wi0_delayr0_ia <= data_u0_m0_wi0_wo0_b;
    u0_m0_wo0_wi0_delayr0_aa <= u0_m0_wo0_wi0_wa0_q;
    u0_m0_wo0_wi0_delayr0_ab <= u0_m0_wo0_wi0_ra0_resize_b;
    u0_m0_wo0_wi0_delayr0_dmem : altsyncram
    GENERIC MAP (
        ram_block_type => "M4K",
        operation_mode => "DUAL_PORT",
        width_a => 13,
        widthad_a => 7,
        numwords_a => 128,
        width_b => 13,
        widthad_b => 7,
        numwords_b => 128,
        lpm_type => "altsyncram",
        width_byteena_a => 1,
        indata_reg_b => "CLOCK0",
        wrcontrol_wraddress_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "CLEAR0",
        address_reg_b => "CLOCK0",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "OLD_DATA",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone II"
    )
    PORT MAP (
        clocken0 => '1',
        wren_a => d_in0_m0_wi0_wo0_assign_sel_q_13_q(0),
        aclr0 => u0_m0_wo0_wi0_delayr0_reset0,
        clock0 => clk,
        address_b => u0_m0_wo0_wi0_delayr0_ab,
        -- data_b => (others => '0'),
        q_b => u0_m0_wo0_wi0_delayr0_iq,
        address_a => u0_m0_wo0_wi0_delayr0_aa,
        data_a => u0_m0_wo0_wi0_delayr0_ia
    );
    u0_m0_wo0_wi0_delayr0_reset0 <= areset;
        u0_m0_wo0_wi0_delayr0_q <= u0_m0_wo0_wi0_delayr0_iq(12 downto 0);

	--bank_u0_m0_wi0_wo0(BITSELECT,6)@12
    bank_u0_m0_wi0_wo0_in <= xIn_bankIn_0_q;
    bank_u0_m0_wi0_wo0_b <= bank_u0_m0_wi0_wo0_in(15 downto 13);

	--u0_m0_wo0_bank_delayr0(DUALMEM,19)@12
    u0_m0_wo0_bank_delayr0_ia <= bank_u0_m0_wi0_wo0_b;
    u0_m0_wo0_bank_delayr0_aa <= GND_q;
    u0_m0_wo0_bank_delayr0_ab <= GND_q;
    u0_m0_wo0_bank_delayr0_dmem : altsyncram
    GENERIC MAP (
        ram_block_type => "M4K",
        operation_mode => "DUAL_PORT",
        width_a => 3,
        widthad_a => 1,
        numwords_a => 2,
        width_b => 3,
        widthad_b => 1,
        numwords_b => 2,
        lpm_type => "altsyncram",
        width_byteena_a => 1,
        indata_reg_b => "CLOCK0",
        wrcontrol_wraddress_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "CLEAR0",
        address_reg_b => "CLOCK0",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "OLD_DATA",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone II"
    )
    PORT MAP (
        clocken0 => '1',
        wren_a => d_in0_m0_wi0_wo0_assign_sel_q_12_q(0),
        aclr0 => u0_m0_wo0_bank_delayr0_reset0,
        clock0 => clk,
        address_b => u0_m0_wo0_bank_delayr0_ab,
        -- data_b => (others => '0'),
        q_b => u0_m0_wo0_bank_delayr0_iq,
        address_a => u0_m0_wo0_bank_delayr0_aa,
        data_a => u0_m0_wo0_bank_delayr0_ia
    );
    u0_m0_wo0_bank_delayr0_reset0 <= areset;
        u0_m0_wo0_bank_delayr0_q <= u0_m0_wo0_bank_delayr0_iq(2 downto 0);

	--u0_m0_wo0_ca0(COUNTER,21)@12
    -- every=1, low=0, high=64, step=1, init=0
    u0_m0_wo0_ca0: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_ca0_i <= TO_UNSIGNED(0,7);
            u0_m0_wo0_ca0_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_compute_q = "1") THEN
                    IF u0_m0_wo0_ca0_i = 63 THEN
                      u0_m0_wo0_ca0_eq <= '1';
                    ELSE
                      u0_m0_wo0_ca0_eq <= '0';
                    END IF;
                    IF (u0_m0_wo0_ca0_eq = '1') THEN
                        u0_m0_wo0_ca0_i <= u0_m0_wo0_ca0_i - 64;
                    ELSE
                        u0_m0_wo0_ca0_i <= u0_m0_wo0_ca0_i + 1;
                    END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_ca0_q <= STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_ca0_i,7));


	--u0_m0_wo0_cab0(BITJOIN,22)@12
    u0_m0_wo0_cab0_q <= u0_m0_wo0_bank_delayr0_q & u0_m0_wo0_ca0_q;

	--u0_m0_wo0_cm0(LOOKUP,23)@12
    u0_m0_wo0_cm0: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_cm0_q <= "0000000011";
        ELSIF rising_edge(clk) THEN            CASE (u0_m0_wo0_cab0_q) IS
                WHEN "0000000000" =>  u0_m0_wo0_cm0_q <= "0000000011";
                WHEN "0000000001" =>  u0_m0_wo0_cm0_q <= "0000001001";
                WHEN "0000000010" =>  u0_m0_wo0_cm0_q <= "0000001001";
                WHEN "0000000011" =>  u0_m0_wo0_cm0_q <= "0000001011";
                WHEN "0000000100" =>  u0_m0_wo0_cm0_q <= "1111100001";
                WHEN "0000000101" =>  u0_m0_wo0_cm0_q <= "1111001111";
                WHEN "0000000110" =>  u0_m0_wo0_cm0_q <= "1111100000";
                WHEN "0000000111" =>  u0_m0_wo0_cm0_q <= "0000001111";
                WHEN "0000001000" =>  u0_m0_wo0_cm0_q <= "0001010000";
                WHEN "0000001001" =>  u0_m0_wo0_cm0_q <= "0001010011";
                WHEN "0000001010" =>  u0_m0_wo0_cm0_q <= "0000100010";
                WHEN "0000001011" =>  u0_m0_wo0_cm0_q <= "1110110011";
                WHEN "0000001100" =>  u0_m0_wo0_cm0_q <= "1110001100";
                WHEN "0000001101" =>  u0_m0_wo0_cm0_q <= "1110011001";
                WHEN "0000001110" =>  u0_m0_wo0_cm0_q <= "0000110001";
                WHEN "0000001111" =>  u0_m0_wo0_cm0_q <= "0010001001";
                WHEN "0000010000" =>  u0_m0_wo0_cm0_q <= "0010000001";
                WHEN "0000010001" =>  u0_m0_wo0_cm0_q <= "0000100110";
                WHEN "0000010010" =>  u0_m0_wo0_cm0_q <= "1110000000";
                WHEN "0000010011" =>  u0_m0_wo0_cm0_q <= "1101001100";
                WHEN "0000010100" =>  u0_m0_wo0_cm0_q <= "1101110010";
                WHEN "0000010101" =>  u0_m0_wo0_cm0_q <= "0001010110";
                WHEN "0000010110" =>  u0_m0_wo0_cm0_q <= "0011010011";
                WHEN "0000010111" =>  u0_m0_wo0_cm0_q <= "0011000001";
                WHEN "0000011000" =>  u0_m0_wo0_cm0_q <= "0000100110";
                WHEN "0000011001" =>  u0_m0_wo0_cm0_q <= "1100111100";
                WHEN "0000011010" =>  u0_m0_wo0_cm0_q <= "1011111011";
                WHEN "0000011011" =>  u0_m0_wo0_cm0_q <= "1100101101";
                WHEN "0000011100" =>  u0_m0_wo0_cm0_q <= "0001110100";
                WHEN "0000011101" =>  u0_m0_wo0_cm0_q <= "0100100111";
                WHEN "0000011110" =>  u0_m0_wo0_cm0_q <= "0100000111";
                WHEN "0000011111" =>  u0_m0_wo0_cm0_q <= "0000011000";
                WHEN "0000100000" =>  u0_m0_wo0_cm0_q <= "1011111100";
                WHEN "0000100001" =>  u0_m0_wo0_cm0_q <= "1010110100";
                WHEN "0000100010" =>  u0_m0_wo0_cm0_q <= "1100010000";
                WHEN "0000100011" =>  u0_m0_wo0_cm0_q <= "0010100000";
                WHEN "0000100100" =>  u0_m0_wo0_cm0_q <= "0101101100";
                WHEN "0000100101" =>  u0_m0_wo0_cm0_q <= "0100111110";
                WHEN "0000100110" =>  u0_m0_wo0_cm0_q <= "0000011111";
                WHEN "0000100111" =>  u0_m0_wo0_cm0_q <= "1010111110";
                WHEN "0000101000" =>  u0_m0_wo0_cm0_q <= "1001101100";
                WHEN "0000101001" =>  u0_m0_wo0_cm0_q <= "1100001000";
                WHEN "0000101010" =>  u0_m0_wo0_cm0_q <= "0011001101";
                WHEN "0000101011" =>  u0_m0_wo0_cm0_q <= "0110100111";
                WHEN "0000101100" =>  u0_m0_wo0_cm0_q <= "0101101010";
                WHEN "0000101101" =>  u0_m0_wo0_cm0_q <= "0000010111";
                WHEN "0000101110" =>  u0_m0_wo0_cm0_q <= "1010001100";
                WHEN "0000101111" =>  u0_m0_wo0_cm0_q <= "1000110111";
                WHEN "0000110000" =>  u0_m0_wo0_cm0_q <= "1011111100";
                WHEN "0000110001" =>  u0_m0_wo0_cm0_q <= "0011101011";
                WHEN "0000110010" =>  u0_m0_wo0_cm0_q <= "0111001110";
                WHEN "0000110011" =>  u0_m0_wo0_cm0_q <= "0110001000";
                WHEN "0000110100" =>  u0_m0_wo0_cm0_q <= "0000000110";
                WHEN "0000110101" =>  u0_m0_wo0_cm0_q <= "1001101010";
                WHEN "0000110110" =>  u0_m0_wo0_cm0_q <= "1000100000";
                WHEN "0000110111" =>  u0_m0_wo0_cm0_q <= "1011101001";
                WHEN "0000111000" =>  u0_m0_wo0_cm0_q <= "0100000111";
                WHEN "0000111001" =>  u0_m0_wo0_cm0_q <= "0111111001";
                WHEN "0000111010" =>  u0_m0_wo0_cm0_q <= "0110010011";
                WHEN "0000111011" =>  u0_m0_wo0_cm0_q <= "1111010001";
                WHEN "0000111100" =>  u0_m0_wo0_cm0_q <= "1001010100";
                WHEN "0000111101" =>  u0_m0_wo0_cm0_q <= "1000011001";
                WHEN "0000111110" =>  u0_m0_wo0_cm0_q <= "1100010010";
                WHEN "0000111111" =>  u0_m0_wo0_cm0_q <= "0100101000";
                WHEN "0001000000" =>  u0_m0_wo0_cm0_q <= "0111111111";
                WHEN "0010000000" =>  u0_m0_wo0_cm0_q <= "0000010010";
                WHEN "0010000001" =>  u0_m0_wo0_cm0_q <= "0000001000";
                WHEN "0010000010" =>  u0_m0_wo0_cm0_q <= "0000000011";
                WHEN "0010000011" =>  u0_m0_wo0_cm0_q <= "1111100101";
                WHEN "0010000100" =>  u0_m0_wo0_cm0_q <= "1111010011";
                WHEN "0010000101" =>  u0_m0_wo0_cm0_q <= "1111010011";
                WHEN "0010000110" =>  u0_m0_wo0_cm0_q <= "1111010110";
                WHEN "0010000111" =>  u0_m0_wo0_cm0_q <= "0000011101";
                WHEN "0010001000" =>  u0_m0_wo0_cm0_q <= "0001000101";
                WHEN "0010001001" =>  u0_m0_wo0_cm0_q <= "0000111010";
                WHEN "0010001010" =>  u0_m0_wo0_cm0_q <= "0000000011";
                WHEN "0010001011" =>  u0_m0_wo0_cm0_q <= "1110100100";
                WHEN "0010001100" =>  u0_m0_wo0_cm0_q <= "1110001101";
                WHEN "0010001101" =>  u0_m0_wo0_cm0_q <= "1110101000";
                WHEN "0010001110" =>  u0_m0_wo0_cm0_q <= "0000111111";
                WHEN "0010001111" =>  u0_m0_wo0_cm0_q <= "0010001100";
                WHEN "0010010000" =>  u0_m0_wo0_cm0_q <= "0010110111";
                WHEN "0010010001" =>  u0_m0_wo0_cm0_q <= "1111110000";
                WHEN "0010010010" =>  u0_m0_wo0_cm0_q <= "1101011101";
                WHEN "0010010011" =>  u0_m0_wo0_cm0_q <= "1101000110";
                WHEN "0010010100" =>  u0_m0_wo0_cm0_q <= "1110001100";
                WHEN "0010010101" =>  u0_m0_wo0_cm0_q <= "0001110111";
                WHEN "0010010110" =>  u0_m0_wo0_cm0_q <= "0011100010";
                WHEN "0010010111" =>  u0_m0_wo0_cm0_q <= "0010101011";
                WHEN "0010011000" =>  u0_m0_wo0_cm0_q <= "1111011000";
                WHEN "0010011001" =>  u0_m0_wo0_cm0_q <= "1100000101";
                WHEN "0010011010" =>  u0_m0_wo0_cm0_q <= "1011101111";
                WHEN "0010011011" =>  u0_m0_wo0_cm0_q <= "1110001001";
                WHEN "0010011100" =>  u0_m0_wo0_cm0_q <= "0011000000";
                WHEN "0010011101" =>  u0_m0_wo0_cm0_q <= "0100111010";
                WHEN "0010011110" =>  u0_m0_wo0_cm0_q <= "0011100100";
                WHEN "0010011111" =>  u0_m0_wo0_cm0_q <= "1110111111";
                WHEN "0010100000" =>  u0_m0_wo0_cm0_q <= "1010110010";
                WHEN "0010100001" =>  u0_m0_wo0_cm0_q <= "1010011111";
                WHEN "0010100010" =>  u0_m0_wo0_cm0_q <= "1101111000";
                WHEN "0010100011" =>  u0_m0_wo0_cm0_q <= "0011110111";
                WHEN "0010100100" =>  u0_m0_wo0_cm0_q <= "0110001000";
                WHEN "0010100101" =>  u0_m0_wo0_cm0_q <= "0100011011";
                WHEN "0010100110" =>  u0_m0_wo0_cm0_q <= "1110101010";
                WHEN "0010100111" =>  u0_m0_wo0_cm0_q <= "1001110010";
                WHEN "0010101000" =>  u0_m0_wo0_cm0_q <= "1001100010";
                WHEN "0010101001" =>  u0_m0_wo0_cm0_q <= "1101011001";
                WHEN "0010101010" =>  u0_m0_wo0_cm0_q <= "0100100101";
                WHEN "0010101011" =>  u0_m0_wo0_cm0_q <= "0111001111";
                WHEN "0010101100" =>  u0_m0_wo0_cm0_q <= "0110011000";
                WHEN "0010101101" =>  u0_m0_wo0_cm0_q <= "1110000010";
                WHEN "0010101110" =>  u0_m0_wo0_cm0_q <= "1001000011";
                WHEN "0010101111" =>  u0_m0_wo0_cm0_q <= "1000111001";
                WHEN "0010110000" =>  u0_m0_wo0_cm0_q <= "1101010101";
                WHEN "0010110001" =>  u0_m0_wo0_cm0_q <= "0101000110";
                WHEN "0010110010" =>  u0_m0_wo0_cm0_q <= "0111110110";
                WHEN "0010110011" =>  u0_m0_wo0_cm0_q <= "0111001010";
                WHEN "0010110100" =>  u0_m0_wo0_cm0_q <= "1101111011";
                WHEN "0010110101" =>  u0_m0_wo0_cm0_q <= "1000011001";
                WHEN "0010110110" =>  u0_m0_wo0_cm0_q <= "1000011100";
                WHEN "0010110111" =>  u0_m0_wo0_cm0_q <= "1101111011";
                WHEN "0010111000" =>  u0_m0_wo0_cm0_q <= "0101011101";
                WHEN "0010111001" =>  u0_m0_wo0_cm0_q <= "0111111110";
                WHEN "0010111010" =>  u0_m0_wo0_cm0_q <= "0101010011";
                WHEN "0010111011" =>  u0_m0_wo0_cm0_q <= "1101100010";
                WHEN "0010111100" =>  u0_m0_wo0_cm0_q <= "1000010110";
                WHEN "0010111101" =>  u0_m0_wo0_cm0_q <= "1000100011";
                WHEN "0010111110" =>  u0_m0_wo0_cm0_q <= "1110010010";
                WHEN "0010111111" =>  u0_m0_wo0_cm0_q <= "0101011110";
                WHEN "0011000000" =>  u0_m0_wo0_cm0_q <= "0111101101";
                WHEN "0100000000" =>  u0_m0_wo0_cm0_q <= "1111101100";
                WHEN "0100000001" =>  u0_m0_wo0_cm0_q <= "1111111110";
                WHEN "0100000010" =>  u0_m0_wo0_cm0_q <= "0000011110";
                WHEN "0100000011" =>  u0_m0_wo0_cm0_q <= "0000110100";
                WHEN "0100000100" =>  u0_m0_wo0_cm0_q <= "1111110001";
                WHEN "0100000101" =>  u0_m0_wo0_cm0_q <= "1111000101";
                WHEN "0100000110" =>  u0_m0_wo0_cm0_q <= "1111001011";
                WHEN "0100000111" =>  u0_m0_wo0_cm0_q <= "0000000000";
                WHEN "0100001000" =>  u0_m0_wo0_cm0_q <= "0001001100";
                WHEN "0100001001" =>  u0_m0_wo0_cm0_q <= "0001011100";
                WHEN "0100001010" =>  u0_m0_wo0_cm0_q <= "0001000000";
                WHEN "0100001011" =>  u0_m0_wo0_cm0_q <= "1111000100";
                WHEN "0100001100" =>  u0_m0_wo0_cm0_q <= "1110001001";
                WHEN "0100001101" =>  u0_m0_wo0_cm0_q <= "1110100010";
                WHEN "0100001110" =>  u0_m0_wo0_cm0_q <= "0000001100";
                WHEN "0100001111" =>  u0_m0_wo0_cm0_q <= "0010000111";
                WHEN "0100010000" =>  u0_m0_wo0_cm0_q <= "0010011000";
                WHEN "0100010001" =>  u0_m0_wo0_cm0_q <= "0001001101";
                WHEN "0100010010" =>  u0_m0_wo0_cm0_q <= "1110010110";
                WHEN "0100010011" =>  u0_m0_wo0_cm0_q <= "1101001000";
                WHEN "0100010100" =>  u0_m0_wo0_cm0_q <= "1101110100";
                WHEN "0100010101" =>  u0_m0_wo0_cm0_q <= "0000011010";
                WHEN "0100010110" =>  u0_m0_wo0_cm0_q <= "0011000101";
                WHEN "0100010111" =>  u0_m0_wo0_cm0_q <= "0011010110";
                WHEN "0100011000" =>  u0_m0_wo0_cm0_q <= "0001100110";
                WHEN "0100011001" =>  u0_m0_wo0_cm0_q <= "1101100001";
                WHEN "0100011010" =>  u0_m0_wo0_cm0_q <= "1011111001";
                WHEN "0100011011" =>  u0_m0_wo0_cm0_q <= "1100000100";
                WHEN "0100011100" =>  u0_m0_wo0_cm0_q <= "0001000111";
                WHEN "0100011101" =>  u0_m0_wo0_cm0_q <= "0100001111";
                WHEN "0100011110" =>  u0_m0_wo0_cm0_q <= "0100010111";
                WHEN "0100011111" =>  u0_m0_wo0_cm0_q <= "0001101111";
                WHEN "0100100000" =>  u0_m0_wo0_cm0_q <= "1100100110";
                WHEN "0100100001" =>  u0_m0_wo0_cm0_q <= "1010101111";
                WHEN "0100100010" =>  u0_m0_wo0_cm0_q <= "1010111011";
                WHEN "0100100011" =>  u0_m0_wo0_cm0_q <= "0001011010";
                WHEN "0100100100" =>  u0_m0_wo0_cm0_q <= "0101011010";
                WHEN "0100100101" =>  u0_m0_wo0_cm0_q <= "0101011000";
                WHEN "0100100110" =>  u0_m0_wo0_cm0_q <= "0001100000";
                WHEN "0100100111" =>  u0_m0_wo0_cm0_q <= "1011101110";
                WHEN "0100101000" =>  u0_m0_wo0_cm0_q <= "1001110010";
                WHEN "0100101001" =>  u0_m0_wo0_cm0_q <= "1011111000";
                WHEN "0100101010" =>  u0_m0_wo0_cm0_q <= "0001111101";
                WHEN "0100101011" =>  u0_m0_wo0_cm0_q <= "0110010100";
                WHEN "0100101100" =>  u0_m0_wo0_cm0_q <= "0110001001";
                WHEN "0100101101" =>  u0_m0_wo0_cm0_q <= "0001101100";
                WHEN "0100101110" =>  u0_m0_wo0_cm0_q <= "1010111011";
                WHEN "0100101111" =>  u0_m0_wo0_cm0_q <= "1000110100";
                WHEN "0100110000" =>  u0_m0_wo0_cm0_q <= "1010101000";
                WHEN "0100110001" =>  u0_m0_wo0_cm0_q <= "0010101011";
                WHEN "0100110010" =>  u0_m0_wo0_cm0_q <= "0111000000";
                WHEN "0100110011" =>  u0_m0_wo0_cm0_q <= "0110100011";
                WHEN "0100110100" =>  u0_m0_wo0_cm0_q <= "0001010111";
                WHEN "0100110101" =>  u0_m0_wo0_cm0_q <= "1010010010";
                WHEN "0100110110" =>  u0_m0_wo0_cm0_q <= "1000010101";
                WHEN "0100110111" =>  u0_m0_wo0_cm0_q <= "1010011000";
                WHEN "0100111000" =>  u0_m0_wo0_cm0_q <= "0011001011";
                WHEN "0100111001" =>  u0_m0_wo0_cm0_q <= "0111101101";
                WHEN "0100111010" =>  u0_m0_wo0_cm0_q <= "0110101111";
                WHEN "0100111011" =>  u0_m0_wo0_cm0_q <= "0000010100";
                WHEN "0100111100" =>  u0_m0_wo0_cm0_q <= "1001101101";
                WHEN "0100111101" =>  u0_m0_wo0_cm0_q <= "1000001100";
                WHEN "0100111110" =>  u0_m0_wo0_cm0_q <= "1011000101";
                WHEN "0100111111" =>  u0_m0_wo0_cm0_q <= "0011111001";
                WHEN "0101000000" =>  u0_m0_wo0_cm0_q <= "0111111111";
                WHEN "0110000000" =>  u0_m0_wo0_cm0_q <= "0000101101";
                WHEN "0110000001" =>  u0_m0_wo0_cm0_q <= "0001001111";
                WHEN "0110000010" =>  u0_m0_wo0_cm0_q <= "0000111110";
                WHEN "0110000011" =>  u0_m0_wo0_cm0_q <= "1111111001";
                WHEN "0110000100" =>  u0_m0_wo0_cm0_q <= "1110110100";
                WHEN "0110000101" =>  u0_m0_wo0_cm0_q <= "1110101110";
                WHEN "0110000110" =>  u0_m0_wo0_cm0_q <= "1111011101";
                WHEN "0110000111" =>  u0_m0_wo0_cm0_q <= "0001000110";
                WHEN "0110001000" =>  u0_m0_wo0_cm0_q <= "0001110010";
                WHEN "0110001001" =>  u0_m0_wo0_cm0_q <= "0001010111";
                WHEN "0110001010" =>  u0_m0_wo0_cm0_q <= "1111111000";
                WHEN "0110001011" =>  u0_m0_wo0_cm0_q <= "1110000000";
                WHEN "0110001100" =>  u0_m0_wo0_cm0_q <= "1101101111";
                WHEN "0110001101" =>  u0_m0_wo0_cm0_q <= "1110111100";
                WHEN "0110001110" =>  u0_m0_wo0_cm0_q <= "0001101100";
                WHEN "0110001111" =>  u0_m0_wo0_cm0_q <= "0010110111";
                WHEN "0110010000" =>  u0_m0_wo0_cm0_q <= "0010001111";
                WHEN "0110010001" =>  u0_m0_wo0_cm0_q <= "1111111000";
                WHEN "0110010010" =>  u0_m0_wo0_cm0_q <= "1100111111";
                WHEN "0110010011" =>  u0_m0_wo0_cm0_q <= "1100011110";
                WHEN "0110010100" =>  u0_m0_wo0_cm0_q <= "1110000001";
                WHEN "0110010101" =>  u0_m0_wo0_cm0_q <= "0010001111";
                WHEN "0110010110" =>  u0_m0_wo0_cm0_q <= "0100001101";
                WHEN "0110010111" =>  u0_m0_wo0_cm0_q <= "0011011110";
                WHEN "0110011000" =>  u0_m0_wo0_cm0_q <= "0000000101";
                WHEN "0110011001" =>  u0_m0_wo0_cm0_q <= "1100000000";
                WHEN "0110011010" =>  u0_m0_wo0_cm0_q <= "1011001100";
                WHEN "0110011011" =>  u0_m0_wo0_cm0_q <= "1101010011";
                WHEN "0110011100" =>  u0_m0_wo0_cm0_q <= "0010101110";
                WHEN "0110011101" =>  u0_m0_wo0_cm0_q <= "0101001111";
                WHEN "0110011110" =>  u0_m0_wo0_cm0_q <= "0100011100";
                WHEN "0110011111" =>  u0_m0_wo0_cm0_q <= "0000010011";
                WHEN "0110100000" =>  u0_m0_wo0_cm0_q <= "1011001100";
                WHEN "0110100001" =>  u0_m0_wo0_cm0_q <= "1010000101";
                WHEN "0110100010" =>  u0_m0_wo0_cm0_q <= "1100011000";
                WHEN "0110100011" =>  u0_m0_wo0_cm0_q <= "0011000110";
                WHEN "0110100100" =>  u0_m0_wo0_cm0_q <= "0110010100";
                WHEN "0110100101" =>  u0_m0_wo0_cm0_q <= "0101011101";
                WHEN "0110100110" =>  u0_m0_wo0_cm0_q <= "0000011001";
                WHEN "0110100111" =>  u0_m0_wo0_cm0_q <= "1010010111";
                WHEN "0110101000" =>  u0_m0_wo0_cm0_q <= "1001000100";
                WHEN "0110101001" =>  u0_m0_wo0_cm0_q <= "1011011010";
                WHEN "0110101010" =>  u0_m0_wo0_cm0_q <= "0011011000";
                WHEN "0110101011" =>  u0_m0_wo0_cm0_q <= "0111010011";
                WHEN "0110101100" =>  u0_m0_wo0_cm0_q <= "0110001000";
                WHEN "0110101101" =>  u0_m0_wo0_cm0_q <= "1111111100";
                WHEN "0110101110" =>  u0_m0_wo0_cm0_q <= "1001110011";
                WHEN "0110101111" =>  u0_m0_wo0_cm0_q <= "1000011111";
                WHEN "0110110000" =>  u0_m0_wo0_cm0_q <= "1011001001";
                WHEN "0110110001" =>  u0_m0_wo0_cm0_q <= "0011101101";
                WHEN "0110110010" =>  u0_m0_wo0_cm0_q <= "0111110101";
                WHEN "0110110011" =>  u0_m0_wo0_cm0_q <= "0110100010";
                WHEN "0110110100" =>  u0_m0_wo0_cm0_q <= "1111111001";
                WHEN "0110110101" =>  u0_m0_wo0_cm0_q <= "1001100011";
                WHEN "0110110110" =>  u0_m0_wo0_cm0_q <= "1000001111";
                WHEN "0110110111" =>  u0_m0_wo0_cm0_q <= "1011001001";
                WHEN "0110111000" =>  u0_m0_wo0_cm0_q <= "0011110111";
                WHEN "0110111001" =>  u0_m0_wo0_cm0_q <= "0111111111";
                WHEN "0110111010" =>  u0_m0_wo0_cm0_q <= "0110101000";
                WHEN "0110111011" =>  u0_m0_wo0_cm0_q <= "1111110100";
                WHEN "0110111100" =>  u0_m0_wo0_cm0_q <= "1001011110";
                WHEN "0110111101" =>  u0_m0_wo0_cm0_q <= "1000001101";
                WHEN "0110111110" =>  u0_m0_wo0_cm0_q <= "1011100000";
                WHEN "0110111111" =>  u0_m0_wo0_cm0_q <= "0100000101";
                WHEN "0111000000" =>  u0_m0_wo0_cm0_q <= "0111111001";
                WHEN "1000000000" =>  u0_m0_wo0_cm0_q <= "0000010010";
                WHEN "1000000001" =>  u0_m0_wo0_cm0_q <= "0000001000";
                WHEN "1000000010" =>  u0_m0_wo0_cm0_q <= "0000000011";
                WHEN "1000000011" =>  u0_m0_wo0_cm0_q <= "1111100101";
                WHEN "1000000100" =>  u0_m0_wo0_cm0_q <= "1111010011";
                WHEN "1000000101" =>  u0_m0_wo0_cm0_q <= "1111010011";
                WHEN "1000000110" =>  u0_m0_wo0_cm0_q <= "1111010110";
                WHEN "1000000111" =>  u0_m0_wo0_cm0_q <= "0000011101";
                WHEN "1000001000" =>  u0_m0_wo0_cm0_q <= "0001000101";
                WHEN "1000001001" =>  u0_m0_wo0_cm0_q <= "0000111010";
                WHEN "1000001010" =>  u0_m0_wo0_cm0_q <= "0000000011";
                WHEN "1000001011" =>  u0_m0_wo0_cm0_q <= "1110100100";
                WHEN "1000001100" =>  u0_m0_wo0_cm0_q <= "1110001101";
                WHEN "1000001101" =>  u0_m0_wo0_cm0_q <= "1110101000";
                WHEN "1000001110" =>  u0_m0_wo0_cm0_q <= "0000111111";
                WHEN "1000001111" =>  u0_m0_wo0_cm0_q <= "0010001100";
                WHEN "1000010000" =>  u0_m0_wo0_cm0_q <= "0010110111";
                WHEN "1000010001" =>  u0_m0_wo0_cm0_q <= "1111110000";
                WHEN "1000010010" =>  u0_m0_wo0_cm0_q <= "1101011101";
                WHEN "1000010011" =>  u0_m0_wo0_cm0_q <= "1101000110";
                WHEN "1000010100" =>  u0_m0_wo0_cm0_q <= "1110001100";
                WHEN "1000010101" =>  u0_m0_wo0_cm0_q <= "0001110111";
                WHEN "1000010110" =>  u0_m0_wo0_cm0_q <= "0011100010";
                WHEN "1000010111" =>  u0_m0_wo0_cm0_q <= "0010101011";
                WHEN "1000011000" =>  u0_m0_wo0_cm0_q <= "1111011000";
                WHEN "1000011001" =>  u0_m0_wo0_cm0_q <= "1100000101";
                WHEN "1000011010" =>  u0_m0_wo0_cm0_q <= "1011101111";
                WHEN "1000011011" =>  u0_m0_wo0_cm0_q <= "1110001001";
                WHEN "1000011100" =>  u0_m0_wo0_cm0_q <= "0011000000";
                WHEN "1000011101" =>  u0_m0_wo0_cm0_q <= "0100111010";
                WHEN "1000011110" =>  u0_m0_wo0_cm0_q <= "0011100100";
                WHEN "1000011111" =>  u0_m0_wo0_cm0_q <= "1110111111";
                WHEN "1000100000" =>  u0_m0_wo0_cm0_q <= "1010110010";
                WHEN "1000100001" =>  u0_m0_wo0_cm0_q <= "1010011111";
                WHEN "1000100010" =>  u0_m0_wo0_cm0_q <= "1101111000";
                WHEN "1000100011" =>  u0_m0_wo0_cm0_q <= "0011110111";
                WHEN "1000100100" =>  u0_m0_wo0_cm0_q <= "0110001000";
                WHEN "1000100101" =>  u0_m0_wo0_cm0_q <= "0100011011";
                WHEN "1000100110" =>  u0_m0_wo0_cm0_q <= "1110101010";
                WHEN "1000100111" =>  u0_m0_wo0_cm0_q <= "1001110010";
                WHEN "1000101000" =>  u0_m0_wo0_cm0_q <= "1001100010";
                WHEN "1000101001" =>  u0_m0_wo0_cm0_q <= "1101011001";
                WHEN "1000101010" =>  u0_m0_wo0_cm0_q <= "0100100101";
                WHEN "1000101011" =>  u0_m0_wo0_cm0_q <= "0111001111";
                WHEN "1000101100" =>  u0_m0_wo0_cm0_q <= "0110011000";
                WHEN "1000101101" =>  u0_m0_wo0_cm0_q <= "1110000010";
                WHEN "1000101110" =>  u0_m0_wo0_cm0_q <= "1001000011";
                WHEN "1000101111" =>  u0_m0_wo0_cm0_q <= "1000111001";
                WHEN "1000110000" =>  u0_m0_wo0_cm0_q <= "1101010101";
                WHEN "1000110001" =>  u0_m0_wo0_cm0_q <= "0101000110";
                WHEN "1000110010" =>  u0_m0_wo0_cm0_q <= "0111110110";
                WHEN "1000110011" =>  u0_m0_wo0_cm0_q <= "0111001010";
                WHEN "1000110100" =>  u0_m0_wo0_cm0_q <= "1101111011";
                WHEN "1000110101" =>  u0_m0_wo0_cm0_q <= "1000011001";
                WHEN "1000110110" =>  u0_m0_wo0_cm0_q <= "1000011100";
                WHEN "1000110111" =>  u0_m0_wo0_cm0_q <= "1101111011";
                WHEN "1000111000" =>  u0_m0_wo0_cm0_q <= "0101011101";
                WHEN "1000111001" =>  u0_m0_wo0_cm0_q <= "0111111110";
                WHEN "1000111010" =>  u0_m0_wo0_cm0_q <= "0101010011";
                WHEN "1000111011" =>  u0_m0_wo0_cm0_q <= "1101100010";
                WHEN "1000111100" =>  u0_m0_wo0_cm0_q <= "1000010110";
                WHEN "1000111101" =>  u0_m0_wo0_cm0_q <= "1000100011";
                WHEN "1000111110" =>  u0_m0_wo0_cm0_q <= "1110010010";
                WHEN "1000111111" =>  u0_m0_wo0_cm0_q <= "0101011110";
                WHEN "1001000000" =>  u0_m0_wo0_cm0_q <= "0111101101";
                WHEN OTHERS =>
                    u0_m0_wo0_cm0_q <= (others => '-');
            END CASE;
        END IF;
    END PROCESS;


	--u0_m0_wo0_mtree_mult1_0(MULT,24)@13
    u0_m0_wo0_mtree_mult1_0_a <= u0_m0_wo0_cm0_q;
    u0_m0_wo0_mtree_mult1_0_b <= u0_m0_wo0_wi0_delayr0_q;
    u0_m0_wo0_mtree_mult1_0_reset <= areset;

    u0_m0_wo0_mtree_mult1_0_component : lpm_mult
    GENERIC MAP (
    lpm_widtha => 10,
    lpm_widthb => 13,
    lpm_widthp => 23,
    lpm_widths => 1,
    lpm_type => "LPM_MULT",
    lpm_representation => "SIGNED",
    lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES,MAXIMIZE_SPEED=5",
    lpm_pipeline => 2
    )
    PORT MAP (
    dataa => u0_m0_wo0_mtree_mult1_0_a,
    datab => u0_m0_wo0_mtree_mult1_0_b,
    clken => VCC_q(0),
    aclr => u0_m0_wo0_mtree_mult1_0_reset,
    clock => clk,
    result => u0_m0_wo0_mtree_mult1_0_s1
    );
    u0_m0_wo0_mtree_mult1_0_q <= u0_m0_wo0_mtree_mult1_0_s1;

	--u0_m0_wo0_accum(ADD,26)@15
    u0_m0_wo0_accum_a <= STD_LOGIC_VECTOR((29 downto 23 => u0_m0_wo0_mtree_mult1_0_q(22)) & u0_m0_wo0_mtree_mult1_0_q);
    u0_m0_wo0_accum_b <= u0_m0_wo0_accum_q;
    u0_m0_wo0_accum_i <= u0_m0_wo0_accum_a;
    u0_m0_wo0_accum: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_accum_o <= (others => '0');
        ELSIF(clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_15_q = "1") THEN
                IF (u0_m0_wo0_aseq_q = "1") THEN
                    u0_m0_wo0_accum_o <= u0_m0_wo0_accum_i;
                ELSE
                    u0_m0_wo0_accum_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_accum_a) + SIGNED(u0_m0_wo0_accum_b));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_accum_q <= u0_m0_wo0_accum_o(29 downto 0);


	--GND(CONSTANT,0)@0
    GND_q <= "0";

	--u0_m0_wo0_oseq(SEQUENCE,27)@14
    u0_m0_wo0_oseq: PROCESS (clk, areset)
        variable u0_m0_wo0_oseq_c : signed (8 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_c := "001000000";
            u0_m0_wo0_oseq_q <= "0";
            u0_m0_wo0_oseq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_14_q = "1") THEN
                IF (u0_m0_wo0_oseq_c = "000000000") THEN
                    u0_m0_wo0_oseq_eq <= '1';
                ELSE
                    u0_m0_wo0_oseq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_oseq_eq = '1') THEN
                    u0_m0_wo0_oseq_c := u0_m0_wo0_oseq_c + 64;
                ELSE
                    u0_m0_wo0_oseq_c := u0_m0_wo0_oseq_c - 1;
                END IF;
                u0_m0_wo0_oseq_q <= std_logic_vector(u0_m0_wo0_oseq_c(8 DOWNTO 8));
            END IF;
        END IF;
    END PROCESS;


	--u0_m0_wo0_oseq_gated(LOGICAL,28)@15
    u0_m0_wo0_oseq_gated_a <= u0_m0_wo0_oseq_q;
    u0_m0_wo0_oseq_gated_b <= d_u0_m0_wo0_compute_q_15_q;
    u0_m0_wo0_oseq_gated_q <= u0_m0_wo0_oseq_gated_a and u0_m0_wo0_oseq_gated_b;

	--u0_m0_wo0_oseq_gated_reg(REG,29)@15
    u0_m0_wo0_oseq_gated_reg: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= "0";
        ELSIF rising_edge(clk) THEN
            u0_m0_wo0_oseq_gated_reg_q <= u0_m0_wo0_oseq_gated_q;
        END IF;
    END PROCESS;


	--xOut(PORTOUT,32)@16
    xOut_v <= u0_m0_wo0_oseq_gated_reg_q;
    xOut_c <= STD_LOGIC_VECTOR("0000000" & GND_q);
    xOut_0 <= u0_m0_wo0_accum_q;


end normal;
