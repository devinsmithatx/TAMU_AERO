function state = initialState(inp)

% initialize the parameters
state.x = inp.x0;
state.t = 0;
state.phi = eye(8,8);
state.Q = zeros(8,8);
state.w = 0;

% initialize object falling
state.falling = 1;

end

