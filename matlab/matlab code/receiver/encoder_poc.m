clear;
clc;


%% encode using RS
rs_n = 18;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5 
rs_k = 6;     % Message length (in gf symbols)
rs_m = 6;
rs_prim_poly = [1 0 0 0 0 1 1]; %dec2bin(primpoly(rs_m)) - '0'; 
rs_coding_rate = rs_k/rs_n;
bits_block_size = 36;

rs_encoder = comm.RSEncoder(rs_n,rs_k,'BitInput',true,'PrimitivePolynomialSource','Property','PrimitivePolynomial',rs_prim_poly);

% rs_encoder = comm.RSEncoder(rs_n,rs_k,'BitInput',true,'PrimitivePolynomialSource','Property','PrimitivePolynomial',rs_prim_poly);
rs_decoder = comm.RSDecoder(rs_n,rs_k,PrimitivePolynomialSource="Property",PrimitivePolynomial=rs_prim_poly,BitInput=true);

% test single data block with error mask
data_bits = randi([0 1],bits_block_size,1);
encoded_bits = rs_encoder.step(data_bits);
release(rs_encoder);
error_mask = zeros(length(encoded_bits),1);
error_mask([1,7,13,19,25,31]) = 1;
rx_bits = xor(encoded_bits, error_mask);
[decoded_bits,error_data] = rs_decoder.step(rx_bits);
release(rs_decoder);

disp("errors = " + num2str(sum(decoded_bits ~= data_bits)) + ...
    ", rs errors found data = " + num2str(error_data));

%%

% error_mask_limit_vec = 0.05;
% itterations = 100;


ber_vec = zeros(length(error_mask_limit_vec), itterations);
for error_mask_limit_index = 1:length(error_mask_limit_vec)
    for itter = 1:itterations
        %% generate data
        data_bits = randi([0 1],bits_block_size,1);
        %% encode
        encoded_bits = rs_encoder.step(data_bits);
        release(rs_encoder);
        %% pass though random errors channel
        error_mask = (rand(bits_block_size/rs_coding_rate,1) <= error_mask_limit_vec(error_mask_limit_index));
        rx_bits = xor(encoded_bits, error_mask);
        %% decode
        decoded_bits = rs_decoder.step(rx_bits);
        release(rs_decoder);
        %% calculate errors
        errors = sum(decoded_bits ~= data_bits);
        ber_vec(error_mask_limit_index, itter) = errors/length(data_bits);
        %% display
        disp("channel ber = " + num2str(error_mask_limit_vec(error_mask_limit_index)) + ...
            " itter num = " + num2str(itter) + ...
            " ber after fec = " + num2str(errors/length(data_bits)));
    end
end
figure(100);
semilogy(error_mask_limit_vec, mean(ber_vec, 2))



%
%
% data_bits = randi([0 1],512,1);
%
% % encode using RS
% rs_m = 8;      % Number of bits per symbol
% rs_n = 128;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5
% rs_k = 64;     % Message length (in gf symbols)
%
%
% % convert to encodable form and encode
% symbol_form_data = reshape(data_bits, rs_m, [])'*(2.^((rs_m-1):-1:0))';
% gf_form_data = gf(symbol_form_data,rs_m);
% RS_encoded_symbols = rsenc(gf_form_data', rs_n, rs_k);
%
% % decode and convert back to bits
% RS_decoded_symbols = rsdec(RS_encoded_symbols,rs_n,rs_k);
% decoded_bits =  reshape((dec2bin(RS_decoded_symbols.x)-'0')',[],1);
%
% % calculate error rate
% errors = sum(decoded_bits ~= data_bits);
%
%
