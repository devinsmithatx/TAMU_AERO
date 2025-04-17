%% simEKF.m

function estimate = simEKF(inp, measurement, estimate, i)

% get time stuff
i_measure = inp.tm/inp.ts;

% initial estimates and mesurement
y = measurement.y;
x = estimate.x_post;
P = estimate.P_post;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Propigate

% propigate the dynamics
dx = xDynamics(inp, x, 0);
x_prior = dx*inp.ts + x;

% propigate the covariance
if inp.algorithm == 1
    % ALGORITHM 1
    F = jacobianF(inp, x);

    dP = F*P + P*F.' + inp.Qs_EKF;
    P_prior = dP.*inp.ts + P;
elseif inp.algorithm == 2
    % ALGORITHM 2
    Q = zeros(8);
    Phi = eye(8);
    F = jacobianF(inp, x);

    dQ = F*Q + Q*F.' + inp.Qs_EKF;
    Q = dQ.*inp.ts + Q;
    
    dPhi = F*Phi;
    Phi = dPhi.*inp.ts + Phi;
    
    P_prior = Phi*P*Phi.' + Q;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Update

if rem(i, i_measure) == 0
    % propigated measurement
    y_prior = xMeasure(inp, x_prior);
    H = jacobianH(inp, x_prior);
    
    % update
    K = (P_prior * H.') * (H * P_prior * H.' + inp.R_EKF)^(-1);
    x_post = x_prior + K*(y - y_prior);
    P_post = (eye(8) - K*H)*P_prior;
else
    % no update
    K = estimate.K;
    x_post = x_prior;
    P_post = P_prior;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Outputs

% store data
estimate.x_prior = x_prior;
estimate.P_prior = P_prior;
estimate.x_post = x_post;
estimate.P_post = P_post;
estimate.K = K;
end