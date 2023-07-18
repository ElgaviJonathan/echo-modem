function [output_signal, cw_sig, sync_sig, data_sig, encoded_bits_coder, data_bits] = echo_transmitter(data_bits) %#codejen
% This funciton acts as the transmitter of the echo modem.
% The transmitter receives data bits, and outputs an audio siganl

% define variables -
%% baseband signal parameters
sample_rate = 44100 ; % requiers regeneration to change

%% cw signal parameters - send cw on 8 frequencies
cw_len_t = 8192/44100;
cw_len_samp = cw_len_t*sample_rate;
cw_freq_options = [12e3, 14e3, 18e3];

%% payload parameters
% rs parameters
rs_n = 18;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
rs_k = 6;     % Message length (in gf symbols)
rs_m = 6;
rs_prim_poly = [1 0 0 0 0 1 1]; %dec2bin(primpoly(rs_m)) - '0';
interleaver_size_rs_blocks = 1;
expected_data_len = 32;
symbol_length_samp = 1500; % symbol_length_t*sample_rate;
symbol_length_t = symbol_length_samp/sample_rate;
symbol_rate = 1/symbol_length_t;

% freq_vec = generate_freq_vector(64,4000,18000, 100, symbol_rate);
% freq_vec = [8820	8849.40000000000	8878.80000000000	8908.20000000000	8937.60000000000	8967	8996.40000000000	9025.80000000000	9408	9437.40000000000	9466.80000000000	9496.20000000000	9525.60000000000	9555	9584.40000000000	9613.80000000000	9996	10025.4000000000	10054.8000000000	10084.2000000000	10113.6000000000	10143	10172.4000000000	10201.8000000000	10584	10613.4000000000	10642.8000000000	10672.2000000000	10701.6000000000	10731	10760.4000000000	10789.8000000000	11172	11201.4000000000	11230.8000000000	11260.2000000000	11289.6000000000	11319	11348.4000000000	11377.8000000000	11760	11789.4000000000	11818.8000000000	11848.2000000000	11877.6000000000	11907	11936.4000000000	11965.8000000000	12348	12377.4000000000	12406.8000000000	12436.2000000000	12465.6000000000	12495	12524.4000000000	12553.8000000000	12936	12965.4000000000	12994.8000000000	13024.2000000000	13053.6000000000	13083	13112.4000000000	13141.8000000000]';

%% cw signal generation
t = (0:cw_len_samp-1)/sample_rate;
cw_sig_mat = sin(2*pi*cw_freq_options'*t);
cw_sig = reshape(cw_sig_mat',1,[]);

%% fit data with zeros for encoding
if (length(data_bits) > expected_data_len) % chop to size
%     disp("input data bits too large")
    data_bits = data_bits(1:expected_data_len);
end
if(length(data_bits) < expected_data_len) % pad to size
%     disp("input data bits too small")
    data_bits = [data_bits; zeros(expected_data_len-length(data_bits),1)];
end
crc_4 = comm.CRCGenerator([1 1 1 1 1]);
data_bits_w_crc = crc_4(data_bits); % add 4 bits for error detection, total of 36

%% encode via rs
rs_encoder = comm.RSEncoder(rs_n,rs_k,'BitInput',true,'PrimitivePolynomialSource','Property','PrimitivePolynomial',rs_prim_poly);
encoded_bits = zeros(1,rs_n*rs_m);
encoded_bits(1:rs_n*rs_m) = rs_encoder.step(data_bits_w_crc);
release(rs_encoder);
% interleave rs symbols - when interleaver block is larger than 1 rs block 
% rs_symbols = 2.^(rs_m-1:-1:0)*reshape(encoded_bits, rs_m, []);
% interleaved_rs_symbols = matintrlv(rs_symbols,interleaver_size_rs_blocks, rs_n);
% interleaved_encoded_bits = reshape(dec2bin(interleaved_rs_symbols,3)' - '0',1,[]);

% for code geneartion:
encoded_bits_coder = encoded_bits(1:rs_n*rs_m);
%% modualte signal
% data_sig = fsk_8_level_64_tone_modulator(encoded_bits_coder, freq_vec,...
%     sample_rate, symbol_length_t);
data_sig = cpfsk_8_level_64_tone_modulator(encoded_bits_coder,...
    sample_rate, symbol_length_samp);
%% fsk sync
samples_per_sync_symbol = 256;
% sync_symbol_length_t = samples_per_sync_symbol/sample_rate;
sync_freq = 6000;

gold_code_seq_256 = [1	-1	-1	1	-1	1	-1	-1	-1	-1	1	1	-1	-1	1	1	-1	1	-1	1	-1	1	1	1	1	1	-1	1	-1	1	1	-1	-1	1	-1	1	1	-1	-1	1	-1	-1	1	1	-1	-1	-1	1	1	1	-1	1	1	1	-1	1	-1	1	1	1	-1	-1	1	-1	-1	1	-1	1	-1	1	1	-1	1	-1	1	1	-1	-1	-1	-1	1	1	1	-1	1	1	-1	1	-1	1	-1	-1	-1	-1	1	1	1	-1	-1	-1	1	-1	1	1	-1	1	1	1	1	-1	-1	-1	-1	1	-1	1	1	-1	-1	1	1	-1	1	1	1	-1	-1	-1	-1	1	1	-1	-1	1	1	-1	1	1	1	1	-1	-1	-1	-1	1	-1	-1	-1	1	1	1	-1	1	-1	-1	-1	-1	-1	-1	1	1	-1	-1	1	1	1	-1	-1	1	1	-1	1	1	-1	1	-1	1	-1	-1	1	-1	-1	1	1	1	-1	-1	-1	-1	-1	-1	1	-1	-1	-1	1	-1	-1	-1	-1	1	-1	-1	1	1	-1	1	1	-1	1	-1	-1	1	1	1	1	-1	1	1	-1	1	-1	1	1	1	1	1	1	1	-1	1	-1	-1	1	-1	1	-1	-1	-1	-1	-1	1	-1	1	-1	-1	1	-1	-1	1	1	1	-1	1	-1	-1];

sync_bits = (gold_code_seq_256+1)/2;
mod_order = 16;
sync_bits_per_symbol = log2(mod_order);
sync_symbol_rate = sample_rate/samples_per_sync_symbol;
reshape(sync_bits,sync_bits_per_symbol,[]);
sync_symbols = (2.^(sync_bits_per_symbol-1:-1:0))*reshape(sync_bits,sync_bits_per_symbol,[]);
% sync_sig_complex = fskmod(sync_symbols, mod_order, 200, samples_per_sync_symbol, 44100);
% fsk_moder = comm.FSKModulator(mod_order, 200, 'SamplesPerSymbol',samples_per_sync_symbol, 'SymbolRate', sync_symbol_rate);
% sync_sig_complex = fsk_moder(sync_symbols');
cpfsk_moder = comm.CPFSKModulator(mod_order,"ModulationIndex",1,"BitInput",true,"SamplesPerSymbol",samples_per_sync_symbol);
sync_sig_complex = cpfsk_moder(sync_bits');

t = (0:length(sync_sig_complex)-1)/sample_rate;
sync_sig = (real(sync_sig_complex).*cos(2*pi*sync_freq*t') - imag(sync_sig_complex).*sin(2*pi*sync_freq*t'))';


%% combine all sections
output_signal = [cw_sig, sync_sig, data_sig];


end