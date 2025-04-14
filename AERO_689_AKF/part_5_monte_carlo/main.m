%% Falling Object Estimation Sim
clear; clc; close all;
addpath("plotting\");
addpath("simulation\");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Nominal System Inputs

% Mass & Gravity
inp.m = 1;
inp.g = 9.8066;

% Initial State
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

% Measurement & EKF Sampling
inp.tm = 1/2;                   % sampling period

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

m = 100;           % number of runs for monte carlo
inp.ts = 0.01;      % simulation time step
inp.tf = 30;        % simulation max time
inp.method = '2';   % algorithm 1 or 2 for the EKF

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Monte Carlo Simulation

sim_data = monteCarlo(inp,m);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post Processing

% plot time history data
plotNoise(inp, sim_data, m);
plotErrors(sim_data, m);
plotStates(sim_data, m);