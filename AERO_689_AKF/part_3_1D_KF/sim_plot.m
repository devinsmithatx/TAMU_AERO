function sim_plot(inp, state_hist, measurement_hist, estimate_hist)
% plots the data from the simulation

% pull evironment data
r_hist = [state_hist.r];
v_hist = [state_hist.v];
t_hist = [state_hist.t];
w_hist = [state_hist.w];
nu_hist = [measurement_hist.nu];
y_hist = [measurement_hist.y];
tk_hist = [measurement_hist.t];

% pull kalman filter data
x_min_hist = [estimate_hist.x_min];
x_plus_hist = [estimate_hist.x_plus];
P_min_hist = [estimate_hist.P_min];
P_plus_hist = [estimate_hist.P_plus];
K_hist = [estimate_hist.K];

% get the true states at each measurement
xk = [r_hist(:,1); v_hist(:,1)];
xk_hist = xk;
for i = 2:length(tk_hist)
    ik = find(t_hist==tk_hist(i));
    xk = [r_hist(:,ik); v_hist(:,ik)];
    xk_hist = [xk_hist xk];
end

% get the estimate errors
eh_min_hist = x_min_hist - xk_hist;
eh_plus_hist = x_plus_hist - xk_hist;

% get the covariance standard deviations
std_hist_min = [sqrt(P_min_hist(2,2)); sqrt(P_min_hist(4,4))];
std_hist_plus = [sqrt(P_plus_hist(2,2)); sqrt(P_plus_hist(4,4))];
for i = 1:(length(tk_hist) - 1)
    std = [sqrt(P_min_hist(2,2 + i*4)); sqrt(P_min_hist(4,4 + i*4))];
    std_hist_min = [std_hist_min std];
    
    std = [sqrt(P_plus_hist(2,2 + i*4)); sqrt(P_plus_hist(4,4 + i*4))];
    std_hist_plus = [std_hist_plus std];
end

% zip together the apriori and aposteriori measurements
eh_hist = zeros(4,length(tk_hist)*2);
std_hist = zeros(2,length(tk_hist)*2);
xh_hist = zeros(4,length(tk_hist)*2);
tk_hist2 = zeros(1,length(tk_hist)*2);
for i = 1:length(tk_hist)
    eh_hist(:,2*i - 1) = eh_min_hist(:,i);
    eh_hist(:,2*i) = eh_plus_hist(:,i);
    std_hist(:,2*i - 1) = std_hist_min(:,i);
    std_hist(:,2*i) = std_hist_plus(:,i);
    xh_hist(:,2*i - 1) = x_min_hist(:,i);
    xh_hist(:,2*i) = x_plus_hist(:,i);
    tk_hist2(:,2*i - 1) = tk_hist(:,i);
    tk_hist2(:,2*i) = tk_hist(:,i);
end

% plot the environment data
tmin = t_hist(1); tmax = t_hist(end);

figure; plot(t_hist,r_hist(2,:)); xlim([tmin, tmax]);
title("Environment - True Position"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r_y$ (m)", Interpreter="latex");

figure; plot(t_hist,v_hist(2,:)); xlim([tmin, tmax]);
title("Environment - True Velocity");
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$v_y$ (m)", Interpreter="latex");

figure; hold on; xlim([tmin, tmax]);
plot(t_hist,w_hist(4,:)); hold on;
plot(t_hist, t_hist*0, 'k');
plot(t_hist, ones(length(t_hist),1)*inp.Qs(4,4), '--k');
plot(t_hist, -ones(length(t_hist),1)*inp.Qs(4,4), '--k');
title("Environment - Process Noise"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\omega$ ($m/s^2$)", Interpreter="latex");

figure; plot(tk_hist,y_hist, 'x'); xlim([tmin, tmax]);
title("Environment - Range Measurements"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$y$ (m)", Interpreter="latex");

figure; hold on; xlim([tmin, tmax]);
plot(tk_hist,nu_hist, 'x'); hold on;
plot(t_hist, t_hist*0, 'k');
plot(t_hist, ones(length(t_hist),1)*sqrt(inp.R), '--k');
plot(t_hist, -ones(length(t_hist),1)*sqrt(inp.R), '--k');
title("Environment - Measurement Noise");
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\nu$ (m)", Interpreter="latex")

% plot the kalman filter data
yh_hist = xh_hist(2,:) + inp.h*ones(1,length(tk_hist2));
figure; plot(tk_hist2,yh_hist); xlim([tmin, tmax]);
title("Kalman Filter - Estimate Range"); 
ylabel("$\hat{y}$ (m)", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter='latex');

figure; xlim([tmin, tmax]); hold on;
plot(tk_hist2, eh_hist(2,:));
plot(tk_hist2, tk_hist2*0, 'k');
plot(tk_hist2, std_hist(1,:), 'k');
plot(tk_hist2, -std_hist(1,:), 'k');
title("Kalman Filter - Estimate Position Error"); 
ylabel("$\hat{e}_{r_y}$ (m)", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter='latex');

figure; xlim([tmin, tmax]); hold on;
plot(tk_hist2, eh_hist(4,:));
plot(tk_hist2, tk_hist2*0, 'k');
plot(tk_hist2, std_hist(1,:), 'k');
plot(tk_hist2, -std_hist(1,:), 'k');
title("Kalman Filter - Estimate Velocity Error"); 
ylabel("$\hat{e}_{v_y}$ (m)", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter='latex');


end

