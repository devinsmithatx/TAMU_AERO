function plotErrors(state_hist, measurement_hist, estimate_hist)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse time history data

% pull time data
t_hist = [state_hist.t];
tk_hist = [measurement_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [state_hist.x];

% pull ekf data
xprior_hist = [estimate_hist.x_prior];
xpost_hist = [estimate_hist.x_post];
Pprior_hist = [estimate_hist.P_prior];
Ppost_hist = [estimate_hist.P_post];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process Estimation Data

% get the true states at each measurement
xk = x_hist(:,1);
xk_hist = xk;
for i = 2:length(tk_hist)
    ik = t_hist==tk_hist(i);
    xk = x_hist(:,ik);
    xk_hist = [xk_hist xk];
end

% get the estimate errors
eprior_hist = xk_hist - xprior_hist;
epost_hist = xk_hist - xpost_hist;

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

for i = 1:(length(tk_hist) - 1)
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
e_hist = zeros(8,length(tk_hist)*2);
S_hist = zeros(8,length(tk_hist)*2);
th_hist = zeros(1,length(tk_hist)*2);
for i = 1:length(tk_hist)
    e_hist(:,2*i - 1) = eprior_hist(:,i);
    e_hist(:,2*i) = epost_hist(:,i);
    S_hist(:,2*i - 1) = Sprior_hist(:,i);
    S_hist(:,2*i) = Spost_hist(:,i);
    th_hist(:,2*i - 1) = tk_hist(:,i);
    th_hist(:,2*i) = tk_hist(:,i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Error Data

figure; plot(th_hist, e_hist(1,:)); xlim(t_bounds); hold on;
plot(th_hist, th_hist*0, 'k--');
plot(th_hist, S_hist(1,:), 'k');
plot(th_hist, -S_hist(1,:), 'k');
title("$r_x$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

figure; plot(th_hist, e_hist(2,:)); xlim(t_bounds); hold on;
plot(th_hist, th_hist*0, 'k--');
plot(th_hist, S_hist(2,:), 'k');
plot(th_hist, -S_hist(2,:), 'k');
title("$r_y$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");

figure; plot(th_hist, e_hist(3,:)); xlim(t_bounds); hold on;
plot(th_hist, th_hist*0, 'k--');
plot(th_hist, S_hist(3,:), 'k');
plot(th_hist, -S_hist(3,:), 'k');
title("$v_x$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

figure; plot(th_hist, e_hist(4,:)); xlim(t_bounds); hold on;
plot(th_hist, th_hist*0, 'k--');
plot(th_hist, S_hist(4,:), 'k');
plot(th_hist, -S_hist(4,:), 'k');
title("$v_y$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v$ (m/s)", Interpreter="latex");

figure; plot(th_hist, e_hist(5,:)); xlim(t_bounds); hold on;
plot(th_hist, th_hist*0, 'k--');
plot(th_hist, S_hist(5,:), 'k');
plot(th_hist, -S_hist(5,:), 'k');
title("$\Delta h$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$h$ (m)", Interpreter="latex");

figure; plot(th_hist, e_hist(6,:)); xlim(t_bounds); hold on;
plot(th_hist, th_hist*0, 'k--');
plot(th_hist, S_hist(6,:), 'k');
plot(th_hist, -S_hist(6,:), 'k');
title("$\Delta \rho_0$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\rho$ $(kg/m^3)$", Interpreter="latex");

figure; plot(th_hist, e_hist(7,:)); xlim(t_bounds); hold on;
plot(th_hist, th_hist*0, 'k--');
plot(th_hist, S_hist(7,:), 'k');
plot(th_hist, -S_hist(7,:), 'k');
title("$\Delta \beta$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\beta$", Interpreter="latex");

figure; plot(th_hist, e_hist(8,:)); xlim(t_bounds); hold on;
plot(th_hist, th_hist*0, 'k--');
plot(th_hist, S_hist(8,:), 'k');
plot(th_hist, -S_hist(8,:), 'k');
title("$\Delta k_p$ Error", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$k_p$ $(m^{-1})$", Interpreter="latex");
end

