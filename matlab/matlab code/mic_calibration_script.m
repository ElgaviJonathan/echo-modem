%% this script is used to determain the frequncy responce of the mic ussed, 
% in order to normalize the gain needed for each frequncy used in the band.
clear;
clc;
%% generate the ref signal, and save to wav file
sample_freq = 44100;
single_freq_test_time = 500e-3; % symbol time in sec
single_freq_test_samp = single_freq_test_time*sample_freq;
t = (0:single_freq_test_samp-1)/sample_freq;
start_freq = 500;
freq_resolution = 500;
end_freq = 15000;
total_sig_length_t = ((end_freq-start_freq)/freq_resolution + 1)*single_freq_test_time;
total_sig_length_samp = total_sig_length_t*sample_freq;
test_freq_vec = start_freq:freq_resolution:end_freq;
ref_sig = [];
for i = 1:length(test_freq_vec)
    itter_sig = cos(2*pi*test_freq_vec(i)*t);
    ref_sig = [ref_sig itter_sig];
end
%% generate a ref signal
audiowrite("mic_calibration_ref_signal.wav",ref_sig,sample_freq);
% sound(ref_sig,sample_freq)
%% now play the signal from phone (actual intended speaker), and record on tested mic

%% read and plot the recorded signal
[raw_rx_sig_1, rx_sample_freq] = audioread("usb_mic_calibration_sig_rx.wav");
raw_rx_sig_1 = sum(raw_rx_sig_1,2);
agc_raw_rx_sig_1 = agc_amplitude(raw_rx_sig_1);
corr_result_1 = abs(conv(agc_raw_rx_sig_1, flip(ref_sig), "valid"));
[~, start_index_1] = max(corr_result_1);
rx_sig_1 = agc_raw_rx_sig_1(start_index_1:start_index_1+length(ref_sig));

[raw_rx_sig_2, rx_sample_freq] = audioread("usb_mic_calibration_sig_rx_2.wav");
raw_rx_sig_2 = sum(raw_rx_sig_2,2);
agc_raw_rx_sig_2 = agc_amplitude(raw_rx_sig_2);
corr_result_2 = abs(conv(agc_raw_rx_sig_2, flip(ref_sig), "valid"));
[~, start_index_2] = max(corr_result_2);
rx_sig_2 = agc_raw_rx_sig_2(start_index_2:start_index_2+length(ref_sig));

[raw_rx_sig_3, rx_sample_freq] = audioread("usb_mic_calibration_sig_rx_3.wav");
raw_rx_sig_3 = sum(raw_rx_sig_3,2);
agc_raw_rx_sig_3 = agc_amplitude(raw_rx_sig_3);
corr_result_3 = abs(conv(agc_raw_rx_sig_3, flip(ref_sig), "valid"));
[~, start_index_3] = max(corr_result_3);
rx_sig_3 = agc_raw_rx_sig_3(start_index_3:start_index_3+length(ref_sig));
rx_sig_3 = agc(rx_sig_3);


[raw_rx_sig_4, rx_sample_freq] = audioread("usb_mic_calibration_sig_rx_4.wav");
raw_rx_sig_4 = sum(raw_rx_sig_4,2);
agc_raw_rx_sig_4 = agc_amplitude(raw_rx_sig_4);
corr_result_4 = abs(conv(agc_raw_rx_sig_4, flip(ref_sig), "valid"));
[~, start_index_4] = max(corr_result_4);
rx_sig_4 = agc_raw_rx_sig_4(start_index_4:start_index_4+length(ref_sig));


%% used mached filetr on each section, to calculate the power of the received signal

t = (0:single_freq_test_samp-1)/sample_freq;
filter_output_vec = zeros(4,length(test_freq_vec));
for i = 1:length(test_freq_vec)
    filter = exp(2*pi*1j*test_freq_vec(i)*t);
    signal_section_1 = rx_sig_1(1+(i-1)*single_freq_test_samp:(i)*single_freq_test_samp);
    signal_section_2 = rx_sig_2(1+(i-1)*single_freq_test_samp:(i)*single_freq_test_samp);
    signal_section_3 = rx_sig_3(1+(i-1)*single_freq_test_samp:(i)*single_freq_test_samp);
    signal_section_4 = rx_sig_4(1+(i-1)*single_freq_test_samp:(i)*single_freq_test_samp);

    filter_output_1 = abs(filter*signal_section_1);
    filter_output_2 = abs(filter*signal_section_2);
    filter_output_3 = abs(filter*signal_section_3);
    filter_output_4 = abs(filter*signal_section_4);

    filter_output_vec(1,i) = filter_output_1;
    filter_output_vec(2,i) = filter_output_2;
    filter_output_vec(3,i) = filter_output_3;
    filter_output_vec(4,i) = filter_output_4;
end

% figure(4);
% plot(test_freq_vec,filter_output_vec);

% normalise the response of the filters in relation to the best one
%  (to cancle out SNR effects)
filter_output_vec(1,:) = filter_output_vec(1,:).*(1/max(filter_output_vec(1,:)));
filter_output_vec(2,:) = filter_output_vec(2,:).*(1/max(filter_output_vec(2,:)));
filter_output_vec(3,:) = filter_output_vec(3,:).*(1/max(filter_output_vec(3,:)));
filter_output_vec(4,:) = filter_output_vec(4,:).*(1/max(filter_output_vec(4,:)));

plot(mean(filter_output_vec))

%% calculate correction vector, and generate new signal based on corrected gains
correction_vec = 1./mean(filter_output_vec);
t = (0:single_freq_test_samp-1)/sample_freq;
corrected_ref_sig = [];
for i = 1:length(test_freq_vec)
    itter_sig = correction_vec(i).*cos(2*pi*test_freq_vec(i)*t);
    corrected_ref_sig = [corrected_ref_sig itter_sig];
end
% normalise to prevent clipping
corrected_ref_sig = corrected_ref_sig.*1/max(corrected_ref_sig);
%% generate corrected signal
audiowrite("mic_calibration_ref_signal_gain_corrected.wav",corrected_ref_sig,sample_freq);

%% now test the corrected signal

%% read corrected rx to test gain correction
[raw_rx_sig_after_cal, rx_sample_freq] = audioread("usb_mic_calibration_sig_rx_gain_corrected.wav");
raw_rx_sig_after_cal = sum(raw_rx_sig_after_cal,2);
agc_raw_rx_sig_after_cal = agc_amplitude(raw_rx_sig_after_cal);
% figure(1);
% plot(agc_raw_rx_sig_after_cal)
% figure(2);
% plot_fft_axis(raw_rx_sig,sample_freq,2,1);

% find start index of the signal by correlation
corr_result_rx = abs(conv(agc_raw_rx_sig_after_cal, flip(ref_sig), "valid"));
[~, max_ind] = max(corr_result_rx);
% figure(3);
% plot(corr_result_rx);
% figure(1)
% xline(max_ind)
%%

t = (0:single_freq_test_samp-1)/sample_freq;
signal_start_index = max_ind;
filter_output_vec = zeros(1,length(test_freq_vec));
for i = 1:length(test_freq_vec)
    filter = exp(2*pi*1j*test_freq_vec(i)*t);
    signal_section = agc_raw_rx_sig_after_cal...
        (signal_start_index+(i-1)*single_freq_test_samp:...
        signal_start_index+(i)*single_freq_test_samp-1);
    filter_output_rx = abs(filter*signal_section);
    filter_output_rx_vec(i) = filter_output_rx;
end
filter_output_rx_vec = filter_output_rx_vec.*1/max(filter_output_rx_vec);
figure(4);
plot(test_freq_vec,filter_output_rx_vec);

