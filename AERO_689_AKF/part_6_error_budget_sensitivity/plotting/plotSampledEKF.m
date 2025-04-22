%% plotSampledEKF.m

function plotSampledEKF(sim_data, sample_data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Time History data

% get number of current plots before functio was called
n = get(gcf,'Number');
if n == 1
    n = 0;
end

% line settings
l = 1.5;                    % linewidth
rgb = [0.5 0.5 0.5];    % color 1
rgb2 = [0.0 0.0 0.0];   % color 2

% pull data from 1st run aka "nominal run"
e_hist = [sim_data{1}.e_hist];
S_hist = [sim_data{1}.SP_hist];
th_hist = [sim_data{1}.th_hist];
t_bounds = [0 inf];

% pull sample data from monte carlo averages
e_bar_hist = sample_data.e_bar_hist;
SP_bar_hist = sample_data.SP_bar_hist;

titles = {"Error - $r_x$", "Error - $r_y$", ...
          "Error - $v_x$", "Error - $v_y$", ...
          "Error - $\Delta h$", "Error - $\Delta \beta$", ...
          "Error - $\Delta \rho_0$", "Error - $\Delta k_p$"};
    
labels = {"$r$ (m)", "$r$ (m)", "$v$ (m/s)", "$v$ (m/s)", ...
          "$h$ (m)", "$\beta$", "$\rho$ $(kg/m^3)$", "$k_p$ (m)"};

for k = 1:8
    plotData(n + k, t_bounds, th_hist, e_hist(k,:), e_bar_hist(k,:),...
             S_hist(k,:), SP_bar_hist(k,:), titles{k}, ...
             labels{k}, l, rgb, rgb2);

end

end

function plotData(fig_num, t_bounds, th_hist, e_data, e_bar_data, s_data, s_bar_data, title_text, y_label, l, rgb, rgb2)
    figure(fig_num);
    
    % Error surface
    x = th_hist;
    y = e_bar_data; % sampled
    S1 = plot(x, y, '--','Color',rgb,'LineWidth',l); hold on;
    y = e_data; % nominal
    S2 = plot(x, y,'-','Color',rgb,'LineWidth',l);

    % Zero line
    plot(th_hist, zeros(size(th_hist)), 'k--', 'LineWidth', 1);

    % +1 sigma surface
    y = s_bar_data; % sampled
    S3 = plot(x, y,'--', 'Color',rgb2,'LineWidth',l);
    y = s_data; % nominal
    S4 = plot(x, y,'-','Color',rgb2,'LineWidth',l);

    % -1 sigma surface
    y = -s_bar_data; % sampled
    plot(x, y, '--', 'Color',rgb2,'LineWidth',l);
    y = -s_data; % nominal
    plot(x, y,'-','Color',rgb2,'LineWidth',l);

    xlim(t_bounds);
    legend([S1, S3, S2, S4], '$\bar{e}$', '$\sqrt{\bar{P}}$', ...
        '$e_i$', '$\sqrt{P_{ii}}$','Interpreter', 'latex', ...
        'Location', 'best');
    title(title_text, 'Interpreter', 'latex');
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');
end