clear; clc; close all

% Longitudinal Dynamics from 
% "State-Space Modeling of a Rocket for Optimal Control System Design"
% by Aliyu Bhar Kisabo and Aliyu Funmilayo Adebimpe

% States: pitch angle (theta), pitch rate (q), z-velocity (w)
% Control: tail plane deflection (delta_eta), induced aoa (alpha_w)
% Measurement: pitch anlge (q)

A = [   0.0000  1  0.00000;         % dtheta/dt
       14.7805  0  0.01958;         % dq/dt
     -100.8580  1 -0.12560;];       % dw/dt

B = [ 0.0000   0.0000; 
      3.4858  14.7805; 
     20.4200 -94.8557;];

C = [1 0 0];
D = [0 0];

rank(ctrb(A,B))
rank(obsv(A,C))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Disturbance model
Bw = [0; 0; 1];       % need to check units

% Minimize [theta u1 u2]^T
Cz = [1 0 0; 0 0 0; 0 0 0];
Dz = [0 0 0; 0 0 1; 0 0 1];

% Open-Loop
P = ss(A, [Bw B], [Cz; C], [Dz; 0 D]);
P.StateName = {'theta'; 'q'; 'w'};
P.InputName = {'d'; 'u1'; 'u2'};
P.OutputName = {'z1'; 'z2'; 'z3'; 'y1'};

% Nominal Closed-Loop
[K, CL, gamma] = hinfsyn(P, height(C), width(B));
% [K, CL, gamma] = h2syn(P, height(C), width(B));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot results
plot_results(P, CL, gamma)

T = 0:0.01:20;
w = 0.5*sin(10*T);
[yout,t] = lsim(CL(1,1),w',T);

figure; 
subplot(2,1,1); title("Sinusoidal Disturbance")
plot(t,yout); xlabel("t (s)"); ylabel("x1")
subplot(2,1,2);
plot(t,w); ylabel("w")


