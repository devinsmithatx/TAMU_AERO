clc; clear; close all;
%% PROBLEM STATEMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework 4, Question 4 (Project)
% AERO 625
% Devin Smith
%
%       Aircraft:             Fuji/Rockwell Commander 700
%       Dyanmics Model:       Cruise, Longitudinal
%       Objective:            Regulate pitch angle to 0 deg
%
%       Constraint 1:         alpha    < 10 deg
%       Constraint 2:         q        < 15 deg/s
%       Constraint 3:         delta_e  < 10 deg
%       Initial Condition 1:  u0       = 5 ft/s
%       Initial Condition 2:  alpha0   = 3 deg
%       Initial Condition 3:  q0       = 0 deg/s
%       Initial Conidtion 4:  theta0   = 15 deg
%       Initial Condition 5:  delta_e0 = 0 deg
%       Sampling Period:      T        = 0.2 s
%       Actuator Dynamics:    tau      = 0.1 s
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A) STATE SPACE DYNAMICS MODEL
% Define the linear state space model of the aircraft dynamics
% .
% x = Ax + Bu
% y = Cx + Du

A = [[-0.0246   6.8470   0.0000 -32.1700];  % A matrix
     [-0.0012  -1.0000   1.0000   0.0000];
     [ 0.0000  -3.5350  -2.2450   0.0000];
     [ 0.0000   0.0000   1.0000   0.0000]];

B = [0.0000;                                % B matrix
    -0.0915;
    -8.5740;
     0.0000];

% Define the actuator dynamics and add them to the state space model
%  delta(s)        1/tau
% ----------  =  ---------
% delta_c(s)     s + 1/tau

tau = 0.1;                              % Time Constant (s)

A = [A           B    ;                 % Augmented A matrix
     zeros(1,4) -1/tau;]; 

B = [zeros(4,1);                        % Augmented B matrix
     1/tau     ;];

C = eye(5,5);                           % assimung actuator can be measured
D = 0;

%% B) OPEN-LOOP CHARACTERISTICS

[vec_ol, val_ol] = eig(A);
[wn_ol, ~, ~] = damp(A);

%% C) SAMPLING PERIOD T

Nq = 2*max(wn_ol);    % w_s = 2pi/T; w_N = pi/T
T = 0.2;

%% D) CONTROLLABILITY AND OBSERVABILITY

[phi, gamma] = c2d(A, B, T);    % discrete system matrices

% controllability / reachability matrix
C_ctrb = ctrb(phi, gamma);
controllable = (rank(C_ctrb) == height(phi));   % rank(C) == n

% observability
O = obsv(phi, C);
observable = (rank(O) == height(phi));          % rank(O) == n

%% F) CONTROLLER GAINS AND WEIGHT MATRICES
% Define the LQR optimization problem
% u = -Kx; K = solution to discrete Ricatti Eq via lqrd(A,B,Q,R,T)

Q = [1 0 0 0 0;                             % State Weight Matrix
     0 1 0 0 0;
     0 0 10000 0 0;
     0 0 0 1 0;
     0 0 0 0 1000;];
R = 500;                                      % Control Weight Matrix
K = lqrd(A,B,Q,R,T);

%% E) CLOSED-LOOP CHARACTERISTICS

[phi, gamma] = c2d(A, B, T);
[vec_cl, val_cl] = eig(phi - gamma*K);
sys = ss(phi - gamma*K, 0*B, C - D*K, 0*D, T);
[wn_cl, ~, p] = damp(sys);

%% G) SIMULATION
% Define initial condition, simulation step size & length

x_0 = [5; 3*pi/180; 0; 15*pi/180; 0;];      % Initial Condition
t_f = 20;                                   % Simulation Length (s)
t_s = 0.01;                                 % Simulation Step Size (s)

% Pass user input into simulation and analyze the output
inp.A = A;
inp.B = B;
inp.C = C;
inp.D = D;
inp.T = T;
inp.Q = Q;
inp.R = R;
inp.x_0 = x_0;
inp.t_f = t_f;
inp.t_s = t_s;

% run and analyze the sim
out = run_sim(inp);
plot_sim(out);
display_lqr(inp, out);
display_performance(out);

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
    x_0 = inp.x_0;
    t_f = inp.t_f;
    t_s = inp.t_s;

    % LQRD
    [K,Q_hat,R_hat,M,~,~] = LQRDJV(A,B,Q,R,T); % lqrdjv

    % SIMULATION PARAMS
    t = 0.0:t_s:t_f;                    % sim time values 
    [phi, gam] = c2d(A,B,t_s);          % phi, gamma

    % SIMULATE RESPONSE
    u_0 = -K*x_0;                % initial control
    y_0 = C*x_0 + D*u_0;                % initial output
    x_k = phi*x_0 + gam*u_0;            % calculate x1
    y   = y_0;                          % store y0
    u   = u_0;                          % store u0
    for i = 1:(t_f/t_s)                 % loop time steps             
        if rem(t(i), inp.T) == 0        % update control w/ T
            u_k =  -K*x_k;     
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
    % PLOT_SIM PLOTS THE STATES AND CONTROLS FROM THE SIM
    % PULL OUTPUT
    y = output.y;
    y(2:5,:) = y(2:5,:)*180/pi;
    u = output.u*180/pi;
    t = output.t;

    % DEFINE PLOT TITLES
    states = {'$u$', '$\alpha$', '$q$', '$\theta$', '$\delta$'};
    controls = {'$\delta_c$'};

    % PLOT STATES AND CONTROL USAGE
    figure(); clf;
    tiledlayout(5,1, 'Padding', 'none', 'TileSpacing', 'compact');
    for i = 1:height(y)
        nexttile; plot(t,y(i,:),'b','linewidth',1);
        title(states(i), Interpreter="latex");  
        xlabel("t (s)"); 
        if i == 1
            ylabel("Velocity (ft/s)");
        elseif ismember(i, [2, 4. 5])
            ylabel("Angle (deg)");
        else
            ylabel("Angular Valocity (deg/s)")
        end
    end

    figure(); clf;
    tiledlayout(1,1, 'Padding', 'none', 'TileSpacing', 'compact');
    nexttile; plot(t,u,'b','linewidth',1);
    title(controls, Interpreter="latex");  
    xlabel("t (s)"); 
    ylabel("Angle (deg)");
end

function display_lqr(input, output)
    % DISPLAYS THE INPUT Q, R, T AND THE OUTPUT Qh, Rh, Mh, K
    disp("T (s):")
    disp(input.T)
    disp("Q:")
    disp(input.Q)
    disp("R:")
    disp(input.Q)
    disp("Q_HAT:")
    disp(output.Q_hat)
    disp("R_HAT:")
    disp(output.R_hat)
    disp("M:")
    disp(output.M)
    disp("K")
    disp(output.K)
end

function display_performance(output)
    % FUNCTION OUTPUTS DESIRED PERFORMANCE FOR PROJECT

    % PULL OUTPUT
    y = output.y;
    u = output.u;
    t = output.t;
    alpha = y(2,:)*180/pi;        % convert to deg
    q = y(3,:)*180/pi;            % convert to deg
    theta = y(4,:)*180/pi;        % convert to deg
    delta = y(5,:)*180/pi;        % convert to deg
    
    % GET MAX VALUES
    alpha_max = max(abs(alpha));
    q_max = max(abs(q));
    delta_max = max(abs(delta));
    
    % GET RISE TIME, SETTLING TIME, OVERSHOOT
    theta_amp = abs(theta(end) - theta(1));
    theta_10 = 0.90*theta_amp;
    theta_90 = 0.10*theta_amp;
    theta_98 = 0.02*theta_amp;
    t_10 = 0;
    t_90 = 0;
    t_98 = 0;
    overshoot = false;
    for i = 1:length(theta)
        theta_amp = abs(theta(end) - psi(i));   
        if abs(theta_amp - theta_10) < 0.01*theta_10 && t_10 == 0
            t_10 = t(i);
        elseif abs(theta_amp - theta_90) <= 0.01*theta_90 && t_90 == 0
            t_90 = t(i);
        elseif abs(theta_amp - theta_98) <= 0.01*theta_98 && t_98 == 0
            t_98 = t(i);
        end
        if theta(1) > theta(end)
            if theta(i) < theta(end)
                overshoot = true;
            end
        else
            if theta(i) > theta(end)
                overshoot = true;
            end
        end
    end
    T_r = t_90 - t_10;
    T_s = t_98;
    
    % DISPLAY PERFORMANCE
    disp("MAX ALPHA MAGNITUDE (deg):")
    disp(alpha_max)
    disp("MAX Q MAGNITUDE (deg/s):")
    disp(q_max)
    disp("MAX DELTA MAGNITUDE (deg):")
    disp(delta_max)
    disp("RISE TIME (s):")
    disp(T_r)
    disp("SETTLING TIME (s):")
    disp(T_s)
    disp("OVERSHOOT (T/F):")
    disp(overshoot)
end