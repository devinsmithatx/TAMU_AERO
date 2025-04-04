function [state, measurement] = simEnv(inp, state, measurement, i)

% update timestep 
t = i*inp.ts;
i_measure = inp.tm/inp.ts;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dynamics 

% evaluate jacobian
F = numericJ(inp.F, state.x);

% propigate the Q martix
Q0 = zeros(8,8);
[~, Q] = ode45(@(t, y) odeQ(t, y, inp, F), [0 inp.ts], Q0(:));
Q = reshape(Q(end,:), 8, 8);

% sample process noise
w = [chol(Q(1:4, 1:4))]*randn(4,1); 
w = [0;0; w(3:4); zeros(4,1)];

% propigate the dynamics
x0 = state.x;
[~, x] = ode45(@(t, y) odeDynamics(t, y, inp, w), [0 inp.ts], x0);
x = reshape(x(end,:), 8, 1);

% check if falling
if state.x(2) <= 0
    state.falling = false;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Measurements 

% check for next measurement 
if rem(i, i_measure) == 0
    
    % sample measurement noise
    v = randn*sqrt(inp.R);
    
    % measure state
    y = measure(inp, x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ouputs

    % store measurement data 
    measurement.y = y + v;
    measurement.v = v;
    measurement.t = t; 
end

% store state data
state.x = x;
state.Q = Q;
state.w = w;
state.t = t;
end

