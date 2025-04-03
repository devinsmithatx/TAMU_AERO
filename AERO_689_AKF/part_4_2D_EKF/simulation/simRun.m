function simRun(inp)

% set the seed
rng(inp.seed)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization

% derive the symbolic jacobian matrices
inp.F = symbolicF(inp);
inp.H = symbolicH(inp);

% initialize states, measurements, and t
state = initialState(inp);
measurement = initialMeasurement(inp, state);
estimate = initialEstimate(inp, measurement);

% initialize time history data
state_hist = state;
measurement_hist = measurement;
estimate_hist = estimate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation

i = 1; % track time steps
while state.falling 

    % simulate environment
    [state, measurement, i] = simEnv(inp, state, measurement, i);

    % check for next measurement
    if rem(i,inp.tm/inp.ts) == 0

    % simulate extended kalman filter
    estimate = simEKF(inp, measurement, estimate);

    % store time history data
    measurement_hist = [measurement_hist measurement];
    estimate_hist = [estimate_hist estimate]; end
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

