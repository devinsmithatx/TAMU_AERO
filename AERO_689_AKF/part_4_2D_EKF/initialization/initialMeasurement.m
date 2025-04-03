function measurement = initialMeasurement(inp, state)

% initialize the measurement
h = sqrt(state.x(1)^2 + (state.x(2) - (inp.bar(1) + inp.x0(5)))^2);
v = randn*sqrt(inp.R);

% store the data
measurement.y = h + v;
measurement.v = v;
measurement.t = 0;

end

