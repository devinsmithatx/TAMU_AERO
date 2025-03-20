%% Problem 1, Test 1
% Devin Smth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This problem will cover auto and cross corellation sequencies to compute
% a frequency response of a dynamic system

clear; clc; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tasks 

% 1. Construct the discrete time model

fs = 1;                 % sampling frequency
k = 1;                  % spring constant
c = 0.01;               % damping coefficient

[Ad, Bd] = discretize(k, c, fs);

disp('A_d ='); disp(Ad)
disp('B_d ='); disp(Bd)

% 2. Plot the acceleration output

T0 = 0;                         % initial time
Tf = 1024;                      % final time
T = T0:1/fs:(Tf - 1/fs);        % time values

uhist = sin(2*T);

[xhist, ahist] = responseDyn(Ad, Bd, T, uhist);
responsePlot(xhist, uhist, ahist, T);

% 3. Apply a random excitation as the input signal to the system and plot

Np = length(T);
Ne = 512;
uhist = zeros(1,Np);
uhist(1,1:Ne)= randn(1,Ne).*hann(Ne).';

[xhist, ahist] = responseDyn(Ad, Bd, T, uhist);
responsePlot(xhist, uhist, ahist, T);

% 4. Compute the DFT of the input/output signals and plot 

Us = fft(uhist, Np)/Np;
Ys = fft(ahist, Np)/Np;

plotDFT(Ys,Us,fs,Np);

% 5. Compute the correlation functions

YU = Ys.*conj(Us);
UU = Us.*conj(Us);

% 6. Compute the transfer function for k = 2,3,4 and plot 

figure;
for k = 1:4
    wn = sqrt(k)/(2*pi); 
    disp(['k = ' num2str(k) ', w_n = ' num2str(wn)]);

    [Ad, Bd] = discretize(k, c, fs);
    [xhist, ahist] = responseDyn(Ad, Bd, T, uhist);
    Us = fft(uhist, Np)/Np;
    Ys = fft(ahist, Np)/Np;
    YU = Ys.*conj(Us);
    UU = Us.*conj(Us);

    Gs = YU./UU;
    Gs = abs(Gs);
    w = 0.5*fs*linspace(0,1,Np/2+1);

    stem(w,Gs(1:Np/2 + 1), DisplayName=['k = ' num2str(k)]); hold on;
    title("Magnitude of $G(j\omega)$", Interpreter='latex');
    xlabel("$F$ (Hz)", Interpreter="latex");
    ylabel('$|G(j\omega)|$', Interpreter='latex');
    legend()
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Functions

% function to discretize the system
function [Ad, Bd] = discretize(k, c, fs)
    A = [0  1; -k -c];              % continuous A matrix
    B = [0; 1];                     % continuous B matrix
    dt = 1/fs;                      % samplinng time step
    
    Ad = expm(A*dt);                % discrete A matrix
    Bd = (Ad - eye(2,2))*A^-1*B;    % discrete B matrix
end

% function to simulate the dynamics
function [xhist, ahist] = responseDyn(Ad, Bd, T, uhist)
    x = [0; 0];
    xhist = x;
    for i = 2:length(T)
        x = Ad*x + Bd*uhist(i);
        xhist = [xhist x];
    end
    ahist = diff(xhist,2);
end

% function to plot the dynamics
function responsePlot(xhist, uhist, ahist, T)
    T0 = T(1);
    Tf = T(end);

    % plot the position
    figure; stairs(T,xhist(1,:), 'k'); xlim([T0, Tf]); 
    ylabel("$x$", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex")
    title("Position vs. Time", Interpreter="latex")
    
    % plot the velocity
    figure; stairs(T,xhist(2,:), 'k'); xlim([T0, Tf]);
    ylabel("$\dot{x}$", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex")
    title("Velocity vs. Time", Interpreter="latex")
    
    % plot the control
    figure; stairs(T,uhist, 'k'); xlim([T0, Tf]);
    ylabel("$u$", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex")
    title("Control vs. Time", Interpreter="latex")
    
    % plot the acceleration
    figure; stairs(T(1:end - 1), ahist, 'k'); xlim([T0, Tf])
    ylabel("$\ddot{x}$", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex")
    title("Acceleration vs. Time", Interpreter="latex")
end

% function to plot the DFT
function plotDFT(Ys, Us, fs, Np)
    Um = round(abs(Us(1:Np/2 + 1)),10);
    Ym = round(abs(Ys(1:Np/2 + 1)),10);
    w = 0.5*fs*linspace(0,1,Np/2+1);
    
    figure; stem(w, Um, 'k'); xlim([w(1) w(end)]);
    title("DFT of Control", Interpreter='latex');
    xlabel("$F$ (Hz)", Interpreter="latex");
    ylabel('$|U(j\omega)|$', Interpreter='latex'); 
    figure; stem(w, Ym, 'k'); xlim([w(1) w(end)]);
    title("DFT of Acceleration", Interpreter='latex');
    xlabel("$F$ (Hz)", Interpreter="latex");
    ylabel('$|Y(j\omega)|$', Interpreter='latex');
end
