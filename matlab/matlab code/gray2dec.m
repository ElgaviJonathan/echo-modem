function [output_dec_vec] = gray2dec(input_gray_vec, binary_length)
% This function returns a decimal vector converted to gray coding (in binary
% format, each increment in gray translates to a single bi flip).

%% for testing
% clear
% clc
% input_gray_vec = [0, 1, 3, 2];
% % input_gray_vec = [0 1 2];
% binary_length = 2;


% test end
%%
dec_binary_mat = zeros(length(input_gray_vec),binary_length);
input_binary_mat = dec2bin(input_gray_vec) - '0';
input_binary_mat = [zeros(length(input_gray_vec),binary_length-length(input_binary_mat(1,:))), input_binary_mat];
dec_binary_mat(:,1) = input_binary_mat(:,1);
for i=2:binary_length
    dec_binary_mat(:,i) = xor(dec_binary_mat(:,i-1), input_binary_mat(:,i));
end
output_dec_vec = (2.^(binary_length-1:-1:0)*dec_binary_mat')';


end