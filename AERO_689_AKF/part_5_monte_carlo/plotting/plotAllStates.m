function plotAllStates(sim_data, m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot time history data

l = 1.5;                     % linewidth
rgb_true = [0.0 0.0 0.0];    % true state color
rgb_est = [0.2 0.5 0.9];     % estimated state color

titles = {"$r_x$", "$r_y$", ...
          "$v_x$", "$v_y$", ...
          "$\Delta h$", "$\Delta \beta$", ...
          "$\Delta \rho_0$", "$\Delta k_p$"};

labels = {"$r$ (m)", "$r$ (m)", "$v$ (m/s)", "$v$ (m/s)", ...
          "$h$ (m)", "$\beta$", "$\rho$ $(kg/m^3)$", "$k_p$ (m)"};

for k = 1:8
    for i = 1:m

    % pull data
    x_hist = [sim_data{i}.state_hist.x];
    xh_hist = [sim_data{i}.xh_hist];
    t_hist = [sim_data{i}.state_hist.t];
    th_hist = [sim_data{i}.th_hist];
    t_bounds = [0 inf];

    if k == 8
         % True trajectory
        figure(20);
        x = x_hist(1,:);
        y = x_hist(2,:);
        z = zeros(size(x));
        S1 = surface([x; x], [y; y], [z; z], ...
            'facecol', 'no', 'edgecol', 'interp', ...
            'linew', l, 'edgealpha', 0.1, 'edgecolor', rgb_true); hold on;
        ylim([0 inf])
        title("Trajectory", 'Interpreter', 'latex');
        xlabel("$x$ (m)", 'Interpreter', 'latex');
        ylabel("$y$ (m)", 'Interpreter', 'latex');
        
        % Estimated trajectory
        x = xh_hist(1,:);
        y = xh_hist(2,:);
        z = zeros(size(x));
        S2 = surface([x; x], [y; y], [z; z], ...
            'facecol', 'no', 'edgecol', 'interp', ...
            'linew', l, 'edgealpha', 0.1, 'edgecolor', rgb_est); hold on;
        legend([S1, S2], '$x$', '$\hat{x}$', 'Interpreter', 'latex', 'Location', 'best');

    else
        plotStateSurface(12 + k, t_bounds, t_hist, th_hist, x_hist(k,:), xh_hist(k,:), ...
            titles{k}, labels{k}, l, rgb_true, rgb_est);
    end
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Surface plotting block

function plotStateSurface(fig_num, t_bounds, t_hist, th_hist, x_true, x_est, title_text, y_label, l, rgb_true, rgb_est)
    figure(fig_num);

    % True State
    x = t_hist;
    y = x_true;
    z = zeros(size(x));
    S1 = surface([x; x], [y; y], [z; z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.1, 'edgecolor', rgb_true); hold on;

    % Estimated State
    x = th_hist;
    y = x_est;
    z = zeros(size(x));
    S2 = surface([x; x], [y; y], [z; z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.1, 'edgecolor', rgb_est); hold on;

    xlim(t_bounds);
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');
    title(title_text, 'Interpreter', 'latex');
    legend([S1, S2], '$x$', '$\hat{x}$', 'Interpreter', 'latex', 'Location', 'best');

end

