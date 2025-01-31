
clear; clc; close all; % start a fresh session
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AERO 625 Homework 2, Problem 7 (Project Part 1)
% Devin Smith
% 
% Aircraft: Fuji/Rockwell Commander 700
% Dyanmics Model: Cruise, Longitudinal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ------------------------------------------------------------------------- 
% a) system in state-space form

% A and B matrices from 'linear models - fixed-wing F24 - Ver3.pdf' slide 1
A = [[-0.0246   6.8470   0.0000 -32.1700];
     [-0.0012  -1.0000   1.0000   0.0000];
     [ 0.0000  -3.5350  -2.2450   0.0000];
     [ 0.0000   0.0000   1.0000   0.0000]];

B = [0.0000;
    -0.0915;
    -8.5740;
     0.0000];

% Choose a C and D matrix
C = [[1 0 0 0];
     [0 1 0 0];
     [0 0 1 0];
     [0 0 0 1]];

D = 0;

% ------------------------------------------------------------------------- 
% b) open-loop characteristics

% eigenvalues and eigenvectors
[eig_vec, eig_val] = eig(A);

% frequencies, damping ratios, and time constants
freqs = [abs(eig_val(1, 1)) abs(eig_val(3, 3))];
damps = abs([real(eig_val(1, 1))/freqs(1) real(eig_val(3, 3))/freqs(2)]);

% ------------------------------------------------------------------------- 
% c) sampling period T

% choosing an sampling period based on highest continuous freq
% w_s = 2pi/T; w_N = pi/T
T = 2*pi/max(freqs);

% ------------------------------------------------------------------------- 
% d) controllability and observability

% discrete state transition matrices
[phi, gamma] = c2d(A, B, T);

% controllability / reachability matrix
C_ctrb = ctrb(phi, gamma);
controllable = (rank(C_ctrb) == height(phi));   % rank(C) == n

% observability
O = obsv(phi, C);
observable = (rank(O) == height(phi));          % rank(O) == n

% ------------------------------------------------------------------------- 
% OUTPUTS

% a)
disp("A Matrix (Continuous)")
disp(A)
disp('B Matrix (Continuous)')
disp(B)
disp("C Matrix (Continuous)")
disp(C)
disp('D Matrix (Continuous)')
disp(D)

% b)
disp("Eigenvalues")
disp([eig_val(1, 1) eig_val(2, 2) eig_val(3, 3) eig_val(4, 4)])
disp("Eigenvectors")
disp([eig_vec])
disp("Natural Frequencies")
disp([freqs(1) freqs(2)])
disp("Damping Ratios")
disp([damps(1) damps(2)])

% c)
disp("Sampling Period (sec)")
disp(T)

% d)
disp("Controllability Matrix (Discrete)")
disp(C_ctrb)
if controllable
    disp('[rank(C) == n] therefore system is controllable')
else
    disp('[rank(C) != n] therefore system is not controllable')
end
disp(' ')

disp("Observability Matrix (Discrete)")
disp(O)
if observable
    disp('[rank(O) == n] therefore system is observable')
else
    disp('[rank(O) != n] therefore system is not observable')
end