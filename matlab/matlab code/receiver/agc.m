function [corected_signal, agc_factor] = agc(input_signal)
%This funciton claculates the agc factor requiered to normalize the power
% of the input signal to 1.

% signal_power = sum(abs(input_signal.^2))/length(input_signal);
signal_rms = (sqrt(sum(input_signal.^2)/length(input_signal)));
agc_factor = 1/signal_rms;
corected_signal = agc_factor.*input_signal;

end