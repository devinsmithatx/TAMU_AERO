clear; clc; close all;

%% USER INPUT

% initial condition
inp.r0 = [0; 1000];     % [m]           initial position
inp.v0 = [0; 0];        % [m/s]         initial velocity

% sensor properties
inp.h = 2;              % [m]           height of radar
inp.R = 4;              % [m^2]         noise covariance
inp.mt = 0.5;           % [s]           measurement sampling period

% process noise properties
inp.qs = .01;           % [m^2 / s^5]   spectral density
inp.Qs = [0 0 0 0       % [m^2 / s^5]   spectral density matrix
          0 0 0 0 
          0 0 0 0
          0 0 0 inp.qs];

%% SIMULATION

dt = 0.01;
plot_data = 1;
simulation(inp, dt, plot_data);
