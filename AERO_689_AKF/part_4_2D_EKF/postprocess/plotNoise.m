function plotNoise(inp, state_hist, measurement_hist)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse time history data

% pull time data
t_hist = [state_hist.t];
tk_hist = [measurement_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
w_hist = [state_hist.w];
y_hist = [measurement_hist.y];
v_hist = [measurement_hist.v];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Noise & Measurement Data

% PLOT process noise 1
figure; plot(t_hist, w_hist(3,:)); xlim(t_bounds); hold on;
plot(t_hist, 0*t_hist, 'k-');
plot(t_hist, sqrt(inp.qs)*ones(length(t_hist)), 'k--');
plot(t_hist, -sqrt(inp.qs)*ones(length(t_hist)), 'k--');
title("$\omega_x$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\omega$ $(m/s^2)$", Interpreter="latex");

% PLOT process noise 2
figure; plot(t_hist, w_hist(4,:)); xlim(t_bounds); hold on;
plot(t_hist, 0*t_hist, 'k--');
plot(t_hist, sqrt(inp.qs)*ones(length(t_hist)), 'k-');
plot(t_hist, -sqrt(inp.qs)*ones(length(t_hist)), 'k-');
title("$\omega_y$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\omega$ $(m/s^2)$", Interpreter="latex");

% PLOT measurement noise
figure; plot(tk_hist, v_hist(1,:), 'x'); xlim(t_bounds); hold on;
plot(tk_hist, 0*tk_hist, 'k--');
plot(tk_hist, sqrt(inp.R)*ones(length(tk_hist)), 'k-');
plot(tk_hist, -sqrt(inp.R)*ones(length(tk_hist)), 'k-');
title("$\nu_k$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\nu$ (m)", Interpreter="latex");

% PLOT range
figure; plot(tk_hist, y_hist(1,:), 'x'); xlim(t_bounds);
title("$r_k$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");


end

