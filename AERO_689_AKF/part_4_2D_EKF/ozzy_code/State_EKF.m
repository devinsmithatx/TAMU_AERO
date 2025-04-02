clc; clear; close all;

%% Define Nominal Constants
rho0_nom = 1.225; % kg/m^3 (sea-level density)
kp_nom = 8500;    % m (scale height of atmosphere)
beta_nom = 50;    % Ballistic coefficient
g = 9.8;         % m/s^2 (gravity)

%% True System Initial Conditions (Falling Mass)
x_true0 = [100; 1000; -2; -10; -0.04; +8.80; -0.10; 740.00]; 

%% EKF Initial Conditions (Different from True State)
x_ekf0 = [97.9; 1037.4; -0.24; -3.50; 0; 0; 0; 0]; % EKF starts with an estimate
P0 = diag([10, 1000, .1, 10, .04, 225, .015, 84600]); % EKF initial covariance

%% Time Setup
dt = 0.1; % Time step
T_final = 100; % Max simulation time
t = 0:dt:T_final;
n = length(t);

%% Process and Measurement Noise
Q = diag([0, 0, 1, 1, 0, 0, 0, 0]); % Process noise covariance
R = diag([4, 4]); % Measurement noise covariance

%% State Initialization
x_est = zeros(8, n); % EKF Estimated state
x_true = zeros(8, n); % True state
P_est = zeros(8, 8, n); % Covariance matrix
P_history = []; % Store covariance over time
x_true(:,1) = x_true0; % True trajectory starts from x_true0
x_est(:,1) = x_ekf0; % EKF starts from x_ekf0
P_est(:,:,1) = P0;
time_history = []; % Double time indexing
%% Simulation Loop
for k = 1:n-1
    % Stop simulation if true height <= 2m
    if x_true(2, k) <= 2
        break;
    end

    % True State Propagation
    x_true(:, k+1) = state_update(x_true(:, k), dt, rho0_nom, kp_nom, beta_nom, g);
    
    % EKF Prediction Step
    [x_pred, F] = state_update(x_est(:, k), dt, rho0_nom, kp_nom, beta_nom, g);
    P_pred = F * P_est(:, :, k) * F' + Q;

    % Store pre-update covariance
    P_history = cat(3, P_history, P_pred);
    time_history = [time_history, k*dt, k*dt]; % Double time entry

    % Measurement (Position Only)
    z_meas = x_true(1:2, k+1) + mvnrnd([0;0], R)'; % Simulated noisy measurement

    % Measurement Update (EKF)
    H = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0]; % Measurement matrix
    K = P_pred * H' / (H * P_pred * H' + R); % Kalman Gain
    x_est(:, k+1) = x_pred + K * (z_meas - H * x_pred); % Updated state estimate
    P_est(:,:, k+1) = (eye(8) - K * H) * P_pred; % Updated covariance

    % Store post-update covariance
    P_history = cat(3, P_history, P_est(:,:,k+1));
end

%% Plot Results
figure;
plot(t(1:327),x_true(4, 1:k), 'b', 'LineWidth', 2); hold on;
plot(t(1:327),x_est(4, 1:k), 'r--', 'LineWidth', 2);
xlabel('x (m)'); ylabel('y (m)'); title('Falling Mass Trajectory');
legend('True Trajectory', 'EKF Estimate');
grid on;
%% Plot Covariance Evolution
% plot(time_history, squeeze(P_history(1,1,:)), 'k-', 'LineWidth', 1.5); hold on;
% plot(time_history, squeeze(P_history(2,2,:)), 'r-', 'LineWidth', 1.5);
% plot(time_history, squeeze(P_history(3,3,:)), 'b-', 'LineWidth', 1.5);
% plot(time_history, squeeze(P_history(4,4,:)), 'g-', 'LineWidth', 1.5);
% xlabel('Time (s)'); ylabel('Covariance');
% title('Evolution of Covariance');
% legend('P_{xx}', 'P_{yy}', 'P_{vxvx}', 'P_{vyvy}');


%% State Update Function (Nonlinear)
function [x_next, F] = state_update(x, dt, rho0_nom, kp_nom, beta_nom, g)
    rho0 = rho0_nom + x(5);
    beta = beta_nom + x(6);
    kp = kp_nom + x(8);
    
    % Compute density (nonlinear)
    rho = rho0 * exp(-x(2)/kp);
    v = norm(x(3:4));
    d = (rho * v^2) / (2 * beta);
    
    % Compute accelerations
    ax = -d * x(3) / v;
    ay = -g - d * x(4) / v;
    
    % Update state using Euler integration
    x_next = x + dt * [x(3); x(4); ax; ay; 0; 0; 0; 0];

    % Compute Jacobian (F matrix for EKF)
    F = eye(8);
    F(1,3) = dt; % ∂x/∂vx
    F(2,4) = dt; % ∂y/∂vy
    F(3,3) = 1 - dt * d/v; % ∂vx/∂vx
    F(3,4) = -dt * d * x(3) / (v^2); % ∂vx/∂vy
    F(4,3) = -dt * d * x(4) / (v^2); % ∂vy/∂vx
    F(4,4) = 1 - dt * d/v; % ∂vy/∂vy
    F(4,2) = dt * (rho0/kp) * exp(-x(2)/kp); % ∂vy/∂y (altitude effect on drag)
end

