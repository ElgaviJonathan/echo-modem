function [signal_fft, freq_axis] = fft_w_axis(signal,sample_freq)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
signal_fft = fftshift(fft(signal));
if(mod(length(signal),2) == 0) % is even
    freq_axis = (-length(signal)/2:length(signal)/2-1)*(sample_freq/length(signal));
else
    freq_axis = (-floor(length(signal)/2):ceil(length(signal)/2)-1)*(sample_freq/length(signal));
end

end