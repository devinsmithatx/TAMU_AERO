function [state, measurement] = simEnv(inp, state, measurement, i)

% update timestep 
t = i*inp.ts;
i_measure = inp.tm/inp.ts;

% pull previous timestep stuff
Q = state.Q;
x = state.x;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dynamics 

% propigate the Q martix
F = jacobianF(inp, x);
Q = zeros(8);
dQ = F*Q + Q*F.' + inp.Qs;
Q = dQ.*inp.ts + Q;

% sample process noise
w = [zeros(2,1); sqrtm(Q(3:4, 3:4))*randn(2,1); zeros(4,1)]; 

% propigate the dynamics
dx = xDynamics(inp, x, w);
x = dx*inp.ts + x;

% check if falling
if x(2) <= 0
    state.falling = false;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Measurements 

% check for next measurement 
if rem(i, i_measure) == 0
    
    % sample measurement noise
    v = randn*sqrt(inp.R);
    
    % measure state
    y = xMeasure(inp, x);

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

