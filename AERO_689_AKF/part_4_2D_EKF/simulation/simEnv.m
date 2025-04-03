function [state, measurement, i] = simEnv(inp, state, measurement, i)

% update timestep 
t = i*inp.ts;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dynamics 

% evaluate jacobian
F = numericJ(inp.F, state.x);

% propigate the Q martix
[~, Q] = ode45(@(t, y) odeQ(t, y, inp, F), [0 inp.ts], zeros(64,1));
Q = reshape(Q(end,:), 8, 8);

% sample process noise
w = [chol(Q(1:4, 1:4))]*randn(4,1); 
w = [0;0; w(3:4); zeros(4,1)];

% propigate the dynamics
[~, x] = ode45(@(t, y) odeDynamics(t, y, inp, w), [0 inp.ts], state.x);
x = reshape(x(end,:), 8, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Measurements 

% check for next measurement 
if rem(i,inp.tm/inp.ts) == 0

% sample measurement noise
v = randn*sqrt(inp.R);

% measure state
radar_height = inp.bar(1) + inp.x0(5);
h = sqrt(state.x(1)^2 + (state.x(2) - radar_height)^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ouputs

% store measurement data 
measurement.y = h + v;
measurement.v = v;
measurement.t = t; end

% store state data
state.x = x;
state.Q = Q;
state.w = w;
state.t = t;

% check if falling or if time has run on too long
if state.x(2) <= 0 || t > inp.tf
    state.falling = 0;
end
end

