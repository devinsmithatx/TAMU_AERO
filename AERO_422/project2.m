clear; clc;

%% Open Loop System

% Define system for P(s) = theta(s)/delta_e(s)
s = tf('s');
P = 160*(s + 2.5)*(s + 0.7)/(s^2 + 5*s +40)/(s^2 + 0.03*s + 0.06);

% open loop rlocus
figure(1);
rlocus(P);
title("Open Loop Root Locus");

%% Controller Design
% Objective 1: tr < 1, M_p < 10%

% Controller Chosen to be Lead Compensator and PI 
% Desired to increase natural frequency and decrease overshoot
% C = K*Dc*(Kp +Ki/s)

% Used MATLAB Control System Designer to design controller

% Lead Compensator
Dc = (s/1.5385 + 1)/(s/153.846 + 1);

% Gains
K = 0.05;
Kp = 3.7;
Ki = 1;

% Controller
C = K*Dc*(Kp + Ki/s);

% obtain t_r, and M_p
G = P*C/(1+P*C);
stepinfo(G)

%% Step Responses

% ref to control
Gur = C/(1 + P*C);
figure(3);
step(Gur);
title("Ref to Control");
ylabel("Elevator angle (deg)");

% ref to error
Ger = 1/(1 + P*C);
figure(4);
step(Ger);
title("Ref to Error");
ylabel("Error (deg)");

% ref to output
Gyr = P*C/(1+P*C);
figure(5);
step(Gyr);
title("Ref to Output");
ylabel("Pitch angle (deg)");

% dist to control
Gud = -P*C/(1+P*C);
figure(6);
step(Gud);
title("Dist to Control");
ylabel("Elevator angle (deg)");

% dist to error
Ged = -P/(1 + P*C);
figure(7);
step(Ged);
title("Dist to Error");
ylabel("Error (deg)");

% dist to output
Gyd = P/(1 + P*C);
figure(8);
step(Gyd);
title("Dist to Output");
ylabel("Pitch angle (deg)");
