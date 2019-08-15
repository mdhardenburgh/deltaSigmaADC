clear all;
delete(instrfindall);
s = serial('COM8');
s.InputBufferSize = 500000;
s.baudrate = 921600;
fopen(s);
i = 0;
binaryRead = 0;
binaryStream = 0;

fs = 16130;     % Sampling frequency                    
T = 1/fs;      % Sampling period       
L = 500;        % Length of signal

binaryRead = fread(s, 500, 'int32');
binaryStream = vertcat(binaryStream, binaryRead);

Y = fft(binaryStream);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

while true
    binaryRead = fread(s, 500, 'int32');
    Y = fft(binaryRead);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    f = fs*(0:(L/2))/L;
    plot(f,P1);
    title('Single-Sided Amplitude Spectrum of X(t)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    drawnow;
end
fclose(s);