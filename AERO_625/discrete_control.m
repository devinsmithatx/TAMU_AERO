
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AERO 625 Homework 1
% Devin Smith
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc; close all; % start a fresh session

% -------------------------------------------------------------------------
% User Inputs

% input the plant
nom = [0 0 1];          % plant numerator coeffecients in s
den = [1 1 0];          % plant denominator coefficients in s
[A, B, C, D] = tf2ss(nom,den); % calculate state space matrices

% input state space matrices if known already/done by hand
% A = [[-1,   0],;
%      [1, 0]];
% B = [1; 0];
% C = [0, 1];
% D = 0;

% input the digital controller parameters
y_r = 1;        % reference commanded value
u_0 = 1;        % controller initial input (step input)
h = 1;          % controller sampling period
K = [0, 1];     % controller gain

% input initial/final conditions
x_0 = [0; 0];           % initial dx, x
y_0 = C*x_0 + D*u_0;    % calculate y0
t_0 = 0;                % initial t
t_f = 10;               % final t

% -------------------------------------------------------------------------
% Calculate Continuous Parameters

% intialize the continuous sampling
T = 0.001;              % sampling period
nframes_c = t_f/T;        % number of samples
t_vals_c = 0.0:T:t_f;   % array of time values

% calculate continuous phi and gamma
% phi = expm(A.*T);                                              
% gamma = integral(@(t) expm(A.*t)*B, 0, T, 'ArrayValued', true);
[phi_c, gamma_c] = c2d(A,B, T); % phi, gamma

% -------------------------------------------------------------------------
% Calculate Discrete Parameters

% intialize the discrete sampling
nframes_d = t_f/h;        % number of samples
t_vals_d = 0.0:h:t_f;   % array of time values

% calculate phi and gamma
% phi = expm(A.*h);                                              
% gamma = integral(@(t) expm(A.*t)*B, 0, h, 'ArrayValued', true);
[phi_d, gamma_d] = c2d(A,B, h); % phi, gamma

% -------------------------------------------------------------------------
% Calculate Continuous Dynamics with Continuous Control

% set current state space variables to initial conditions
x_k = phi_c*x_0 + gamma_c*u_0;  % initial x_k
u_vals_cc = u_0;                % store u_0
y_vals_cc = y_0;                % store y_0

% calculate the continuous response
for i = 1:nframes_c
    u_k = y_r - K*x_k;                  % calculate u_k from previous x_k
    y_k = C*x_k + D*u_k;                % calculate y_k from previous x_k
    x_k = phi_c*x_k + gamma_c*u_k;      % calculate x_k+1 from previous x_k
    u_vals_cc = [u_vals_cc; u_k];       % store u_k
    y_vals_cc = [y_vals_cc; y_k];       % store y_k
end

% -------------------------------------------------------------------------
% Calculate Continuous Dynamics with Discrete Control

% set current state space variables to initial conditions
x_k = phi_c*x_0 + gamma_c*u_0;  % initial x_k
u_vals_cd = u_0;                % store u_0
y_vals_cd = y_0;                % store y_0

% calculate the continuous / discrete response
for i = 1:nframes_c
    % discretely update control
    if t_vals_c(i) == 0
        u_k = y_r - K*x_k;              % calculate u_k from previous x_k
    elseif rem(t_vals_c(i), h) == 0
        u_k = y_r - K*x_k;              % calculate u_k from previous x_k
    end

    % continuously update everything else
    y_k = C*x_k + D*u_k;                % calculate y_k from previous x_k
    x_k = phi_c*x_k + gamma_c*u_k;      % calculate x_k+1 from previous x_k
    u_vals_cd = [u_vals_cd; u_k];       % store u_k
    y_vals_cd = [y_vals_cd; y_k];       % store y_k
end

% -------------------------------------------------------------------------
% Calculate Discrete Control with Discrete Dynamics

% set current state space variables to initial conditions
x_k = phi_d*x_0 + gamma_d*u_0;  % initial x_k
u_vals_dd = u_0;                % store u_0
y_vals_dd = y_0;                % store y_0
% calculate the discrete response
for i = 1:nframes_d
    u_k = y_r - K*x_k;                    % calculate u_k from previous x_k
    y_k = C*x_k + D*u_k;                  % calculate y_k from previous x_k
    x_k = phi_d*x_k + gamma_d*u_k;        % calculate x_k from previous x_k
    u_vals_dd = [u_vals_dd; u_k];         % store u_k
    y_vals_dd = [y_vals_dd; y_k];         % store y_k
end

% -------------------------------------------------------------------------
% Plot Continuous Dynamics with Continuous Control

% initialize plot
figure(1);

% plot t,y
subplot(2,1,1);
plot(t_vals_c, y_vals_cc); ylim([0, 1.6]);
xlabel('Time'); ylabel('Phi'); title('Continuous Dynamics');

% plot t,u
subplot(2,1,2); ylim([-0.4, 1.2]);
plot(t_vals_c, u_vals_cc);
xlabel('Time'); ylabel('Control Input'); title('Continuous Control');

% -------------------------------------------------------------------------
% Plot Continuous Dynamics with Discrete Control

% initialize plot
figure(2); 

% plot t,y 
subplot(2,1,1);
plot(t_vals_c, y_vals_cd); ylim([0, 1.6]);
xlabel('Time'); ylabel('Phi'); title('Continuous Dynamics');

% plot t,u
subplot(2,1,2) ;
plot(t_vals_c, u_vals_cd); ylim([-0.4, 1.2]);
xlabel('Time'); ylabel('Control Input'); title('Discrete Control');

% -------------------------------------------------------------------------
% Plot Discrete Dynamics with Discrete Control

% initialize plot
figure(3); 

% plot t,y 
subplot(2,1,1);
stairs(t_vals_d, y_vals_dd); ylim([0, 1.6]);
xlabel('Time'); ylabel('Phi'); title('Discrete Dynamics');

% plot t,u
subplot(2,1,2);
stairs(t_vals_d, u_vals_dd); ylim([-0.4, 1.2]);
xlabel('Time'); ylabel('Control Input'); title('Discrete Control');
