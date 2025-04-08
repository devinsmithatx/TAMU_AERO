%% Falling Object Estimation Sim
clear; clc; close all;
addpath("plotting\");
addpath("simulation\");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Inputs

% Initial State
inp.x0 = [ 100.00;              % r_x
          1000.00;              % r_y
            -2.00;              % v_x
           -10.00;              % v_y
            -0.04;              % Delta h
             8.80;              % Delta beta
            -0.10;              % Delta rho_0
           740.00];             % Delta k_p

% Initial State Estimate
inp.xh0 = [  97.90;             % r_x
           1037.40;             % r_y
             -0.24;             % v_x
             -3.50;             % v_y
              0.00;             % Delta h
              0.00;             % Delta beta 
              0.00;             % Delta rho_0
              0.00];            % Delta k_p

% Nominal Values for Uncertain Constants/States
inp.bar = [   2.000;            % h_bar
            150.000;            % beta_bar
              1.225;            % rho_0_bar
           9200.000];           % k_p_bar

% Initial Error Covariance Estimate
inp.P0 = diag([10 1000 .1 10 0.04 225 0.015 846400]);

% Process Noise Spectral Density
inp.Qs = 1*diag([0 0 1 1 0 0 0 0]);

% Measurement Noise Variance
inp.R = 4;

% Measurement & EKF Sampling
inp.tm = 1/2;       % sampling period

% Mass & Gravity
inp.m = 1;
inp.g = 9.8066;

% Simulation Parameters
inp.seed = 3;
inp.ts = 0.01;      % simulation time step
inp.tf = 30;        % simulation max time
inp.method = '2';   % algorithm 1 or 2 for the EKF

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation

% run the sim
[state_hist, measurement_hist, estimate_hist] = simRun(inp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post Processing

% plot time history data
plotNoise(inp, state_hist, measurement_hist);
plotErrors(state_hist, estimate_hist);
plotStates(inp, state_hist, estimate_hist);