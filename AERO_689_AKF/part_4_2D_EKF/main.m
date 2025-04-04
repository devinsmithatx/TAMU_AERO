%% Falling Object Estimation Sim
clear; clc; close all;
addpath("jacobians\");
addpath("ode\");
addpath("plotting\");
addpath("simulation\");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Inputs

% Initial State
inp.x0 = [ 100.00; 
          1000.00; 
            -2.00; 
           -10.00; 
            -0.04; 
             8.80; 
            -0.10; 
           740.00];

% Initial State Estimate
inp.xh0 = [  97.90; 
           1037.40; 
             -0.24; 
             -3.50; 
              0.00; 
              0.00; 
              0.00; 
              0.00];

% Nominal Values for Uncertain Constants/States
inp.bar = [   2.000; 
            150.000;
              1.225; 
           9200.000];

% Initial Error Covariance Estimate
inp.P0 = diag([10 1000 0.1 10 0.04 225 0.015 846400]);

% Process Noise Spectral Density
inp.Qs = diag([0 0 1 1 0 0 0 0]);

% Measurement Noise Variance
inp.R = 4;

% Mass & Gravity
inp.m = 1;
inp.g = 9.8066;

% Time Parameters
inp.tm = 1/2;       % measurement sampling period
inp.ts = 0.1;       % simulation time step
inp.tf = 30;        % simulation max time

% Random Number Seed
inp.seed = 22;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation

% run the sim
simRun(inp);
