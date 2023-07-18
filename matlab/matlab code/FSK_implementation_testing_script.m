%% FSK implementation testing script
% this script tests posible implementations for asychroius FSK transmitter
% receiver.

%%
clear;
clc;


%% define channel parameters
EbNo_vec = 0:10;
freq_offset_vec = 0;
error_limit = 1e3;
bit_limit = 1e6;
block_size_bits = 512;
use_fec = true;

%% baseband signal parameters
modulation_order = 4;
symbol_rate = 4096;
sample_rate = 40960;
modulation_index = 1;

bits_per_symbol = log2(modulation_order);
bit_rate = log2(modulation_order)*symbol_rate;
samples_per_symbol = sample_rate/symbol_rate;
delta_f = modulation_index*symbol_rate;
spectral_bandwidth = delta_f*modulation_order;
sampling_bandwidth = sample_rate/2;
fft_bin_size = sampling_bandwidth/samples_per_symbol; % assuming fft test for each symbol


% rs(128,64,8) parameters
rs_m = 8;      % Number of bits per symbol
rs_n = 128;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
rs_k = 64;     % Message length (in gf symbols)
rs_prim_poly = [1 0 0 0 1 1 1 0 1];
rs_coding_rate = rs_k/rs_n;

%% configure modulator
fsk_mod = comm.FSKModulator(ModulationOrder = modulation_order,...
    FrequencySeparation = delta_f,...
    SymbolRate = symbol_rate,...
    SamplesPerSymbol = sample_rate/symbol_rate, ...
    BitInput = true);

%% configure demodulator
fsk_demod = comm.FSKDemodulator(ModulationOrder = modulation_order,...
    FrequencySeparation = delta_f,...
    SymbolRate = symbol_rate,...
    SamplesPerSymbol = sample_rate/symbol_rate,BitOutput=true);

%% main ber testing loop
BER_vec = zeros(1,length(EbNo_vec));
for EbNo_idx = 1:length(EbNo_vec)
    total_errors = 0;
    total_bits = 0;
    itter_cntr = 0;
    while (total_errors< error_limit && total_bits< bit_limit)
        itter_cntr = itter_cntr+1;

        %% generate data bits
        data_bits = randi([0 1],block_size_bits,1);

        %% rs encoding
        if (use_fec)
            rs_encoder = comm.RSEncoder(rs_n,rs_k,'BitInput',true,'PrimitivePolynomialSource','Property','PrimitivePolynomial',rs_prim_poly);
            encoded_bits = rs_encoder.step(data_bits);
            release(rs_encoder);
        else
            encoded_bits = data_bits;
        end
        %% modualte baseband signal
        baseband_sig = fsk_mod.step(encoded_bits);
        fsk_mod.release();

        %% convert to passband
        center_freq = 10e3;
        start_freq = center_freq - spectral_bandwidth/2;
        stop_freq = center_freq + spectral_bandwidth/2;
        t = (0:length(baseband_sig)-1)/sample_rate;
        passband_sig = real(baseband_sig).*cos(2*pi*center_freq*t).'-imag(baseband_sig).*sin(2*pi*center_freq*t).';%.*exp(-2*pi*1j*center_freq*t)';
        % sound(real(passband_sig),sample_rate);
        % save("passband tx signal", "passband_sig");
        tx_signal = passband_sig;

        %% channel
        if (use_fec)
            coding_rate = rs_coding_rate;
        else
            coding_rate = 1;
        end
        snr = convertSNR(EbNo_vec(EbNo_idx),"ebno","snr","BitsPerSymbol",data_bits_per_symbol,"CodingRate",coding_rate,"SamplesPerSymbol",samples_per_symbol);
        awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);

        rx_signal = awgn_chan.step(tx_signal);

        %% downconvert siganl to baseband

        t = (0:length(passband_sig)-1)/sample_rate;
        unfiltered_rx_baseband = rx_signal.*exp(2*pi*1j*center_freq*t)';
        rx_baseband = 2.*lowpass(unfiltered_rx_baseband, (spectral_bandwidth/2) ,sample_rate);

        %% demodulate signal
        demoded_bits = fsk_demod.step(rx_baseband);
        fsk_demod.release();

        %         demoded_bits = demodulate_fsk_async(rx_baseband, modulation_order, symbol_rate, modulation_index, sample_rate);

        %% decode via rs
        % convert bits to rs symbols
        %         demodulated_symbol_form_data = reshape(demoded_bits, rs_m, [])'*(2.^((rs_m-1):-1:0))';
        %         demodulated_gf_form_data = gf(demodulated_symbol_form_data,rs_m);
        %         % decode and convert back to bits
        %         rs_decoded_symbols = rsdec(demodulated_gf_form_data',rs_n,rs_k);
        %         decoded_bits =  reshape((dec2bin(rs_decoded_symbols.x)-'0')',[],1);
        %         if(use_rs_coding == true)
        %             decoded_bits = rs_decoder.step(demoded_bits);
        %             release(rs_decoder);
        %         else
        %             decoded_bits = demoded_bits;
        %         end
        if(use_fec)
            decoded_bits = decode_rs(demoded_bits);
        else
            decoded_bits = demoded_bits;
        end
        %% calculate error rate
        errors = sum(decoded_bits ~= data_bits);
        ber = errors/ length(data_bits);
        total_bits = total_bits + block_size_bits;
        total_errors = total_errors + errors;
        %% display logs
        disp("EbNo = " + num2str(EbNo_vec(EbNo_idx)) + ...
            " itter = " + num2str(itter_cntr) + ...
            " total errors = " + num2str(total_errors) + " ("+ num2str((total_errors/error_limit)*100) +"%)" +......
            " total bits = " + num2str(total_errors) + " ("+ num2str((total_bits/bit_limit)*100) +"%)"...
            );
    end
    disp("EbNo = " + num2str(EbNo_vec(EbNo_idx)) + ...
        " ber = " + num2str(total_errors/total_bits));
    BER_vec(EbNo_idx) = total_errors/total_bits;
end
figure(1)
semilogy(EbNo_vec,BER_vec);
grid on;
hold on;