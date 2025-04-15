function plotSampledEKF(sim_data, sample_data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Time History data

l = 1.5;                % linewidth
rgb2 = [0.0 0.0 0.0];   % line colors
rgb = [0.2 0.5 0.9]; 
rgb3 = [0.9 0.5 0.2];

% pull data from 1st run aka "nominal run"
e_hist = [sim_data{1}.e_hist];
S_hist = [sim_data{1}.SP_hist];
th_hist = [sim_data{1}.th_hist];
t_bounds = [0 inf];

% pull sample data from monte carlo averages
e_bar_hist = sample_data.e_bar_hist;
SP_bar_hist = sample_data.SP_bar_hist;

titles = {"$r_x$ Error", "$r_y$ Error", ...
          "$v_x$ Error", "$v_y$ Error", ...
          "$\Delta h$ Error", "$\Delta \beta$ Error", ...
          "$\Delta \rho_0$ Error", "$\Delta k_p$ Error"};
    
labels = {"$r$ (m)", "$r$ (m)", "$v$ (m/s)", "$v$ (m/s)", ...
          "$h$ (m)", "$\beta$", "$\rho$ $(kg/m^3)$", "$k_p$ (m)"};

for k = 1:8
    plotData(20 + k, t_bounds, th_hist, e_hist(k,:), e_bar_hist(k,:),...
             S_hist(k,:), SP_bar_hist(k,:), titles{k}, labels{k}, l, rgb, rgb2, rgb3);

end

end

function plotData(fig_num, t_bounds, th_hist, e_data, e_bar_data, s_data, s_bar_data, title_text, y_label, l, rgb, rgb2, rgb3)
    figure(fig_num);
    
    % Error surface
    x = th_hist;
    y = e_bar_data;
    S1 = plot(x, y, '--','Color',rgb3); hold on;

    y = e_data;
    S2 = plot(x, y,'--','Color',rgb);

    % Zero line
    plot(th_hist, zeros(size(th_hist)), 'k--', 'LineWidth', l);

    % +1 sigma surface
    y = s_data;
    S3 = plot(x, y, 'Color',rgb2);

    y = s_bar_data;
    S4 = plot(x, y,'Color',rgb3);

    % -1 sigma surface
    y = -s_data;
    plot(x, y, 'Color',rgb2);

    y = -s_bar_data;
    plot(x, y,'Color',rgb3);

    xlim(t_bounds);
    legend([S1, S2, S3, S4], '$e$', '$\bar{e}$', '$1 \sigma$', '$1 \bar{\sigma}$','Interpreter', 'latex', 'Location', 'best');
    title(title_text, 'Interpreter', 'latex');
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');
end