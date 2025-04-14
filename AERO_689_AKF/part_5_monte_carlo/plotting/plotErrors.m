function plotErrors(sim_data, m)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse time history data

l = 1.5;                % linewidth
rgb = [0.0 0.0 0.0];   % line colors
rgb2 = [0.2 0.2 0.2];   % line colors

for i=1:m

% pull time data
t_hist = [sim_data{i}.state_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [sim_data{i}.state_hist.x];

% pull ekf data
xprior_hist = [sim_data{i}.estimate_hist.x_prior];
xpost_hist = [sim_data{i}.estimate_hist.x_post];
Pprior_hist = [sim_data{i}.estimate_hist.P_prior];
Ppost_hist = [sim_data{i}.estimate_hist.P_post];

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

% pull time data
t_hist = [sim_data{i}.state_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [sim_data{i}.state_hist.x];

% pull ekf data
xprior_hist = [sim_data{i}.estimate_hist.x_prior];
xpost_hist = [sim_data{i}.estimate_hist.x_post];
Pprior_hist = [sim_data{i}.estimate_hist.P_prior];
Ppost_hist = [sim_data{i}.estimate_hist.P_post];

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
% PLOT r_y
plotSurfaceFigure(6, t_bounds, th_hist, e_hist(2,:), S_hist(2,:), ...
    "$r_y$ Error", "$r$ (m)", l, rgb, rgb2);
end

for i=1:m

% pull time data
t_hist = [sim_data{i}.state_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [sim_data{i}.state_hist.x];

% pull ekf data
xprior_hist = [sim_data{i}.estimate_hist.x_prior];
xpost_hist = [sim_data{i}.estimate_hist.x_post];
Pprior_hist = [sim_data{i}.estimate_hist.P_prior];
Ppost_hist = [sim_data{i}.estimate_hist.P_post];

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
% PLOT v_x
plotSurfaceFigure(7, t_bounds, th_hist, e_hist(3,:), S_hist(3,:), ...
    "$v_x$ Error", "$v$ (m/s)", l, rgb, rgb2);
end
for i=1:m

% pull time data
t_hist = [sim_data{i}.state_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [sim_data{i}.state_hist.x];

% pull ekf data
xprior_hist = [sim_data{i}.estimate_hist.x_prior];
xpost_hist = [sim_data{i}.estimate_hist.x_post];
Pprior_hist = [sim_data{i}.estimate_hist.P_prior];
Ppost_hist = [sim_data{i}.estimate_hist.P_post];

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
% PLOT v_y
plotSurfaceFigure(8, t_bounds, th_hist, e_hist(4,:), S_hist(4,:), ...
    "$v_y$ Error", "$v$ (m/s)", l, rgb, rgb2);
end
for i=1:m

% pull time data
t_hist = [sim_data{i}.state_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [sim_data{i}.state_hist.x];

% pull ekf data
xprior_hist = [sim_data{i}.estimate_hist.x_prior];
xpost_hist = [sim_data{i}.estimate_hist.x_post];
Pprior_hist = [sim_data{i}.estimate_hist.P_prior];
Ppost_hist = [sim_data{i}.estimate_hist.P_post];

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
% PLOT delta h
plotSurfaceFigure(9, t_bounds, th_hist, e_hist(5,:), S_hist(5,:), ...
    "$\Delta h$ Error", "$h$ (m)", l, rgb, rgb2);
end
for i=1:m

% pull time data
t_hist = [sim_data{i}.state_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [sim_data{i}.state_hist.x];

% pull ekf data
xprior_hist = [sim_data{i}.estimate_hist.x_prior];
xpost_hist = [sim_data{i}.estimate_hist.x_post];
Pprior_hist = [sim_data{i}.estimate_hist.P_prior];
Ppost_hist = [sim_data{i}.estimate_hist.P_post];

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
% PLOT delta beta
plotSurfaceFigure(10, t_bounds, th_hist, e_hist(6,:), S_hist(6,:), ...
    "$\Delta \beta$ Error", "$\beta$", l, rgb, rgb2);
end
for i=1:m

% pull time data
t_hist = [sim_data{i}.state_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [sim_data{i}.state_hist.x];

% pull ekf data
xprior_hist = [sim_data{i}.estimate_hist.x_prior];
xpost_hist = [sim_data{i}.estimate_hist.x_post];
Pprior_hist = [sim_data{i}.estimate_hist.P_prior];
Ppost_hist = [sim_data{i}.estimate_hist.P_post];

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
% PLOT delta rho0
plotSurfaceFigure(11, t_bounds, th_hist, e_hist(7,:), S_hist(7,:), ...
    "$\Delta \rho_0$ Error", "$\rho$ $(kg/m^3)$", l, rgb, rgb2);
end
for i=1:m

% pull time data
t_hist = [sim_data{i}.state_hist.t];

% t-axis bounds for plots
t_bounds = [t_hist(1) t_hist(end)];

% pull evironment data
x_hist = [sim_data{i}.state_hist.x];

% pull ekf data
xprior_hist = [sim_data{i}.estimate_hist.x_prior];
xpost_hist = [sim_data{i}.estimate_hist.x_post];
Pprior_hist = [sim_data{i}.estimate_hist.P_prior];
Ppost_hist = [sim_data{i}.estimate_hist.P_post];

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
% PLOT delta k_p
plotSurfaceFigure(12, t_bounds, th_hist, e_hist(8,:), S_hist(8,:), ...
    "$\Delta k_p$ Error", "$k_p$ (m)", l, rgb, rgb2);

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
