function [output_bits, error_vector, logged_state, rec] = echo_receiver(raw_input_step, input_struct, setup_flag) %#codegen
% This funciton acts as the receiver of the echo modem.
% The receiver receives blocks of size buffer_step_size, and accumulates
% the input samples into a buffer of length buffer_size.
%
% The input is then passed through preprocessing (filtering, AGC, etc), and
% then added to the internal memory buffer of the receiver.
%
% The main execution of the receiver follows the receiver state machine (RCM),
% with the following states:
%
% 0 - IDLE
% While in IDLE, the receiver attempts to detect the first stage of the
% signal - the CW. If non is detected, the RCM remains in IDLE.
%
% 1 - SYNC
%  While in sync, the RCM searches for the synchronization sequence /
%  sequences and calibrates the channel model.
%
% 2 - DEMOD
% while in demod, the RCM accumulates sufficiant samples in order to
% correctly decode adn return the data bits received. If the erorr rate
% climes above the limit, the RCM will return to the IDLE state.
%


%% parameters
% signal parameters
sample_rate = 44100; % requiers regeneration to change
% highpass_freq = 4500;
%general parameters
buffer_size = 2^15; % 32768
buffer_step_size = 2^12; % 4096


% cw parameters
cw_length_t = 8192/44100; % in [ms]
cw_length_samp = cw_length_t*sample_rate;
cw_detection_threshold = 6.5;
cw_freq_options = [12e3, 14e3, 18e3];
% cw_highpass_freq = 8e3;

% payload parameters
modulation_order = 8;
bits_per_symbol = log2(modulation_order);
samples_per_symbol = 1500;
symbol_length_t = samples_per_symbol/sample_rate;
symbol_rate = sample_rate/samples_per_symbol;

%% freq generatrion
% freq_start_multiplier = 250;% (start freq = 300*symbol rate = 8820)
% modulation_index = 2;
% freq_between_channels_multiplier = 40;
% channel_freqs = (1:modulation_index:8*modulation_index)-1;
% freq_vec = reshape(symbol_rate*(freq_start_multiplier + repmat(channel_freqs,[8,1]) + repmat(freq_between_channels_multiplier*(0:7)',[1,8]))',1,[]);
% center_freqs = symbol_rate*(freq_start_multiplier+3.5*modulation_index+freq_between_channels_multiplier*(0:7));
%%
% freq_vec = [9067	9214	9361	9508	9625.60000000000	9772.60000000000	9890.20000000000	10037.2000000000	10184.2000000000	10331.2000000000	10478.2000000000	10595.8000000000	10742.8000000000	10860.4000000000	11036.8000000000	11183.8000000000	11330.8000000000	11448.4000000000	11595.4000000000	11713	11830.6000000000	11977.6000000000	12124.6000000000	12271.6000000000	12389.2000000000	12536.2000000000	12653.8000000000	12800.8000000000	12918.4000000000	13036	13183	13330	13477	13624	13771	13918	14035.6000000000	14182.6000000000	14329.6000000000	14447.2000000000	14594.2000000000	14741.2000000000	14858.8000000000	15005.8000000000	15152.8000000000	15270.4000000000	15388	15535	15682	15799.6000000000	15946.6000000000	16064.2000000000	16240.6000000000	16358.2000000000	16534.6000000000	16652.2000000000	16799.2000000000	16916.8000000000	17063.8000000000	17210.8000000000	17357.8000000000	17504.8000000000	17622.4000000000	17740]';
% freq_vec = [8820	8849.40000000000	8878.80000000000	8908.20000000000	8937.60000000000	8967	8996.40000000000	9025.80000000000	9408	9437.40000000000	9466.80000000000	9496.20000000000	9525.60000000000	9555	9584.40000000000	9613.80000000000	9996	10025.4000000000	10054.8000000000	10084.2000000000	10113.6000000000	10143	10172.4000000000	10201.8000000000	10584	10613.4000000000	10642.8000000000	10672.2000000000	10701.6000000000	10731	10760.4000000000	10789.8000000000	11172	11201.4000000000	11230.8000000000	11260.2000000000	11289.6000000000	11319	11348.4000000000	11377.8000000000	11760	11789.4000000000	11818.8000000000	11848.2000000000	11877.6000000000	11907	11936.4000000000	11965.8000000000	12348	12377.4000000000	12406.8000000000	12436.2000000000	12465.6000000000	12495	12524.4000000000	12553.8000000000	12936	12965.4000000000	12994.8000000000	13024.2000000000	13053.6000000000	13083	13112.4000000000	13141.8000000000]';
freq_vec = [7350	7408.80000000000	7467.60000000000	7526.40000000000	7585.20000000000	7644	7702.80000000000	7761.60000000000	8526	8584.80000000000	8643.60000000000	8702.40000000000	8761.20000000000	8820	8878.80000000000	8937.60000000000	9702	9760.80000000000	9819.60000000000	9878.40000000000	9937.20000000000	9996	10054.8000000000	10113.6000000000	10878	10936.8000000000	10995.6000000000	11054.4000000000	11113.2000000000	11172	11230.8000000000	11289.6000000000	12054	12112.8000000000	12171.6000000000	12230.4000000000	12289.2000000000	12348	12406.8000000000	12465.6000000000	13230	13288.8000000000	13347.6000000000	13406.4000000000	13465.2000000000	13524	13582.8000000000	13641.6000000000	14406	14464.8000000000	14523.6000000000	14582.4000000000	14641.2000000000	14700	14758.8000000000	14817.6000000000	15582	15640.8000000000	15699.6000000000	15758.4000000000	15817.2000000000	15876	15934.8000000000	15993.6000000000]';

% sync_sequence parameters
samples_per_sync_symbol = 256;
% sync_symbol_length_t = samples_per_sync_symbol/sample_rate;
sync_freq = 6000;
gold_code_seq_256 = [1	-1	-1	1	-1	1	-1	-1	-1	-1	1	1	-1	-1	1	1	-1	1	-1	1	-1	1	1	1	1	1	-1	1	-1	1	1	-1	-1	1	-1	1	1	-1	-1	1	-1	-1	1	1	-1	-1	-1	1	1	1	-1	1	1	1	-1	1	-1	1	1	1	-1	-1	1	-1	-1	1	-1	1	-1	1	1	-1	1	-1	1	1	-1	-1	-1	-1	1	1	1	-1	1	1	-1	1	-1	1	-1	-1	-1	-1	1	1	1	-1	-1	-1	1	-1	1	1	-1	1	1	1	1	-1	-1	-1	-1	1	-1	1	1	-1	-1	1	1	-1	1	1	1	-1	-1	-1	-1	1	1	-1	-1	1	1	-1	1	1	1	1	-1	-1	-1	-1	1	-1	-1	-1	1	1	1	-1	1	-1	-1	-1	-1	-1	-1	1	1	-1	-1	1	1	1	-1	-1	1	1	-1	1	1	-1	1	-1	1	-1	-1	1	-1	-1	1	1	1	-1	-1	-1	-1	-1	-1	1	-1	-1	-1	1	-1	-1	-1	-1	1	-1	-1	1	1	-1	1	1	-1	1	-1	-1	1	1	1	1	-1	1	1	-1	1	-1	1	1	1	1	1	1	1	-1	1	-1	-1	1	-1	1	-1	-1	-1	-1	-1	1	-1	1	-1	-1	1	-1	-1	1	1	1	-1	1	-1	-1];
sync_bits = (gold_code_seq_256+1)/2;
sync_mod_order = 16;
sync_bits_per_symbol = log2(sync_mod_order);
sync_symbol_rate = sample_rate/samples_per_sync_symbol;
reshape(sync_bits,sync_bits_per_symbol,[]);
sync_symbols = (2.^(sync_bits_per_symbol-1:-1:0))*reshape(sync_bits,sync_bits_per_symbol,[]);


% fsk_moder = comm.FSKModulator(sync_mod_order, 200, 'SamplesPerSymbol',samples_per_sync_symbol, 'SymbolRate', sync_symbol_rate);
% sync_sig_complex = fsk_moder(sync_symbols');
% t = (0:length(sync_sig_complex)-1)/sample_rate;

cpfsk_moder = comm.CPFSKModulator(sync_mod_order,"ModulationIndex",1,"BitInput",true,"SamplesPerSymbol",samples_per_sync_symbol);
sync_sig_complex = cpfsk_moder(sync_bits');



% sync_sig = real(sync_sig_complex).*cos(2*pi*sync_freq*t) - imag(sync_sig_complex).*sin(2*pi*sync_freq*t);
% sync_sig = (real(sync_sig_complex).*cos(2*pi*sync_freq*t') - imag(sync_sig_complex).*sin(2*pi*sync_freq*t'))';
% sync_sig_2 = (real(sync_sig_complex).*cos(2*pi*sync_freq*t'+pi/2) - imag(sync_sig_complex).*sin(2*pi*sync_freq*t'+pi/2))';

sync_length_samp = length(sync_sig_complex);
% sync_length_bits = length(sync_bits);
sync_attempts_limit = 3;
sync_non_complex_factor = 0.5;
sync_threshold = 0.15 * sync_non_complex_factor;



% rs parameters
rs_n = 18;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
rs_k = 6;     % Message length (in gf symbols)
rs_m = 6;
% rs_prim_poly = [1 0 0 0 0 1 1]; %dec2bin(primpoly(rs_m)) - '0';
interleaver_size_rs_blocks = 1;
rs_coding_rate = rs_k/rs_n;

repetition_code_mode = true; % use repetitoin code to maximize data recovery

data_block_len_bits = rs_k*rs_m;
encoded_data_block_len_bits = data_block_len_bits/rs_coding_rate;
encoded_interleaver_block_len_bits = encoded_data_block_len_bits*interleaver_size_rs_blocks;
encoded_data_block_len_samp = (encoded_data_block_len_bits/bits_per_symbol)*samples_per_symbol;
demodulation_block_len_samp = encoded_data_block_len_samp/3; % split the demodulation block into smaller sizes (to fit in the buffer)

payload_high_pass_filter = dsp.HighpassFilter("PassbandFrequency",4500,"DesignForMinimumOrder",false,"FilterOrder",32);
cw_high_pass_filter = dsp.HighpassFilter("PassbandFrequency",8000, "StopbandFrequency",7000);


%% struct for state & memory preservation between funciton calls

if (setup_flag) % first call for receiver funciton, initilize struct
    %%
    rec = struct( ...
        'raw_buffer',complex(zeros(buffer_size,1)),... % raw signal memory window used by the receiver
        'buffer',complex(zeros(buffer_size,1)),... % processed signal memory window used by the receiver
        'sm_state',0,... % current state machine state of the receiver
        'sm_log', zeros(1,30),... %history of 20 previous states of the receiver
        'index',1,... % tracker for last point where the previos section or block was found
        'agc_factor',1,... % agc factor for normalising signal power
        'sync_attempts',0,... % limit to attempts to find sync after a signal was detected
        'sync_corr_max',0,... % max correaltion value of the sync signal
        'accumulated_encoded_bits',[],... % demodulated encoded bits (matrix of possible demodulations), to allow for partial demodulation of interleaver blocks
        'step_num_for_debug',0 ...
        );
     coder.cstructname(rec, 'rec_struct');

else % continue running based on previos receiver step
    rec = input_struct;
    rec.step_num_for_debug = rec.step_num_for_debug+1;
end



%% preprocessor
% step with the raw buffer
% raw_input_step = highpass(raw_input_step,highpass_freq,sample_rate);
rec.raw_buffer = [rec.raw_buffer(buffer_step_size+1:end);raw_input_step];
% filtered_input_step = highpass(raw_input_step,highpass_freq,sample_rate);
filtered_input_step = payload_high_pass_filter(raw_input_step);
[agc_corected_step, rec.agc_factor] = agc(filtered_input_step);
rec.buffer = [rec.buffer(buffer_step_size+1:end);agc_corected_step];


%% Receiver State machine

% set default values for outputs
output_bits = [];
error_vector = -2;  
logged_state = rec.sm_state;

switch rec.sm_state

    case 0 %%%%%%%%%%%%%% IDLE state - searching for signal %%%%%%%%%%%%%%%%
        %% no test for sufficiant samples needed

        %% test for signal presence
        % search in window of half the size of expected cw - to make sure
        % full possible power is measured (for agc calibratoin)
        %         cw_signal_search_window = highpass(rec.raw_buffer(end-cw_length_samp/2+1:end),cw_highpass_freq,sample_rate);
        cw_signal_search_window = cw_high_pass_filter(rec.raw_buffer(end-cw_length_samp/2+1:end));
        %         plot_fft_axis(cw_signal_search_window, sample_rate,1,1);
        %         figure(2);
        %         plot(highpass(rec.raw_buffer, highpass_freq, sample_rate))
        cw_freq_num = 0;
        cw_detection_flag = false;
        while cw_freq_num < length(cw_freq_options) && cw_detection_flag == false
            cw_freq_num = cw_freq_num+1;
            cw_freq = cw_freq_options(cw_freq_num);
            [cw_detection_flag, ~, ~] = cw_detector(cw_signal_search_window,...
                cw_freq, cw_detection_threshold,sample_rate);
        end
        if (cw_detection_flag == 0) % signal not found
            rec.index = buffer_size; % checked entire current buffer
            rec.sm_state = 0;
        elseif (cw_detection_flag == 1) % signal found
            % add offset to index based on the detected cw (to reduce
            % number of correlations)
            rec.index = buffer_size + cw_length_samp*(length(cw_freq_options) - cw_freq_num); 
            % update return state
            rec.sm_state = 1;
        end


    case 1 %%%%%%%%%%%%%% SYNC state - searching for sync sequences %%%%%%%%%
        %% continue search for cw - in case of improvment in parameters:

        %% test for sufficiant samples:
        if (rec.index + sync_length_samp > buffer_size)
            % insufficiant samples accumulated - remain at current state
            rec.sm_state = 1;
            rec.index = rec.index - buffer_step_size;
            rec.sm_log = [rec.sm_log(2:end), rec.sm_state];
            return;
        end

        %% sufficiant samples accumulated, test for sync
        %         figure(100);
        %         plot(abs(conv(rec.buffer, flip(sync_sig))) + abs(conv(rec.buffer, flip(sync_sig_2))));
        [detection_flag, end_index, sync_peak_val] = sync_correlator(rec.buffer,sync_sig_complex, sync_threshold, rec.index, 0, sync_freq, sample_rate);
        rec.sync_attempts = rec.sync_attempts+1;
        if (detection_flag == 0 && rec.sync_attempts > sync_attempts_limit)
            % limit exceded, no sync found
            rec.index = buffer_size;
            rec.sm_state = 0;
        elseif (detection_flag == 0 && rec.sync_attempts <= sync_attempts_limit)
            % no signal found, andvance attempt counter and remain in
            % current state
            rec.index = buffer_size;
            rec.sm_state = 1;
        elseif (detection_flag == true)
            % sync found, update channel parameters and continue to next
            % state
            rec.sync_corr_max = sync_peak_val;
            rec.index = end_index;
            rec.sm_state = 2;
            %             disp("payload start index = " + num2str(rec.index) + ...
            %                 " step_num = " + num2str(rec.step_num_for_debug));
        end

        %         if(rec.step_num_for_debug == 8 && detection_flag == false)
        %             disp("debug- syc miss");
        %         end

    case 2 %%%%%%%%%%%%%%%%%%%% DEMOD state - demodulatong data %%%%%%%%%%%%%%%%%%%%%%%%
        %% test again for sync, in case of early detection
        if (rec.sync_attempts <= sync_attempts_limit)
            [detection_flag, end_index, sync_peak_val] = sync_correlator(rec.buffer,sync_sig_complex, sync_threshold, rec.index, 0, sync_freq, sample_rate);
            rec.sync_attempts = rec.sync_attempts+1;
            if(detection_flag == true && sync_peak_val > rec.sync_corr_max) % prev detection was early, push index forward
                rec.sync_corr_max = sync_peak_val;
                rec.index = end_index;
                rec.sm_state = 2;
                rec.index = rec.index - buffer_step_size;
                rec.sm_log = [rec.sm_log(2:end), rec.sm_state];
                return;
            end
        end
        %% test for sufficiant samples:
        if (rec.index + demodulation_block_len_samp > buffer_size)
            % insufficiant samples accumulated - remain at current state
            rec.sm_state = 2;
            rec.index = rec.index - buffer_step_size;
            rec.sm_log = [rec.sm_log(2:end), rec.sm_state];
            return;
        end

        %% sufficiant samples accumulated, demodulate data block
        data_block_signal = rec.buffer(rec.index+1 : rec.index + demodulation_block_len_samp);
        % demodulate the data block
        [demodulated_bits_block] = fsk_8_level_64_tone_demodulator(data_block_signal, freq_vec,sample_rate, symbol_length_t);
        rec.accumulated_encoded_bits = [rec.accumulated_encoded_bits, demodulated_bits_block];

        %% check if sufficiant bits have been demodulated for decoding
        if(size(rec.accumulated_encoded_bits,2) == encoded_interleaver_block_len_bits) % demodulatoin complete, decode data
            % attempt the decoding process on each on of the returnd bit
            % value options
            decoding_sucsessful = false;
            attempt_cntr = 0;
            while (decoding_sucsessful == false && attempt_cntr < size(rec.accumulated_encoded_bits,1))
                attempt_cntr = attempt_cntr+1;
                % de interleave the data
                if(repetition_code_mode == true)
                    demodulated_bits_repetition_corrected = mode(reshape(rec.accumulated_encoded_bits(attempt_cntr,:),[],interleaver_size_rs_blocks)',1);
                    % rs_symbols = 2.^(rs_m-1:-1:0)*reshape(demodulated_bits_repetition_corrected, rs_m, []);
                    % rs_bits = reshape(dec2bin(rs_symbols)' - '0',1,[]);
                    rs_bits = demodulated_bits_repetition_corrected;
                    [decoded_bits_block, rs_errors] = decode_rs(rs_bits(1:rs_m*rs_n)');
                    output_bits = decoded_bits_block;
                else
                    rs_interleaved_symbols = 2.^(rs_m-1:-1:0)*reshape(rec.accumulated_encoded_bits(attempt_cntr,:), rs_m, []);
                    rs_deinterleaved_symbols = matdeintrlv(rs_interleaved_symbols,interleaver_size_rs_blocks, rs_n);
                    deinterleaved_bits = reshape(dec2bin(rs_deinterleaved_symbols)' - '0',1,[]);
                    [decoded_bits_block, rs_errors] = decode_rs(deinterleaved_bits');
                    output_bits = decoded_bits_block;
                end
                if(sum(rs_errors == -1) == 0)
                    decoding_sucsessful = true;
                    rec.accumulated_encoded_bits = [];
                    rec.sm_state = 0;
                    error_vector = rs_errors;
                    %                     disp("decoding sucsessful, EOM triggered");
                end
            end

            if(decoding_sucsessful == false) % no sucsessful decoding made
                rec.sm_state = 0;
                output_bits = [];
                rec.accumulated_encoded_bits = [];
                error_vector = -1;
                %                 disp("decoding failed, EOM triggered");
            end
        elseif(length(rec.accumulated_encoded_bits) < encoded_interleaver_block_len_bits) % demodulatoin incomplete, demodulate additional  data
            rec.sm_state = 2;
        end


        % advance index:
        rec.index = rec.index + demodulation_block_len_samp;



end
%% update parameters for next receiver run:
rec.sm_log = [rec.sm_log(2:end), rec.sm_state];
rec.index = rec.index - buffer_step_size; % step back the index by buffer step size.



end