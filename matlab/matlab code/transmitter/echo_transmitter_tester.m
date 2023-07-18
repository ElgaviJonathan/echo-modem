clear;
clc;

sample_rate = 44100;

% data_bits = randi([0 1],32,1);
% data_bits = ...
%     [1, 0, 1, 0, 0, 0, 0, 0,...
%      1, 1, 1, 0, 0, 1, 0, 0,...
%      0, 1, 0, 0, 0, 0, 1, 0,...
%      1, 1, 0, 0, 1, 1, 1, 0]';

device_id = randi([0 65535],1,1);
message_id = randi([0 65535],1,1);

device_id_bits = dec2bin(device_id,16) - '0';
message_id_bits = dec2bin(message_id,16) - '0';
data_bits = [device_id_bits, message_id_bits]';

[tx_sig, cw_sig, sync_sig, data_sig, encoded_bits, debug_data_bits] = echo_transmitter(data_bits);

disp("data bits =    " + num2str(data_bits'));
disp("encoded bits = " + num2str(encoded_bits));
% sound(tx_sig,sample_rate);

%% save data bits and tx audio file
% save("C:\ToDATA\audio modem project\matlab\audio recordings\echo_test_tx_signal_5-7", "data_bits", "tx_sig");
% 
% audiowrite("C:\ToDATA\audio modem project\matlab\audio recordings\matlab_echo_sig_tx_5-7.wav",tx_sig,sample_rate);
%%

% %% 
% raw_file = fileread("C:\ToDATA\audio modem project\matlab\matlab code\transmitter\codegen_testing\echo_transmitter_test\tx_stream_file.txt");
% cpp_tx_signal = str2num(raw_file);
% 
% raw_file = fileread("C:\ToDATA\audio modem project\matlab\matlab code\transmitter\codegen_testing\echo_transmitter_test\encoded_bits_file.txt");
% cpp_encoded_bits = str2num(raw_file);
% 
% raw_file = fileread("C:\ToDATA\audio modem project\matlab\matlab code\transmitter\codegen_testing\echo_transmitter_test\data_bits_file.txt");
% cpp_data_bits = str2num(raw_file);
% 
% 
% figure(5)
% plot(tx_sig);
% hold on
% plot(cpp_tx_signal);
% disp(cpp_encoded_bits == encoded_bits);

