%%
clear;
clc;
%% parameters
%% user defined parameters
EbNo_vec = 0:35;
freq_offset_vec = 0;
data_block_size_bits = 999;  
error_limit = 2e3;
bit_limit = 1e5;

%% constants
modulation_order = 8;
symbol_rate = 44100/1500;
sample_rate = 44100;
modulaiton_index = 1;
bits_per_symbol = log2(modulation_order);
bit_rate = log2(modulation_order)*symbol_rate;
samples_per_symbol = 1500;
symbol_length_t = samples_per_symbol/sample_rate;
delta_f = modulaiton_index*symbol_rate;



%% testing loops
ber_vec = zeros(length(EbNo_vec), length(freq_offset_vec));
for EbNo_index = 1:length(EbNo_vec)
    for freq_offset_index = 1:length(freq_offset_vec)
        total_bits = 0;
        total_errors = 0;
        itter_cntr = 0;
        while (total_errors< error_limit && total_bits< bit_limit)
            itter_cntr = itter_cntr+1;
            %% transmitter
            full_freq_vec = [9067	9214	9361	9508	9625.60000000000	9772.60000000000	9890.20000000000	10037.2000000000	10184.2000000000	10331.2000000000	10478.2000000000	10595.8000000000	10742.8000000000	10860.4000000000	11036.8000000000	11183.8000000000	11330.8000000000	11448.4000000000	11595.4000000000	11713	11830.6000000000	11977.6000000000	12124.6000000000	12271.6000000000	12389.2000000000	12536.2000000000	12653.8000000000	12800.8000000000	12918.4000000000	13036	13183	13330	13477	13624	13771	13918	14035.6000000000	14182.6000000000	14329.6000000000	14447.2000000000	14594.2000000000	14741.2000000000	14858.8000000000	15005.8000000000	15152.8000000000	15270.4000000000	15388	15535	15682	15799.6000000000	15946.6000000000	16064.2000000000	16240.6000000000	16358.2000000000	16534.6000000000	16652.2000000000	16799.2000000000	16916.8000000000	17063.8000000000	17210.8000000000	17357.8000000000	17504.8000000000	17622.4000000000	17740]';
            data_bits = randi([0 1],data_block_size_bits,1);
            % tx_sig = fskmod(data_bits,modulation_order, delta_f, samples_per_symbol, sample_rate);
            freq_vec = full_freq_vec(1:8);
            tx_sig = multi_tone_fsk_modulator_2(data_bits, modulation_order ,freq_vec, sample_rate, symbol_length_t);
            % add additional FSK data signals in difffrent frequencies
            freq_vec_1 = full_freq_vec(9:16);
            tx_sig_interf_1 = multi_tone_fsk_modulator_2(data_bits, modulation_order ,freq_vec_1, sample_rate, symbol_length_t);
            freq_vec_2 = full_freq_vec(17:24);
            tx_sig_interf_2 = multi_tone_fsk_modulator_2(data_bits, modulation_order ,freq_vec_2, sample_rate, symbol_length_t);
            freq_vec_3 = full_freq_vec(25:32);
            tx_sig_interf_3 = multi_tone_fsk_modulator_2(data_bits, modulation_order ,freq_vec_3, sample_rate, symbol_length_t);
            freq_vec_4 = full_freq_vec(33:40);
            tx_sig_interf_4 = multi_tone_fsk_modulator_2(data_bits, modulation_order ,freq_vec_4, sample_rate, symbol_length_t);
            freq_vec_5 = full_freq_vec(41:48);
            tx_sig_interf_5 = multi_tone_fsk_modulator_2(data_bits, modulation_order ,freq_vec_5, sample_rate, symbol_length_t);
            freq_vec_6 = full_freq_vec(49:56);
            tx_sig_interf_6 = multi_tone_fsk_modulator_2(data_bits, modulation_order ,freq_vec_6, sample_rate, symbol_length_t);
            freq_vec_7 = full_freq_vec(57:64);
            tx_sig_interf_7 = multi_tone_fsk_modulator_2(data_bits, modulation_order ,freq_vec_7, sample_rate, symbol_length_t);

            tx_sig_sum = tx_sig + ...
                tx_sig_interf_1 + ...
                tx_sig_interf_2 + ...
                tx_sig_interf_3 + ...
                tx_sig_interf_4 + ...
                tx_sig_interf_5 + ...
                tx_sig_interf_6 + ...
                tx_sig_interf_7;
            tx_sig_sum = tx_sig_sum.*1/8;%(max(abs(tx_sig_sum))); % normalise ampiltude to 1s
            % tx_sig_sum = tx_sig_sum.*1/2; % normalise ampiltude to 1s

            %% channel
            snr = convertSNR(EbNo_vec(EbNo_index),"ebno","snr","BitsPerSymbol",bits_per_symbol,"SamplesPerSymbol",samples_per_symbol);
            awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);
            payload_high_pass_filter = dsp.HighpassFilter("PassbandFrequency",4500,"DesignForMinimumOrder",false,"FilterOrder",32);

            t = (0:length(tx_sig)-1)/sample_rate;
            freq_offset_tx_sig = exp(2*pi*1j*freq_offset_vec(freq_offset_index)*t).*tx_sig_sum;
            rx_signal = awgn_chan.step(freq_offset_tx_sig).';
            filtered_rx_signal = payload_high_pass_filter(rx_signal);
            %% receiver
            output_bits = multi_tone_fsk_demodulator(rx_signal, modulation_order,sample_rate, samples_per_symbol, full_freq_vec, data_bits);
            errors = sum(output_bits ~= data_bits);
            total_errors   = total_errors + errors;
            total_bits = total_bits + length(data_bits);
            disp("itter " + num2str(itter_cntr) ...
                + " EbNo " + num2str(EbNo_vec(EbNo_index)) ...
                + " (snr =  " + num2str(snr) + ")" ...
                + " itter ber " + num2str(errors/length(data_bits)) ...
                + " errors: " + num2str(errors) + "(" + num2str((total_errors/error_limit)*100) + "%)" ...
                + " bits: " + num2str(total_bits) + "(" + num2str((total_bits/bit_limit)*100) + "%)"...
                );

        end
        ber_vec(EbNo_index,freq_offset_index) = total_errors/total_bits;
        disp("EbNo = " + num2str(EbNo_vec(EbNo_index)) + ...
            ", freq offset = " + num2str(freq_offset_vec(freq_offset_index)) + ...
            ", BER = " + num2str(ber_vec(EbNo_index,freq_offset_index)));
    end
    figure(1);
    semilogy(EbNo_vec, ber_vec);
    grid on;
end
