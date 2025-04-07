function [state_hist, measurement_hist, estimate_hist] = simRun(inp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization5

% set sim paramenters
rng(inp.seed)
i_max = inp.tf/inp.ts;       % # of max iterations allowed in the sim
i_measure = inp.tm/inp.ts;   % # of iterations between measurement/estimate

% derive the symbolic jacobian matrices
inp.F = symbolicF(inp);                     % dx/dt = F(x(t)) * x(t)
inp.H = symbolicH(inp);                     % y     = H(x(t)) * x(t) 

% initialize state, measurement, and estimate
state = initialState(inp);                          % x(0)    = ...
measurement = initialMeasurement(inp, state);       % y(0)    = ...
estimate = initialEstimate(inp, measurement);       % xhat(0) = ... 

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

    % check for next measurement / estimate update
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

end

