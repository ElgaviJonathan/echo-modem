function [output_sig] = cpfsk_8_level_64_tone_modulator(data_bits,...
    sample_rate, symbol_length_samp)%#codegen
% this funciton wrapes the general multi tone fsk modulator, for a
% specific implementation of 8 symbols based on 64 provided frequencies. 
%% for testing
% clear;
% clc;
% data_bits = randi([0 1],108,1);

% sample_rate = 44100;
% symbol_length_samp = 1500; % symbol_length_t*sample_rate;
% end of test
% mod_level = 3;
% data_symbols = 2.^(mod_level-1:-1:0)*reshape(data_bits,mod_level,[]);
% % convert to gray encoding to minimize errors
% gray_data_symbols = dec2gray(data_symbols,mod_level)';
% 

symbol_length_samp = round(symbol_length_samp);
symbol_length_t = symbol_length_samp/sample_rate;
symbol_rate = 1/symbol_length_t;


freq_start_multiplier = 250;% (start freq = 300*symbol rate = 8820)
modulation_index = 2;
freq_between_channels_multiplier = 40;

channel_freqs = (1:modulation_index:8*modulation_index)-1;
freq_vec = reshape(symbol_rate*(freq_start_multiplier + repmat(channel_freqs,[8,1]) + repmat(freq_between_channels_multiplier*(0:7)',[1,8]))',1,[]);
center_freqs = symbol_rate*(freq_start_multiplier+3.5*modulation_index+freq_between_channels_multiplier*(0:7));

%% parameters

mod_order = 8;
cpfsk_modulator_object = comm.CPFSKModulator(mod_order, "BitInput",true, ModulationIndex=modulation_index,SamplesPerSymbol=symbol_length_samp, SymbolMapping="Gray");


%% modulate data
complex_sig = cpfsk_modulator_object(data_bits');

t = (0:length(complex_sig)-1)/sample_rate;
bandpass_sig = ...
    (real(complex_sig).*cos(2*pi*center_freqs(1)*t') - imag(complex_sig).*sin(2*pi*center_freqs(1)*t'))' + ...
    (real(complex_sig).*cos(2*pi*center_freqs(2)*t') - imag(complex_sig).*sin(2*pi*center_freqs(2)*t'))' + ...
    (real(complex_sig).*cos(2*pi*center_freqs(3)*t') - imag(complex_sig).*sin(2*pi*center_freqs(3)*t'))' + ...
    (real(complex_sig).*cos(2*pi*center_freqs(4)*t') - imag(complex_sig).*sin(2*pi*center_freqs(4)*t'))' + ...
    (real(complex_sig).*cos(2*pi*center_freqs(5)*t') - imag(complex_sig).*sin(2*pi*center_freqs(5)*t'))' + ...
    (real(complex_sig).*cos(2*pi*center_freqs(6)*t') - imag(complex_sig).*sin(2*pi*center_freqs(6)*t'))' + ...
    (real(complex_sig).*cos(2*pi*center_freqs(7)*t') - imag(complex_sig).*sin(2*pi*center_freqs(7)*t'))' + ...
    (real(complex_sig).*cos(2*pi*center_freqs(8)*t') - imag(complex_sig).*sin(2*pi*center_freqs(8)*t'))';

output_sig = bandpass_sig.*(1/8);

end