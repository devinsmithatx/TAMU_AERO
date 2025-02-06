function state = measure(state, ss)
%MEASURE Measures the position using the radar
%   yk = Hxk + b + nu_k

x = [state.r; state.v];         % pull current state

% simulate the measurements
nu = randn*sqrt(ss.R);          % generate measurement noise
y = ss.H*x + ss.b + nu;         % measure the state

% store the data
state.y = y;
state.tk = state.t;
state.nu = nu;

end

