function estimate = initialEstimate(inp, measurement)

% initial estimates and mesurement
xh = inp.xh0;
Ph = inp.P0;
y = measurement.y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Propigate

% evaluate the jacobian
F = numericJ(inp.F, xh);

% propigate the dynamics
[~, x] = ode45(@(t, y) odeDynamics(t, y, inp, 0), [0 inp.tm], xh);
x_prior = reshape(x(end,:), 8, 1);

%% propigate the covariance | ALGORITHM 1
P0 = Ph;
[~, P] = ode45(@(t, y) odeP(t, y, inp, F), [0 inp.tm], P0(:));
P_prior = reshape(P(end,:), 8, 8);

%% propigate the covariance | ALGORITHM 2
% Q0 = zeros(8,8);
% [~, Q] = ode45(@(t, y) odeQ(t, y, inp, F), [0 inp.ts], Q0(:));
% Q = reshape(Q(end,:), 8, 8);
% 
% Phi0 = eye(8,8);
% [~, Phi] = ode45(@(t, y) odePhi(t, y, F), [0 inp.ts], Phi0(:));
% Phi = reshape(Phi(end,:), 8, 8);
% 
% P_prior = Phi*Ph*(Phi.') + Q;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Update

% propigated measurement
y_prior = measure(inp, x_prior);

% evaluate the jacobian
H = numericJ(inp.H, x_prior);

% update
K = (P_prior * H.') / (H * P_prior * H.' + inp.R);
x_post = x_prior + K*(y - y_prior);
P_post = (1 - K*H)*P_prior;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Outputs

% store data
estimate.x_prior = x_prior;
estimate.P_prior = P_prior;
estimate.x_post = x_post;
estimate.P_post = P_post;
estimate.K = K;
% estimate.Q = Q;
% estimate.Phi = Phi;
estimate.t = measurement.t;
end

