clear; clc; close all

% Longitudinal Dynamics from 
% "State-Space Modeling of a Rocket for Optimal Control System Design"
% by Aliyu Bhar Kisabo and Aliyu Funmilayo Adebimpe

% States: pitch angle (theta), pitch rate (q), z-velocity (w)
% Control: tail plane deflection (delta_eta), induced aoa (alpha_w)
% Measurement: pitch anlge (q)

A = [   0.0000  1  0.00000; 
       14.7805  0  0.01958;
     -100.8580  1 -0.12560;];

B = [ 0.0000   0.0000; 
      3.4858  14.7805; 
     20.4200 -94.8557;];

C = [1 0 0];
D = [0 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Disturbance model
Bw = [0; 0; 1];              % assuming disturbance is in form of m/s^2

% Minimize [theta]^T
Cz = [1 0 0];
Dz = [0 0 0];

% Open-Loop
P = ss(A, [Bw B], [Cz; C], [Dz; 0 D]);
P.StateName = {'theta'; 'q'; 'w'};
P.InputName = {'d'; 'u1'; 'u2'};
P.OutputName = {'z1'; 'y1'};

% Nominal Closed-Loop
[K, CL, gamma] = hinfsyn(P, height(C), width(B));
% [K, CL, gamma] = h2syn(P, height(C), width(B));

% plot results
plot_results(P, CL, gamma)