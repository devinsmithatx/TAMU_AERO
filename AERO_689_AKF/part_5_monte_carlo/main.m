%% EXTENDED KALMAN FILTER PROJECT, PART 4: MONTE CARLO SIMULATION

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Up Workspace

clear; clc; close all;
addpath("plotting\");
addpath("simulation\");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Truth System Inputs

% Mass & Gravity
inp.m = 1;
inp.g = 9.8066;

% Initial State Truth
inp.x0 = [ 100.00;              % r_x
          1000.00;              % r_y
            -2.00;              % v_x
           -10.00;              % v_y
            -0.04;              % True Delta h
             8.80;              % True Delta beta
            -0.10;              % True Delta rho_0
           740.00];             % True Delta k_p
    
% Nominal Values for Uncertain Constants
inp.bar = [   2.000;            % h_bar
            150.000;            % beta_bar
              1.225;            % rho_0_bar
           9200.000];           % k_p_bar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stochastic System Inputs

% Process Noise Spectral Density
inp.Qs = 1*diag([0 0 1 1 0 0 0 0]);

% Measurement Noise Variance
inp.R = 4;

% Initial Error Covariance Estimate
inp.P0 = diag([10 1000 .1 10 0.04 225 0.015 846400]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation Inputs

m = 20;            % number of runs for monte carlo
inp.ts = 0.01;      % simulation time step
inp.tf = 25;        % simulation max alloted time falling
inp.tm = 1/2;       % EKF & Radar sampling period
inp.method = '2';   % algorithm 1 or 2 for the EKF

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Monte Carlo Simulation

% run the monte carlo simulation
[sim_data, sample_data] = monteCarlo(inp,m);

% plot all data from first n runs
plotAllNoise(inp, sim_data, m);
plotAllErrors(sim_data, m);
plotAllStates(sim_data, m);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EKF Performance Check

% plot nominal EKF run vs mean error & sampled error covariance
plotSampledEKF(sim_data, sample_data);