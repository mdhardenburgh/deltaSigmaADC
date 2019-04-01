R = 1000; %ohms
C = 1E-6; %farads

gain = tf([0 -1],[R*C 0]);

figure(1);
bode(gain, {1, 1E6})
grid on;
