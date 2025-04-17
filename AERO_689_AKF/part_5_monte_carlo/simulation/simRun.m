function [state_hist, measurement_hist, estimate_hist] = simRun(inp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization

% set sim paramenters
i_max = inp.tf/inp.ts;       % # of iterations
i_measure = inp.tm/inp.ts;   % # of iterations between measurement/estimate

% initialize state, measurement, and estimate
state = initialState(inp);                          % x(0)
measurement = initialMeasurement(inp, state);       % y(0)
estimate = initialEstimate(inp, measurement);       % xhat(0)

% initialize time history data
state_hist = repmat(state,1,i_max + 1);
measurement_hist = repmat(measurement,1,int32(i_max/i_measure));
estimate_hist = repmat(estimate,1,int32(i_max/i_measure));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulation

for i = 1:i_max

    % simulate environment
    [state, measurement] = simEnv(inp, state, measurement, i);

    % simulate kalman filter
    estimate = simEKF(inp, measurement, estimate, i);

    % check for next measurement
    if rem(i, i_measure) == 0

    % store most recent state / measurement / estimate  
        measurement_hist(int32(i/i_measure) + 1) = measurement;
        estimate_hist(int32(i/i_measure) + 1) = estimate;
    end
    state_hist(i + 1) = state;
    
end
end