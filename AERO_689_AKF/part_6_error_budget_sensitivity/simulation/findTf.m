%% findTf.m

function tf = findTf(inp)

% initialize environment
state = initialState(inp);                          % x0
measurement = initialMeasurement(inp, state);       % y(0)

% sim environment until reaches r_y of iterest
i = 1;
while state.x(2) >= inp.ry_stop
    [state, measurement] = simEnv(inp, state, measurement, i);
    i = i + 1;
end

% get final time at ry_stop or tf_stop, depending on which is first
tf = round(state.t,2);
if tf > inp.tf_stop
    tf = inp.tf_stop;    % max allowed time spent falling
end
end