function [output_gray_vec] = dec2gray(input_dec_vec, binary_length)
% This function returns a decimal vector converted to gray coding (in binary
% format, each increment in gray translates to a single bi flip).

%% for testing
% clear
% clc
% input_dec_vec = 0:3;
% binary_length = 3;


% test end
%%
gray_binary_mat = zeros(length(input_dec_vec),binary_length);
input_binary_mat = dec2bin(input_dec_vec,binary_length) - '0';
gray_binary_mat(:,1) = input_binary_mat(:,1);
for i=2:binary_length
    gray_binary_mat(:,i) = xor(input_binary_mat(:,i-1), input_binary_mat(:,i));
end
output_gray_vec = (2.^(binary_length-1:-1:0)*gray_binary_mat')';




end