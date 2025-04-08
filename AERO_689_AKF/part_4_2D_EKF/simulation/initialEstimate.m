function estimate = initialEstimate(inp, measurement)

% initial estimates and mesurement
y = measurement.y;
x = inp.xh0;
P = inp.P0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Propigate

% propigate the dynamics
x_prior = x;

% propigate the covariance
P_prior = P;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Update

% propigated measurement
y_prior = xMeasure(inp, x_prior);
H = jacobianH(inp, x_prior);

% update
K = (P_prior * H') / (H * P_prior * H' + inp.R);
x_post = x_prior + K*(y - y_prior);
P_post = (eye(8) - K*H)*P_prior;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Outputs

% store data
estimate.x_prior = x_prior;
estimate.P_prior = P_prior;
estimate.x_post = x_post;
estimate.P_post = P_post;
estimate.K = K;
end

