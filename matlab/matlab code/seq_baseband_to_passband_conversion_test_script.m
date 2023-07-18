clear
clc


%% define channel parameters
EbNo = 0;
freq_offset_vec = 0;
num_of_rs_blocks = 1;
error_limit = 1e3;
bit_limit = 1e6;
use_rs_coding = true;

%% baseband signal parameters
modulation_order = 4;
symbol_rate = 4096;
sample_rate = 40960;
modulaiton_index = 1;

bits_per_symbol = log2(modulation_order);
bit_rate = log2(modulation_order)*symbol_rate;
samples_per_symbol = sample_rate/symbol_rate;
delta_f = modulaiton_index*symbol_rate;
spectral_bandwidth = delta_f*modulation_order;
sampling_bandwidth = sample_rate/2;
fft_bin_size = sampling_bandwidth/samples_per_symbol; % assuming fft test for each symbol
rs_m = 8;      % Number of bits per symbol
rs_n = 128;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
rs_k = 64;     % Message length (in gf symbols)
rs_coding_rate = rs_k/rs_n;

%%
load('gold_code_sig_2500.mat')
baseband_sig = gold_code_sig;
filtered_baseband_sig = lowpass(baseband_sig, (spectral_bandwidth/2)*1.2 ,sample_rate);

%% convert to passband
center_freq = 10e3;
start_freq = center_freq - spectral_bandwidth/2;
stop_freq = center_freq + spectral_bandwidth/2;
t = (0:length(baseband_sig)-1)/sample_rate;
passband_sig = real(baseband_sig).*cos(2*pi*center_freq*t).'-imag(baseband_sig).*sin(2*pi*center_freq*t).';%.*exp(-2*pi*1j*center_freq*t)';
% sound(real(passband_sig),sample_rate);
% save("passband tx signal", "passband_sig");
tx_signal = passband_sig;

%% loop testing
% for i = 1:1000
    %% channel
    if (use_rs_coding == true)
        coding_rate = rs_coding_rate;
    else
        coding_rate = 1;
    end
    snr = convertSNR(EbNo,"ebno","snr","BitsPerSymbol",bits_per_symbol,"CodingRate",coding_rate,"SamplesPerSymbol",samples_per_symbol);
    awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);
    rx_signal = awgn_chan.step(tx_signal);
    release(awgn_chan);
    rx_direct_baseband = awgn_chan.step(baseband_sig);
    release(awgn_chan);
    %% downconvert siganl to baseband

    t = (0:length(passband_sig)-1)/sample_rate;
    unfiltered_rx_baseband = rx_signal.*exp(2*pi*1j*center_freq*t)';
    rx_filtered_shifted_baseband = 2.*lowpass(unfiltered_rx_baseband, (spectral_bandwidth/2)*1.2 ,sample_rate);

    %% 
    figure(1)
    max(abs(conv(rx_filtered_shifted_baseband, flip(conj(gold_code_sig)))))
    plot(abs(conv(rx_filtered_shifted_baseband, flip(conj(gold_code_sig)))))
    figure(2)
    max(abs(conv(rx_direct_baseband, flip(conj(gold_code_sig)))))
    plot(abs(conv(rx_direct_baseband, flip(conj(gold_code_sig)))))
    figure(3)
    max(abs(conv(rx_filtered_shifted_baseband, flip(conj(filtered_baseband_sig)))))
    plot(abs(conv(rx_filtered_shifted_baseband, flip(conj(filtered_baseband_sig)))))
    figure(4)
    max(abs(conv(rx_direct_baseband, flip(conj(filtered_baseband_sig)))))
    plot(abs(conv(rx_direct_baseband, flip(conj(filtered_baseband_sig)))))
    
    
%     total_error_rx_filtered_baseband_baseband_sync_sig = ...
%         total_error_rx_filtered_baseband_baseband_sync_sig + max(abs(conv(rx_filtered_baseband, flip(conj(baseband_sync_sig)))));
%      total_error_rx_filtered_baseband_baseband_sync_sig = ...
%         total_error_rx_filtered_baseband_baseband_sync_sig + max(abs(conv(rx_filtered_baseband, flip(conj(baseband_sync_sig)))));
%     
    
    
    
    % end
