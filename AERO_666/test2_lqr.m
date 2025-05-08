clear; clc; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problem 2

% Open-loop Damping Ratio and Natural Frequency
zeta = -0.01;
omega_n = 3;

% Open-Loop Lransfer Function Coefficients 1/(s^2 + a1*s + a2)
a1 = 2*zeta*omega_n;
a2 = omega_n^2;

% Define A and B Matrices
A = [0  1; -a2 -a1;]; 
B = [0; 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problem 2.1

% Define Q and R matrices
Q = [4 1; 1 4];
R = 10;

% Solve the Algebraic Ricatti Equation and Solve for G
P = are(A,B*R^(-1)*B',Q);
G = R^(-1)*B'*P;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problem 2.2

% Calculate the Controlled Response
sys = ss(A-B*G, B, eye(2), 0);
t = 0:0.01:5;
x0 = [10, 5];
[y, t, x] = initial(sys, x0, t);

% Plot x1 for Systemsys
figure;
subplot(2,1,1)
plot(t,y(:,1), 'k'); grid on;
ylabel("$x_1$", Interpreter="latex");
title(['Controlled Response for LQR Gain = $[' num2str(G(1)) ...
    '\ ' num2str(G(2)) ']$'], Interpreter='latex');

% Plot x2 for System
subplot(2,1,2);
plot(t,y(:,2),'k'); grid on;
ylabel('$x_2$', Interpreter="latex")
xlabel('$t$ (s)', Interpreter="latex")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problem 2.3

% Frequency Responses
w = log10(logspace(0.1, 100, 500));
[mag1, phase1, w] = bode(sys, w);

% Magnitude and Phases
mag1_x1 = 20*log10(mag1(1,:));
mag1_x2 = 20*log10(mag1(2,:));
phase1_x1 = phase1(1,:);
phase1_x2 = phase1(2,:);

% Plot |G(s)| for System 1, x1
figure;
subplot(2,2,1)
sgtitle(['Bode Plots for LQR Gain = $[' num2str(G(1)) ...
    '\ ' num2str(G(2)) ']$'], Interpreter="latex");
semilogx(w, mag1_x1, 'k'); grid on;
ylabel("$|G(j\omega)|$ (dB)", Interpreter="latex");
title('$x_1$', Interpreter='latex')

% Plot < G(s) for System 1, x1
subplot(2,2,3);
semilogx(w, phase1_x1,'k'); grid on;
ylabel('$\angle G(j\omega)$ (deg)', Interpreter="latex")
xlabel('$\omega$ (rad/s)', Interpreter="latex")

% Plot |G(s)| for System 1, x2
subplot(2,2,2)
semilogx(w, mag1_x2, 'k'); grid on;
title('$x_2$', Interpreter='latex')

% Plot < G(s) for System 1, x2
subplot(2,2,4);
semilogx(w, phase1_x2,'k'); grid on;
xlabel('$\omega$ (rad/s)', Interpreter="latex")