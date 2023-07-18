%% constants
modulation_order = 4;
symbol_rate = 4096;
sample_rate = 40960;
bits_per_symbol = log2(modulation_order);
bit_rate = log2(modulation_order)*symbol_rate;
samples_per_symbol = sample_rate/symbol_rate;

rs_m = 8;      % Number of bits per symbol
rs_n = 128;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
rs_k = 64;     % Message length (in gf symbols)
rs_coding_rate = rs_k/rs_n;



%%
t = 0:0.01:10;
sig = [complex(ones(1,length(t)))];%exp(2*pi*1j*1*t);complex(zeros(1,length(t))), 
EbNo = 0;
snr = convertSNR(EbNo,"ebno","snr","BitsPerSymbol",bits_per_symbol,"CodingRate",rs_coding_rate,"SamplesPerSymbol",samples_per_symbol);
awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);
noisy_sig = awgn_chan.step(sig).';

raw_sig_power = sum(abs(sig).^2)/length(sig);
sig_power = sum(abs(noisy_sig).^2)/length(noisy_sig);


sig_fft = fftshift(fft(noisy_sig));
[fft_max_val, fft_max_ind] = max(abs(sig_fft));
cw_signal_power = sum(abs(sig_fft(fft_max_ind)/length(sig_fft)));

