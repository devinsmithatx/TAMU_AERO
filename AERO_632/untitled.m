% Homework 2 Work
clear; clc;

%% Problem 5
syms omega

G = (i*omega + 2)/(4*i*omega+1);
G_1 = pi*int(G,omega,0,inf)