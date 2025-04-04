function plotNoise(inp, state_hist, measurement_hist)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse time history data

% pull time data
t_hist = [state_hist.t];
tk_hist = [measurement_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
w_hist = [state_hist.w];
Q_hist = [state_hist.Q];
y_hist = [measurement_hist.y];
v_hist = [measurement_hist.v];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process State Data

% get process noise standard deviations
S_hist = [sqrt(Q_hist(1,1));
          sqrt(Q_hist(2,2));
          sqrt(Q_hist(3,3));
          sqrt(Q_hist(4,4));
          sqrt(Q_hist(5,5));
          sqrt(Q_hist(6,6));
          sqrt(Q_hist(7,7));
          sqrt(Q_hist(8,8));];

for i = 1:(length(t_hist) - 1)
    S = [sqrt(Q_hist(1,1 + i*8));
         sqrt(Q_hist(2,2 + i*8));
         sqrt(Q_hist(3,3 + i*8));
         sqrt(Q_hist(4,4 + i*8));
         sqrt(Q_hist(5,5 + i*8));
         sqrt(Q_hist(6,6 + i*8));
         sqrt(Q_hist(7,7 + i*8));
         sqrt(Q_hist(8,8 + i*8));];

        S_hist = [S_hist S];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Noise & Measurement Data

% PLOT process noise 1
figure; 
line1 = plot(t_hist, w_hist(3,:),'b', DisplayName="$\omega$"); hold on;
plot(t_hist, 0*t_hist, 'k-');
line2 = plot(t_hist, S_hist(3,:), 'k--', DisplayName="$\sigma$");
plot(t_hist, -S_hist(3,:),'k--');
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best");
title("$\omega_x$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\omega$ $(m/s^2)$", Interpreter="latex");

% PLOT process noise 2
figure; 
line1 = plot(t_hist, w_hist(4,:), 'b', DisplayName="$\omega$"); hold on;
plot(t_hist, 0*t_hist, 'k-');
line2 = plot(t_hist, S_hist(4,:), 'k--', DisplayName="$\sigma$");
plot(t_hist, -S_hist(3,:),'k--');
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$\omega_y$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\omega$ $(m/s^2)$", Interpreter="latex");

% PLOT measurement noise
figure; 
line1 = plot(tk_hist, v_hist, 'bx', DisplayName="$\nu$"); hold on;
plot(tk_hist, 0*tk_hist, 'k-');
line2 = plot(tk_hist, sqrt(inp.R)*ones(length(tk_hist),1), 'k--', DisplayName="$\sigma$");
plot(tk_hist, -sqrt(inp.R)*ones(length(tk_hist),1),'k--');
xlim(t_bounds);
legend([line1 line2], Interpreter="latex", Location="best")
title("$\nu_k$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$\nu$ (m)", Interpreter="latex");

% PLOT range
figure; plot(tk_hist, y_hist(1,:), 'bx'); xlim(t_bounds);
title("$r_k$", Interpreter="latex"); 
xlabel("$t$ (s)", Interpreter="latex"); 
ylabel("$r$ (m)", Interpreter="latex");


end

