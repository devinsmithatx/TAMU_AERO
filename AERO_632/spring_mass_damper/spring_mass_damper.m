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
A = [0 0 1 0; 0 0 0 1; -k1/m1 k1/m1 -c1/m1 c1/m1; k1/m1 -(k1+k2)/m2 c1/m2 -c1/m2;];

% B Matrix
Bw = [0; 0; 0; k2/m2]; 
Bu = [0; 0; 1/m1; -1/m2];

% Minimize z = [x1 u]^T
% Cz = [1 0 0 0; 0 0 0 0;]; 
% Dzw = [0; 0];
% Dzu = [0; 1];

% Minimize z = x1
Cz = [1 0 0 0];
Dzw = 0;
Dzu = 0;

% Measure y = d^2/dt^2 x1 (acceleration of x1)
% Cy = A(3,:); 
% Dyw = Bw(3,:); 
% Dyu = Bu(3,:);

% Measure x1
Cy = [1 0 0 0];
Dyw = 0;
Dyu = 0;

% Open-Loop
P = ss(A, [Bw Bu], [Cz; Cy], [Dzw Dzu; Dyw Dyu]);
P.StateName = {'x1'; 'x2'; 'v1'; 'v2'};
P.InputName = {'w'; 'u'};
P.OutputName = {'z1'; 'y'};

% Nominal & Uncertain Open-Loop (for plots)
P_uncertain = P;
P_nominal = P.NominalValue;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Closed-Loop State-Space Model

% Nominal Closed-Loopl,
[K, CL, gamma] = hinfsyn(P, height(Cy), width(Bu));
% [K, CL, gamma] = h2syn(P, height(Cy), width(Bu));

% Uncertain Closed-Loop (insert uncertain P.A and P.B into CL.A and CL.B)
CL_A = [P.A CL.A(1:4,5:8); CL.A(5:end,:)];
CL_B = [P.B(1:end, 1); CL.B(5:end,:)];

CL_nominal = CL;
CL_uncertain = ss(CL_A, CL_B, CL.C, CL.D);

CL_uncertain.StateName = CL_nominal.StateName;
CL_uncertain.InputName = CL_nominal.InputName;
CL_uncertain.OutputName = CL_nominal.OutputName;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plots

plot_results(P_nominal, P_uncertain, CL_nominal, CL_uncertain, gamma);