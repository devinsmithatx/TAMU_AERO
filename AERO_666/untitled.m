clear; clc; close all;
T = 1/8;
T0 = 4;
t = 0:T:T0;
x = @rectpuls;
y = pulstran(t,0:T0:T0,x);

stem(t,y)
hold off
xlabel('Time (s)')
ylabel('Waveform')