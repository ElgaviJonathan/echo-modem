function [corected_signal, agc_factor] = agc_amplitude(input_signal)
%This funciton claculates the agc factor requiered to normalize the power
% of the input signal to 1.

signal_power = sum(abs(input_signal))/length(input_signal);
agc_factor = 1/signal_power;
corected_signal = agc_factor.*input_signal;

end