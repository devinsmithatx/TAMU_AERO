%% plotAllNoise.m

function plotAllNoise(sim_data, m)
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
titles = {"Process Noise - $w_x$", " Process Noise - $w_y$"};
labels = {"$w$ $(m/s^2)$", "$w$ $(m/s^2)$"};

% loop through each plot and monte carlo sims
for k = 1:4
    for i = 1:m

        % pull data
        w_hist = [sim_data{i}.state_hist.w];
        t_hist = [sim_data{i}.state_hist.t];
        S_hist = [sim_data{i}.SQ_hist];
        y_hist = [sim_data{i}.measurement_hist.y];
        v_hist = [sim_data{i}.measurement_hist.v];
        R_hist = [sim_data{i}.measurement_hist.R];
        tk_hist = [sim_data{i}.measurement_hist.t];
        t_bounds = [0 inf];

        if k == 1 || k == 2
            plotFigure(n + k, t_bounds, t_hist, w_hist(k+2,:),...
                S_hist(k+2,:), titles{k}, labels{k},  l, rgb, rgb2);
        elseif k==3
            % PLOT measurement noise
            figure(n + 3); 
            x = tk_hist;
            y = v_hist;

            S3 = scatter(x, y, 'o', 'MarkerEdgeColor',rgb(1:3),...
                    'MarkerEdgeAlpha', rgb(4), 'LineWidth',l); hold on;
            S4 = plot(tk_hist, R_hist.^.5, 'Color', rgb2, 'LineWidth', l);
            plot(tk_hist, -R_hist.^.5, 'Color', rgb2, 'LineWidth', l);

            xlim(t_bounds);
            title("Measurement Noise - $v_k$", 'Interpreter', 'latex'); 
            xlabel("$t$ (s)", 'Interpreter', 'latex'); 
            ylabel("$v$ (m)", 'Interpreter', 'latex');
            legend([S3, S4], '$v_i$', '$1 \sigma_i$', 'Interpreter', 'latex', 'Location', 'best');
        else
            % PLOT range
            figure(n + 4); 
            x = tk_hist;
            y = y_hist(1,:);

            S5 = scatter(x, y, 'o', 'MarkerEdgeColor',rgb(1:3),...
                 'MarkerEdgeAlpha', rgb(4), 'LineWidth',l); hold on;

            xlim(t_bounds);
            title("Measurement - $r_k$", 'Interpreter', 'latex'); 
            xlabel("$t$ (s)", 'Interpreter', 'latex'); 
            ylabel("$r$ (m)", 'Interpreter', 'latex');
            legend(S5, '$r_i$', 'Interpreter', 'latex', 'Location', 'best');
        end
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Surface plotting block

function plotFigure(fig_num, t_bounds, th_hist, e_data, s_data, title_text, y_label, l, rgb, rgb2)
    figure(fig_num);
    
    % x
    x = th_hist;

    % noise plot
    y = e_data;
    S1 = plot(x,y, 'Color',rgb, 'LineWidth',l); hold on;

    % zero line
    plot(th_hist, zeros(size(th_hist)), 'k--', 'LineWidth', 1);

    % +1 sigma plot
    y = s_data;
    S2 = plot(x,y,'Color',rgb2, 'LineWidth',l); hold on;

    % -1 sigma surface
    y = -s_data;
    plot(x,y,'Color',rgb2, 'LineWidth',l); hold on;
    
    % graph settings
    xlim(t_bounds);
    legend([S1, S2], '$w_i$', '$1 \sigma_i$', 'Interpreter', ...
           'latex', 'Location', 'best');
    title(title_text, 'Interpreter', 'latex');
    xlabel('$t$ (s)', 'Interpreter', 'latex');
    ylabel(y_label, 'Interpreter', 'latex');
end