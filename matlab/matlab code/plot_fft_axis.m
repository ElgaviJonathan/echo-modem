function [signal_fft, freq_axis] = plot_fft_axis(signal,sample_freq, figure_num, clear_flag)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
signal_fft = fftshift(fft(signal));
if(mod(length(signal),2) == 0) % is even
    freq_axis = (-length(signal)/2:length(signal)/2-1)*(sample_freq/length(signal));
else
    freq_axis = (-floor(length(signal)/2):ceil(length(signal)/2)-1)*(sample_freq/length(signal));
end

figure(figure_num);
if (clear_flag)
    clf(figure_num);
end
hold on;
psd_from_fft = (1/(sample_freq*length(signal))) * abs(signal_fft).^2;
plot(freq_axis, pow2db(2*psd_from_fft));
% plot(freq_axis, 2*psd_from_fft);
grid on;
xlabel("Freq [Hz]")
ylabel("power [dB]")
% plot(freq_axis,abs(signal_fft));

end