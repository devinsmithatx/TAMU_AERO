clc; clear; close all;

% add all the fucntions needed
addpath("Functions\Valasek\")
addpath("Functions\Analysis\")
addpath("Functions\SDR\")
addpath("Functions\PI_SDR\")
addpath("Functions\NZSP\")
addpath("Functions\PI_NZSP\")
addpath("Functions\PIF_NZSP_CRW\")
addpath("Functions\SINUSOID\")

%% PROBLEM STATEMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework 4, Question 4 (Project)
% AERO 625
% Devin Smith
%
%       Aircraft:             Fuji/Rockwell Commander 700
%       Dyanmics Model:       Cruise, Lat/d
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SYSTEM MODEL

% STATE SPACE (CONTINUOUS)
A = [-0.1380 -0.0017 -0.9910 0.1910
     -0.8390 -1.7200  0.1520 0.0000
      2.9800 -0.8220 -0.2690 0.0000
      0.0000  1.0000  0.0000 0.0000];

B = [0.0000  0.0046
     2.0100  0.1230
     0.3050 -1.3900
     0.0000  0.0000];

C = eye(4,4);
D = zeros(4,2);

inp.A = A;
inp.B = B;
inp.C = C;
inp.D = D;

% ACTUATOR DYNAMICS
tau = 0.1;
inp.A = [A B; zeros(2,4) -1/tau*eye(2,2);]; 
inp.B = [zeros(4,2); 1/tau*eye(2,2);];
inp.C = eye(6,6);
inp.D = zeros(6,2);


% CONTROLLER
[wn, ~, ~] = damp(A);       % open loop natural frequecies
w_nyq = max(wn)/(2*pi);     % let nyquist freq = highest natural freq
w_ctrl = w_nyq*10;          % sampling at 10*nyquist
inp.T = 1/w_ctrl;           % sampling period
inp.T = round(inp.T,1);     % round the sampling period

% STATE SPACE (DISCRETE)
[inp.phi, inp.gamma] = c2d(inp.A,inp.B,inp.T);

% OPEN-LOOP CHARACTERISTICS (CONTINUOUS AND DISCRETE)
% open_loop_characteristics(inp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATIONS AND ANALYSIS 

% A) sampled data regulator (SDR)
inp.x_0 = [5*pi/180; 0.1*pi/180; 0.1*pi/180; 5*pi/180; 0; 0];
% SDR(inp);

% B) proportional integral sampled data regulator (PI-SDR)
inp.Gw = [1*pi/180; 0; 0; 0; 0; 0; 0]; 
% PI_SDR(inp)

% C) nonzero setpoint
% NZSP(inp)
% NZSP(inp)
inp.y_m = [10*pi/180; 10*pi/180;];
% NZSP(inp)

% D) proportional integral nonzero setpoint
inp.Gw = [1*pi/180; 0; 0; 0; 0; 0; 0;]; 
% PI_NZSP(inp)

% E) proportional integral filter nonzero setpoint
inp.Gw = [1*pi/180; 0; 0; 0; 0; 0; 0; 0; 0;]; 
inp.x_0 = [5*pi/180; 0.1*pi/180; 0.1*pi/180; 5*pi/180; 0; 0];
inp.y_m = [10*pi/180; 10*pi/180;];
% PIF_NZSP_CRW(inp)

% sinusoidal input for y_m(t) using PIF-NZSP-CRW
inp.x_0 = [5*pi/180; 0.1*pi/180; 0.1*pi/180; 5*pi/180; 0; 0];
inp.y_m = [10*pi/180; 10*pi/180;];
inp.amplitude = 5*pi/180;
inp.period = 15;
SINUSOID(inp)
