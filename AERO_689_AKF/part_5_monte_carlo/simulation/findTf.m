function tf = findTf(inp)

% initialize environment
state = initialState(inp);                          % x0
measurement = initialMeasurement(inp, state);       % y(0)

% sim environment until reaches 0
i = 1;
while state.falling
    [state, measurement] = simEnv(inp, state, measurement, i);
    i = i + 1;
end

% get final time
tf = round(state.t,2);
end
