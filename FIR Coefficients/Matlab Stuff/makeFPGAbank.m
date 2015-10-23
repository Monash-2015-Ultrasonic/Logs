clear; close all; clc;

%%
H0 = importdata('FIR_CH0.txt');
H1 = importdata('FIR_CH1.txt');
H2 = importdata('FIR_CH2.txt');
H3 = importdata('FIR_CH3.txt');
H4 = importdata('FIR_CH4.txt');

H = [H0; H1; H2; H3; H4];

%%
fileBank = fopen('FIR_Bank.txt', 'w');

if ( (length(H0')+length(H1')+length(H2')+length(H3')+length(H4')) ~= (65*5) ),
    error('INCONSISTENT IMPULSE RESPONSES');
end

for i = 1:5,
    for j = 1:length(H0')-1,
       fprintf(fileBank, '%g, ', H(i,j));  
    end
    fprintf(fileBank, '%g\n', H(i,end));
end

fclose(fileBank);
