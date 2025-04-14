function plotStates(sim_data, m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Settings

l = 1.5;                 % linewidth
rgb_true = [0.0 0.0 0.0];      % true state color
rgb_est = [0.2 0.5 0.9]; % estimated state color

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse time history data

for i = 1:m

    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    t_bounds = [t_hist(1) t_hist(end)];

    % Pull state and estimate data
    x_hist = [sim_data{i}.state_hist.x];
    xprior_hist = [sim_data{i}.estimate_hist.x_prior];
    xpost_hist = [sim_data{i}.estimate_hist.x_post];

    % Combine estimates
    xh_hist = zeros(8, length(t_hist)*2);
    th_hist = zeros(1, length(t_hist)*2);
    for j = 1:length(t_hist)
        xh_hist(:,2*j - 1) = xprior_hist(:,j);
        xh_hist(:,2*j) = xpost_hist(:,j);
        th_hist(:,2*j - 1) = t_hist(:,j);
        th_hist(:,2*j) = t_hist(:,j);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting State Data

    % Plot states with surface formatting
    plotStateSurface(13, t_bounds, t_hist, th_hist, x_hist(2,:), xh_hist(2,:), ...
        "$r_y$", "$r$ (m)", l, rgb_true, rgb_est);
end
for i = 1:m

    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    t_bounds = [t_hist(1) t_hist(end)];

    % Pull state and estimate data
    x_hist = [sim_data{i}.state_hist.x];
    xprior_hist = [sim_data{i}.estimate_hist.x_prior];
    xpost_hist = [sim_data{i}.estimate_hist.x_post];

    % Combine estimates
    xh_hist = zeros(8, length(t_hist)*2);
    th_hist = zeros(1, length(t_hist)*2);
    for j = 1:length(t_hist)
        xh_hist(:,2*j - 1) = xprior_hist(:,j);
        xh_hist(:,2*j) = xpost_hist(:,j);
        th_hist(:,2*j - 1) = t_hist(:,j);
        th_hist(:,2*j) = t_hist(:,j);
    end

    plotStateSurface(14, t_bounds, t_hist, th_hist, x_hist(3,:), xh_hist(3,:), ...
        "$v_x$", "$v$ (m/s)", l, rgb_true, rgb_est);
end
for i = 1:m

    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    t_bounds = [t_hist(1) t_hist(end)];

    % Pull state and estimate data
    x_hist = [sim_data{i}.state_hist.x];
    xprior_hist = [sim_data{i}.estimate_hist.x_prior];
    xpost_hist = [sim_data{i}.estimate_hist.x_post];

    % Combine estimates
    xh_hist = zeros(8, length(t_hist)*2);
    th_hist = zeros(1, length(t_hist)*2);
    for j = 1:length(t_hist)
        xh_hist(:,2*j - 1) = xprior_hist(:,j);
        xh_hist(:,2*j) = xpost_hist(:,j);
        th_hist(:,2*j - 1) = t_hist(:,j);
        th_hist(:,2*j) = t_hist(:,j);
    end

    plotStateSurface(15, t_bounds, t_hist, th_hist, x_hist(4,:), xh_hist(4,:), ...
        "$v_y$", "$v$ (m/s)", l, rgb_true, rgb_est);
end
for i = 1:m

    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    t_bounds = [t_hist(1) t_hist(end)];

    % Pull state and estimate data
    x_hist = [sim_data{i}.state_hist.x];
    xprior_hist = [sim_data{i}.estimate_hist.x_prior];
    xpost_hist = [sim_data{i}.estimate_hist.x_post];

    % Combine estimates
    xh_hist = zeros(8, length(t_hist)*2);
    th_hist = zeros(1, length(t_hist)*2);
    for j = 1:length(t_hist)
        xh_hist(:,2*j - 1) = xprior_hist(:,j);
        xh_hist(:,2*j) = xpost_hist(:,j);
        th_hist(:,2*j - 1) = t_hist(:,j);
        th_hist(:,2*j) = t_hist(:,j);
    end

    plotStateSurface(16, t_bounds, t_hist, th_hist, x_hist(5,:), xh_hist(5,:), ...
        "$\Delta h$", "$h$ (m)", l, rgb_true, rgb_est);
end
for i = 1:m

    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    t_bounds = [t_hist(1) t_hist(end)];

    % Pull state and estimate data
    x_hist = [sim_data{i}.state_hist.x];
    xprior_hist = [sim_data{i}.estimate_hist.x_prior];
    xpost_hist = [sim_data{i}.estimate_hist.x_post];

    % Combine estimates
    xh_hist = zeros(8, length(t_hist)*2);
    th_hist = zeros(1, length(t_hist)*2);
    for j = 1:length(t_hist)
        xh_hist(:,2*j - 1) = xprior_hist(:,j);
        xh_hist(:,2*j) = xpost_hist(:,j);
        th_hist(:,2*j - 1) = t_hist(:,j);
        th_hist(:,2*j) = t_hist(:,j);
    end

    plotStateSurface(17, t_bounds, t_hist, th_hist, x_hist(6,:), xh_hist(6,:), ...
        "$\Delta \beta$", "$\beta$", l, rgb_true, rgb_est);
end
for i = 1:m

    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    t_bounds = [t_hist(1) t_hist(end)];

    % Pull state and estimate data
    x_hist = [sim_data{i}.state_hist.x];
    xprior_hist = [sim_data{i}.estimate_hist.x_prior];
    xpost_hist = [sim_data{i}.estimate_hist.x_post];

    % Combine estimates
    xh_hist = zeros(8, length(t_hist)*2);
    th_hist = zeros(1, length(t_hist)*2);
    for j = 1:length(t_hist)
        xh_hist(:,2*j - 1) = xprior_hist(:,j);
        xh_hist(:,2*j) = xpost_hist(:,j);
        th_hist(:,2*j - 1) = t_hist(:,j);
        th_hist(:,2*j) = t_hist(:,j);
    end

    plotStateSurface(18, t_bounds, t_hist, th_hist, x_hist(7,:), xh_hist(7,:), ...
        "$\Delta \rho_0$", "$\rho$ $(kg/m^3)$", l, rgb_true, rgb_est);
end
for i = 1:m

    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    t_bounds = [t_hist(1) t_hist(end)];

    % Pull state and estimate data
    x_hist = [sim_data{i}.state_hist.x];
    xprior_hist = [sim_data{i}.estimate_hist.x_prior];
    xpost_hist = [sim_data{i}.estimate_hist.x_post];

    % Combine estimates
    xh_hist = zeros(8, length(t_hist)*2);
    th_hist = zeros(1, length(t_hist)*2);
    for j = 1:length(t_hist)
        xh_hist(:,2*j - 1) = xprior_hist(:,j);
        xh_hist(:,2*j) = xpost_hist(:,j);
        th_hist(:,2*j - 1) = t_hist(:,j);
        th_hist(:,2*j) = t_hist(:,j);
    end

    plotStateSurface(19, t_bounds, t_hist, th_hist, x_hist(8,:), xh_hist(8,:), ...
        "$\Delta k_p$", "$k_p$ (m)", l, rgb_true, rgb_est);
end
for i = 1:m

    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    t_bounds = [t_hist(1) t_hist(end)];

    % Pull state and estimate data
    x_hist = [sim_data{i}.state_hist.x];
    xprior_hist = [sim_data{i}.estimate_hist.x_prior];
    xpost_hist = [sim_data{i}.estimate_hist.x_post];

    % Combine estimates
    xh_hist = zeros(8, length(t_hist)*2);
    th_hist = zeros(1, length(t_hist)*2);
    for j = 1:length(t_hist)
        xh_hist(:,2*j - 1) = xprior_hist(:,j);
        xh_hist(:,2*j) = xpost_hist(:,j);
        th_hist(:,2*j - 1) = t_hist(:,j);
        th_hist(:,2*j) = t_hist(:,j);
    end

    % --- Subplot 1: True trajectory ---
    figure(20);
    subplot(1,2,1);
    x = x_hist(1,:);
    y = x_hist(2,:);
    z = zeros(size(x));
    surface([x; x], [y; y], [z; z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.2, 'edgecolor', rgb_true); hold on;
    ylim([0 inf])
    title("True Trajectory", 'Interpreter', 'latex');
    xlabel("$x$ (m)", 'Interpreter', 'latex');
    ylabel("$y$ (m)", 'Interpreter', 'latex');
    
    % --- Subplot 2: Estimated trajectory ---
    subplot(1,2,2);
    x = xh_hist(1,:);
    y = xh_hist(2,:);
    z = zeros(size(x));
    surface([x; x], [y; y], [z; z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.2, 'edgecolor', rgb_est); hold on;
    title("Estimated Trajectory", 'Interpreter', 'latex');
    ylim([0 inf])
    xlabel("$x$ (m)", 'Interpreter', 'latex');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Surface plotting block

function plotStateSurface(fig_num, t_bounds, t_hist, th_hist, x_true, x_est, title_text, y_label, l, rgb_true, rgb_est)
    figure(fig_num);

    % --- Subplot 1: True State ---
    subplot(1,2,1);
    x = t_hist;
    y = x_true;
    z = zeros(size(x));
    surface([x; x], [y; y], [z; z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.01, 'edgecolor', rgb_true); hold on;

    xlim(t_bounds);
    title([title_text ' (True)'], 'Interpreter', 'latex');
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');

    % --- Subplot 2: Estimated State ---
    subplot(1,2,2);
    x = th_hist;
    y = x_est;
    z = zeros(size(x));
    surface([x; x], [y; y], [z; z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.01, 'edgecolor', rgb_est); hold on;

    xlim(t_bounds);
    title([title_text ' (Estimate)'], 'Interpreter', 'latex');
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');
end
