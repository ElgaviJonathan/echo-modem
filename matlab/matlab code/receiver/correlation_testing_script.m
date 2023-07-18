clear;
clc;

%%
EbNo_vec = 50;
freq_offset_vec = 0:100;

sig_len_t = 0.0499;
sample_rate = 44100;


% %% constants
% 
% modulation_order = 2;
% symbol_rate = 2205;
% sample_rate = 44100;
% modulaiton_index = 1;
% bits_per_symbol = log2(modulation_order);
% bit_rate = log2(modulation_order)*symbol_rate;
% samples_per_symbol = sample_rate/symbol_rate;
% delta_f = modulaiton_index*symbol_rate;
% spectral_bandwidth = delta_f*modulation_order;
% sampling_bandwidth = sample_rate/2;
% 
% siganl_len_samp = sig_len_t*sample_rate;
% symbol_len = (siganl_len_samp/samples_per_symbol)/log2(modulation_order);
% data_bits = randi([0 modulation_order-1], symbol_len);
% test_signal = fskmod(data_bits,modulation_order,delta_f,samples_per_symbol,sample_rate);

%%
corr_vec = zeros(length(freq_offset_vec), length(EbNo_vec));
for freq_offset_index = 1:length(freq_offset_vec)
    for EbNo_index = 1:length(EbNo_vec)
        snr = convertSNR(EbNo_vec(EbNo_index),"ebno","snr","BitsPerSymbol",bits_per_symbol,"CodingRate",rs_coding_rate,"SamplesPerSymbol",samples_per_symbol);
        awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);
        t = (0:length(baseband_sync_sig)-1)/sample_rate;
        freq_offset_sig = exp(2*pi*1j*freq_offset_vec(freq_offset_index)*t).*baseband_sync_sig.';
        noisy_signal = awgn_chan.step(freq_offset_sig).';
        corr_vec(freq_offset_index, EbNo_index) = abs(noisy_signal.'*conj(baseband_sync_sig));
    end
end

plot(EbNo_vec,corr_vec);
