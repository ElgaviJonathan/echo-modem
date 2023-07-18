function [freq_vec, error_flag] = ...
    generate_freq_vector(freq_num, start_freq, stop_freq, min_distance_from_harmonic, symbol_rate)

%% for testing
% clear
% clc
% min_distance_from_harmonic = 50;
% freq_num = 64;
% start_freq = 1000;
% stop_freq = 10000;
%%%%%%% test end

freq_range = start_freq:stop_freq;
prim_freqs = freq_range(isprime(start_freq:stop_freq));% find all primes in range
% distant_freqs = prim_freqs(1:10:end); % set skips to ensure distance
freq_set = prim_freqs(1:end);


sufficiant_freqs_found = 0;


while(~sufficiant_freqs_found)

    % create matrix of remainder when each number is devided by every other
    % number. This will show the distance from a harmonic
    mod_mat_forward = mod(freq_set,freq_set');
    mod_mat_forward(mod_mat_forward==0) = NaN;
    % create matrix calculaitng the distance of the remainder in case it is
    % close to the next number
    mod_mat_backward = freq_set'-mod(freq_set,freq_set');
    % combine to single matrix which describes the distances from harmonics
    min_distance_from_mult_mat = min(mod_mat_forward,mod_mat_backward);
    % find absolute min for each number to find worst case distance
    min_distance_from_mult = min(min_distance_from_mult_mat);
    % extract relevant frequencies
    sufficiantly_far_freqs = freq_set(min_distance_from_mult>=min_distance_from_harmonic);
    % if sufficiant freqs are found, exit filtering process
    if(length(sufficiantly_far_freqs) >= freq_num)
%         sufficiant_freqs_found = 1;
        error_flag = false;
        break;
    end
    % sufficiant freqs not found, find worst freq candidate:
    logical_distance_mat = min_distance_from_mult_mat<=min_distance_from_harmonic;
    freq_scores = sum(logical_distance_mat,2); 

    % the score marks how many frequencuies the spesific freq eliminates.
    % the higher the score, the more frequncies the freq eliminates (high
    % score => bad)

    [~, worst_freq_index] = max(freq_scores);
    % remove the selected freq:
    freq_set(worst_freq_index) = [];
    
    if(length(freq_set)< freq_num) % process failed
        error_flag = true;
        break;
    end
end

freq_vec = sufficiantly_far_freqs';

%% move all frequncies to nearest orthogonal option based on fsk symbol rate
distances_from_orthogonal_freq = mod(freq_vec-freq_vec(1), symbol_rate);
distances_from_orthogonal_freq(distances_from_orthogonal_freq > (symbol_rate/2)) =...
    distances_from_orthogonal_freq(distances_from_orthogonal_freq > (symbol_rate/2)) - symbol_rate;
moded_freq_vec = freq_vec - distances_from_orthogonal_freq;

freq_vec = moded_freq_vec;

end