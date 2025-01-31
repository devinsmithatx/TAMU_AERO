function SDR_plot_sim(output)
% PLOT_SIM PLOTS THE STATES AND CONTROLS FROM THE SIM
% PULL OUTPUT
t = output.t;
y = output.y*180/pi;
u = output.u*180/pi;
ny = height(y);
nu = height(u);

% DEFINE PLOT TITLES
states = {'$\beta$', '$p$','$r$','$\phi$'};
controls = {'$\delta_A$', '$\delta_R$'};

% PLOT STATES AND CONTROL USAGE
figure(); clf;
tiledlayout(ny - nu,1, 'Padding', 'none', 'TileSpacing', 'compact');
for i = 1:ny - nu
    nexttile; 
    plot(t,y(i,:),'b','linewidth',1); hold on
    plot(t,0*ones(1,length(t)),'k--','linewidth',1)
    title(states(i), Interpreter="latex");  
    xlabel("t (s)");
    if ismember(i, [1,4,5])
        ylabel("Angle (deg)");
    else
        ylabel('Angle Rate (deg/s)')
    end
end

figure(); clf;
tiledlayout(nu,1, 'Padding', 'none', 'TileSpacing', 'compact');
for i = 1:nu
    nexttile; 
    stairs(t,u(i,:),'b','linewidth',1); hold on;
    plot(t,y(i + ny - nu,:),'r','linewidth',1);
    plot(t,0*ones(1,length(t)),'k--','linewidth',1)
    title(controls(i), Interpreter="latex");  
    xlabel("t (s)"); 
    ylabel("Angle (deg)");
end
end
