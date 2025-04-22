function plotSensitivity(error_table)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Sensitivity Analysis

% parameter to adjust entry magnitudes
alpha = linspace(0,10, 100);

% plot settings
names = {'$r_x$','$r_y$','$v_x$','$v_y$',...
    '$\Delta h$', '$\Delta \beta$', '$\Delta \rho_0$', '$\Delta k_p$', ...
    '$Q_x$', '$Q_y$', 'R'};
l = 1.5; % linewidth

colors = [
    0.000, 0.450, 0.700;   % Blue
    0.800, 0.475, 0.655;   % Pink
    0.350, 0.700, 0.900;   % Sky Blue
    0.900, 0.600, 0.000;   % Orange
    0.000, 0.600, 0.500;   % Teal
    0.800, 0.600, 0.700;   % Light Purple
    0.950, 0.900, 0.250;   % Yellow
    0.000, 0.000, 0.000;   % Black
    0.600, 0.600, 0.600;   % Gray
    0.400, 0.400, 0.400;   % Dark Gray
    0.200, 0.800, 0.200    % Green
];

% loop throw every state
for j = 1:width(error_table)
    figure;
    % loop through ever error category
    for i = 1:(height(error_table) - 1)
        
        % get error category entry multiplied by alpha
        e_ij = (alpha*error_table(i,j));

        % get how p(i) changes with (alpha*e(i,j))
        p_i = (error_table(end,j)^2 - error_table(i,j)^2 + e_ij.^2).^.5;

        % plot the sensitvity plot for the current error category
        plot(alpha, p_i, 'DisplayName',names{i},...
            'Color', colors(i,:), 'LineWidth', l);
        xlabel('$\alpha$', Interpreter='latex'); hold on;
        ylabel(['$\sqrt{P_' num2str(j) '}$'], Interpreter='latex')
        title(['Sensitivity - ' names{j}], Interpreter='latex');
        legend(Interpreter="latex", Location='best');
    end
end
end