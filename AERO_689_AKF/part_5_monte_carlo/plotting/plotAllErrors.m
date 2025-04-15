function plotAllErrors(sim_data, m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Time History data

l = 1.5;                % linewidth
rgb2 = [0.0 0.0 0.0];   % line colors
rgb = [0.2 0.5 0.9]; 

for k=1:8
    for i=1:m
    
    % pull data
    e_hist = [sim_data{i}.e_hist];
    S_hist = [sim_data{i}.SP_hist];
    th_hist = [sim_data{i}.th_hist];
    t_bounds = [0 inf];
    
    titles = {"$r_x$ Error", "$r_y$ Error", ...
              "$v_x$ Error", "$v_y$ Error", ...
              "$\Delta h$ Error", "$\Delta \beta$ Error", ...
              "$\Delta \rho_0$ Error", "$\Delta k_p$ Error"};
    
    labels = {"$r$ (m)", "$r$ (m)", "$v$ (m/s)", "$v$ (m/s)", ...
              "$h$ (m)", "$\beta$", "$\rho$ $(kg/m^3)$", "$k_p$ (m)"};

    plotSurfaceFigure(k + 4, t_bounds, th_hist, e_hist(k,:), ...
                     S_hist(k,:), titles{k}, labels{k}, l, rgb, rgb2);
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Surface plotting block

function plotSurfaceFigure(fig_num, t_bounds, th_hist, e_data, s_data, title_text, y_label, l, rgb, rgb2)
    figure(fig_num);
    
    % Error surface
    x = th_hist;
    y = e_data;
    z = zeros(size(x));
    S1 = surface([x;x], [y;y], [z;z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.1, 'edgecolor', rgb); hold on;

    % Zero line
    plot(th_hist, zeros(size(th_hist)), 'k--', 'LineWidth', l);

    % +1 sigma surface
    y = s_data;
    S2 = surface([x;x], [y;y], [z;z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.1, 'edgecolor', rgb2); hold on;

    % -1 sigma surface
    y = -s_data;
    surface([x;x], [y;y], [z;z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.1, 'edgecolor', rgb2); hold on;

    xlim(t_bounds);
    legend([S1, S2], '$e$', '$1 \sigma$', 'Interpreter', 'latex', 'Location', 'best');
    title(title_text, 'Interpreter', 'latex');
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');
end
