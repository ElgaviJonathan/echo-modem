function [signal_detected, end_index] = sync_correlator_2(input_signal, gold_code_signal, threshold, start_index, coherent_detection, passband_freq, sample_rate)
%This funciton searches for a gold code signal in the input signal, using
% correlation
% The threshold is schaled by the length of the gold code signal
% the start index notes at what point the preamble could appeare in the
% input signal (based on external previos information)

% use double correlation with phase offset flag
% double_correlation_flag = true;

seq_len = length(gold_code_signal);
sig_len = length(input_signal);

t = (0:length(gold_code_signal)-1)/sample_rate;
gold_code_passband = (real(gold_code_signal).*cos(2*pi*passband_freq*t') - imag(gold_code_signal).*sin(2*pi*passband_freq*t'))';
gold_code_passband_phase_shifted = (real(gold_code_signal).*cos(2*pi*passband_freq*t'+pi/2) - imag(gold_code_signal).*sin(2*pi*passband_freq*t'+pi/2))';



signal_detected = false;
end_index = sig_len;
internal_threshold = threshold*seq_len;
step_size = 10; % deteciton correlations are more sparse, to reduce complexity
for i = (start_index-seq_len+1):step_size:(sig_len - seq_len) % from possible start of seq to possible end
    % corr_result = conj(gold_code_signal)*input_signal(i:i+seq_len-1);
    corr_result = conj(gold_code_passband)*input_signal(i:i+seq_len-1);
    corr_result_phase_shift = gold_code_passband_phase_shifted*input_signal(i:i+seq_len-1);
    
    corr_abs = abs(corr_result+corr_result_phase_shift);
    corr_real = real(corr_result);
    if(coherent_detection == true)
        corr_test = corr_real;
    else
        corr_test = corr_abs;
    end

    if(corr_test >= internal_threshold)
        corr_max = corr_test;
        signal_detected = true;
        end_index = i+seq_len;
        % Additional search to find peak (after threshold
        % condition in met), in case first pass is not max value:
        for j = i+1-step_size:min(i+2e3, (sig_len - seq_len))
            corr_result = conj(gold_code_passband)*input_signal(j:j+seq_len-1);
            corr_result_phase_shift = gold_code_passband_phase_shifted*input_signal(j:j+seq_len-1);
            corr_abs = abs(corr_result+corr_result_phase_shift);
            corr_real = real(corr_result);
            if(coherent_detection == true)
                corr_test = corr_real;
            else
                corr_test = corr_abs;
            end
            if(corr_test > corr_max)
                corr_max = corr_test;
                end_index = j+seq_len;
            end
        end
        return
    end
    signal_detected = false;
    end_index = sig_len;
end