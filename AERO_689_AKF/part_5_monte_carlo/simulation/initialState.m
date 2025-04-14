function state = initialState(inp)

% initialize the state parameters from initial conditions
state.x = inp.x0_sampled;
state.Q = zeros(8,8);
state.w = zeros(8,1);
state.t = 0;
state.falling = true;

end