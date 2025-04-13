clc; clear; close all

% Pitch Dynamics Taken from SMAC_LFRT_v2.1 library

% States:       angle of attack (alpha), pitch rate (q)
% Control:      tail plane deflection (delta_p)
% Measurements: load factor (eta), pitch rate (q)

% Linearized about given trim:
% alpha0 = 0.1745;
% q0 = 0;
% Mach = 3;

% Load A, B, C, D matrices
missile_linearized

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Disturbance model
Bw = [0; 180/pi];              % assuming disturbance is in form of rad/s^2

% Minimize [alpha delta_p]^T
Cz = [1 0; 0 0];
Dz = [0 0; 0 1];

% Open-Loop
P = ss(A, [Bw B], [Cz; C], [Dz; [0; 0] D]);
P.StateName = {'alpha'; 'q'};
P.InputName = {'w'; 'u'};
P.OutputName = {'z1'; 'z2'; 'y1'; 'y2'};

% Nominal Closed-Loop
[K, CL, gamma] = hinfsyn(P, height(C), width(B));
% [K, CL, gamma] = h2syn(P, height(C), width(B));

% plot results
plot_results(P, CL, gamma)