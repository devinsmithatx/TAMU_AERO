function simRun(inp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization

% set sim paramenters
rng(inp.seed)
i_max = inp.tf/inp.ts;
i_measure = inp.tm/inp.ts;

% derive the symbolic jacobian matrices
inp.F = symbolicF(inp);
inp.H = symbolicH(inp);

% initialize state, measurement, and estimate
state = initialState(inp);
measurement = initialMeasurement(inp, state);
estimate = initialEstimate(inp, measurement);

% initialize time history data
state_hist = state;
measurement_hist = measurement;
estimate_hist = estimate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation

i = 1; % track time step
while state.falling && i <= i_max

    % simulate environment
    [state, measurement] = simEnv(inp, state, measurement, i);

    % check for next measurement
    if rem(i, i_measure) == 0

        % simulate extended kalman filter
        estimate = simEKF(inp, measurement, estimate);

        % store time history data
        measurement_hist = [measurement_hist measurement];
        estimate_hist = [estimate_hist estimate];
    end
    state_hist = [state_hist state];

    i = i + 1; % increment time step
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post Processing

% plot time history data
plotNoise(inp, state_hist, measurement_hist);
plotStates(inp, state_hist, measurement_hist, estimate_hist);
plotErrors(state_hist, measurement_hist, estimate_hist);

end

