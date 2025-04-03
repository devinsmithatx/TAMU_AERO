function estimate = simEKF(inp, measurement, estimate)


% initial estimates and mesurement
x = estimate.x_post;
P = estimate.P_post;
y = measurement.y;

% evaluate the jacobians
F = numericJ(inp.F, x);
H = numericJ(inp.H, x);

% propigate the dynamics
[~, x] = ode45(@(t, y) odeDynamics(t, y, inp, 0), [0 inp.tm], x);
x_prior = reshape(x(end,:), 8, 1);
h_prior = sqrt(x_prior(1)^2 + (x_prior(2) - (inp.bar(1) + x_prior(5)))^2);

% propigate the covariance
P0 = eye(8);
[~, P] = ode45(@(t, y) odeP(t, y, inp, F), [0 inp.tm], P0(:));
P_prior = reshape(P(end,:), 8, 8);

% update
K = P_prior * H.' / (H * P_prior * H.' + inp.R);
x_post = x_prior + K*(y - h_prior);
P_post = (1 - K*H)*P_prior;

% store data
estimate.x_prior = x_prior;
estimate.x_post = x_post;
estimate.P_prior = P_prior;
estimate.P_post = P_post;
estimate.K = K;
estimate.t = measurement.t;
end

