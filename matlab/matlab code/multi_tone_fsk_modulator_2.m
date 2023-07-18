function [output_sig] = ...
    multi_tone_fsk_modulator_2(data_bits, modulation_order, freq_vec,...
    sample_rate, symbol_length_t)
%This funciton performes multi tone fsk moduation of the data bits, and
%returnd a baseband signal
% data bits must be a multiple of modulation_order, as in multi-tone fsk
% each symbol reprisents moduation_order bits.
%% for testing
% clear
% clc
% data_bits = randi([0 1],128,1);
% modulation_order = 64;
% delta_f = 125; % in Hz
% sample_rate = 44100;
% symbol_length_t = 50e-3; % 50 [ms]
% end of testing


num_of_symbols = length(data_bits)/log2(modulation_order);
symbol_length_samp = round(symbol_length_t*sample_rate);
t = (0:symbol_length_samp-1)/sample_rate;

%% construct the output signal
output_sig = [];
% output_sig = zeros(1,num_of_symbols*round(symbol_length_samp));

for symbol_start = 1:log2(modulation_order):(length(data_bits))
    data_bits_block = data_bits(symbol_start:symbol_start+log2(modulation_order)-1);
    data_symbol = 2.^(log2(modulation_order)-1:-1:0)*data_bits(symbol_start:symbol_start+log2(modulation_order)-1);
    gray_data_symbol = dec2gray(data_symbol, log2(modulation_order));
    selected_freq = freq_vec(gray_data_symbol+1);
    symbol_sig = sin(2*pi*selected_freq*t);
    output_sig = [output_sig symbol_sig];
end

% adjust amplitude of signal to standard
output_sig = agc_amplitude(output_sig);

% remove all extream peaks - to clean and prevent clipping (magic number)
output_sig(output_sig>5.5) = 5.5;
output_sig(output_sig<-5.5) = -5.5;

output_sig = output_sig.*1/(max(abs(output_sig))); % normalise ampiltude to 1s

% plot_complex(baseband_sig,1);
% plot_fft_axis(baseband_sig,sample_rate,2);

end