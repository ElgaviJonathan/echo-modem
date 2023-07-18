function [decoded_bits, rs_errors] = decode_rs(encoded_bits) %#codegen

rs_n = 18;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5 
rs_k = 6;     % Message length (in gf symbols)
rs_m = 6;
rs_prim_poly = [1 0 0 0 0 1 1]; % dec2bin(primpoly(rs_m)) - '0'; 

rs_decoder = comm.RSDecoder(rs_n,rs_k,PrimitivePolynomialSource="Property",PrimitivePolynomial=rs_prim_poly,BitInput=true);
[decoded_bits, rs_errors] = rs_decoder.step(encoded_bits);
release(rs_decoder);

% 
% rs_encoder = comm.RSEncoder(rs_n,rs_k,'  ',true,'PrimitivePolynomialSource','Property','PrimitivePolynomial',rs_prim_poly);
% encoded_bits = rs_encoder.step(data_bits);
% release(rs_encoder);