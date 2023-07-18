function [ber,numBits] = bertool_echo_modem(EbNo,maxNumErrs,maxNumBits,varargin)
%BERTOOLTEMPLATE Template for a BERTool (Bit Error Rate Analysis app) simulation function.
%   This file is a template for a BERTool-compatible simulation function.
%   To use the template, insert your own code in the places marked "INSERT
%   YOUR CODE HERE" and save the result as a file on your MATLAB path. Then
%   use the Monte Carlo pane of BERTool to execute the script.
%
%   [BER, NUMBITS] = YOURFUNCTION(EBNO, MAXNUMERRS, MAXNUMBITS) simulates
%   the error rate performance of a communications system. EBNO is a vector
%   of Eb/No values, MAXNUMERRS is the maximum number of errors to collect
%   before stopping the simulation, and MAXNUMBITS is the maximum number of
%   bits to run before stopping the simulation. BER is the computed bit error
%   rate, and NUMBITS is the actual number of bits run. Simulation can be
%   interrupted only after an Eb/No point is simulated.
%
%   [BER, NUMBITS] = YOURFUNCTION(EBNO, MAXNUMERRS, MAXNUMBITS, BERTOOL)
%   also provides BERTOOL, which is the handle for the BERTool app and can
%   be used to check the app status to interrupt the simulation of an Eb/No
%   point.
%
%   For more information about this template and an example that uses it,
%   see the Communications Toolbox documentation.
%
%   See also BERTOOL and VITERBISIM.

% Copyright 2020 The MathWorks, Inc.

% Initialize variables related to exit criteria.
totErr  = 0; % Number of errors observed
numBits = 0; % Number of bits processed

% --- Set up the simulation parameters. ---
% --- INSERT YOUR CODE HERE.
%% parameter configuration
data_length = 512;

modulation_order = 16;
symbol_rate = 256;
sample_rate = 40960;
modulaiton_index = 2;


% encode using RS 
rs_m = 8;      % Number of bits per symbol
rs_n = 128;    % Codeword length (in gf symbols). max = 2^m - 1, set to 128 for ratio of 0.5 
rs_k = 64;     % Message length (in gf symbols)

bit_rate = log2(modulation_order)*symbol_rate;
samples_per_symbol = sample_rate/symbol_rate;
delta_f = modulaiton_index*symbol_rate;
bandwidth = delta_f*modulation_order;
fft_bin_size = sample_rate/samples_per_symbol;
fsk_mod = comm.FSKModulator(ModulationOrder = modulation_order,...
    FrequencySeparation = modulaiton_index*symbol_rate,...
    SymbolRate = symbol_rate,...
    SamplesPerSymbol = sample_rate/symbol_rate, ...
    BitInput = true);

snr = convertSNR(EbNo,"ebno","snr","BitsPerSymbol",4,"CodingRate",0.5,"SamplesPerSymbol",160);
awgn_chan = comm.AWGNChannel("NoiseMethod",'Signal to noise ratio (SNR)','SNR', snr);

fsk_demod = comm.FSKDemodulator(ModulationOrder = modulation_order,...
    FrequencySeparation = modulaiton_index*symbol_rate,...
    SymbolRate = symbol_rate,...
    SamplesPerSymbol = sample_rate/symbol_rate,BitOutput=true);

%%
% Simulate until either the number of errors exceeds maxNumErrs
% or the number of bits processed exceeds maxNumBits.
while((totErr < maxNumErrs) && (numBits < maxNumBits))

    % Check if the user clicked the Stop button of BERTool.
    if isBERToolSimulationStopped(varargin{:})
        break
    end

    % --- Proceed with the simulation.
    % --- Be sure to update totErr and numBits.
    % --- INSERT YOUR CODE HERE.
    %% generate data bits
    data_bits = randi([0 1],data_length,1);

    %% encode via rs, and return to bit format
    % convert to encodable form and encode
    symbol_form_data = reshape(data_bits, rs_m, [])'*(2.^((rs_m-1):-1:0))';
    gf_form_data = gf(symbol_form_data,rs_m);
    rs_encoded_symbols = rsenc(gf_form_data', rs_n, rs_k);
    % convert back to bits
    encoded_bits = reshape((dec2bin(rs_encoded_symbols.x)-'0')',[],1);

    
    %% transmitt data
    baseband_tx_sig = fsk_mod.step(encoded_bits);
    fsk_mod.release();
    %% pass through channel
    frequency_offset = 0;
    phase_offset = 0;
    t = (0:length(baseband_tx_sig)-1)/sample_rate;
    tx_sig = baseband_tx_sig.*exp(2*pi*1j*(frequency_offset*t + phase_offset)).';
    rx_signal = awgn_chan.step(tx_sig);
    %% receive signal
    demoded_bits = fsk_demod.step(rx_signal);
    fsk_demod.release();

    %% decode via rs
    % convert bits to rs symbols
    demodulated_symbol_form_data = reshape(demoded_bits, rs_m, [])'*(2.^((rs_m-1):-1:0))';
    demodulated_gf_form_data = gf(demodulated_symbol_form_data,rs_m);
    % decode and convert back to bits
    rs_decoded_symbols = rsdec(demodulated_gf_form_data',rs_n,rs_k);
    decoded_bits =  reshape((dec2bin(rs_decoded_symbols.x)-'0')',[],1);
    
    %% calculate errors
    totErr = totErr + sum(decoded_bits ~= data_bits);
    numBits = numBits + data_length;
end % End of loop

% Compute the BER.
ber = totErr/numBits;