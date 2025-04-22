%% monteCarlo.m

function [sim_data, sample_data] = monteCarlo(inp, m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Up Monte Carlo Simulations

% set the seed
rng(inp.seed);

% find the time until it falls (keeps t_hist same for all runs)
inp.tf_stop = inf;
inp.ry_stop = 0; 
inp.tf = findTf(inp);

% set sim iteration parameters
inp.i_max = inp.tf/inp.ts;       % # of iterations total per run
inp.i_measure = inp.tm/inp.ts;   % # of iterations between t_k per run

% generate all initial error vectors
[V,S] = eig(inp.P0);
Sigma = sqrtm(S);
e0 = V*Sigma*randn(8,m);
M = cov(e0');

% apply transformation such that w_bar = 0, M = P0;
[Gamma, D] = eig(M);
Delta = sqrtm(D);
R = V*Sigma*(Delta^(-1))*Gamma.';
w0 = R*e0;

% use the given estimation error for a single nominal run
if m == 1
    xh0 = [97.9; 1037.4; -0.24; -3.50; 0; 0; 0; 0];
    w0 = xh0 - inp.x0;
end

% run monte carlo m times and store data from runs
sim_data = cell(m,1);
for i = 1:m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulate Run

% output current run every 50 runs
if mod(i,50) == 0
    disp(['Monte Carlo Run #' num2str(i) '...'])
end
    
% sample an initial estimate state vector
inp.xh0 = inp.x0 + w0(:,i);         % xh = x + e
inp.xh0(5:end) = zeros(4,1);        % delta states = 0

% sim the tracking problem
[state_hist, measurement_hist, estimate_hist] = simRun(inp);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process Run

% pull the environment data
x_hist = [state_hist.x];
Q_hist = [state_hist.Q];
t_hist = [state_hist.t];
tk_hist = [measurement_hist.t];
    
% pull the EKF data
xprior_hist = [estimate_hist.x_prior];
xpost_hist = [estimate_hist.x_post];
Pprior_hist = [estimate_hist.P_prior];
Ppost_hist = [estimate_hist.P_post];
    
% get the true states at each measurement t_k
xk_hist = zeros(8,length(tk_hist));
for j = 1:length(tk_hist)
    jk = t_hist==tk_hist(j);
    xk_hist(:,j) = x_hist(:,jk);
end

% calculate estimate errors at each t_k
eprior_hist = xk_hist - xprior_hist;
epost_hist = xk_hist - xpost_hist;

% calculate process noise standard deviations
SQ_hist = zeros(8, length(t_hist));
for j = 0:(length(t_hist)-1)
    SQ = diag(Q_hist(:,1+j*8:j*8+8)).^.5;
    SQ_hist(:,j+1) = SQ;
end

% calculate EKF estimation error standard deviations
SPprior_hist = zeros(8, length(tk_hist));
SPpost_hist = zeros(8, length(tk_hist));
for j = 0:(length(tk_hist)-1)
    SQ = diag(Q_hist(:,1+j*8:j*8+8)).^.5;
    SPprior = diag(Pprior_hist(:,1+j*8:j*8+8)).^.5;
    SPpost = diag(Ppost_hist(:,1+j*8:j*8+8)).^.5;
    SQ_hist(:,j+1) = SQ;
    SPprior_hist(:,j+1) = SPprior;
    SPpost_hist(:,j+1) = SPpost;
end
    
% zip together the apriori and aposteriori data
xh_hist = zeros(8, length(tk_hist)*2);
e_hist = zeros(8,length(tk_hist)*2);
th_hist = zeros(1,length(tk_hist)*2);
SP_hist = zeros(8,length(tk_hist)*2);
for j = 1:length(tk_hist)
    xh_hist(:,2*j - 1) = xprior_hist(:,j);
    xh_hist(:,2*j) = xpost_hist(:,j);
    e_hist(:,2*j - 1) = eprior_hist(:,j);
    e_hist(:,2*j) = epost_hist(:,j);
    SP_hist(:,2*j - 1) = SPprior_hist(:,j);
    SP_hist(:,2*j) = SPpost_hist(:,j);
    th_hist(:,2*j - 1) = tk_hist(:,j);
    th_hist(:,2*j) = tk_hist(:,j);
end

% store the raw data and calculated data for the run
sim_data{i} = struct('state_hist', state_hist, ...
                     'measurement_hist', measurement_hist, ...
                     'estimate_hist', estimate_hist, ...
                     'th_hist', th_hist, ...
                     'xh_hist', xh_hist,...
                     'e_hist', e_hist, ...
                     'SQ_hist', SQ_hist, ...,
                     'SP_hist', SP_hist);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process All Runs

% calculate the mean error
e_bar = zeros(8, length(th_hist));
for j = 1:length(th_hist)
    ei = sim_data{1}.e_hist;
    ej_sum = ei(:,j);
    for i = 2:m
        ei = sim_data{i}.e_hist;
        ej_sum = ej_sum + ei(:,j);
    end
    e_bar(:,j) = ej_sum./m;
end

% calculate sampled mean estimation error covariance
P_bar = zeros(8, length(th_hist)*8);
for j = 1:length(th_hist)
    ei = sim_data{1}.e_hist;
    Pj_sum = (ei(:,j) - e_bar(:,j))*(ei(:,j) - e_bar(:,j))';
    for i = 2:m
        ei = sim_data{i}.e_hist;
        Pj = (ei(:,j) - e_bar(:,j))*(ei(:,j) - e_bar(:,j))';
        Pj_sum = Pj_sum + Pj;
    end
    P_bar(:,1+j*8:j*8+8) = Pj_sum./(m - 1);
end

% calculate sampled mean esimation error covariance standard deviations
SPbar_hist = zeros(8, length(th_hist));
for j = 1:length(th_hist) 
    SPbar = diag(P_bar(:, 1 + j*8 : 8 + j*8)).^.5;
    SPbar_hist(:,j)=  SPbar;
end
    
% store the caclualted mean sample data
sample_data.e_bar_hist = e_bar;
sample_data.SP_bar_hist = SPbar_hist;
end