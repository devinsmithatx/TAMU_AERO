clear; clc; close all;

%% USER INPUT

inp.r0 = [0; 1000];     % [m]           initial position
inp.v0 = [0; 0];        % [m/s]         initial velocity
inp.h = 2;              % [m]           height of radar
inp.R = 4;              % [m^2]         noise covariance
inp.tm = 0.5;           % [s]           measurement sampling period
inp.Qs = [0 0 0 0       % [m^2 / s^5]   spectral density matrix
          0 0 0 0 
          0 0 0 0
          0 0 0 0.01];
inp.P0 = [0 0 0 0       % [m^2, m^2/s^4] initial estimate error covariance
          0 100 0 0
          0 0 0 0
          0 0 0 10];
inp.dt = 0.1;          % [s]           simulation time step

%% SIMULATION

sim_run(inp);
