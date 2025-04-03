function [state, measurement, i] = simEnv(inp, state, measurement, i)

% update timestep 
t = i*inp.ts;

% sim the process noise
% F = solveFdouble(inp.F, state.x);
% dQ = F*state.Q + state.Q*(F.') + inp.Qs;
% state.Q = state.Q + dQ.*inp.ts;
w = [ 0; 0; 0.1*randn(2,1); 0; 0; 0; 0];

% sim the dynamics
[~, x] = ode45(@(t,y) odeDynamics(t, y, inp, w), [0 inp.ts], state.x);

% store the dynamics data
state.x = x(end,:)';
state.t = t;
state.w = w;

% sim the measurement
if rem(i,inp.tm/inp.ts) == 0
    y = sqrt(state.x(1)^2 + (state.x(2) - inp.bar(1) - inp.x0(5))^2);
    nu = randn*sqrt(inp.R);

    % store measurement data
    measurement.y = y + nu;
    measurement.t = t;
    measurement.nu = nu;
end

% check if falling or if time has run on too long
if state.x(2) <= 0 || t > 100
    state.falling = 0;
end

end

