function state = initial_state(inp, ss)
%INITIAL_STATE Creates the initial state, time, and process noise
state.r = inp.r0;                           % pull r0
state.v = inp.v0;                           % pull v0
state.t = 0;                                % let t0 = 0
state.w = [0; 0; 0; sqrt(inp.qs)]*randn;    % generate an initial w0
state = measure(state, ss);                 % get initial measurement
state.falling = true;
end

