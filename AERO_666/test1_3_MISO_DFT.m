%% Problem 3, Test 1
% Devin Smth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use the method in problem 1 for a the new spring-mass damper system

clear; clc; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tasks

% 1. Consider the three mass system. Get G_31 and G_33 using Problem 1

m = 2;              % given mass (kg)
k = 10;             % given k (N/m)
c1 = 0.05;          % given c1 
c2 = 0.07;          % given c2 
c3 = 0.04;          % given c3
fs = 2;             % chose same fs as problem 1

[Ad, Bd] = discretize(m, k, c1, c2, c3, fs);

T0 = 0;                         % given initial time
Tf = 1024;                      % given final time (1024 samples)
T = T0:1/fs:(Tf - 1/fs);        % time values

Np = length(T);
Ne = Np/2;
uhist = zeros(2,Np);
uhist(:,1:Ne) = randn(2,Ne).*hann(Ne).';

[xhist, ahist] = responseDyn(Ad, Bd, T, uhist);
responsePlot(xhist, uhist, ahist, T);

U1s = fft(uhist(1,:), Np)/Np;
U3s = fft(uhist(2,:), Np)/Np;
X3s = fft(xhist(3,:), Np)/Np;

plotDFT(X3s,U1s,U3s,fs,Np);

X3U1 = X3s.*conj(U1s);
U1U1 = U1s.*conj(U1s);
G31s = X3U1./U1U1;
X3U3 = X3s.*conj(U3s);
U3U3 = U3s.*conj(U3s);
G33s = X3U3./U3U3;

% 2. Plot the frequency responses of the system

plotG(G31s, G33s, fs, Np)

A = [0 0 0 1 0 0;
     0 0 0 0 1 0;
     0 0 0 0 0 1;
    -2*k  k    0 (-c1 - c2) c2         0;
     k   -2*k  k c2         (-c2 - c3) c3;
     0    k   -k 0          0          0];
A(4:end,:) = A(4:end,:)/m;
wn = imag(eig(A))/(2*pi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Functions

% discretize the system
function [Ad, Bd] = discretize(m, k, c1, c2, c3, fs)
    A = [0 0 0 1 0 0;
         0 0 0 0 1 0;
         0 0 0 0 0 1;
         -2*k k 0 (-c1 - c2) c2 0;
         k -2*k k c2 (-c2 - c3) c3;
         0 k -k 0 0 0];
    A(4:end,:) = A(4:end,:)/m;
        
    B = [0 0;
         0 0;
         0 0;
         1/m 0;
         0 0; 
         0 1/m;];

    dt = 1/fs;                      % samplinng time step
    
    Ad = expm(A*dt);                % discrete A matrix
    Bd = (Ad - eye(6,6))*A^-1*B;    % discrete B matrix
end

% simulate the dynamics
function [xhist, ahist] = responseDyn(Ad, Bd, T, uhist)
    x = [0; 0; 0; 0; 0; 0];
    xhist = x;
    for i = 2:length(T)
        x = Ad*x + Bd*uhist(:,i);
        xhist = [xhist x];
    end

    a1hist = diff(xhist(4,:));
    a2hist = diff(xhist(5,:));
    a3hist = diff(xhist(6,:));
    ahist = [a1hist; a2hist; a3hist];
end

% plot the dynamics
function responsePlot(xhist, uhist, ahist, T)
    T0 = T(1);
    Tf = T(end);

    % plot the position 1
    figure; stairs(T,xhist(1,:), 'k'); xlim([T0, Tf]); 
    ylabel("$x_1$ ($m$)", Interpreter='latex');
    xlabel("$t$ ($s$)", Interpreter="latex")
    title("Position 1 vs. Time", Interpreter="latex")
    
   % plot the position 2
    figure; stairs(T,xhist(2,:), 'k'); xlim([T0, Tf]); 
    ylabel("$x_2$ ($m$)", Interpreter='latex');
    xlabel("$t$ ($s$)", Interpreter="latex")
    title("Position 2 vs. Time", Interpreter="latex")

    % plot the position 3
    figure; stairs(T,xhist(3,:), 'k'); xlim([T0, Tf]); 
    ylabel("$x_3$ ($m$)", Interpreter='latex');
    xlabel("$t$ ($s$)", Interpreter="latex")
    title("Position 3 vs. Time", Interpreter="latex")

    % plot the velocity 1
    figure; stairs(T,xhist(4,:), 'k'); xlim([T0, Tf]);
    ylabel("$\dot{x}_1$ ($\frac{m}{s}$)", Interpreter='latex');
    xlabel("$t$ ($s$)", Interpreter="latex")
    title("Velocity 1 vs. Time", Interpreter="latex")

    % plot the velocity 2
    figure; stairs(T,xhist(5,:), 'k'); xlim([T0, Tf]);
    ylabel("$\dot{x}_2$ ($\frac{m}{s}$)", Interpreter='latex');
    xlabel("$t$ ($s$)", Interpreter="latex")
    title("Velocity 2 vs. Time", Interpreter="latex")

    % plot the velocity 1
    figure; stairs(T,xhist(6,:), 'k'); xlim([T0, Tf]);
    ylabel("$\dot{x}_3$ ($\frac{m}{s}$)", Interpreter='latex');
    xlabel("$t$ ($s$)", Interpreter="latex")
    title("Velocity 3 vs. Time", Interpreter="latex")

    % plot the control 1
    figure; stairs(T,uhist(1,:), 'k'); xlim([T0, Tf]);
    ylabel("$u_1$ ($N$)", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex")
    title("Control 1 vs. Time", Interpreter="latex")

    % plot the control 3
    figure; stairs(T,uhist(2,:), 'k'); xlim([T0, Tf]);
    ylabel("$u_3$ ($N$)", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex")
    title("Control 3 vs. Time", Interpreter="latex")
    
    % plot the acceleration 1
    figure; stairs(T(1:end - 1), ahist(1,:), 'k'); xlim([T0, Tf])
    ylabel("$\ddot{x}_1$ ($\frac{m}{s^2}$)", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex")
    title("Acceleration 1 vs. Time", Interpreter="latex")

    % plot the acceleration 2
    figure; stairs(T(1:end - 1), ahist(2,:), 'k'); xlim([T0, Tf])
    ylabel("$\ddot{x}_2$ ($\frac{m}{s^2}$)", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex")
    title("Acceleration 2 vs. Time", Interpreter="latex")

    % plot the acceleration 3
    figure; stairs(T(1:end - 1), ahist(3,:), 'k'); xlim([T0, Tf])
    ylabel("$\ddot{x}_3$ ($\frac{m}{s^2}$)", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex")
    title("Acceleration 3 vs. Time", Interpreter="latex")
end

% plot the DFT
function plotDFT(X3s, U1s, U3s, fs, Np)
    U1m = round(abs(U1s(1:Np/2 + 1)),10);
    U3m = round(abs(U3s(1:Np/2 + 1)),10);
    X3m = round(abs(X3s(1:Np/2 + 1)),10);
    w = 0.5*fs*linspace(0,1,Np/2+1);
    
    figure; stem(w, U1m, 'k'); xlim([w(1) w(end)]);
    title("DFT of Control 1", Interpreter='latex');
    xlabel("$F$ (Hz)", Interpreter="latex");
    ylabel('$|U_1(s)|$', Interpreter='latex'); 

    figure; stem(w, U3m, 'k'); xlim([w(1) w(end)]);
    title("DFT of Control 3", Interpreter='latex');
    xlabel("$F$ (Hz)", Interpreter="latex");
    ylabel('$|U_3(s)|$', Interpreter='latex'); 
    
    figure; stem(w, X3m, 'k'); xlim([w(1) w(end)]);
    title("DFT of Position 3", Interpreter='latex');
    xlabel("$F$ (Hz)", Interpreter="latex");
    ylabel('$|X_3(s)|$', Interpreter='latex');
end

% plot G(s)
function plotG(G13s, G33s, fs, Np)
    G13s = abs(G13s);
    G33s = abs(G33s);
    w = 0.5*fs*linspace(0,1,Np/2+1);

    figure; stem(w,G13s(1:Np/2 + 1), 'k');
    title('Magnitude of $G_{31}(s)$', Interpreter='latex');
    xlabel("$F$ (Hz)", Interpreter="latex");
    ylabel('$|G_{31}(s)|$', Interpreter='latex');

    figure; stem(w,G33s(1:Np/2 + 1), 'k');
    title('Magnitude of $G_{33}(s)$', Interpreter='latex');
    xlabel("$F$ (Hz)", Interpreter="latex");
    ylabel('$|G_{33}(s)|$', Interpreter='latex');
end
