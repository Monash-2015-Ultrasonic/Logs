clear; close all; clc;

%%

HBank = importdata('ALTERA_FIR_BANK.txt');

H0 = HBank(1:65, :);
H1 = HBank(66:130, :);
H2 = HBank(131:195, :);
H3 = HBank(196:260, :);
H4 = HBank(261:end, :);

sumHsq_CH0 = sum(H0.^2);
sumHsq_CH1 = sum(H1.^2);
sumHsq_CH2 = sum(H2.^2);
sumHsq_CH3 = sum(H3.^2);
sumHsq_CH4 = sum(H4.^2);

