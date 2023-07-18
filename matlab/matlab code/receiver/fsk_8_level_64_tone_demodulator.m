function [rx_bits_mat] = fsk_8_level_64_tone_demodulator(input_signal, freq_vec,...
    sample_rate, symbol_length_t)%#codegen
% this funciton demodulates multi tone fsk modulator, for a
% specific implementation of 8 symbols based on 64 provided frequencies.
% The funciton returns a matrix of possible demodulations, to be tested
% using the RS decoding for the best result

%% for testing
% clear
% clc
% sample_rate = 44100;
% symbol_length_samp = 1024; % symbol_length_t*sample_rate;
% symbol_length_t = symbol_length_samp/sample_rate;
%
% freq_vec = [5023	5101	5171	5237	5297	5351	5419	5503	5581	5659	5737	5807	5869	5927	6011	6079	6143	6217	6301	6367	6427	6491	6553	6619	6679	6737	6803	6883	6961	7043	7121	7187	7253	7309	7393	7459	7537	7607	7687	7759	7823	7883	7951	8017	8093	8167	8233	8297	8377	8461	8543	8609	8681	8747	8807	8867	8941	9007	9067	9151	9221	9283	9349	9421]';
%
% data_bits = randi([0 1],120,1);
%
% input_signal = fsk_8_level_64_tone_modulator(data_bits, freq_vec,...
%     sample_rate, symbol_length_t);

% end of testing
%% parameters
num_of_tones = 64;
mod_level = 3;
multi_tone_order = num_of_tones / 2^mod_level; % amount of repeded tones in the modulation
symbol_length_samp = round(symbol_length_t*sample_rate);
num_of_symbols = length(input_signal)/symbol_length_samp;
% t = (0:symbol_length_samp-1)/sample_rate;

%% reshape signal to proper size

% z_scores = [];

symbol_signal_mat = reshape(input_signal, round(symbol_length_samp), []); % each column is 1 symbol
t = (0:symbol_length_samp-1)/sample_rate;
filter_freq_vec = freq_vec;
filter_bank = exp(2*pi*1j*filter_freq_vec*t);
demoded_symbols_possible_combinatons_mat = zeros(2^multi_tone_order-1, num_of_symbols);
for i = 1:num_of_symbols
    % symbol_filter_outputs = abs(filter_bank*symbol_signal_mat(:,i));
    filter_outputs = filter_bank*symbol_signal_mat(:,i);
    symbol_filter_outputs = real(filter_outputs).^2 + imag(filter_outputs).^2;

    %% return all posible combinations of the filter outputs, total of 8 possible fsk signals
    % 8^2 = 256
    symbol_filter_outputs_mat = reshape(symbol_filter_outputs,8,[]);
    binary_index_mat = dec2bin(1:2^multi_tone_order-1) - '0';
    binary_index_mat_with_weights = [sum(binary_index_mat,2), binary_index_mat];
    binary_index_mat = sortrows(binary_index_mat_with_weights, 1, "descend");
    binary_index_mat = binary_index_mat(:,2:end);
    optional_demodulatd_symbol_vec = zeros(1,2^multi_tone_order-1);
    for j = 1:2^multi_tone_order-1
        % selected_indexs = find(binary_index_mat(j,:) == 1);
        temp_sum = sum(symbol_filter_outputs_mat(:,binary_index_mat(j,:) == 1),2);
        [~,optional_demodulatd_symbol_vec(j)] = max(temp_sum);
    end
    demoded_symbols_possible_combinatons_mat(:,i) = optional_demodulatd_symbol_vec;




end

rx_bits_mat = zeros(2^multi_tone_order-1,num_of_symbols*mod_level);
for i = 1:length(demoded_symbols_possible_combinatons_mat)
    demoded_degrayd_symbols = gray2dec(demoded_symbols_possible_combinatons_mat(i,:)-1,mod_level)';
    % correct gray mapping:
    temp = demoded_degrayd_symbols;
    temp(demoded_degrayd_symbols == 5) = 4;
    temp(demoded_degrayd_symbols == 4) = 5;
    temp(demoded_degrayd_symbols == 6) = 7;
    temp(demoded_degrayd_symbols == 7) = 6;
    demoded_degrayd_symbols = temp;
    % end of correction
    zeros_padding = zeros(mod_level - size(dec2bin(demoded_degrayd_symbols)' - '0',1), size(dec2bin(demoded_degrayd_symbols)' - '0',2));
    demoded_degrayd_bits = reshape([zeros_padding; dec2bin(demoded_degrayd_symbols)' - '0'],[],1);
    rx_bits_mat(i,:) = demoded_degrayd_bits;
end


end