function plotErrors(state_hist, estimate_hist)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse time history data

% pull time data
t_hist = [state_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [state_hist.x];

% pull ekf data
xprior_hist = [estimate_hist.x_prior];
xpost_hist = [estimate_hist.x_post];
Pprior_hist = [estimate_hist.P_prior];
Ppost_hist = [estimate_hist.P_post];

l = 1.5; % linewidth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process Estimation Data

% get the estimate errors
eprior_hist = x_hist - xprior_hist;
epost_hist = x_hist - xpost_hist;

% get the covariance standard deviations
Sprior_hist = [sqrt(Pprior_hist(1,1));
               sqrt(Pprior_hist(2,2));
               sqrt(Pprior_hist(3,3));
               sqrt(Pprior_hist(4,4));
               sqrt(Pprior_hist(5,5));
               sqrt(Pprior_hist(6,6));
               sqrt(Pprior_hist(7,7));
               sqrt(Pprior_hist(8,8));];
Spost_hist = [sqrt(Ppost_hist(1,1));
              sqrt(Ppost_hist(2,2));
              sqrt(Ppost_hist(3,3));
              sqrt(Ppost_hist(4,4));
              sqrt(Pprior_hist(5,5));
              sqrt(Ppost_hist(6,6));
              sqrt(Ppost_hist(7,7));
              sqrt(Ppost_hist(8,8));];

for i = 1:(length(t_hist) - 1)
    S = [sqrt(Pprior_hist(1,1 + i*8));
         sqrt(Pprior_hist(2,2 + i*8));
         sqrt(Pprior_hist(3,3 + i*8));
         sqrt(Pprior_hist(4,4 + i*8));
         sqrt(Pprior_hist(5,5 + i*8));
         sqrt(Pprior_hist(6,6 + i*8));
         sqrt(Pprior_hist(7,7 + i*8));
         sqrt(Pprior_hist(8,8 + i*8));];

    Sprior_hist = [Sprior_hist S];
    
    S = [sqrt(Ppost_hist(1,1 + i*8));
         sqrt(Ppost_hist(2,2 + i*8));
         sqrt(Ppost_hist(3,3 + i*8));
         sqrt(Ppost_hist(4,4 + i*8));
         sqrt(Ppost_hist(5,5 + i*8));
         sqrt(Ppost_hist(6,6 + i*8));
         sqrt(Ppost_hist(7,7 + i*8));
         sqrt(Ppost_hist(8,8 + i*8));];

    Spost_hist = [Spost_hist S];
end

% zip together the apriori and aposteriori measurements
e_hist = zeros(8,length(t_hist)*2);
S_hist = zeros(8,length(t_hist)*2);
th_hist = zeros(1,length(t_hist)*2);
for i = 1:length(t_hist)
    e_hist(:,2*i - 1) = eprior_hist(:,i);
    e_hist(:,2*i) = epost_hist(:,i);
    S_hist(:,2*i - 1) = Sprior_hist(:,i);
    S_hist(:,2*i) = Spost_hist(:,i);
    th_hist(:,2*i - 1) = t_hist(:,i);
    th_hist(:,2*i) = t_hist(:,i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Error Data

% PLOT r_x
figure; 
line1 = plot(th_hist, e_hist(1,:), 'b',DisplayName="$e$", LineWidth=l); hold on;
plot(th_hist, th_hist*0, 'k--', LineWidth=l);
line2 = plot(th_hist, S_hist(1,:), 'k', DisplayName="$\sigma$",LineWidth=l);
plot(th_hist, -S_hist(1,:), 'k', LineWidth=l);
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$r_x$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

% PLOT r_y
figure; 
line1 = plot(th_hist, e_hist(2,:),'b', DisplayName="$e$", LineWidth=l); hold on;
plot(th_hist, th_hist*0, 'k--', LineWidth=l);
line2 = plot(th_hist, S_hist(2,:), 'k', DisplayName="$\sigma$", LineWidth=l);
plot(th_hist, -S_hist(2,:), 'k', LineWidth=l);
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$r_y$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

% PLOT v_x
figure; 
line1 = plot(th_hist, e_hist(3,:),'b', DisplayName="$e$", LineWidth=l); hold on;
plot(th_hist, th_hist*0, 'k--', LineWidth=l);
line2 = plot(th_hist, S_hist(3,:), 'k', DisplayName="$\sigma$", LineWidth=l);
plot(th_hist, -S_hist(3,:), 'k', LineWidth=l);
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$v_x$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

% PLOT v_y
figure; 
line1 = plot(th_hist, e_hist(4,:),'b', DisplayName="$e$", LineWidth=l); hold on;
plot(th_hist, th_hist*0, 'k--', LineWidth=l);
line2 = plot(th_hist, S_hist(1,:), 'k', DisplayName="$\sigma$", LineWidth=l);
plot(th_hist, -S_hist(1,:), 'k', LineWidth=l);
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$v_y$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

% PLOT delta h
figure; 
line1 = plot(th_hist, e_hist(5,:),'b', DisplayName="$e$", LineWidth=l); hold on;
plot(th_hist, th_hist*0, 'k--', LineWidth=l);
line2 = plot(th_hist, S_hist(5,:), 'k', DisplayName="$\sigma$", LineWidth=l);
plot(th_hist, -S_hist(5,:), 'k', LineWidth=l);
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$\Delta h$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$h$ (m)", Interpreter="latex");

% PLOT delta beta
figure; 
line1 = plot(th_hist, e_hist(6,:),'b', DisplayName="$e$", LineWidth=l); hold on;
plot(th_hist, th_hist*0, 'k--', LineWidth=l);
line2 = plot(th_hist, S_hist(6,:), 'k', DisplayName="$\sigma$", LineWidth=l);
plot(th_hist, -S_hist(6,:), 'k', LineWidth=l);
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$\Delta \beta$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\beta$", Interpreter="latex");

% PLOT delta rho0
figure; 
line1 = plot(th_hist, e_hist(7,:),'b', DisplayName="$e$", LineWidth=l); hold on;
plot(th_hist, th_hist*0, 'k--', LineWidth=l);
line2 = plot(th_hist, S_hist(7,:), 'k', DisplayName="$\sigma$", LineWidth=l);
plot(th_hist, -S_hist(7,:), 'k', LineWidth=l);
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$\Delta \rho_0$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\rho$ $(kg/m^3)$", Interpreter="latex");

% PLOT delta k_p
figure; 
line1 = plot(th_hist, e_hist(8,:),'b', DisplayName="$e$", LineWidth=l); hold on;
plot(th_hist, th_hist*0, 'k--', LineWidth=l);
line2 = plot(th_hist, S_hist(8,:), 'k', DisplayName="$\sigma$", LineWidth=l);
plot(th_hist, -S_hist(8,:), 'k', LineWidth=l);
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$\Delta k_p$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$k_p$ (m)", Interpreter="latex");
end

