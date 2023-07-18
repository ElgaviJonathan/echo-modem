%%
clear;
clc;


%% define channel parameters
EbNo_vec = 0:15;
freq_offset_vec = 0;
num_of_rs_blocks = 1;
error_limit = 1e3;
bit_limit = 1e5;
use_rs_coding = false;

%% baseband signal parameters
modulation_order = 1024;
symbol_rate = 10;
sample_rate = 40960;
modulaiton_index = 1;


rs_m = 8;      % Number of bits per symbol
rs_n = 128;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
rs_k = 64;     % Message length (in gf symbols)
rs_coding_rate = rs_k/rs_n;
rs_uncoded_block_size_bits = rs_m*rs_k;
rs_coded_block_size_bits = rs_m*rs_n;
rs_prim_poly = [1 0 0 0 1 1 1 0 1];


bits_per_symbol = log2(modulation_order);
bit_rate = log2(modulation_order)*symbol_rate;
samples_per_symbol = sample_rate/symbol_rate;
delta_f = modulaiton_index*symbol_rate;
spectral_bandwidth = delta_f*modulation_order;
sampling_bandwidth = sample_rate/2;
fft_bin_size = sampling_bandwidth/samples_per_symbol; % assuming fft test for each symbol

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


%% define rs encoder

rs_encoder = comm.RSEncoder(rs_n,rs_k,'BitInput',true,'PrimitivePolynomialSource','Property','PrimitivePolynomial',rs_prim_poly);

%% define rs decoder
rs_decoder = comm.RSDecoder(rs_n,rs_k,PrimitivePolynomialSource="Property",PrimitivePolynomial=rs_prim_poly,BitInput=true);

%% main ber testing loop
BER_vec = zeros(1,length(EbNo_vec));
raw_BER_vec = zeros(1,length(EbNo_vec));
for EbNo_idx = 1:length(EbNo_vec)
    total_errors = 0;
    total_raw_errors = 0;
    total_bits = 0;
    itter_cntr = 0;
    while (total_errors< error_limit && total_bits< bit_limit)
        itter_cntr = itter_cntr+1;

        %% generate data bits
%         data_bits = randi([0 1],rs_uncoded_block_size_bits*num_of_rs_blocks,1);
        data_bits = randi([0 1],1000,1);


        %% encode data bits
        if (use_rs_coding == true)
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
        if (use_rs_coding == true)
            coding_rate = rs_coding_rate;
        else
            coding_rate = 1;
        end
        snr = convertSNR(EbNo_vec(EbNo_idx),"ebno","snr","BitsPerSymbol",bits_per_symbol,"CodingRate",coding_rate,"SamplesPerSymbol",samples_per_symbol);
        awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);

        rx_signal = awgn_chan.step(tx_signal);

        %% downconvert siganl to baseband

        t = (0:length(passband_sig)-1)/sample_rate;
        unfiltered_rx_baseband = rx_signal.*exp(2*pi*1j*center_freq*t)';
        rx_baseband = 2.*lowpass(unfiltered_rx_baseband, (spectral_bandwidth/2) ,sample_rate);

        %% demodulate signal
        demoded_bits = fsk_demod.step(rx_baseband);
        fsk_demod.release();

        %% decode via rs
        if(use_rs_coding == true)
            decoded_bits = rs_decoder.step(demoded_bits);
            release(rs_decoder);
        else
            decoded_bits = demoded_bits;
        end

        %% calculate error rate
        raw_errors = sum(demoded_bits ~= encoded_bits);
        errors = sum(decoded_bits ~= data_bits);
        ber = errors/ length(data_bits);
        total_bits = total_bits + length(data_bits);
        total_errors = total_errors + errors;
        total_raw_errors = total_raw_errors + raw_errors;
        %% display logs
        disp("EbNo = " + num2str(EbNo_vec(EbNo_idx)) + ...
            " (actual snr = " + num2str(snr) + ")" + ...
            " itter = " + num2str(itter_cntr) + ...
            " errors = " + num2str(errors) + " ("+ num2str((total_errors/error_limit)*100) +"%)" +......
            " raw errors = " + num2str(raw_errors) + ...
            " total bits = " + num2str(total_bits) + " ("+ num2str((total_bits/bit_limit)*100) +"%)"...
        );
    end
    disp("EbNo = " + num2str(EbNo_vec(EbNo_idx)) + ...
        " ber = " + num2str(total_errors/total_bits));
    BER_vec(EbNo_idx) = total_errors/total_bits;
    raw_BER_vec(EbNo_idx) = total_raw_errors/total_bits;
end

figure(1)
semilogy(EbNo_vec,BER_vec);
grid on;
hold on;