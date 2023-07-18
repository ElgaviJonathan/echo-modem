%% gold code generator script
clear;
clc;

%% set parameters
gold_code_len = 4096;
autocorrelation_threshold = 0.035; %ratio between seq len and max autocorr value


%% find gold code
corr_res = gold_code_len; % max possible correlation, for while initilization
min_corr_res = corr_res; 
while(max(corr_res)>autocorrelation_threshold*gold_code_len)
    seq = randi([0 1],gold_code_len,1)*2-1;
    corr_res = conv(seq,flip(seq));
    corr_res(gold_code_len) = 0;
    if(max(corr_res) < min_corr_res)
        min_corr_res = max(corr_res);
        disp(num2str(min_corr_res/gold_code_len));
        figure(99);
        hold on;
        grid on;
        disp_corr_res = corr_res;
        disp_corr_res(gold_code_len) = gold_code_len;
        plot(disp_corr_res);
    end
end
gold_code_seq = seq;
