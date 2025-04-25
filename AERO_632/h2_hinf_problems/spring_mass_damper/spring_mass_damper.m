%% spring_mass_damper.m

clear; clc; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% System Parameters

m1 = ureal('m1', 290, 'Percentage', [-20 20]);     % kg    Body mass
m2 = ureal('m2', 60);                              % kg    Suspension mass
k1 = ureal('k1', 16200);                           % N/m   Spring 1
k2 = ureal('k2', 191000, 'Percentage', [-10 10]);  % N/m   Spring 2
c1 = ureal('c1', 1000, 'Percentage', [-10 10]);    % Ns/m  Damper 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Open-Loop State-Space Model

% A Matrix
A = [0 0 1 0; 0 0 0 1; -k1/m1 k1/m1 -c1/m1 c1/m1;
                        k1/m1 -(k1+k2)/m2 c1/m2 -c1/m2;];

% B Matrix
Bw = [0; 0; 0; k2/m2]; 
Bu = [0; 0; 1/m1; -1/m2];

% % Minimize z = [x1 u]^T
w = 1e-7;                                          % weight the control
Cz = [1 0 0 0; 0 0 0 0]; 
Dzw = [0; 0];
Dzu = w*[0; 1];

% % Alternatively, set w(t) to be an acceleration
% Bw = [0; 0; 0; 1/m2];

% % Measure y = d^2/dt^2 x1 (acceleration of x1)
% Cy = A(3,:); 
% Dyw = Bw(3,:); 
% Dyu = Bu(3,:);

% Measure y = x1
Cy = [1 0 0 0]; 
Dyw = 0;
Dyu = 0;

% Open-Loop
P = ss(A, [Bw Bu], [Cz; Cy], [Dzw Dzu; Dyw Dyu]);
P.StateName = {'x_1'; 'x_2'; 'v_1'; 'v_2'};
P.InputName = {'w'; 'u'};
P.OutputName = {'z_1'; 'z_2'; 'y'};

% Nominal & Uncertain Open-Loop (for plots)
P_uncertain = P;
P_nominal = P.NominalValue;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Closed-Loop State-Space Model

% Nominal Closed-Loopl,
[K1, CL1, gamma1] = hinfsyn(P, height(Cy), width(Bu));

% Uncertain Closed-Loop (insert uncertain P.A and P.B into CL.A and CL.B)
CL1_A = [P.A CL1.A(1:4,5:8); CL1.A(5:end,:)];
CL1_B = [P.B(1:end, 1); CL1.B(5:end,:)];

CL1_nominal = CL1;
CL1_uncertain = ss(CL1_A, CL1_B, CL1.C, CL1.D);

CL1_uncertain.StateName = CL1_nominal.StateName;
CL1_uncertain.InputName = CL1_nominal.InputName;
CL1_uncertain.OutputName = CL1_nominal.OutputName;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test Controller

% test sinusoidal w(t)
T = 0:0.01:20;
w = sin(10*T);
[yout1,t1] = lsim(CL1_nominal(1,1),w',T);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plots

% plot the poles, zeros, step/impulse response, and frequency plots
plot_results(P_nominal, P_uncertain, CL1_nominal, CL1_uncertain, gamma1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plots for sinusoidal disturbance

% plot the response for the sinusoidal w(t) for Hinf
figure; 
subplot(2,1,1); plot(t1,yout1); 
title("Sinusoidal Response"); ylabel("x_1 (m)");
subplot(2,1,2); plot(t1,w);
ylabel("w (m)");  xlabel("t (s)");