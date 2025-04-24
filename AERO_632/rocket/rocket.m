clear; clc; close all

% Longitudinal Dynamics from 
% "State-Space Modeling of a Rocket for Optimal Control System Design"
% by Aliyu Bhar Kisabo and Aliyu Funmilayo Adebimpe

% States: pitch angle (theta), pitch rate (q), z-velocity (w)
% Control: tail plane deflection (delta_eta), induced aoa (alpha_w)
% Measurement: pitch anlge (theta)

A = [ -0.12560  1  -100.8580;      % dw/dt  
       0.01958  0  14.7805;        % dq/dt
       0.00000  1  0.0000;];       % dtheta/dt

B = [20.4200 -94.8557; 
      3.4858  14.7805; 
      0.0000   0.0000;];

C = [0 0 1];
D = [0 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Disturbance model
Bw = [0; 1; 0];

% Minimize [theta u1 u2]^T
Cz = [0 0 1; 0 0 0; 0 0 0];
Dz = [0 0 0; 0 1 0; 0 0 1];

% Open-Loop
P = ss(A, [Bw B], [Cz; C], [Dz; 0 D]);
P.StateName = {'theta'; 'q'; 'w'};
P.InputName = {'d'; 'u1'; 'u2'};
P.OutputName = {'z1'; 'z2'; 'z3'; 'y1'};

% Nominal Closed-Loop
[K1, CL1, gamma1] = hinfsyn(P, height(C), width(B));
[K2, CL2, gamma2] = h2syn(P, height(C), width(B));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% test sinusoid
T = 0:0.01:20;
w = sin(10*T);
[yout1,t1] = lsim(CL1(1,1),w',T);
[yout2,t2] = lsim(CL2(1,1),w',T);

% plot results
plot_results(P, CL1, gamma1)

figure; 
subplot(2,1,1); title("Sinusoidal Disturbance")
plot(t1,yout1); xlabel("t (s)"); ylabel("x1 (rad/s)")
subplot(2,1,2);
plot(t1,w); ylabel("w (rad/s^2)")

% plot results
plot_results(P, CL2, gamma1)

figure; 
subplot(2,1,1); title("Sinusoidal Disturbance")
plot(t2,yout2); xlabel("t (s)"); ylabel("x1 (rad/s)")
subplot(2,1,2);
plot(t2,w); ylabel("w (rad/s^2)")

