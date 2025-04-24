%% EXTENDED KALMAN FILTER PROJECT, PART 5: MONTE CARLO SIMULATION
%% main.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Up Workspace

clear; clc; close all;
addpath("simulation\", "simulation\error budget", "plotting\");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% System Truth Inputs

% Mass & Gravity
inp.m = 1;
inp.g = 9.8066;

% Initial State Truth
inp.x0 = [ 100.00;                      % r_x
          1000.00;                      % r_y
            -2.00;                      % v_x
           -10.00;                      % v_y
            -0.04;                      % True Delta h
             8.80;                      % True Delta beta
            -0.10;                      % True Delta rho_0
           740.00];                     % True Delta k_p
    
% Nominal Values for Uncertain Constants
inp.bar = [   2.000;                    % h_bar
            150.000;                    % beta_bar
              1.225;                    % rho_0_bar
           9200.000];                   % k_p_bar

% Process Noise Spectral Density
inp.Qs = diag([0 0 1 1 0 0 0 0]);       % Noise Qs(t)

% Measurement Noise Variance
inp.R = 4;                              % Measurement R_k

% Measurement Sampling
inp.tm = 1/2;                           % Delta t_k

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extended Kalman Filter Inputs

% Process Noise Spectral Density
inp.Qs_EKF = diag([0 0 1 1 0 0 0 0]);               % Noise Qs(t)

% Measurement Noise Variance
inp.R_EKF = 4;                                          % Measurement R_k

% Initial Error Covariance Estimate
inp.P0 = diag([10 1000 5 10 0.04 225 0.015 846400]);    % Error P0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation Inputs

% Simulation Settings
m = 1000;                       % Monte Carlo - # of runs
n = 1000;                       % Monte Carlo - # of runs per plot
inp.tf_stop = inf;              % Error Budget - time of interest
inp.ry_stop = 0;                % Error Budget - height of interest
inp.seed = 10;                  % random number generator seed

% Integration Settings
inp.ts = 0.01;                  % sim integartion time step
inp.algorithm = 2;              % EKF algorithm 1 or 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation & Analysis

% Monte Carlo - generate 'm' runs and generate sample mean data
[sim_data, sample_data] = monteCarlo(inp,m);

% Error Budget - generate the error budget table
[error_table, Pstar, r] = errorBudget(inp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Data
close all;

% Monte Carlo - plot nominal run vs sampled data
plotSampledEKF(sim_data, sample_data);

% Monte Carlo - plot all sim data from first 'n' runs
plotAllNoise(sim_data, n);
plotAllErrors(sim_data, n);
plotAllGains(sim_data,n);
plotAllStates(sim_data, n);

% Error Budget - gains vs time
plotAllGains(sim_data,1);

% Sensitivity Analysis - sensitivity plots
plotSensitivity(error_table);