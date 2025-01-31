clc; clear; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework 4, Questions 1, 2, & 3
% AERO 625
% Devin Smith
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% F-18A LAT/D STATE SPACE DYNAMICS

input.A = [-0.238  0     -1     0.0207 0;
           16.78  -2.14   0.029 0      0;
            7.11   0.035 -0.264 0      0;
            0      1      0     0      0;
            0      0      1     0      0;];

input.B = [-0.0005  0.0177 -0.0048  0      0    ;
            4.97    4.33   20.33   28.62   0.17 ;
           -0.225  -2.88   -0.862  -1.32  -0.008;
            0       0       0       0      0    ;
            0       0       0       0      0    ;];

input.C = eye(5,5);

input.D = zeros(5,5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROBLEM 1

% SIMULATION PARAMETERS
input.t_f = 10;
input.t_s = 0.01;                       % simulation step size
input.x_cmd = [0; 0; 0; 0; 0;];         % regulate all to zero
input.x_0 = [0; 0; 0; 10*pi/180; 0;];   % initial condition

% CONTROLLER PARAMETERS
input.T = 0.1;                          % sampling period
input.Q = eye(5,5);                     % iteration 1
input.R = eye(5,5);                     % iteration 1
input.Q(4,4) = 2;                       % iteration 2

% % RUN SIMULATION
% output = run_sim(input);                % output data
% plot_sim(output);                       % plots
% display_lqr(input, output);             % get Qh, Rh, M, etc.
% display_performance_p1p2(output);       % get Tr, Ts, max values, etc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROBLEM 2

% CONTROLLER PARAMETERS
input.T = 0.5;                          % new sampling period
input.Q = eye(5,5);                     % iteration 1
input.R = eye(5,5);                     % iteration 1
input.Q(4,4) = 2;                       % iteration 2

% % RUN SIMULATION
% output = run_sim(input);                % output data
% plot_sim(output);                       % plots
% display_lqr(input, output);             % get Qh, Rh, M, etc.
% display_performance_p1p2(output);       % get Tr, Ts, max values, etc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROBLEM 3

% SIMULATION PARAMETERS
input.t_f = 20;                         % longer sim time
input.x_0 = [0; 0; 0; 0; 30*pi/180;];   % new initial condition

% CONTROLLER PARAMETERS
% I have attempted to get the desired specifications with realistic 
% responses, however it seems that the controls are just not good enough to 
% get the desired response with realistic values.
%
% Below are my attempts to get the desired response with actually realistic
% numbers. They get pretty close, but everything is still out of spec.

input.Q = eye(5,5);             % iteration 1.1
input.R = eye(5,5);             % iteration 1.1
input.Q(5,5) = 20;              % iteration 1.2
input.R(2,2) = 20;              % iteration 1.2
input.Q(2,2) = 5;               % iteration 1.3
input.Q(4,4) = 5;               % iteration 1.3
input.Q(5,5) = 30;              % iteration 1.4
input.R(2,2) = 30;              % iteration 1.4

% Technically, there is a way to get the desired results, but it would
% require having unlrealistic responses for certain states and controls.
% Below, the iterations set the controller weights to zero for the controls
% that were not specified. 
% 
% This results in super high numbers, but is still technically within the 
% desired specifications. 

input.Q = eye(5,5);                     % iteration 1.1
input.R = eye(5,5);                     % iteration 1.1
input.R(3:5, 3:5) = zeros(3,3);         % iteration 2.1 

% RUN SIMULATION
output = run_sim(input);
plot_sim(output);
display_lqr(input, output);
display_performance_p3(output);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FUNCTIONS

function output = run_sim(inp)
    % RUN_SIM SIMULATES A RESPONSE FOR STATE-SPACE LQRD CONTROL 

    % PULL INPUT
    A = inp.A;
    B = inp.B;
    C = inp.C;
    D = inp.D;
    Q = inp.Q;
    R = inp.R;
    T = inp.T;
    x_cmd = inp.x_cmd;
    x_0 = inp.x_0;
    t_f = inp.t_f;
    t_s = inp.t_s;

    % LQRD
    [K,Q_hat,R_hat,M,~,~] = LQRDJV(A,B,Q,R,T); % lqrdjv

    % SIMULATION PARAMS
    t = 0.0:t_s:t_f;                    % sim time values 
    [phi, gam] = c2d(A,B,t_s);          % phi, gamma

    % SIMULATE RESPONSE
    u_0 = x_cmd - K*x_0;                % initial control
    y_0 = C*x_0 + D*u_0;                % initial output
    x_k = phi*x_0 + gam*u_0;            % calculate x1
    y   = y_0;                          % store y0
    u   = u_0;                          % store u0
    for i = 1:(t_f/t_s)                 % loop time steps             
        if rem(t(i), inp.T) == 0        % update control w/ T
            u_k =  x_cmd - K*x_k;     
        end
        y_k = C*x_k + D*u_k;            % update y_k w/ t_s
        y = [y y_k];                    % store y_k
        u = [u u_k];                    % store u_k
        x_k = phi*x_k + gam*u_k;        % calculate x_(k+1)
    end

    % OUTPUT RESULTS
    output.K = K;
    output.Q_hat = Q_hat;
    output.R_hat = R_hat;
    output.M = M;
    output.u = u;
    output.y = y;
    output.t = t;
end

function plot_sim(output)
    % PLOTS THE STATES AND CONTROLS FROM THE SIM

    % PULL OUTPUT
    y = output.y;
    y(1,:) = y(1,:)*180/pi;         % convert to deg
    y(4:5,:) = y(4:5,:)*180/pi;     % convert to deg
    u = output.u*180/pi;            % convert to deg
    t = output.t;

    % DEFINE PLOT TITLES
    states = {'$\beta$', '$p$', '$r$', '$\phi$', '$\psi$'};
    controls = {'$\delta_a$', '$\delta_r$', '$\delta_{DT}$', ...
                '$\delta_{DLEF}$', '$\delta_{DTEF}$'};

    % PLOT STATES AND CONTROL USAGE
    figure(); clf;
    tiledlayout(5,2, 'Padding', 'none', 'TileSpacing', 'compact');
    for i = 1:height(y)
        nexttile; plot(t,y(i,:),'b','linewidth',1);
        title(states(i), Interpreter="latex");  
        xlabel("t (s)"); 
        if ismember(i, [1 4 5])
            ylabel("Angle (deg)");
        else
            ylabel("Angular Velocity (deg/s)");
        end
        nexttile; plot(t,u(i,:),'b','linewidth',1);
        title(controls(i), Interpreter="latex");  
        xlabel("t (s)"); 
        ylabel("Angle (deg)");
    end
end

function display_lqr(input, output)
    % DISPLAYS THE INPUT Q, R, T AND THE OUTPUT Qh, Rh, Mh, K, and EIG
    disp("T (s):")
    disp(input.T)
    disp("Q:")
    disp(input.Q)
    disp("R:")
    disp(input.R)
    disp("Q_HAT:")
    disp(output.Q_hat)
    disp("R_HAT:")
    disp(output.R_hat)
    disp("M:")
    disp(output.M)
    disp("K")
    disp(output.K)
    disp("Eigenvalues")
    [phi, gamma] = c2d(input.A,input.B,input.T);
    disp(eig(phi - gamma*output.K))
end

function display_performance_p1p2(output)
    % OUTPUTS DESIRED PERFORMANCE FOR PROBLEM 1 

    % PULL OUTPUT
    y = output.y;
    t = output.t;
    beta = y(1,:)*180/pi;   % convert to deg
    phi = y(4,:)*180/pi;    % convert to deg
    
    % GET MAX VALUES
    beta_max = max(abs(beta));
    
    % GET RISE TIME, SETTLING TIME
    phi_amp = abs(phi(end) - phi(1));
    phi_10 = 0.90*phi_amp;
    phi_90 = 0.10*phi_amp;
    phi_98 = 0.02*phi_amp;
    t_10 = 0;
    t_90 = 0;
    t_98 = 0;
    for i = 1:length(phi)
        phi_amp = abs(phi(end) - phi(i));
        if abs(phi_amp - phi_10) < 0.01*phi_10 && t_10 == 0
            t_10 = t(i);
        elseif abs(phi_amp - phi_90) <= 0.01*phi_90 && t_90 == 0
            t_90 = t(i);
        elseif abs(phi_amp - phi_98) <= 0.01*phi_98 && t_98 == 0
            t_98 = t(i);
        end
    end
    T_r = t_90 - t_10;
    T_s = t_98;
    
    % DISPLAY PERFORMANCE
    disp("MAX BETA MAGNITUDE (deg):")
    disp(beta_max)
    disp("RISE TIME (s):")
    disp(T_r)
    disp("SETTLING TIME (s):")
    disp(T_s)
end

function display_performance_p3(output)
    % FUNCTION OUTPUTS DESIRED PERFORMANCE FOR PROBLEM 1

    % PULL OUTPUT
    y = output.y;
    u = output.u;
    t = output.t;
    p = y(2,:)*180/pi;              % convert to deg
    phi = y(4,:)*180/pi;            % convert to deg
    psi = y(5,:)*180/pi;            % convert to deg
    delta_a = u(1,:)*180/pi;        % convert to deg
    delta_r = u(2,:)*180/pi;        % convert to deg
    
    % GET MAX VALUES
    phi_max = max(abs(phi));
    p_max = max(abs(p));
    delta_a_max = max(abs(delta_a));
    delta_r_max = max(abs(delta_r));
    
    % GET RISE TIME, SETTLING TIME, OVERSHOOT
    psi_amp = abs(psi(end) - psi(1));
    psi_10 = 0.90*psi_amp;
    psi_90 = 0.10*psi_amp;
    psi_98 = 0.02*psi_amp;
    t_10 = 0;
    t_90 = 0;
    t_98 = 0;
    overshoot = false;
    for i = 1:length(psi)
        psi_amp = abs(psi(end) - psi(i));   
        if abs(psi_amp - psi_10) < 0.01*psi_10 && t_10 == 0
            t_10 = t(i);
        elseif abs(psi_amp - psi_90) <= 0.01*psi_90 && t_90 == 0
            t_90 = t(i);
        elseif abs(psi_amp - psi_98) <= 0.01*psi_98 && t_98 == 0
            t_98 = t(i);
        end
        if psi(1) > psi(end)
            if psi(i) < psi(end)
                overshoot = true;
            end
        else
            if psi(i) > psi(end)
                overshoot = true;
            end
        end
    end
    T_r = t_90 - t_10;
    T_s = t_98;
    
    % DISPLAY PERFORMANCE
    disp("MAX PHI MAGNITUDE (deg):")
    disp(phi_max)
    disp("MAX P MAGNITUDE (deg/s):")
    disp(p_max)
    disp("MAX DELTA_A MAGNITUDE (deg):")
    disp(delta_a_max)
    disp("MAX DELTA_R MAGNITUDE (deg):")
    disp(delta_r_max)
    disp("RISE TIME (s):")
    disp(T_r)
    disp("SETTLING TIME (s):")
    disp(T_s)
    disp("OVERSHOOT (T/F):")
    disp(overshoot)
end