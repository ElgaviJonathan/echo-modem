%% orthogonality test:
clear;
clc
%%
sample_rate = 44100;
symbol_length_samp = 1500; % symbol_length_t*sample_rate;
symbol_length_t = symbol_length_samp/sample_rate;
symbol_rate = 1/symbol_length_t;

freq_start_multiplier = 250;% (start freq = 300*symbol rate = 8820)
modulation_index = 2;
freq_between_channels_multiplier = 40;

channel_freqs = (1:modulation_index:8*modulation_index)-1;
freq_vec = reshape(symbol_rate*(freq_start_multiplier + repmat(channel_freqs,[8,1]) + repmat(freq_between_channels_multiplier*(0:7)',[1,8]))',1,[]);
center_freqs = symbol_rate*(freq_start_multiplier+3.5*modulation_index+freq_between_channels_multiplier*(0:7));

% freq_vec_optional = ...
%     [(symbol_rate*300):symbol_rate:(symbol_rate*307), ...
%     (symbol_rate*320):symbol_rate:(symbol_rate*327), ...
%     (symbol_rate*340):symbol_rate:(symbol_rate*347), ...
%     (symbol_rate*360):symbol_rate:(symbol_rate*367), ...
%     (symbol_rate*380):symbol_rate:(symbol_rate*387), ...
%     (symbol_rate*400):symbol_rate:(symbol_rate*407), ...
%     (symbol_rate*420):symbol_rate:(symbol_rate*427), ...
%     (symbol_rate*440):symbol_rate:(symbol_rate*447)];



%%

orth_mat = zeros(64,64,5);
for i = 1:64
    for j = 1:64
        for k = 1:5
            t = (0:symbol_length_samp-1)/sample_rate;
            f_a = freq_vec_optional(i);
            f_b = (freq_vec_optional(j)*k);
            sig_a = cos(2*pi*f_a*t);
            sig_b = cos(2*pi*f_b*t);
            orth_mat(i,j,k) = sig_a*sig_b';
             if(f_b > sample_rate/2)
                orth_mat(i,j,k) = 0;
            end
            if(orth_mat(i,j,k) > 10)
                disp("debug, f1 = " + num2str(f_a) + " f2 = " + num2str(f_b));
            end
        end
    end
end
figure(1)

%% 
% 
% orth_mat = zeros(64,1000);
% for i = 1:64
%     for j = 1:1000
%         t = (0:symbol_length_samp-1)/sample_rate;
%         sig_a = cos(2*pi*freq_vec(i)*t) + ...
%             cos(2*pi*freq_vec(i)*2*t) + ...
%             cos(2*pi*freq_vec(i)*3*t) + ...
%             cos(2*pi*freq_vec(i)*4*t) + ...
%             cos(2*pi*freq_vec(i)*5*t);
%         sig_b = cos(2*pi*((freq_vec(1)+j)*t));
%         orth_mat(i,j) = sig_a*sig_b';
%     end
% end
% figure(1)