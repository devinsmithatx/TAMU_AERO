%% plotAllStates.m

function plotAllStates(sim_data, m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot time history data

% get number of current plots before functio was called
n = get(gcf,'Number');
if n == 1
    n = 0;
end

% line settings
l = 1.5;                    % linewidth
rgb = [0.5 0.5 0.5 0.2];    % color 1
rgb2 = [0.0 0.0 0.0 0.2];   % color 2
if m == 1
    rgb(4) = 1;
    rgb2(4) = 1;
end

% titles and labels
titles = {"State - $r_x$", "State - $r_y$", ...
          "State - $v_x$", "State - $v_y$", ...
          "State - $\Delta h$", "State - $\Delta \beta$", ...
          "State - $\Delta \rho_0$", "State - $\Delta k_p$"};

labels = {"$r$ (m)", "$r$ (m)", "$v$ (m/s)", "$v$ (m/s)", ...
          "$h$ (m)", "$\beta$", "$\rho$ $(kg/m^3)$", "$k_p$ (m)"};

% loop through each plot and monte carlo sims
for k = 1:9
    for i = 1:m

    % pull data
    x_hist = [sim_data{i}.state_hist.x];
    xh_hist = [sim_data{i}.xh_hist];
    t_hist = [sim_data{i}.state_hist.t];
    th_hist = [sim_data{i}.th_hist];
    t_bounds = [0 inf];

    if k == 9
         % True trajectory
        figure(n + 9);
        x = x_hist(1,:);
        y = x_hist(2,:);

        S1 = plot(x,y,'Color',rgb2, 'LineWidth',l); hold on;
        
        % Estimated trajectory
        x = xh_hist(1,:);
        y = xh_hist(2,:);

        S2 = plot(x,y,'Color',rgb, 'LineWidth',l); hold on;

        legend([S1, S2], '$x_i$', '$\hat{x}_i$', 'Interpreter', 'latex', 'Location', 'best');
        ylim([0 inf])
        title("Object Trajectory", 'Interpreter', 'latex');
        xlabel("$x$ (m)", 'Interpreter', 'latex');
        ylabel("$y$ (m)", 'Interpreter', 'latex');
    else
        plotFigure(n + k, t_bounds, t_hist, th_hist, x_hist(k,:), xh_hist(k,:), ...
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
    legend([S1, S2], '$x_i$', '$\hat{x}_i$', 'Interpreter', 'latex', 'Location', 'best');
end

