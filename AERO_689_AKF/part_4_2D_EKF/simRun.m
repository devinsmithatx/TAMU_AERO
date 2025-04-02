function simRun(inp)

% initialize states, measurements, and t
state = initialState(inp);
measurement = initialMeasurement(inp, state);

% initialize time history data
state_hist = state;
measurement_hist = measurement;

% simulate while object is falling
i = 1;
while state.falling

    % simulate environment
    [state, measurement, i] = simEnv(inp, state, measurement, i);

    % store time history data
    if rem(i,inp.tm/inp.ts) == 0
        measurement_hist = [measurement_hist measurement];
    end
    state_hist = [state_hist state];
    i = i + 1;
end

% plot time history data
simPlot(inp, state_hist, measurement_hist)
end

