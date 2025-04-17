%% plotAllErrors.m

function plotAllErrors(sim_data, m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Time History data

% line settings
l = 1.5;                    % linewidth
rgb = [0.5 0.5 0.5 0.2];    % color 1
rgb2 = [0.0 0.0 0.0 0.2];   % color 2

% titles and labels
titles = {"Error - $r_x$", "Error - $r_y$", ...
          "Error - $v_x$", "Error - $v_y$", ...
          "Error - $\Delta h$", "Error - $\Delta \beta$", ...
          "Error - $\Delta \rho_0$", "Error - $\Delta k_p$"};
    
labels = {"$r$ (m)", "$r$ (m)", "$v$ (m/s)", "$v$ (m/s)", ...
          "$h$ (m)", "$\beta$", "$\rho$ $(kg/m^3)$", "$k_p$ (m)"};

% loop through each plot and monte carlo sims
for k=1:8
    for i=1:m
    
    % pull data
    e_hist = [sim_data{i}.e_hist];
    S_hist = [sim_data{i}.SP_hist];
    th_hist = [sim_data{i}.th_hist];
    t_bounds = [0 inf];

    plotFigure(k + 4, t_bounds, th_hist, e_hist(k,:), ...
               S_hist(k,:), titles{k}, labels{k}, l, ...
               rgb, rgb2);
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Surface plotting block

function plotFigure(fig_num, t_bounds, th_hist, e_data, s_data, title_text, y_label, l, rgb, rgb2)
    figure(fig_num);
    
    % x and z axis (if applicable)
    x = th_hist;

    % error plot
    y = e_data;
    S1 = plot(x,y,'Color',rgb, 'LineWidth',l); hold on;

    % zero line
    plot(th_hist, zeros(size(th_hist)), 'k--', 'LineWidth', 1);

    % +1 sigma plot
    y = s_data;
    S2 = plot(x,y,'Color',rgb2, 'LineWidth',l); hold on;

    % -1 sigma plot
    y = -s_data;
    plot(x,y,'Color',rgb2, 'LineWidth',l);

    % graph settings
    xlim(t_bounds);
    legend([S1, S2], '$e_i$', '$\sqrt{P_{ii}}$', 'Interpreter', 'latex', 'Location', 'best');
    title(title_text, 'Interpreter', 'latex');
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');
end
