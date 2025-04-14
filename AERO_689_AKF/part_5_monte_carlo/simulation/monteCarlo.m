function sim_data = monteCarlo(inp, m)

% repeat simulation m times with sampled data each time
sim_data = cell(m,1);

for i = 1:m
    
    % change rng seed
    rng(i);

    % sample an initial truth state vector
    inp.x0_sampled = sqrtm(inp.P0)*randn(8,1) + inp.x0;
    
    % sample an initial estimate state vector
    inp.xh0_sampled = sqrtm(inp.P0)*randn(8,1) + inp.x0;
    inp.xh0_sampled(5:end) = zeros(4,1);

    % run the environment / ekf simulation for the sampled vectors
    [state_hist, measurement_hist, estimate_hist] = simRun(inp);

    % store the data for the run
    sim_data{i} = struct('state_hist', state_hist, ...
                         'measurement_hist', measurement_hist, ...
                         'estimate_hist', estimate_hist);
end

end