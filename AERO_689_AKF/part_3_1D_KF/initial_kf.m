function estimate = initial_kf(inp, ss, measurement)
% Gets values for kalman filter (estimates, gain, and covariance) at t=0

Qk1 = ss.Qk1_tm;
phi = ss.phi_tm;
uk1 = ss.uk1_tm;
R = inp.R;
H = ss.H;
b = ss.b;
y = measurement.y;

% initial conditions
x0 = [inp.r0; inp.v0];
P0 = inp.P0;
e0 = [0; 0; 0; 0];
x_plus = x0 + e0;
P_plus = P0;

% propagate
x_min = phi*x_plus + uk1;
P_min = phi*P_plus*phi' + Qk1;

% update
K = P_min * H' * (H*P_min*H' + R)^-1;
x_plus = x_min + K*(y - H*x_min - b );
P_plus = (eye(4,4) - K*H)*P_min;

% store
estimate.x_min = x_min;
estimate.x_plus = x_plus;
estimate.P_min = P_min;
estimate.P_plus = P_plus;
estimate.K = K;
end


