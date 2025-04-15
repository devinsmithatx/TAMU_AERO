function plotAllStates(sim_data, m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot time history data

% line settings
l = 1.5;                    % linewidth
rgb = [0.2 0.5 0.9 0.2];    % color 1
rgb2 = [0.0 0.0 0.0 0.2];   % color 2

% titles and labels
titles = {"$r_x$", "$r_y$", ...
          "$v_x$", "$v_y$", ...
          "$\Delta h$", "$\Delta \beta$", ...
          "$\Delta \rho_0$", "$\Delta k_p$"};

labels = {"$r$ (m)", "$r$ (m)", "$v$ (m/s)", "$v$ (m/s)", ...
          "$h$ (m)", "$\beta$", "$\rho$ $(kg/m^3)$", "$k_p$ (m)"};

% loop through each plot and monte carlo sims
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

        S1 = plot(x,y,'Color',rgb2, 'LineWidth',l); hold on;
        
        % Estimated trajectory
        x = xh_hist(1,:);
        y = xh_hist(2,:);

        S2 = plot(x,y,'Color',rgb, 'LineWidth',l); hold on;

        legend([S1, S2], '$x$', '$\hat{x}$', 'Interpreter', 'latex', 'Location', 'best');
        ylim([0 inf])
        title("Trajectory", 'Interpreter', 'latex');
        xlabel("$x$ (m)", 'Interpreter', 'latex');
        ylabel("$y$ (m)", 'Interpreter', 'latex');
    else
        plotFigure(12 + k, t_bounds, t_hist, th_hist, x_hist(k,:), xh_hist(k,:), ...
            titles{k}, labels{k}, l, rgb, rgb2);
    end
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Surface plotting block

function plotFigure(fig_num, t_bounds, t_hist, th_hist, x_true, x_est, title_text, y_label, l, rgb, rgb2)
    figure(fig_num);

    % x
    x = t_hist;
    xh = th_hist;

    % true State
    y = x_true;
    S1 = plot(x,y,'Color',rgb2, 'LineWidth',l); hold on;

    % estimated State
    y = x_est;
    S2 = plot(xh,y,'Color',rgb, 'LineWidth',l); hold on;

    xlim(t_bounds);
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');
    title(title_text, 'Interpreter', 'latex');
    legend([S1, S2], '$x$', '$\hat{x}$', 'Interpreter', 'latex', 'Location', 'best');
end

