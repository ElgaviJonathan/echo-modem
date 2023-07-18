%%
clear;
clc;
%% parameters
%% user defined parameters
EbNo_vec = 8:15;
freq_offset_vec = 0;
num_of_rs_blocks = 1;
error_limit = 1e3;
bit_limit = 1e5;
use_passband_conversion = true;
passband_freq = 10e3;

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
            data_bits = randi([0 1],rs_uncoded_block_size_bits*num_of_rs_blocks,1);
            tx_sig = echo_transmitter(data_bits, use_passband_conversion ,passband_freq);
            % add zeros to start
            tx_sig = [zeros(buffer_step_size*3, 1); tx_sig];

            %% channel
            snr = convertSNR(EbNo_vec(EbNo_index),"ebno","snr","BitsPerSymbol",bits_per_symbol,"CodingRate",rs_coding_rate,"SamplesPerSymbol",samples_per_symbol);
            awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);

            t = (0:length(tx_sig)-1)/sample_rate;
            freq_offset_tx_sig = exp(2*pi*1j*freq_offset_vec(freq_offset_index)*t).*tx_sig.';
            rx_signal = awgn_chan.step(freq_offset_tx_sig).';

            %% receiver
            % seperate signal into chuncks for receiver input buffer stepper:
            padded_rx_sig = [rx_signal; zeros(buffer_step_size - mod(length(rx_signal),buffer_step_size),1)];% pad to length
            rx_sig_matrix = reshape(padded_rx_sig,1024,[]);
            %call once for initilization
            [output_bits, error_vector, logged_state, rec_obj] = echo_receiver(rx_sig_matrix(:,1), use_passband_conversion ,passband_freq);

            for buffer_step_num = 2:(length(padded_rx_sig)/buffer_step_size)
                [output_bits, error_vector, logged_state, rec_obj] = echo_receiver(rx_sig_matrix(:,buffer_step_num), use_passband_conversion ,passband_freq, ...
                    rec_obj);
            end
            output_bits_mask = zeros(length(data_bits),1);
            output_bits_mask(1:length(output_bits)) = or(output_bits_mask(1:length(output_bits)),output_bits);
            output_bits = output_bits_mask;
            errors = sum(output_bits ~= data_bits);
            total_errors   = total_errors + errors;
            total_bits = total_bits + length(data_bits);
            %             disp("state machine log: " + num2str(rec_obj.sm_log));
            disp("itter " + num2str(itter_cntr) ...
                + " EbNo " + num2str(EbNo_vec(EbNo_index)) ...
                + " (snr =  " + num2str(snr) + ")" ...
                + " itter ber " + num2str(errors/length(data_bits)) ...
                + " errors: " + num2str(errors) + "(" + num2str((total_errors/error_limit)*100) + "%)" ...
                + " bits: " + num2str(total_bits) + "(" + num2str((total_bits/bit_limit)*100) + "%)"...
                + " sm trace " + num2str(rec_obj.sm_log) ...
                );
            %% debug point
            if (sum(rec_obj.sm_log == 2) > 1) %double detection
                save("double_detection_rx_signal","rx_signal");
            end

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
