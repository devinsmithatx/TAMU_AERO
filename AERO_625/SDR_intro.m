clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AERO 625 Homework 3 (problem 6)
% Devin Smith
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% USER INPUTS
inp.A = [0  1; -4 0.4;];          % Continuous A
inp.B = [0; 1;];                  % Continuous B
inp.C = [1 0; 0 1; 0 0;];         % Continuous C (outputs x1, x2)
inp.D = [0; 0; 1;];               % Continuous D (outputs u)
inp.x_cmd = [0; 0;];              % commanded state
inp.x_0   = [1; 0;];              % initial condition
inp.t_s   = 0.001;                % simulation time step
inp.t_f   = 10.0;                 % simulation length

%% a) 
% Reproduce the figures on page 4-33 of the lectures.

inp.T = 0.2;                      % controller sampling period
inp.Q = [10 0; 0 10;];            % state weighing matrix
inp.R = 1;                        % contol weighing matrix

% SIMULATION
control_sim(inp)

% %% b) 
% % Redesign the controller to drive the position state to the origin in one 
% % second. Report the Q,R,Q_hat,R_hat,M values for EACH of the design
% % iterations you make.
% 
% inp.T = 0.2; % same as before
% inp.R = 1;   % same as before
% 
% % inp.Q = [100 0; 0 10;];   % attempt 1
% % inp.Q = [1000 0; 0 10;];  % attempt 2
% inp.Q = [5000 0; 0 100;]; % attempt 3
% 
% % control_sim(inp)
% 
% 
% %% c) 
% % Assuming no specification on the position state or the velocity state,
% % redesign the controller so that the control magnitude does not exceed a 
% % value of 1.5. Report the Q,R,Q_hat,R_hat,M values for EACH of the design
% % iterations that you make.
% 
% inp.Q = [1 0; 0 1;];       % Q identity
% inp.T = 0.2;               % same as before
% inp.t_f = 20;              % will take longer to reach steady state
% 
% % inp.R = 5;                 % attempt 1
% inp.R = 15;                % attempt 2
% 
% % control_sim(inp)

%% function
function control_sim(inp)
    % LQRD CALCULATIONS
    [K,Q_hat,R_hat,M,~,~] = LQRDJV(inp.A,inp.B,inp.Q,inp.R,inp.T); % lqrdjv
    % CLOSED-LOOP SIMULATION
    t = 0.0:inp.t_s:inp.t_f;                         % sim time values 
    [phi, gam] = c2d(inp.A, inp.B, inp.t_s);         % phi, gamma
    disp(phi, gam)

    u_0 = K*(inp.x_cmd - inp.x_0);                   % initial control
    y_0 = inp.C*inp.x_0 + inp.D*u_0;                 % initial output
    x_k = phi*inp.x_0 + gam*u_0;                     % calculate x1
    y   = y_0;                                       % store y0

    for i = 1:(inp.t_f/inp.t_s)                      % loop time steps             
        if rem(t(i), inp.T) == 0                     % update control w/ T
            u_k =  K*(inp.x_cmd - x_k);     
        end
        y_k = inp.C*x_k + inp.D*u_k;                 % update y_k w/ t_s
        y = [y y_k];                                 % store y_k
        x_k = phi*x_k + gam*u_k;                     % calculate x_(k+1)
    end

    % OUTPUT PLOTS
    figure(); subplot(2,1,1); hold on; grid('on');           % subplot 1
    plot(t, y(1,:)); plot(t, y(2,:));                        % plot states
    ymin = min([min(y(1,:)) min(y(2,:))]);                   % lower lim
    ymax = max([max(y(1,:)) max(y(2,:))]);                   % upper lim
    ylim(1.1*[ymin ymax]);                                   % limits
    ylabel('States'); title('Closed-Loop Responses');        % labels
    legend('$x_1$', '$x_2$', Interpreter='latex');           % legend
    subplot(2,1,2); hold on; grid('on');                     % subplot 2
    plot(t, y(3,:));                                         % plot control
    ylim(1.1*[min(y(3,:)) max(y(3,:))]);                     % limits
    xlabel('Time (s)'); ylabel('Control');                   % labels

    % OUTPUT CONTROLLER INPUT FOR T, Q, and R
    disp("T (s)"); disp(inp.T)
    disp("Q"); disp(inp.Q)
    disp("R"); disp(inp.R)

    % OUTPUT LQRDJV PARAMETERS
    disp("GAIN"); disp(K)
    disp("Q_hat"); disp(Q_hat)
    disp("R_hat"); disp(R_hat)
    disp("M"); disp(M)
end