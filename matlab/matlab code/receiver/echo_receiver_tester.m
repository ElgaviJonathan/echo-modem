clear
clc
%% user params
EbNo = 25;
freq_offset = 0;
phase_offset = 0;  
use_audio_recording = 0;
use_matlab_signal = 1;
%% constants
modulation_order = 8;
sample_rate = 44100;
bits_per_symbol = log2(modulation_order);
samples_per_symbol = 1500;
buffer_size = 2^15;
buffer_step_size = 2^12;
rs_n = 18;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
rs_k = 6;     % Message length (in gf symbols)
rs_m = 6;
rs_coding_rate = rs_k/rs_n;
interleaver_size_rs_blocks = 1;
repetition_code_mode = true; % use repetitoin code to maximize data recovery
if (repetition_code_mode  == true) % if repetition code is used, all interleaver blocks are identical.
    data_block_size_bits = rs_m*rs_k;
else
    data_block_size_bits = rs_m*rs_k*interleaver_size_rs_blocks;
end
data_block_size_symbols = data_block_size_bits/log2(modulation_order);
data_block_size_samples = data_block_size_symbols*samples_per_symbol;

%% load input signal
% load('double_detection_rx_signal.mat')
% sig = ones(length(sig),1);
if (use_audio_recording == true)

    load('C:\ToDATA\audio modem project\matlab\audio recordings\echo_test_tx_signal_5-7.mat')
    crc_4 = comm.CRCGenerator([1 1 1 1 1]); % generate the crc used in the transmitter
    data_bits = crc_4(data_bits(1:32));
    % [raw_rx_sig, rx_sample_freq] = audioread("C:\ToDATA\audio modem project\matlab\audio recordings\recording_echo_sig_tx_11-6_sig_4.wav");
    [raw_rx_sig, rx_sample_freq] = audioread("C:\ToDATA\audio modem project\matlab\matlab code\receiver\AppDesigner echo terminal\audio_stream_files\audio_stream_6.wav");
    raw_rx_sig = raw_rx_sig(:,1); % use one channel
    rx_signal = resample(raw_rx_sig,sample_rate,rx_sample_freq);
    tx_device_id = 2.^(15:-1:0)*data_bits(1:16);
    tx_message_id = 2.^(15:-1:0)*data_bits(17:32);
    %% generate input signal
elseif (use_matlab_signal == true)
    % data_bits = randi([0 1],32,1);
    tx_device_id = randi([0 65535],1,1);
    tx_message_id = randi([0 65535],1,1);
    device_id_bits = dec2bin(tx_device_id,16) - '0';
    message_id_bits = dec2bin(tx_message_id,16) - '0';
    data_bits = [device_id_bits, message_id_bits]';
    [tx_sig, cw_sig, sync_sig, data_sig, debug_encoded_bits , debug_data_bits] = echo_transmitter(data_bits);
    crc_4 = comm.CRCGenerator([1 1 1 1 1]); % generate the crc used in the transmitter
    data_bits = crc_4(data_bits(1:32));
    % pass through channel
    snr = convertSNR(EbNo,"ebno","snr","BitsPerSymbol",bits_per_symbol,"CodingRate",rs_coding_rate,"SamplesPerSymbol",samples_per_symbol);
    awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);
    t = (0:length(tx_sig)-1)/sample_rate;
    freq_offset_tx_sig = tx_sig; %exp(2*pi*1j*(freq_offset*t + phase_offset)).*tx_sig.';
    padded_tx_sig = [zeros(1,data_block_size_samples), freq_offset_tx_sig, zeros(1,data_block_size_samples*3)];
    rx_signal = awgn_chan.step(padded_tx_sig).';
end

%% plot recording analysis

% figure(1);
% title("cw signal");
% plot(cw_sig);
% plot_fft_axis(cw_sig,sample_rate,2,1);
% 
% 
% figure(2);
% plot_fft_axis(rx_signal, sample_rate, 3 ,1);
% title("rx signal fft");


%% sync_sequence testing
% sync_sequence parameters
samples_per_sync_symbol = 256;
% sync_symbol_length_t = samples_per_sync_symbol/sample_rate;
sync_freq = 6000;
gold_code_seq_256 = [1	-1	-1	1	-1	1	-1	-1	-1	-1	1	1	-1	-1	1	1	-1	1	-1	1	-1	1	1	1	1	1	-1	1	-1	1	1	-1	-1	1	-1	1	1	-1	-1	1	-1	-1	1	1	-1	-1	-1	1	1	1	-1	1	1	1	-1	1	-1	1	1	1	-1	-1	1	-1	-1	1	-1	1	-1	1	1	-1	1	-1	1	1	-1	-1	-1	-1	1	1	1	-1	1	1	-1	1	-1	1	-1	-1	-1	-1	1	1	1	-1	-1	-1	1	-1	1	1	-1	1	1	1	1	-1	-1	-1	-1	1	-1	1	1	-1	-1	1	1	-1	1	1	1	-1	-1	-1	-1	1	1	-1	-1	1	1	-1	1	1	1	1	-1	-1	-1	-1	1	-1	-1	-1	1	1	1	-1	1	-1	-1	-1	-1	-1	-1	1	1	-1	-1	1	1	1	-1	-1	1	1	-1	1	1	-1	1	-1	1	-1	-1	1	-1	-1	1	1	1	-1	-1	-1	-1	-1	-1	1	-1	-1	-1	1	-1	-1	-1	-1	1	-1	-1	1	1	-1	1	1	-1	1	-1	-1	1	1	1	1	-1	1	1	-1	1	-1	1	1	1	1	1	1	1	-1	1	-1	-1	1	-1	1	-1	-1	-1	-1	-1	1	-1	1	-1	-1	1	-1	-1	1	1	1	-1	1	-1	-1];
sync_bits = (gold_code_seq_256+1)/2;
sync_mod_order = 16;
sync_bits_per_symbol = log2(sync_mod_order);
sync_symbol_rate = sample_rate/samples_per_sync_symbol;
reshape(sync_bits,sync_bits_per_symbol,[]);
sync_symbols = (2.^(sync_bits_per_symbol-1:-1:0))*reshape(sync_bits,sync_bits_per_symbol,[]);
% sync_sig_complex = fskmod(sync_symbols, sync_mod_order, 200, samples_per_sync_symbol, 44100);
% fsk_moder = comm.FSKModulator(sync_mod_order, 200, 'SamplesPerSymbol',samples_per_sync_symbol, 'SymbolRate', sync_symbol_rate);
% sync_sig_complex = fsk_moder(sync_symbols');
% t = (0:length(sync_sig_complex)-1)/sample_rate;
% % sync_sig = real(sync_sig_complex).*cos(2*pi*sync_freq*t) - imag(sync_sig_complex).*sin(2*pi*sync_freq*t);
% sync_sig = (real(sync_sig_complex).*cos(2*pi*sync_freq*t') - imag(sync_sig_complex).*sin(2*pi*sync_freq*t'))';
% sync_sig_2 = (real(sync_sig_complex).*cos(2*pi*sync_freq*t'+pi/2) - imag(sync_sig_complex).*sin(2*pi*sync_freq*t'+pi/2))';


cpfsk_moder = comm.CPFSKModulator(sync_mod_order,"ModulationIndex",1,"BitInput",true,"SamplesPerSymbol",samples_per_sync_symbol);
sync_sig_complex = cpfsk_moder(sync_bits');

t = (0:length(sync_sig_complex)-1)/sample_rate;
sync_sig = (real(sync_sig_complex).*cos(2*pi*sync_freq*t') - imag(sync_sig_complex).*sin(2*pi*sync_freq*t'))';
sync_sig_2 = (real(sync_sig_complex).*cos(2*pi*sync_freq*t'+pi/2) - imag(sync_sig_complex).*sin(2*pi*sync_freq*t'+pi/2))';


figure(1);
clf(1);
hold on;
% debug_conv = conv(flip(sync_sig), rx_signal);
debug_conv = abs(conv(rx_signal, flip(sync_sig))) + abs(conv(rx_signal, flip(sync_sig_2)));
plot(debug_conv(length(sync_sig):end));
hold off;



%% seperate signal into chuncks for receiver input buffer stepper:
padded_sig = [rx_signal; zeros(buffer_step_size - mod(length(rx_signal),buffer_step_size),1)];% pad to length
sig_matrix = reshape(padded_sig,buffer_step_size,[]);

%% call receiver function, feed one buffer step each iteration

%% create receiver input struct, for code generation
rec = struct( ...
    'raw_buffer',complex(zeros(buffer_size,1)),... % raw signal memory window used by the receiver
    'buffer',complex(zeros(buffer_size,1)),... % processed signal memory window used by the receiver
    'sm_state',0,... % current state machine state of the receiver
    'sm_log', [],... %history of all previous states of the receiver
    'index',1,... % tracker for last point where the previos section or block was found
    'agc_factor',1,... % agc factor for normalising signal power
    'sync_attempts',0,... % limit to attempts to find sync after a signal was detected
    'accumulated_encoded_bits',[],... % demodulated encoded bits (matrix of possible demodulations), to allow for partial demodulation of interleaver blocks
    'step_num_for_debug',0 ...
    );

%call once for initilization
[output_bits, error_vector, logged_state, rec_obj] = echo_receiver(sig_matrix(:,1), rec, 1);
full_output_bits = [];
for buffer_step_num = 2:(length(padded_sig)/buffer_step_size)
    [output_bits, error_vector, logged_state, rec_obj] = echo_receiver(sig_matrix(:,buffer_step_num), rec_obj, 0);
    disp("sm trace " + num2str(rec_obj.sm_log));
    full_output_bits = [full_output_bits; output_bits];
end
data_symbols = reshape(data_bits,bits_per_symbol,[])'*(2.^((bits_per_symbol-1):-1:0))';
rx_symbols = reshape(full_output_bits,bits_per_symbol,[])'*(2.^((bits_per_symbol-1):-1:0))';
full_output_bits = [full_output_bits; zeros(length(data_bits) - length(full_output_bits),1)];

crc_4 = comm.CRCGenerator([1 1 1 1 1]);
expected_crc = crc_4(full_output_bits(1:32));
expected_crc = expected_crc(33:36);
rx_crc = full_output_bits(33:36);
crc_flag = (sum(rx_crc==expected_crc)==4);
disp("errors: " + num2str(sum(full_output_bits~=data_bits)) + " crc: " + num2str(crc_flag));
rx_device_id = 2.^(15:-1:0)*full_output_bits(1:16);
rx_message_id = 2.^(15:-1:0)*full_output_bits(17:32);
disp("tx device ID: " + num2str(tx_device_id) + " tx message ID: " + num2str(tx_message_id));
disp("rx device ID: " + num2str(rx_device_id) + " rx message ID: " + num2str(rx_message_id));

