%%

clear;
clc;

%% transmit audio
% data_bits = randi([0 1],64,1);
data_bits = ones(64,1);

modulation_order = 64;
sample_rate = 44100;
symbol_length_t = 5;%50e-3; % 50 [ms]
start_freq = 3000;
stop_freq = 10000;
[passband_sig, error_flag] = ...
    multi_tone_fsk_modulator(data_bits,modulation_order,...
    sample_rate,symbol_length_t, start_freq, stop_freq);
passband_sig = passband_sig.';
figure(1)
clf(1)
plot(passband_sig);
plot_fft_axis(passband_sig,sample_rate,2,1);
%
% sound(passband_sig,sample_rate);
audiowrite("matlab_direct_wav_multi_tone_fsk_all_ones.wav",passband_sig,sample_rate);

%% decode audio recording
clear
clc
% load('multi tone fsk test.mat');
sample_rate = 44100;
start_freq = 3000;
stop_freq = 10000;
symbol_length_t = 50e-3;
modulation_order = 64;

z_threshold = 3;
symbol_length_samp = symbol_length_t*sample_rate;
[freq_vec, error_flag] = generate_freq_vector(modulation_order,start_freq,stop_freq,30);
% [raw_rx_sig, rx_sample_freq] = audioread("matlab_direct_wav_multi_tone_fsk_all_ones.wav");
[raw_rx_sig, rx_sample_freq] = audioread("multi_tone_fsk_test_all_ones.wav");
dual_rx_sig = sum(raw_rx_sig,2);
start_index = 5e4;
signal_section = dual_rx_sig(start_index:start_index+symbol_length_samp-1);
demoded_bits = multi_tone_fsk_demodulator...
    (signal_section,64,sample_rate,symbol_length_samp,freq_vec,z_threshold,[]);

% errors = sum(data_bits' ~= demoded_bits);
% disp("errors = " + num2str(errors) + " ber = " + num2str(errors/length(data_bits)));