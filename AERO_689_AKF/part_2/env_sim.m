function [state, y] = env_sim(state, inp, dt, i, ss)
%ENVIRONMENT Simulates dynamics and measurements

% dynamics
state = dynamics(dt, state, ss);

% measurements
if rem(i,inp.mt/dt) == 0
    state = measure(state, ss);
end 

% check if above radar dish
if state.r(2) <= inp.h
    state.falling = false;
end

end