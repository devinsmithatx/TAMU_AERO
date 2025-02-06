function [state, y] = env_sim(state, inp, dt, i, ss)
%ENVIRONMENT Summary of this function goes here
%   Detailed explanation goes here

state = dynamics(dt, state, ss);
if rem(i,inp.mt/dt) == 0
    state = measure(state, ss);
end 
if state.r(2) <= inp.h
    state.falling = false;
end
end