function sim_plot(inp, state_hist, measurement_hist, estimate_hist)
% plots the data from the simulation

% pull stored evironment data
r_hist = [state_hist.r];
v_hist = [state_hist.v];
t_hist = [state_hist.t];
w_hist = [state_hist.w];
nu_hist = [measurement_hist.nu];
y_hist = [measurement_hist.y];
tk_hist = [measurement_hist.t];

% plot the environment data
tmin = t_hist(1); tmax = t_hist(end);

figure; plot(t_hist,r_hist(2,:)); xlim([tmin, tmax]);
title("Environment - True Position"); xlabel("t (s)"); ylabel("r_y (m)");

figure; plot(t_hist,v_hist(2,:)); xlim([tmin, tmax]);
title("Environment - True Velocity"); xlabel("t (s)"); ylabel("v_y (m/s)");

figure; hold on; xlim([tmin, tmax]);
plot(t_hist,w_hist(4,:)); hold on;
plot(t_hist, t_hist*0, 'k');
plot(t_hist, ones(length(t_hist),1)*inp.Qs(4,4), '--k');
plot(t_hist, -ones(length(t_hist),1)*inp.Qs(4,4), '--k');
title("Environment - Process Noise"); xlabel("t (s)"); ylabel("w (m/s^2)");

figure; plot(tk_hist,y_hist, 'x'); xlim([tmin, tmax]);
title("Environment - Range Measurements"); xlabel("t (s)"); ylabel("y (m)");

figure; hold on; xlim([tmin, tmax]);
plot(tk_hist,nu_hist, 'x'); hold on;
plot(t_hist, t_hist*0, 'k');
plot(t_hist, ones(length(t_hist),1)*sqrt(inp.R), '--k');
plot(t_hist, -ones(length(t_hist),1)*sqrt(inp.R), '--k');
title("Environment - Measurement Noise"); xlabel("t (s)"); ylabel("nu (m)");

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
for i = 1:(length(tk_hist) - 1)
    std = [sqrt(P_min_hist(2,2 + i*4)); sqrt(P_min_hist(4,4 + i*4))];
    std_hist_min = [std_hist_min std];
end

std_hist_plus = [sqrt(P_plus_hist(2,2)); sqrt(P_plus_hist(4,4))];
for i = 1:(length(tk_hist) - 1)
    std = [sqrt(P_plus_hist(2,2 + i*4)); sqrt(P_plus_hist(4,4 + i*4))];
    std_hist_plus = [std_hist_plus std];
end

figure; xlim([tmin, tmax]); hold on;
plot(tk_hist, eh_min_hist(2,:), 'x');
plot(t_hist, t_hist*0, 'k');
plot(tk_hist, std_hist_min(1,:), '--k');
plot(tk_hist, -std_hist_min(1,:), '--k');
title("Kalman Filter - Estimate Position Error (Apriori)"); 
xlabel("t (s)"); ylabel("r_h (m)");

figure; xlim([tmin, tmax]); hold on;
plot(tk_hist, eh_plus_hist(2,:), 'x');
plot(t_hist, t_hist*0, 'k');
plot(tk_hist, std_hist_plus(1,:), '--k');
plot(tk_hist, -std_hist_plus(1,:), '--k');
title("Kalman Filter - Estimate Position Error (Aposteriori)"); 
xlabel("t (s)"); ylabel("r_h (m)");

figure; xlim([tmin, tmax]); hold on;
plot(tk_hist, eh_min_hist(4,:), 'x');
plot(t_hist, t_hist*0, 'k');
plot(tk_hist, std_hist_min(2,:), '--k');
plot(tk_hist, -std_hist_min(2,:), '--k');
title("Kalman Filter - Estimate Velocity Error (Apriori)"); 
xlabel("t (s)"); ylabel("r_h (m)");

figure; xlim([tmin, tmax]); hold on;
plot(tk_hist, eh_plus_hist(4,:), 'x');
plot(t_hist, t_hist*0, 'k');
plot(tk_hist, std_hist_plus(2,:), '--k');
plot(tk_hist, -std_hist_plus(2,:), '--k');
title("Kalman Filter - Estimate Velocity Error (Aposteriori)"); 
xlabel("t (s)"); ylabel("r_h (m)");
end

