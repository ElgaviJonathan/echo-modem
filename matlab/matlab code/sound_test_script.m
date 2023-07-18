clear;
clc;

data_bits = randi([0 1],64,1);
modulation_order = 64;
delta_f = 125; % in Hz
sample_rate = 44100;
symbol_length_t = 1;%50e-3; % 50 [ms]
passband_sig = multi_tone_fsk_modulator(data_bits,modulation_order,delta_f,sample_rate,symbol_length_t);
passband_sig = passband_sig.';
figure(1)
clf(1)
plot(passband_sig);
plot_fft_axis(passband_sig,sample_rate,2);
sound(passband_sig,sample_rate);
%%
% 
% t = (0:sample_rate*3)/sample_rate;
% sig = cos(2*pi*2000*t);
% sound(sig,sample_rate);
