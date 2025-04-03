function simPlot(inp, state_hist, measurement_hist)
%% Parse time history data

% pull time data
t_hist = [state_hist.t];
tk_hist = [measurement_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [state_hist.x];
y_hist = [measurement_hist.y];
nu_hist = [measurement_hist.nu];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting State Data

% PLOT x position
figure; plot(t_hist, x_hist(1,:), 'k'); xlim(t_bounds);
title("$r_x$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

% PLOT y position
figure; plot(t_hist, x_hist(2,:), 'k'); xlim(t_bounds);
title("$r_y$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

% PLOT x velocity
figure; plot(t_hist, x_hist(3,:), 'k'); xlim(t_bounds);
title("$v_x$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

% PLOT y velocity
figure; plot(t_hist, x_hist(4,:), 'k'); xlim(t_bounds);
title("$v_y$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

% PLOT Trajectory
figure; plot(x_hist(1,:), x_hist(2,:), 'k'); ylim([0 x_hist(2,1)])
title("Object Trajectory", Interpreter="latex"); 
xlabel("$x$ (m)", Interpreter="latex"); 
ylabel("$y$ (m)", Interpreter="latex");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Measurement Data

% PLOT range
figure; plot(tk_hist, y_hist(1,:), 'x'); xlim(t_bounds);
title("$r_k$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

% PLOT measurement noise
figure; plot(tk_hist, nu_hist(1,:), 'x'); xlim(t_bounds); hold on;
plot(tk_hist, 0*tk_hist, 'k-');
plot(tk_hist, sqrt(inp.R)*ones(length(tk_hist)), 'k--');
plot(tk_hist, -sqrt(inp.R)*ones(length(tk_hist)), 'k--');
title("$\nu_k$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\nu$ (m)", Interpreter="latex");

end

