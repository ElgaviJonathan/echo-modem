%%

clear;
clc;  

%% transmit audio
% data_bits = randi([0 1],64,1);
% data_bits = [ones(32,1); zeros(32,1)];

% data_bits = ((-1).^(1:64)+1)/2; % alternating bits  
data_bits = zeros(64,1);
data_bits(8:8:64) = 1; % configure to symbol type 7 (from 0 to 7)


modulation_order = 64;
sample_rate = 44100;
symbol_length_t = 10;%50e-3; % 50 [ms]
symbol_length_samp = symbol_length_t*sample_rate;
start_freq = 3000;
stop_freq = 10000;
delta_f = 150;
%%
generate_freq_vector(modulation_order,start_freq,stop_freq, delta_f)
[passband_sig, freq_vec, error_flag] = ...
    multi_tone_fsk_modulator(data_bits,modulation_order,...
    sample_rate,symbol_length_t, start_freq, stop_freq);
passband_sig = passband_sig.';
% figure(1)
% clf(1)
% plot(passband_sig);
% plot_fft_axis(passband_sig,sample_rate,2,1);
%
% sound(passband_sig,sample_rate);
%%
audiowrite("matlab_fsk_symbol_type_7_10s.wav",passband_sig,sample_rate);

%% single tone generator
f = freq_vec(35);
t = (0:symbol_length_samp-1)/sample_rate;
single_tone = sin(2*pi*f*t);
%%
audiowrite("matlab_direct_single_tone_f7393_10s.wav",single_tone,sample_rate);


%% run rolling filter on recorded signal
% [raw_rx_sig, rx_sample_freq] = audioread("all_ones_10s_no_movement_recording.wav");
% [raw_rx_sig, rx_sample_freq] = audioread("single_tone_f9817_10s_recording.wav");
% [raw_rx_sig, rx_sample_freq] = audioread("single_tone_f3001_10s_recording.wav");
% [raw_rx_sig, rx_sample_freq] = audioread("recording_alternating_0-1.wav");
% [raw_rx_sig, rx_sample_freq] = audioread("matlab_fsk_alternating_0-1_10s.wav");
% [raw_rx_sig, rx_sample_freq] = audioread("recording_fsk_all_ones_10s_walking.wav");
% [raw_rx_sig, rx_sample_freq] = audioread("mic_calibration_ref_signal.wav");
% [raw_rx_sig, rx_sample_freq] = audioread("matlab_fsk_symbol_type_7_10s.wav");
[raw_rx_sig, rx_sample_freq] = audioread("recording_fsk_symbol_type_7_10s.wav");




% raw_rx_sig = raw_rx_sig(1:length(raw_rx_sig)/10);
%% filter based tone deteciton 
filter_freq_vec = freq_vec;%(500:500:15000)';
raw_rx_sig = raw_rx_sig(:,1);

window_len_t = 25e-3;
window_len_samp = window_len_t*sample_rate; 
t = (0:window_len_samp-1)/sample_rate;
% filter_freqs = (500:10:10000)';
filter_bank = exp(2*pi*1j*filter_freq_vec*t);...
%     + exp(2*pi*1j*(freq_vec + 0.3/window_len_t)*t)...
%     + exp(2*pi*1j*(freq_vec - 0.3/window_len_t)*t);

% conv_res_mat = zeros(640824,64);
for i = 1:length(filter_freq_vec)
    conv_res_mat(:,i) = abs(conv(filter_bank(i,:),raw_rx_sig));
end
symbol_0_convs = conv_res_mat(:,1:8:end);
symbol_0_convs_sum = sum(symbol_0_convs,2);
symbol_1_convs = conv_res_mat(:,2:8:end);
symbol_1_convs_sum = sum(symbol_1_convs,2);
symbol_2_convs = conv_res_mat(:,3:8:end);
symbol_2_convs_sum = sum(symbol_2_convs,2);
symbol_3_convs = conv_res_mat(:,4:8:end);
symbol_3_convs_sum = sum(symbol_3_convs,2);
symbol_4_convs = conv_res_mat(:,5:8:end);
symbol_4_convs_sum = sum(symbol_4_convs,2);
symbol_5_convs = conv_res_mat(:,6:8:end);
symbol_5_convs_sum = sum(symbol_5_convs,2);
symbol_6_convs = conv_res_mat(:,7:8:end);
symbol_6_convs_sum = sum(symbol_6_convs,2);
symbol_7_convs = conv_res_mat(:,8:8:end);
symbol_7_convs_sum = sum(symbol_7_convs,2);

symbol_conv_mat = [symbol_0_convs_sum, symbol_1_convs_sum, symbol_2_convs_sum,...
    symbol_3_convs_sum, symbol_4_convs_sum, symbol_5_convs_sum,...
    symbol_6_convs_sum, symbol_7_convs_sum];

figure()
plot(symbol_conv_mat);

distance_sig = symbol_conv_mat(:,8) - max(symbol_conv_mat(:,1:7),[],2);
sum(distance_sig<0)/length(distance_sig)
%% combined filter on single frequency
filter_freq = freq_vec(1);
single_filter_1 = exp(2*pi*1j*filter_freq*t);
single_filter_2 =  exp(2*pi*1j*(filter_freq + 0.3/window_len_t)*t);
single_filter_3 = exp(2*pi*1j*(filter_freq - 0.3/window_len_t)*t);

com_filter = single_filter_1;%+single_filter_2+single_filter_3;

single_conv_res = abs(conv(com_filter,raw_rx_sig));...
%     + abs(conv(single_filter_2,raw_rx_sig))...
%         + abs(conv(single_filter_3,raw_rx_sig));
plot(single_conv_res)

%% 
raw_rx_sig = raw_rx_sig(:,1);
plot_fft_axis(raw_rx_sig,sample_rate,99,1);


[x1,freq_axis] = plot_fft_axis(raw_rx_sig(2e4:2e4+window_len_samp),sample_rate,100,1);
x2 = plot_fft_axis(raw_rx_sig(3e4:3e4+window_len_samp),sample_rate,100,0);
x3 = plot_fft_axis(raw_rx_sig(4e4:4e4+window_len_samp),sample_rate,100,0);
x4 = plot_fft_axis(raw_rx_sig(5e4:5e4+window_len_samp),sample_rate,100,0);
x5 = plot_fft_axis(raw_rx_sig(6e4:6e4+window_len_samp),sample_rate,100,0);
x6 = plot_fft_axis(raw_rx_sig(7e4:7e4+window_len_samp),sample_rate,100,0);
x7 = plot_fft_axis(raw_rx_sig(8e4:8e4+window_len_samp),sample_rate,100,0);

avr_x = mean([x1,x2,x3,x4,x5,x6,x7].');
plot(freq_axis,  abs(avr_x))

y1 = plot_fft_axis(raw_rx_sig(2e5:2e5+window_len_samp),sample_rate,101,1);
y2 = plot_fft_axis(raw_rx_sig(2.1e5:2.1e5+window_len_samp),sample_rate,101,0);
y3 = plot_fft_axis(raw_rx_sig(2.2e5:2.2e5+window_len_samp),sample_rate,101,0);
y4 = plot_fft_axis(raw_rx_sig(2.3e5:2.3e5+window_len_samp),sample_rate,101,0);
y5 = plot_fft_axis(raw_rx_sig(2.4e5:2.4e5+window_len_samp),sample_rate,101,0);
y6 = plot_fft_axis(raw_rx_sig(2.5e5:2.5e5+window_len_samp),sample_rate,101,0);
y7 = plot_fft_axis(raw_rx_sig(2.6e5:2.6e5+window_len_samp),sample_rate,101,0);

avr_y = mean([y1,y2,y3,y4,y5,y6,y7].');
plot(freq_axis,  abs(avr_y))



