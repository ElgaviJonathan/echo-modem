%%
clear;
clc;


%% define channel parameters
EbNo_vec = 0:8;
freq_offset_vec = 0;
error_limit = 1e4;
bit_limit = 1e6;
data_bits_length = 60; % must be multiple of mod order (= bit rate)
use_rs_coding = false;

z_threshold_vec = 4:8;
%% baseband signal parameters
modulation_order = 64;
symbol_length_t = 50e-3;
symbol_rate = 1/symbol_length_t;
sample_rate = 44100;

% rs parameters
% rs_m = 8;      % Number of bits per symbol
% rs_n = 128;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
% rs_k = 64;     % Message length (in gf symbols)
% rs_coding_rate = rs_k/rs_n;
% rs_uncoded_block_size_bits = rs_m*rs_k;
% rs_coded_block_size_bits = rs_m*rs_n;
% rs_prim_poly = [1 0 0 0 1 1 1 0 1];


bits_per_symbol = modulation_order;
bit_rate = bits_per_symbol*symbol_rate;
samples_per_symbol = sample_rate/symbol_rate;

%% rs defenitions
if (use_rs_coding)
    % define rs encoder
    rs_encoder = comm.RSEncoder(rs_n,rs_k,'BitInput',true,'PrimitivePolynomialSource','Property','PrimitivePolynomial',rs_prim_poly);

    % define rs decoder
    rs_decoder = comm.RSDecoder(rs_n,rs_k,PrimitivePolynomialSource="Property",PrimitivePolynomial=rs_prim_poly,BitInput=true);

end
%% main ber testing loop
BER_vec = zeros(length(EbNo_vec), length(z_threshold_vec));
for EbNo_index = 1:length(EbNo_vec)
    for z_index = 1:length(z_threshold_vec)
        total_errors = 0;
        total_bits = 0;
        itter_cntr = 0;
        while (total_errors< error_limit && total_bits< bit_limit)
            itter_cntr = itter_cntr+1;

            %% generate data bits
            data_bits = randi([0 1],data_bits_length,1);


            %% encode data bits
            if (use_rs_coding == true)
                encoded_bits = rs_encoder.step(data_bits);
                release(rs_encoder);
            else
                encoded_bits = data_bits;
            end

            %% modualte signal
            [tx_signal, used_frequencies, ~] = multi_tone_fsk_modulator(encoded_bits,modulation_order,sample_rate,symbol_length_t);

            %% channel
            if (use_rs_coding == true)
                coding_rate = rs_coding_rate;
            else
                coding_rate = 1;
            end
            snr = convertSNR(EbNo_vec(EbNo_index),"ebno","snr","BitsPerSymbol",bits_per_symbol,"CodingRate",coding_rate,"SamplesPerSymbol",samples_per_symbol);
            awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);

            rx_signal = awgn_chan.step(tx_signal);


            %% demodulate signal
            demoded_bits = multi_tone_fsk_demodulator...
                (rx_signal,modulation_order,sample_rate,samples_per_symbol...
                ,used_frequencies, z_threshold_vec(z_index));

            %% decode via rs
            if(use_rs_coding == true)
                decoded_bits = rs_decoder.step(demoded_bits);
                release(rs_decoder);
            else
                decoded_bits = demoded_bits;
            end

            %% calculate error rate
            errors = sum(decoded_bits ~= data_bits);
            ber = errors/ length(data_bits);
            total_bits = total_bits + length(data_bits);
            total_errors = total_errors + errors;


            %% display logs
            disp("EbNo = " + num2str(EbNo_vec(EbNo_index)) + ...
                " (actual snr = " + num2str(snr) + ")" + ...
                " z threshold = " + num2str(z_threshold_vec(z_index)) + ...
                " itter = " + num2str(itter_cntr) + ...
                " errors = " + num2str(errors) + " ("+ num2str((total_errors/error_limit)*100) +"%)" +......
                " itter ber = " + num2str(errors/length(data_bits)) + ......
                " total bits = " + num2str(total_bits) + " ("+ num2str((total_bits/bit_limit)*100) +"%)"...
                );
        end

        disp("EbNo = " + num2str(EbNo_vec(EbNo_index)) + ...
            " ber = " + num2str(total_errors/total_bits) + ...
            " z threshold = " + num2str(z_threshold_vec(z_index)));
        BER_vec(EbNo_index, z_index) = total_errors/total_bits;
    end
end

figure(1)
clf(1)  
% semilogy(EbNo_vec,BER_vec);
grid on;
hold on;