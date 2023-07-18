clear;
clc;
%%
EbNo_vec = 0:20;
freq_offset_vec = 0;

%% constants

rs_uncoded_block_size_bits = 512;
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
buffer_size = 8192;
buffer_step_size = 1024;
rs_m = 8;      % Number of bits per symbol
rs_n = 128;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
rs_k = 64;     % Message length (in gf symbols)
rs_coding_rate = rs_k/rs_n;
cw_length_t = 100e-3; % in [ms]
cw_length_samp = cw_length_t*sample_rate;
%%

z_score_vec = zeros(1, length(EbNo_vec));
for EbNo_index = 1:length(EbNo_vec)
    snr = convertSNR(EbNo_vec(EbNo_index),"ebno","snr","BitsPerSymbol",bits_per_symbol,"CodingRate",rs_coding_rate,"SamplesPerSymbol",samples_per_symbol);
    awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);
    sig = ones(cw_length_samp/2-1,1);
    noisy_sig = awgn_chan(sig);
    signal_fft = fftshift(fft(noisy_sig));
    fft_mean = mean(abs(signal_fft));
    fft_std = std(abs(signal_fft));
    [fft_max_val, fft_max_ind] = max(abs(signal_fft));
    z_score = (fft_max_val-fft_mean)/fft_std;
    z_score_vec(EbNo_index) = z_score;
end

plot(EbNo_vec,z_score_vec);
