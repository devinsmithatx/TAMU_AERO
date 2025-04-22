%% simEnv.m

function [state, measurement] = simEnv(inp, state, measurement, i)

% update timestep 
t = i*inp.ts;
i_measure = inp.tm/inp.ts;

% pull previous timestep stuff
Q = state.Q; x = state.x;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dynamics 

% propigate the Q martix
F = jacobianF(inp, x);
Q = zeros(8);
dQ = F*Q + Q*F.' + inp.Qs;
Q = dQ.*inp.ts + Q;

% sample process noise
[V, S] = eig(Q);
w = V*S.^(0.5)*randn(8,1);

% propigate the dynamics
dx = xDynamics(inp, x, w);
x = dx*inp.ts + x;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Measurements 

% check for next measurement 
if rem(i, i_measure) == 0
    
    % sample measurement noise
    v = randn(1)*sqrt(inp.R);
    
    % measure state
    y = xMeasure(inp, x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ouputs

    % store measurement data 
    measurement.y = y + v;
    measurement.R = inp.R;
    measurement.v = v;
    measurement.t = t; 
end

% store state data
state.x = x;
state.Q = Q;
state.w = w;
state.t = t;
end