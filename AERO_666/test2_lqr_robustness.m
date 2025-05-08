clear; clc; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problem 3

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
%% Problem 3.1

% Define Alpha Values
alpha = linspace(2, 1000, 1000);

% Solve for all Gains
G = zeros(length(alpha),2);
for i = 1:length(alpha)
    % Define Q and R matrices
    Q = [alpha(i) 1; 1 alpha(i)];
    R = 1;

    % Solve the Algebraic Ricatti Equation and Solve for G
    P = are(A,B*R^(-1)*B',Q);
    G(i,:) = R^(-1)*B'*P;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problem 3.2

% Calculate ||E||
E = zeros(1,length(alpha));
for i = 1:length(alpha)
    [phi, lambda] = eig(A-B*G(i,:));
    E(i) = min(-real(diag(lambda)))/cond(phi);
end

figure;
plot(alpha,E, 'k'); grid on;
title('$\|E(\alpha)\|$ for LQR Controller', Interpreter='latex')
xlabel('$\alpha$', Interpreter='latex')
ylabel('$\|E\|$', Interpreter='latex')


