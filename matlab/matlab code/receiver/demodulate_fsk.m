function [demodulated_bits] = demodulate_fsk(data_sig, modulation_order, symbol_rate, modulaiton_index) %#codegen
%This function demodulates the input signal, assuming a modulation of 16
%fsk


% % payload parameters
% modulation_order = 16;
% bits_per_symbol = log2(modulation_order);
% symbol_rate = 4096;
% modulaiton_index = 1;
sample_rate = 40960; % requiers regeneration to change


fsk_demod = comm.FSKDemodulator(ModulationOrder = modulation_order,...
    FrequencySeparation = modulaiton_index*symbol_rate,...
    SymbolRate = symbol_rate,...
    SamplesPerSymbol = sample_rate/symbol_rate,BitOutput=true);


demodulated_bits = fsk_demod.step(data_sig);
release(fsk_demod);


end