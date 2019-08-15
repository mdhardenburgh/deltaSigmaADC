clear all;
delete(instrfindall);
s = serial('COM8');
s.InputBufferSize = 500000;
s.baudrate = 921600;
fopen(s);
binaryRead = 0;

fs = (100E6)/(1024);           % Sampling frequency                        


% while true    
%     binaryRead = fread(s, 5000, 'int32');
%     binaryStream = vertcat(binaryStream, binaryRead);
%     plot(binaryRead)
%     axis([0 500 0 12E8])
%     drawnow;
% end
% fclose(s);

binaryRead = fread(s, 500, 'int32');
myMax = max(binaryRead)
myMin = min(binaryRead)
ENOB = log2(myMax-myMin)
plot(binaryRead)
axis([0 500 0 12E8])
title('Samples v. Resolution')
xlabel('Samples')
ylabel('Resolution')

fclose(s);


% meanRead = mean(binaryRead)
% withoutDc = binaryRead-mean(binaryRead);
% plot(abs(fft(withoutDc)))
