function measurement = initialMeasurement(inp, state)

% get measurement and noise
y = measure(inp, state.x);
v = randn*sqrt(inp.R);

% store the data
measurement.y = y + v;
measurement.v = v;
measurement.t = 0;

end

