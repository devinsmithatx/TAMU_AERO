% problem 3 constant scalars
r = 10/100;         % (m)
g = 9.81;           % (m/s)
t0 = 0;             % (s)
tf = 2;             % (s)
dth0 = 0;           % (rad/s^2)

% problem 3 constant matrices & vectors
syms omega theta time

A_U = [[1, 0, 0],;                              % DCM from U to A
       [0, cos(theta), -sin(theta)],;
       [0, sin(theta), cos(theta)]];

N_A = [[cos(omega*time), -sin(omega*time), 0],; % DCM from A to N
       [sin(omega*time), cos(omega*time), 0],;
       [0, 0, 1]];

r_U = [0; r; 0];        % r vector in the U frame (m)
r_N = N_A*A_U*r_U;      % r vector in the N frame (m)

% problem A conditions
th0 = 0;            % rad
om = 0.5*(2*pi/1);  % rad/s

% solve the EOM ode
[t, th] = ode45(@(t, th) eom(t, th, r, g, om), [0, 2], [th0, dth0]);

% calculate trajectory from t0 to tf
trajectory = [];
for i=1:length(t)
    trajectory(i, 1:3) = subs(r_N, {time theta omega}, {t(i) th(i) om});
end

% theta plot
plot(t, th(:, 1), "DisplayName", "Theta");
xlabel("Time (s)"); ylabel("Theta (rad)"); title("theta");

% dtheta plot
plot(t, th(:, 2), "DisplayName", "dTheta");
xlabel("Time (s)"); ylabel("dTheta (rad/s)"); title("dtheta");

plot3(trajectory(:, 1), trajectory(:, 2), trajectory(:, 3));
xlabel("x (m)"); xlabel("y (m)"); zlabel("z (m)"); title("position over time");

% problem B conditions
th0 = 45*pi/180;     % rad
om = 5*(2*pi/1);     % rad/s

% solve the EOM ode
[t, th] = ode45(@(t, th) eom(t, th, r, g, om), [0, 2], [th0, dth0]);

% calculate trajectory from t0 to tf
trajectory = [];
for i=1:length(t)
    trajectory(i, 1:3) = subs(r_N, {time theta omega}, {t(i) th(i) om});
end

% theta plot
plot(t, th(:, 1), "DisplayName", "Theta");
xlabel("Time (s)"); ylabel("Theta (rad)"); title("theta");

% dtheta plot
plot(t, th(:, 2), "DisplayName", "dTheta");
xlabel("Time (s)"); ylabel("dTheta (rad/s)"); title("dtheta");

plot3(trajectory(:, 1), trajectory(:, 2), trajectory(:, 3));
xlabel("x (m)"); xlabel("y (m)"); zlabel("z (m)"); title("position over time");

% problem C
omega_C = solve(-cos(-th0)*(g/r + omega^2*sin(-th0)) == 0, omega); % solve EOM = 0
omega_C = omega_C(1)

% problem D
th0 = -th0;     % rad
om = omega_C;   % rad/s

% solve the EOM ode
[t, th] = ode45(@(t, th) eom(t, th, r, g, om), [0, 2], [th0, dth0]);

% calculate trajectory from t0 to tf
trajectory = [];
for i=1:length(t)
    trajectory(i, 1:3) = subs(r_N, {time theta omega}, {t(i) th(i) om});
end

% theta plot
plot(t, th(:, 1), "DisplayName", "Theta");
xlabel("Time (s)"); ylabel("Theta (rad)"); title("theta");

% dtheta plot
plot(t, th(:, 2), "DisplayName", "dTheta");
xlabel("Time (s)"); ylabel("dTheta (rad/s)"); title("dtheta");

plot3(trajectory(:, 1), trajectory(:, 2), trajectory(:, 3));
xlabel("x (m)"); xlabel("y (m)"); zlabel("z (m)"); title("position over time");

% equation of motion
function dth = eom(t, th,r , g, om)
    dth = zeros(2, 1);
    dth(1) = th(2);
    dth(2) = -cos(th(1))*(g/r + om^2*sin(th(1)));
end
