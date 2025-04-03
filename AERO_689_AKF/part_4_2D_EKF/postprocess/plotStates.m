function plotStates(inp, state_hist, measurement_hist, estimate_hist)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse time history data

% pull time data
t_hist = [state_hist.t];
tk_hist = [measurement_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [state_hist.x];

% pull ekf data
xprior_hist = [estimate_hist.x_prior];
xpost_hist = [estimate_hist.x_post];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process Estimation Data

% zip together the apriori and aposteriori measurements
xh_hist = zeros(8,length(tk_hist)*2);
th_hist = zeros(1,length(tk_hist)*2);
for i = 1:length(tk_hist)
    xh_hist(:,2*i - 1) = xprior_hist(:,i);
    xh_hist(:,2*i) = xpost_hist(:,i);
    th_hist(:,2*i - 1) = tk_hist(:,i);
    th_hist(:,2*i) = tk_hist(:,i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting State Data

% PLOT x position
figure; plot(t_hist, x_hist(1,:), 'k'); xlim(t_bounds); hold on;
plot(th_hist, xh_hist(1,:), 'r-');
title("$r_x$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

% PLOT y position
figure; plot(t_hist, x_hist(2,:), 'k'); 
xlim(t_bounds); ylim([0 inp.x0(2)]); hold on;
plot(th_hist, xh_hist(2,:), 'r-');
title("$r_y$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

% PLOT x velocity
figure; plot(t_hist, x_hist(3,:), 'k'); xlim(t_bounds); hold on;
plot(th_hist, xh_hist(3,:), 'r-');
title("$v_x$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

% PLOT y velocity
figure; plot(t_hist, x_hist(4,:), 'k'); xlim(t_bounds); hold on;
plot(th_hist, xh_hist(4,:), 'r-');
title("$v_y$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

% PLOT delta h
figure; plot(t_hist, x_hist(5,:), 'k'); xlim(t_bounds); hold on;
plot(th_hist, xh_hist(5,:), 'r-');
title("$\Delta h$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$h$ (m)", Interpreter="latex");

% PLOT delta beta
figure; plot(t_hist, x_hist(6,:), 'k'); xlim(t_bounds); hold on;
plot(th_hist, xh_hist(6,:), 'r-');
title("$\Delta \beta$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\beta$", Interpreter="latex");

% PLOT delta rho0
figure; plot(t_hist, x_hist(7,:), 'k'); xlim(t_bounds); hold on;
plot(th_hist, xh_hist(7,:), 'r-');
title("$\Delta \rho_0$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\rho$ $(kg/m^3)$", Interpreter="latex");

% PLOT delta k_p
figure; plot(t_hist, x_hist(8,:), 'k'); xlim(t_bounds); hold on;
plot(th_hist, xh_hist(8,:), 'r-');
title("$\Delta k_p$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$k_p$ (m)", Interpreter="latex");

% PLOT Trajectory
figure; plot(x_hist(1,:), x_hist(2,:), 'k'); hold on; ylim([0 x_hist(2,1)])
plot( xh_hist(1,:), xh_hist(2,:), 'r-');
title("Object Trajectory", Interpreter="latex"); 
xlabel("$x$ (m)", Interpreter="latex"); 
ylabel("$y$ (m)", Interpreter="latex");

end

