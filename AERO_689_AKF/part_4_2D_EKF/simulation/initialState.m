function state = initialState(inp)

% initialize the state parameters from initial conditions
state.x = inp.x0;
state.Q = zeros(8,8);
state.w = zeros(8,1);
state.t = 0;
state.F = numericJ(inp.F, state.x);
state.falling = true;

end

