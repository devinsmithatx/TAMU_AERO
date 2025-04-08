function [state_hist, measurement_hist, estimate_hist] = simRun(inp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization5

% set sim paramenters
rng(inp.seed)                % rng seed
i_max = inp.tf/inp.ts;       % # of max iterations
i_measure = inp.tm/inp.ts;   % # of iterations between measurement/estimate

% initialize state, measurement, and estimate
state = initialState(inp);                          % x(0)
measurement = initialMeasurement(inp, state);       % y(0)
estimate = initialEstimate(inp, measurement);       % xhat(0)

% initialize time history data
state_hist = state;
measurement_hist = measurement;
estimate_hist = estimate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation

i = 1; % track time step
while (state.falling) && (i <= i_max)

    % simulate environment
    [state, measurement] = simEnv(inp, state, measurement, i);

    % simulate kalman filter
    estimate = simEKF(inp, measurement, estimate, i);

    % check for next measurement
    if rem(i, i_measure) == 0
        measurement_hist = [measurement_hist measurement];
    end
    estimate_hist = [estimate_hist estimate];
    state_hist = [state_hist state];

    i = i + 1; % increment time step
end

end

