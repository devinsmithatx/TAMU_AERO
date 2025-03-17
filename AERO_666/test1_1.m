%% Problem 1
% Test 1
% Devin Smth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This problem will cover auto and cross corellation sequencies to compute
% a frequency response of a dynamic system

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Construct the discrete time model

fs = 1;                         % given sampling frequency
k = 1;                          % given spring constant
c = 0.01;                       % given damping coefficient

A = [0  1; -k -c];              % continuous A matrix
B = [0; 1];                     % continuous B matrix
dt = 1/fs;                      % samplinng time step

Ad = expm(A*dt);                % discrete A matrix
Bd = (Ad - eye(2,2))*A^-1*B;    % discrete B matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Plot the acceleration output

T0 = 0;                         % given initial time
Tf = 1023;                      % given final time (1024 samples)

% simulate the discrete dynamics and get the velocity
vhist = [];
for T = T0:dt:Tf
    u = sin(2*T);
    if T == 0
        x = [0; 0];
    else
        x = Ad*x + Bd*u;
    end
    vhist = [vhist; x(2)];
end

% compute the acceleration
ahist = 0;
for i = 1:(length(vhist) - 1)
    a = (vhist(i + 1) - vhist(i))/dt;
    ahist = [ahist; a];
end
y = ahist;

% plot the acceleration
figure
plot(T0:dt:Tf,y)
xlim([T0, Tf])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Apply a random excitation as the input signal to the system and plot

Ne = 512;
ur(1,1:Ne) = randn(1,Ne).*hann(Ne).';

% simulate the discrete dynamics and get the velocity
vhist = [];
for i = 1:length(T0:dt:Tf)
    if i == 1
        x = [0; 0];
    else
        x = Ad*x + Bd*ur(i);
    end
    vhist = [vhist; x(2)];
end

% compute the acceleration
ahist = 0;
for i = 1:(length(vhist) - 1)
    a = (vhist(i + 1) - vhist(i))/dt;
    ahist = [ahist; a];
end
y = ahist;

% plot the acceleration
figure
plot(T0:dt:Tf,y)
xlim([T0, Tf])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Compute the DFT of the input/output signals and plot 

Np = 1024;
Us = fft(ur, Np)/Np;
Ys = fft(y, Np)/Np;
w = 0.5*fs*linspace(0,1,Np/2+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Compute the correlation functions

YU = Ys.*conj(Us);
UU = Us.*conj(Us);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7. Compute the transfer function for k = 2,3,4 and plot 

Gs = YU./UU;