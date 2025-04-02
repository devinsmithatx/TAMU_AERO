function measurement = initialMeasurement(inp, state)

y = sqrt(state.x(1)^2 + (state.x(2)- inp.bar(1) - inp.x0(5))^2);
nu = randn*sqrt(inp.R);

measurement.y = y + nu;
measurement.t = 0;
measurement.nu = nu;

end

