clc; clear; close all

% Pitch Dynamics Taken from SMAC_LFRT_v2.1 library

% States:       angle of attack (alpha), pitch rate (q)
% Control:      tail plane deflection (delta_p)
% Measurements: load factor (eta), pitch rate (q)

% Linearized about given trim:
% alpha0 = 0.1745;
% q0 = 0;
% Mach = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% System Parameters

% Load A, B, C, D matrices
missile_linearized

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Controllability & Observability

figure; pzmap(ss(A,B,C,D));
rank(ctrb(A,B))
rank(obsv(A,C))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Open-Loop State-Space Model

% Disturbance model
Bw = [0; 1];

% Minimize [q delta_p]^T
Cz = [0 1; 0 0];
Dz = [0 0; 0 1];

% Open-Loop
P = ss(A, [Bw B], [Cz; C], [Dz; [0; 0] D]);
P.StateName = {'alpha'; 'q'};
P.InputName = {'w'; 'u'};
P.OutputName = {'z1'; 'z2'; 'y1'; 'y2'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Closed-Loop State-Space Model

% Nominal Closed-Loop
[K1, CL1, gamma1] = hinfsyn(P, height(C), width(B));
[K2, CL2, gamma2] = h2syn(P, height(C), width(B));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test Controller

% test sinusoid
T = 0:0.01:20;
w = sin(10*T);
[yout1,t1] = lsim(CL1(2,1),w',T);
[yout2,t2] = lsim(CL2(2,1),w',T);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plots

% plot results
plot_results(P, CL2, gamma1)

% plot results
plot_results(P, CL1, gamma1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plots for sinusoidal disturbance

figure; 
subplot(2,1,1);
plot(t1,yout1); ylabel("q (rad/s)")
title("Sinusoidal Response");
subplot(2,1,2);
plot(t1,w); ylabel("w (rad/s^2)"); xlabel("t (s)"); 

figure; 
subplot(2,1,1); 
plot(t2,yout2); ylabel("q (rad/s)")
title("Sinusoidal Response")
subplot(2,1,2);
plot(t2,w); ylabel("w (rad/s^2)"); xlabel("t (s)"); 