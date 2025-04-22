%% plotAllGains.m

function plotAllGains(sim_data, m)
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
if m == 1
    rgb(4) = 1;
end

% titles and labels
titles = {"Gain - $r_x$", "Gain - $r_y$", ...
          "Gain - $v_x$", "Gain - $v_y$", ...
          "Gain - $\Delta h$", "Gain - $\Delta \beta$", ...
          "Gain - $\Delta \rho_0$", "Gain - $\Delta k_p$"};

% loop through each plot and monte carlo sims
for k = 1:8
    figure(n + k);
    for i = 1:m

    % pull data
    K_hist = [sim_data{i}.estimate_hist.K];
    tk_hist = [sim_data{i}.measurement_hist.t];
    t_bounds = [0 inf];

    % plot kalman gain
    scatter(tk_hist,K_hist(k,:),'MarkerEdgeColor',rgb(1:3),...
                                'MarkerEdgeAlpha',rgb(4),'LineWidth',l); 
    hold on;

    xlim(t_bounds);
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel("$K_i$", 'Interpreter', 'latex');
    title(titles(k), 'Interpreter', 'latex');
    end

    % plot zero line
    plot(tk_hist,zeros(size(tk_hist)),'k--');
end
end

