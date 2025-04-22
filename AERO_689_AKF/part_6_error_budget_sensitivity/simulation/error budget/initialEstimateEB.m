%% initialEstimateEB.m

function estimate = initialEstimateEB(inp, measurement, K_hist)

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

% update (now using joeseph formula)
K = K_hist(:,1);
x_post = x_prior + K*(y - y_prior);
P_post = (eye(8) - K*H)*P_prior*(eye(8) - K*H).' + K*inp.R_EKF*K';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Outputs

% store data
estimate.x_prior = x_prior;
estimate.P_prior = P_prior;
estimate.x_post = x_post;
estimate.P_post = P_post;
estimate.K = K;
end