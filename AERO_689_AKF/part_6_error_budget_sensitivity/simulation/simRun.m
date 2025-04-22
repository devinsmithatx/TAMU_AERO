%% simRun.m

function [state_hist, measurement_hist, estimate_hist] = simRun(inp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization

% initialize state, measurement, and estimate
state = initialState(inp);                          % x(t0)
measurement = initialMeasurement(inp, state);       % y(t0)
estimate = initialEstimate(inp, measurement);       % xhat(t0)

% allocate time history data
state_hist = repmat(state,1,inp.i_max + 1);
measurement_hist = repmat(measurement,1,int32(inp.i_max/inp.i_measure));
estimate_hist = repmat(estimate,1,int32(inp.i_max/inp.i_measure));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation

% sim the environment and EKF for all T
for i = 1:inp.i_max

    % simulate environment
    [state, measurement] = simEnv(inp, state, measurement, i);

    % simulate kalman filter
    estimate = simEKF(inp, measurement, estimate, i);

    % store state at t_s
    state_hist(i + 1) = state;

    % store measurement & estimate at t_k 
    if rem(i, inp.i_measure) == 0
        measurement_hist(int32(i/inp.i_measure) + 1) = measurement;
        estimate_hist(int32(i/inp.i_measure) + 1) = estimate;
    end
end
end