function plotStates(inp, state_hist, estimate_hist)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse time history data

% pull time data
t_hist = [state_hist.t];

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
xh_hist = zeros(8,length(t_hist)*2);
th_hist = zeros(1,length(t_hist)*2);
for i = 1:length(t_hist)
    xh_hist(:,2*i - 1) = xprior_hist(:,i);
    xh_hist(:,2*i) = xpost_hist(:,i);
    th_hist(:,2*i - 1) = t_hist(:,i);
    th_hist(:,2*i) = t_hist(:,i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting State Data

% PLOT x position
figure; 
line1 = plot(t_hist, x_hist(1,:), 'k', DisplayName="$x$"); hold on;
line2 = plot(th_hist, xh_hist(1,:), 'b-', DisplayName="$\hat{x}$");
xlim(t_bounds); 
legend([line1 line2], Interpreter="latex", Location="best")
title("$r_x$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

% PLOT y position
figure;
line1 = plot(t_hist, x_hist(2,:), 'k', DisplayName="$x$");  hold on;
line2 = plot(th_hist, xh_hist(2,:), 'b-', DisplayName="$\hat{x}$");
xlim(t_bounds); ylim([0 inp.x0(2)]);
legend([line1 line2], Interpreter="latex", Location="best")
title("$r_y$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

% PLOT x velocity
figure;
line1 = plot(t_hist, x_hist(3,:), 'k', DisplayName="$x$");  hold on;
line2 = plot(th_hist, xh_hist(3,:), 'b-', DisplayName="$\hat{x}$");
xlim(t_bounds); 
legend([line1 line2], Interpreter="latex", Location="best")
title("$v_x$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

% PLOT y velocity
figure;
line1 = plot(t_hist, x_hist(4,:), 'k', DisplayName="$x$");  hold on;
line2 = plot(th_hist, xh_hist(4,:), 'b-', DisplayName="$\hat{x}$");
xlim(t_bounds); 
legend([line1 line2], Interpreter="latex", Location="best")
title("$v_y$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

% PLOT delta h
figure;
line1 = plot(t_hist, x_hist(5,:), 'k', DisplayName="$x$");  hold on;
line2 = plot(th_hist, xh_hist(5,:), 'b-', DisplayName="$\hat{x}$");
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$\Delta h$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$h$ (m)", Interpreter="latex");

% PLOT delta beta
figure;
line1 = plot(t_hist, x_hist(6,:), 'k', DisplayName="$x$");  hold on;
line2 = plot(th_hist, xh_hist(6,:), 'b-', DisplayName="$\hat{x}$");
xlim(t_bounds); 
legend([line1 line2], Interpreter="latex", Location="best")
title("$\Delta \beta$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\beta$", Interpreter="latex");

% PLOT delta rho0
figure; 
line1 = plot(t_hist, x_hist(7,:), 'k', DisplayName="$x$");  hold on;
line2 = plot(th_hist, xh_hist(7,:), 'b-', DisplayName="$\hat{x}$");
xlim(t_bounds); 
legend([line1 line2], Interpreter="latex", Location="best")
title("$\Delta \rho_0$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\rho$ $(kg/m^3)$", Interpreter="latex");

% PLOT delta k_p
figure; 
line1 = plot(t_hist, x_hist(8,:), 'k', DisplayName="$x$");  hold on;
line2 = plot(th_hist, xh_hist(8,:), 'b-', DisplayName="$\hat{x}$");
xlim(t_bounds); 
legend([line1 line2], Interpreter="latex", Location="best")
title("$\Delta k_p$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$k_p$ (m)", Interpreter="latex");

% PLOT Trajectory
figure; 
line1 = plot(x_hist(1,:), x_hist(2,:), 'k', DisplayName="$x$"); hold on; 
line2 = plot( xh_hist(1,:), xh_hist(2,:), 'b-', DisplayName="$\hat{x}$");
ylim([0 x_hist(2,1)]); 
legend([line1 line2], Interpreter="latex", Location="best")
title("Object Trajectory", Interpreter="latex"); 
xlabel("$x$ (m)", Interpreter="latex"); 
ylabel("$y$ (m)", Interpreter="latex");

end

