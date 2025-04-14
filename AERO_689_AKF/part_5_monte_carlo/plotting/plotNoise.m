function plotNoise(inp, sim_data, m)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse time history data

l = 1.5;                % linewidth
rgb2 = [0.0 0.0 0.0];
rgb = [0.2 0.5 0.9]; 

for i = 1:m
    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    tk_hist = [sim_data{i}.measurement_hist.t];
    
    % Time-axis bounds for plots
    t_bounds = [t_hist(1) inf];
    
    % Pull environment data
    w_hist = [sim_data{i}.state_hist.w];
    Q_hist = [sim_data{i}.state_hist.Q];
    y_hist = [sim_data{i}.measurement_hist.y];
    v_hist = [sim_data{i}.measurement_hist.v];
    
    %% Process State Data
    % Get process noise standard deviations
    S_hist = [sqrt(Q_hist(1,1));
              sqrt(Q_hist(2,2));
              sqrt(Q_hist(3,3));
              sqrt(Q_hist(4,4));
              sqrt(Q_hist(5,5));
              sqrt(Q_hist(6,6));
              sqrt(Q_hist(7,7));
              sqrt(Q_hist(8,8))];
    
    for j = 1:(length(t_hist) - 1)
        S = [sqrt(Q_hist(1, 1 + j*8));
             sqrt(Q_hist(2, 2 + j*8));
             sqrt(Q_hist(3, 3 + j*8));
             sqrt(Q_hist(4, 4 + j*8));
             sqrt(Q_hist(5, 5 + j*8));
             sqrt(Q_hist(6, 6 + j*8));
             sqrt(Q_hist(7, 7 + j*8));
             sqrt(Q_hist(8, 8 + j*8))];
        
        S_hist = [S_hist S];
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% Plot Noise & Measurement Data
    
    % PLOT process noise 1
    plotSurfaceFigure(1, t_bounds, t_hist, w_hist(3,:), S_hist(3,:), ...
    "$w_x$", "$w$ $(m/s^2)$", l, rgb, rgb2);
end

for i = 1:m
    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    tk_hist = [sim_data{i}.measurement_hist.t];
    
    % Time-axis bounds for plots
    t_bounds = [t_hist(1) inf];
    
    % Pull environment data
    w_hist = [sim_data{i}.state_hist.w];
    Q_hist = [sim_data{i}.state_hist.Q];
    y_hist = [sim_data{i}.measurement_hist.y];
    v_hist = [sim_data{i}.measurement_hist.v];
    
    %% Process State Data
    % Get process noise standard deviations
    S_hist = [sqrt(Q_hist(1,1));
              sqrt(Q_hist(2,2));
              sqrt(Q_hist(3,3));
              sqrt(Q_hist(4,4));
              sqrt(Q_hist(5,5));
              sqrt(Q_hist(6,6));
              sqrt(Q_hist(7,7));
              sqrt(Q_hist(8,8))];
    
    for j = 1:(length(t_hist) - 1)
        S = [sqrt(Q_hist(1, 1 + j*8));
             sqrt(Q_hist(2, 2 + j*8));
             sqrt(Q_hist(3, 3 + j*8));
             sqrt(Q_hist(4, 4 + j*8));
             sqrt(Q_hist(5, 5 + j*8));
             sqrt(Q_hist(6, 6 + j*8));
             sqrt(Q_hist(7, 7 + j*8));
             sqrt(Q_hist(8, 8 + j*8))];
        
        S_hist = [S_hist S];
    end

    % PLOT process noise 2
    figure(2); 
    plotSurfaceFigure(2, t_bounds, t_hist, w_hist(3,:), S_hist(4,:), ...
    "$w_y$", "$w$ $(m/s^2)$", l, rgb, rgb2);
end

for i = 1:m
    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    tk_hist = [sim_data{i}.measurement_hist.t];
    
    % Time-axis bounds for plots
    t_bounds = [t_hist(1) inf];
    
    % Pull environment data
    w_hist = [sim_data{i}.state_hist.w];
    Q_hist = [sim_data{i}.state_hist.Q];
    y_hist = [sim_data{i}.measurement_hist.y];
    v_hist = [sim_data{i}.measurement_hist.v];
    
    %% Process State Data
    % Get process noise standard deviations
    S_hist = [sqrt(Q_hist(1,1));
              sqrt(Q_hist(2,2));
              sqrt(Q_hist(3,3));
              sqrt(Q_hist(4,4));
              sqrt(Q_hist(5,5));
              sqrt(Q_hist(6,6));
              sqrt(Q_hist(7,7));
              sqrt(Q_hist(8,8))];
    
    for j = 1:(length(t_hist) - 1)
        S = [sqrt(Q_hist(1, 1 + j*8));
             sqrt(Q_hist(2, 2 + j*8));
             sqrt(Q_hist(3, 3 + j*8));
             sqrt(Q_hist(4, 4 + j*8));
             sqrt(Q_hist(5, 5 + j*8));
             sqrt(Q_hist(6, 6 + j*8));
             sqrt(Q_hist(7, 7 + j*8));
             sqrt(Q_hist(8, 8 + j*8))];
        
        S_hist = [S_hist S];
    end

    % PLOT measurement noise
    figure(3); 
    x = tk_hist;
    y = v_hist;
    z = zeros(size(x));
    S3 = scatter3(x, y, z, 50, rgb, 'filled', 'MarkerFaceAlpha', 0.2); hold on;
    S4 = plot(tk_hist, sqrt(inp.R)*ones(length(tk_hist), 1), 'k-', 'LineWidth', l);
    plot(tk_hist, -sqrt(inp.R)*ones(length(tk_hist), 1), 'k-', 'LineWidth', l);
    xlim(t_bounds);
    title("$v_k$", 'Interpreter', 'latex'); 
    xlabel("$t$ (s)", 'Interpreter', 'latex'); 
    ylabel("$v$ (m)", 'Interpreter', 'latex');
    legend([S3, S4], '$v$', '$1 \sigma$', 'Interpreter', 'latex', 'Location', 'best');

    view([0, 90]);  % Azimuth 0 and Elevation 90 degrees for top-down view
    axis vis3d;      % Lock the axis to keep the same aspect ratio
    axis normal;    % Use normal scaling without forcing equal scaling on all axes
    axis tight;     % Tight fitting of axes, not locked to a square
end

for i = 1:m
    % Pull time data
    t_hist = [sim_data{i}.state_hist.t];
    tk_hist = [sim_data{i}.measurement_hist.t];
    
    % Time-axis bounds for plots
    t_bounds = [t_hist(1) t_hist(end)];
    
    % Pull environment data
    w_hist = [sim_data{i}.state_hist.w];
    Q_hist = [sim_data{i}.state_hist.Q];
    y_hist = [sim_data{i}.measurement_hist.y];
    v_hist = [sim_data{i}.measurement_hist.v];
    
    %% Process State Data
    % Get process noise standard deviations
    S_hist = [sqrt(Q_hist(1,1));
              sqrt(Q_hist(2,2));
              sqrt(Q_hist(3,3));
              sqrt(Q_hist(4,4));
              sqrt(Q_hist(5,5));
              sqrt(Q_hist(6,6));
              sqrt(Q_hist(7,7));
              sqrt(Q_hist(8,8))];
    
    for j = 1:(length(t_hist) - 1)
        S = [sqrt(Q_hist(1, 1 + j*8));
             sqrt(Q_hist(2, 2 + j*8));
             sqrt(Q_hist(3, 3 + j*8));
             sqrt(Q_hist(4, 4 + j*8));
             sqrt(Q_hist(5, 5 + j*8));
             sqrt(Q_hist(6, 6 + j*8));
             sqrt(Q_hist(7, 7 + j*8));
             sqrt(Q_hist(8, 8 + j*8))];
        
        S_hist = [S_hist S];
    end

    % PLOT range
    figure(4); 
    x = tk_hist;
    y = y_hist(1,:);
    z = zeros(size(x));
    S5 = scatter3(x, y, z, 50, rgb, 'filled', 'MarkerFaceAlpha', 0.2); hold on;
    xlim(t_bounds);
    title("$r_k$", 'Interpreter', 'latex'); 
    xlabel("$t$ (s)", 'Interpreter', 'latex'); 
    ylabel("$r$ (m)", 'Interpreter', 'latex');
    legend([S5], '$r$', 'Interpreter', 'latex', 'Location', 'best');

    view([0, 90]);  % Azimuth 0 and Elevation 90 degrees for top-down view
    axis vis3d;      % Lock the axis to keep the same aspect ratio
    axis normal;    % Use normal scaling without forcing equal scaling on all axes
    axis tight;     % Tight fitting of axes, not locked to a square
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
        'linew', l, 'edgealpha', 0.01, 'edgecolor', rgb); hold on;

    % Zero line
    plot(th_hist, zeros(size(th_hist)), 'k--', 'LineWidth', l);

    % +1 sigma surface
    y = s_data;
    S2 = surface([x;x], [y;y], [z;z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.01, 'edgecolor', rgb2); hold on;

    % -1 sigma surface
    y = -s_data;
    S3 = surface([x;x], [y;y], [z;z], ...
        'facecol', 'no', 'edgecol', 'interp', ...
        'linew', l, 'edgealpha', 0.01, 'edgecolor', rgb2); hold on;

    xlim(t_bounds);
    legend([S1, S2], '$e$', '$1 \sigma$', 'Interpreter', 'latex', 'Location', 'best');
    title(title_text, 'Interpreter', 'latex');
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');
end