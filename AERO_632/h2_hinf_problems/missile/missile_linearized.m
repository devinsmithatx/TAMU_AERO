clear; clc; close all

% load missle data
missile_data

% trim condition
alpha0 = 0.1745;
q0 = 0;
Ma0 = 3;
delta_p0 = -(m3*alpha0^3 + m2*alpha0^2 + m1*(-7 +(8/3)*Ma0)*alpha0)/m0;

% symbolic variables
syms alpha q Ma delta_p

% differential equations
Cz = z3*alpha^3 + z2*alpha^2 + z1*(2 -(1/3)*Ma)*alpha + z0*delta_p;
Cm = m3*alpha^3 + m2*alpha^2 + m1*(-7 +(8/3)*Ma)*alpha + m0*delta_p;

d_alpha = K1*Ma*Cz*cos(alpha) + q;
d_q = K2*Ma^2*Cm;
eta = K3*Ma^2*Cz;

F = [d_alpha; d_q; eta];

% evaluate jacobian
J = [diff(F,'alpha') diff(F,'q') diff(F,'delta_p')];

% substitute trim conditon
J0 = double(subs(J, {alpha, q, Ma, delta_p}, {alpha0, q0, Ma0, delta_p0}));

% A, B, C, D matrices
A = J0(1:2,1:2);            % [dda/da dda/dq; ddq/da ddq/dq]
B = J0(1:2, 3);             % [dda/ddp; ddq/ddp]
C = [J0( 3, 1:2); 0 1];     % [dn/da dn/dq; 0 q] 
D = [J0( 3,  3); 0];        % [dn/ddp; 0]