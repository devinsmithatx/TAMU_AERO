clear; clc;
% System Parameters

m1 = 290; % kg -- Body mass
m2 = 60; % kg -- suspension mass
k1 = 16200; % N/m
k2 = 191000; % N/m
c1 = 1000; % Ns/m

A = [0       0          1      0    ;
     0       0          0      1    ;
    -k1/m1   k1/m1     -c1/m1  c1/m1;
     k1/m1 -(k1+k2)/m2  c1/m2 -c1/m2;];

Bu = [0;
      0;
      1/m1;
     -1/m2];

Bw = [0;
      0;
      0;
      k2/m2];

nx = 4; nu = 1;
nz = 1; nw = 1;

Cz = [1,0,0,0];

Du = 1;

Dw = 1;

P = ss(A, [Bw Bu], Cz, [Dw Du]);

nmeas = 1;
ncount = 2;
[K, CL, gamma] = h2syn(P, nmeas, ncount);