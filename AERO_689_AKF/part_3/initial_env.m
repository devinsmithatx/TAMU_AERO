function [state, measurement] = initial_env(inp, ss)
% Gets values for environment (states and measurements) at t=0

% initialize the states
state.r = inp.r0;                               % pull r0
state.v = inp.v0;                               % pull v0
state.w = [0; 0; 0; inp.Qs(4,4)]*randn;   % generate an initial w0
state.t = 0;                                    % let t0 = 0
state.falling = true;                           % set falling parameter

% initialize the measurements
nu = randn*sqrt(ss.R);
x = [state.r; state.v];
y = ss.H*x + ss.b + nu;

measurement.y = y;                              % get y0
measurement.nu = nu;
measurement.t = 0;                              % let t0 = 0
end

