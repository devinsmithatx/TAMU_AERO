%% Falling Object Estimation Sim
clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Inputs

% initial state truths
inp.g = 9.8066;
inp.m = 1;
inp.x0 = [100; 1000; -2; -10; -.04; 8.8; -.1; 740];

% initial state estimation guesses
inp.P0 = diag([10 1000 0.1 10 0.04 225 0.015 846400]);
inp.xh0 = [97.9; 1037.4; -.24; -3.5; 0; 0; 0; 0];

% process noise characteristics
inp.qs = 1;
inp.Qs = inp.qs*diag([0 0 1 1 0 0 0 0]);

% measurement noise characteristics
inp.R = 4;
inp.tm = 1/2;

% nominal values of uncertain states
inp.bar = [2; 150; 1.225; 9200];

% simulation parameters
inp.ts = 0.1;
inp.F = solveFsym(inp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation

% run the sim
simRun(inp);
