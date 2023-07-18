%% real time audio display test
clear
clc

%% read real time data 
deviceReader = audioDeviceReader(44100,4096);
tic
while toc<5
    new_input_buffer = deviceReader();
    figure(1)
    plot(new_input_buffer)
    ylim([-0.5 0.5])    
end



