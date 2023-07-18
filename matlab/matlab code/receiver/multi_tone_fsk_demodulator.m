function [demoded_data_bits] = ...
    multi_tone_fsk_demodulator(input_sig, modulation_order,...
    sample_rate, symbol_length_samp, freq_vec,...
    debug_data_bits)
%This funciton performes multi tone fsk de-moduation of the input signal
% input signal must be a multiple of symbol_length_samp

%% for testing
% clear
% clc
% data_bits = randi([0 1],64,1);
% modulation_order = 64;
% delta_f = 125; % in Hz
% sample_rate = 44100;
% symbol_length_t = 50e-3; % 50 [ms]
% symbol_length_samp = symbol_length_t*sample_rate;
% % generate freq vector, at prime frequnencies (for minimal interfirance)
% start_freq = 4000;
% stop_freq = 12000;
% [freq_vec, error_flag] = generate_freq_vector(modulation_order,start_freq,stop_freq,50);
% [input_sig, ~] = multi_tone_fsk_modulator(data_bits,modulation_order,sample_rate,symbol_length_t);


% end of testing
%% filter bank method
num_of_symbols = length(input_sig)/symbol_length_samp;
symbol_signal_mat = reshape(input_sig, round(symbol_length_samp), []); % each column is 1 symbol
t = (0:symbol_length_samp-1)/sample_rate;
filter_freq_vec = freq_vec(1:32);
filter_bank = exp(2*pi*1j*filter_freq_vec*t);
output_symbols = zeros(1,num_of_symbols);
for i = 1:num_of_symbols
    % symbol_filter_outputs = abs(filter_bank*symbol_signal_mat(:,i)).^2;
    symbol_filter_outputs = real(filter_bank*symbol_signal_mat(:,i)).^2 + imag(filter_bank*symbol_signal_mat(:,i)).^2;
    symbol_filter_outputs = sum(reshape(symbol_filter_outputs,8,[])',1); % accumulate all copies of the mfsk signal
    [~, filter_demoded_symbol] = max(symbol_filter_outputs);
    output_symbols(i) =  gray2dec(filter_demoded_symbol-1,log2(modulation_order));
end
demoded_data_bits = reshape((dec2bin(output_symbols) - '0')',[],1);


%% fft demodulation method
% 
% demoded_data_bits = [];
% fft_bin_size = sample_rate/symbol_length_samp;
% if(mod(symbol_length_samp,2) == 0) % is even
%     fft_freq_axis = (-symbol_length_samp/2:symbol_length_samp/2-1)*(sample_rate/symbol_length_samp);
% else
%     fft_freq_axis = (-floor(symbol_length_samp/2):ceil(symbol_length_samp/2)-1)*(sample_rate/symbol_length_samp);
% end
% % use top half of fft (positive freqs)
% top_fft_freq_axis = fft_freq_axis(ceil(symbol_length_samp/2)+1:end);
% % find indexes of the active frequencies
% top_freq_indexs = sum(and((top_fft_freq_axis < freq_vec+fft_bin_size/2), (top_fft_freq_axis > freq_vec-fft_bin_size/2)));
% % inverse indexes, to remove for z score ref calculations
% top_non_freq_indexes = ~sum(and((top_fft_freq_axis < freq_vec+fft_bin_size), (top_fft_freq_axis > freq_vec-fft_bin_size)));
% % remove up to 100 hz to clean DC
% top_non_freq_indexes(1:(100/fft_bin_size)) = 0;
% 
% 
% for symbol_start = 1:symbol_length_samp:(length(input_sig))
%     symbol_signal = input_sig(symbol_start:symbol_start+symbol_length_samp-1);
%     symbol_fft = fftshift(fft(symbol_signal));
%     top_symbol_fft = symbol_fft(ceil(symbol_length_samp/2)+1:end);
%     % calulate z scores of all possible freqs
%     clean_top_fft = top_symbol_fft(logical(top_non_freq_indexes));
%     symbol_fft_mean = mean(abs(clean_top_fft));
%     symbol_fft_std = std(abs(clean_top_fft));
%     fft_val_vec = abs(top_symbol_fft(logical(top_freq_indexs)));
%     z_score_vec = (fft_val_vec-symbol_fft_mean)/symbol_fft_std;
%     full_z_score = (abs(top_symbol_fft)-symbol_fft_mean)/symbol_fft_std;
%     symbol_demoded_bits = z_score_vec > z_threshold;
%     demoded_data_bits = [demoded_data_bits symbol_demoded_bits];
% end
% demoded_data_bits = demoded_data_bits';
% 
% 
% %% use matched filter method
% t = (0:symbol_length_samp-1)/sample_rate;
% % filter_freqs = (500:10:10000)';
% filter_bank = exp(2*pi*1j*freq_vec*t);
% filter_outputs = abs(input_sig'*filter_bank');
% demod_bits_2 = filter_outputs > 0.5;

end