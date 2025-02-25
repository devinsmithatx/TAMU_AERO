function [state, measurement] = sim_env(inp, ss, i, state, measurement)
% Simulates dynamics and measurements

% pull state
x = [state.r; state.v]; 

% simulate the dynamics
w = ss.Qk1_sqrt*(randn(4,1));                 % process noise 
x = ss.phi*x + ss.uk1;                        % update x_k

% store the data
state.r = x(1:2);
state.v = x(3:4);
state.w = w;
state.t = state.t + inp.dt;

% simulate measurements
if rem(i,inp.tm/inp.dt) == 0
    % simulate the measurements
    nu = randn*sqrt(ss.R);          % generate measurement noise
    y = ss.H*x + ss.b + nu;         % measure the state
    
    % store the data
    measurement.y = y;
    measurement.nu = nu;
    measurement.t = state.t;
end

% check if above radar dish
if state.r(2) <= inp.h
    state.falling = false;
end

end