function [output_sig] = fsk_8_level_64_tone_modulator(data_bits, freq_vec,...
    sample_rate, symbol_length_t)%#codegen
% this funciton wrapes the general multi tone fsk modulator, for a
% specific implementation of 8 symbols based on 64 provided frequencies. 



%% parameters
num_of_tones = 64;
mod_level = 3;
num_of_symbols = length(data_bits)/mod_level; % modulation order 8
% symbol_length_samp = symbol_length_t*sample_rate;
% t = (0:symbol_length_samp-1)/sample_rate;

%% convert data bits to tone map
data_symbols = 2.^(mod_level-1:-1:0)*reshape(data_bits,mod_level,[]);
% convert to gray encoding to minimize errors
gray_data_symbols = dec2gray(data_symbols,mod_level)';
% generate bit pattern based on selected symbol:
% (0 : 000) 0 - 10000000100000001000000010000000....
% (1 : 001) 1 - 01000000010000000100000001000000....
% (3 : 011) 2 - 00100000001000000010000000100000....
% (2 : 010) 3 - 00010000000100000001000000010000....
% (6 : 110) 4 - 00001000000010000000100000001000....
% (7 : 111) 5 - 00000100000001000000010000000100....
% (5 : 101) 6 - 00000010000000100000001000000010....
% (4 : 100) 7 - 00000001000000010000000100000001....

data_symbols_index_form = gray_data_symbols+1;
tone_mapping_mat = zeros(num_of_symbols,num_of_tones)';
for symbol_index = 1:num_of_symbols
    tone_mapping_mat(data_symbols_index_form(symbol_index):8:end,symbol_index) = 1;
end
tone_mapping_bits = reshape(tone_mapping_mat,1,[]);

%% modulate the signal through the general multi tone fsk modem:
[output_sig] = multi_tone_fsk_modulator(tone_mapping_bits, num_of_tones, freq_vec,...
    sample_rate, symbol_length_t);




end