function [demoded_bits] = ...
    demodulate_fsk_async(input_signal, modulation_order, symbol_rate, modulation_index, sample_rate)
% This funciton demodulates the input fsk signal
%% for debug
% clear
% clc
% modulation_order = 4;
% bits_per_symbol = log2(modulation_order);
% symbol_rate = 4096;
% modulation_index = 1;
% sample_rate = 40960;
% fsk_mod_data = comm.FSKModulator(ModulationOrder = modulation_order,...
%     FrequencySeparation = modulation_index*symbol_rate,...
%     SymbolRate = symbol_rate,...
%     SamplesPerSymbol = sample_rate/symbol_rate, ...
%     BitInput = true);
% data_bits = randi([0 1],512,1);
% data_symbols = reshape(data_bits,bits_per_symbol,[])'*(2.^((bits_per_symbol-1):-1:0))';
% input_signal = fsk_mod_data.step(data_bits);
% fsk_mod_data.release();
%%

samples_per_symbol = sample_rate/symbol_rate;

t = (0:samples_per_symbol-1)/sample_rate;
delta_f = symbol_rate*modulation_index;
symbol_freqs = (0:delta_f:delta_f*(modulation_order-1))-(delta_f*(modulation_order-1)/2);
fsk_filter_bank = exp(2*pi*1j*symbol_freqs'*t);
% the filters are arranged as follows:
% [sym1_first_sample sym1_second_sample  .   sym1_last_sample  ]
% [sym2              .                   .   .                 ]
% [.                 .                   .   .                 ]
% [symM_first_sample symM_second_sample  .   symM_last_sample  ]
rx_symbols_mat = reshape(input_signal, samples_per_symbol, []);
% the symbols are arranged as follows:
% [sym1_first_sample sym2_first_sample  .   symN_first_sample   ]
% [sym1              .                  .   .                   ]
% [sym1              .                  .   .                   ]
% [sym1_last_sample  sym2_last_sample   .   symN_last_sample    ]

filtere_res_mat = fsk_filter_bank*rx_symbols_mat; % run mached filter on all symbols
filtere_res_mat_abs = abs(filtere_res_mat); % async receiver
[~, symbol_indexes] = max(filtere_res_mat_abs); % select optimal match
% re-map gray mapping
demoded_symbols = zeros(length(symbol_indexes),1);
demoded_symbols(symbol_indexes==4) = 2;%2
demoded_symbols(symbol_indexes==2) = 1;%1
demoded_symbols(symbol_indexes==1) = 0;%0
demoded_symbols(symbol_indexes==3) = 3;%3
demoded_bits = reshape((dec2bin(demoded_symbols) - '0')',[],1);


end