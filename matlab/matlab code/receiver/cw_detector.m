function [cw_detected, cw_signal_power, z_score] = cw_detector(input_signal, expected_cw_freq, det_threshold, sample_freq)%#codegen
% This funciton detects the presence of a carrier in the input signal.
% The carrier should be centered in the baseband signal, however some
% frequency offset is expected (in non audio cenarios)

% the detection is conditioned by 2 factors - the z score (to show peak
% behavior) and a frequency offset limit

freq_offset_limit = 100; % in Hz
fft_bin_size = sample_freq/length(input_signal);
freq_offset_bin_limit = ceil(freq_offset_limit/fft_bin_size);
signal_fft = fftshift(fft(input_signal));
search_size = freq_offset_bin_limit;
expected_cw_bin = round(length(signal_fft)/2 + expected_cw_freq/fft_bin_size + 1);
signal_fft_search_range = signal_fft(expected_cw_bin-search_size:expected_cw_bin+search_size);
fft_mean = mean(abs(signal_fft));
fft_std = std(abs(signal_fft));
[fft_max_val, fft_max_ind] = max(abs(signal_fft_search_range));
fft_max_ind = expected_cw_bin - ceil(length(signal_fft_search_range)/2) + fft_max_ind; % return max index to range of full fft
z_score = (fft_max_val-fft_mean)/fft_std;
if(z_score > det_threshold)
    cw_detected = true;
    %index edge case handeling
    if (fft_max_ind == 1)
        fft_max_ind = 2;
    elseif(fft_max_ind == length(signal_fft))
        fft_max_ind = fft_max_ind-1;
    end
    cw_signal_power = 2*sum(abs(signal_fft(fft_max_ind-search_size:fft_max_ind+search_size)/length(signal_fft))); % factor of 2 for pos and neg power component
else
    cw_detected = false;
    cw_signal_power = 0;
end
end