function sim_run(inp)
% Simulates dynamics, measurements, and kalman filter for all time

% generate state space dynamics
ss = initial_ss(inp);

% initialize the state, measurement and estimate
[state, measurement] = initial_env(inp, ss);
estimate = initial_kf(inp, ss, measurement);

% initialize sim history
state_hist = state;
measurement_hist = measurement;
estimate_hist = estimate;

% loop through the simulation
i = 1;
while state.falling
    % run the environment with sim timestep
    [state, measurement] = sim_env(inp, ss, i, state, measurement);
    
    % run kalman filter with measurement timestep
    if rem(i,inp.tm/inp.dt) == 0
        estimate = sim_kf(inp, ss, measurement, estimate);
        
        measurement_hist = [measurement_hist, measurement];
        estimate_hist = [estimate_hist, estimate];
    end
    state_hist = [state_hist, state];
    
    i = i + 1;
end

% plot the results
sim_plot(inp, state_hist, measurement_hist, estimate_hist);
end
