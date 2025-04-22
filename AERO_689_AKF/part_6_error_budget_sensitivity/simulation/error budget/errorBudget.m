%% errorBudget.m

function [error_table, P_star, r] = errorBudget(inp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Up Error Budget Nominal Run

% set the seed
rng(inp.seed);

% find the time until it falls to the desired point (10 m)
inp.tf = findTf(inp);
    
% set sim iteration parameters
inp.i_max = inp.tf/inp.ts;       % # of iterations total per run
inp.i_measure = inp.tm/inp.ts;   % # of iterations between t_k per run

% generate the initial error vector
[V,S] = eig(inp.P0);
Sigma = sqrtm(S);
e0 = V*Sigma*randn(8,1);
M = cov(e0');

% apply transformation such that w_bar = 0, M = P0;
[Gamma, D] = eig(M);
Delta = sqrtm(D);
R = V*Sigma*(Delta^(-1))*Gamma.';
w0 = R*e0;

% sample the initial estimate state vector
inp.xh0 = inp.x0 + w0;         % xh = x + e
inp.xh0(5:end) = zeros(4,1);   % delta states = 0

% get the time of interest P* matrix and K* history
[~, ~, estimate_hist] = simRun(inp);
P_hist = [estimate_hist.P_prior];
P_star = P_hist(:,(end-7):end);
K_star = [estimate_hist.K];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate Error Budget Table

% the nominal input P0, Qs, and R
P0_nominal = inp.P0;
Qs_nominal = inp.Qs_EKF;
R_nominal = inp.R_EKF;

% allocate error table
error_table = zeros(12,8);

% get each P0 entry
for i = 1:11
    
    % initialize all error sources as 0
    inp.P0 = zeros(8);      % Set P0 = 0
    inp.Qs_EKF = zeros(8);  % set Qs = 0
    inp.R_EKF = 0;          % set R = 0

    if ismember(i,1:8)
        % set the P0 matrix
        inp.P0(i,i) = P0_nominal(i,i);
    elseif ismember(i,9:10)
        % set the Qs matrix
        inp.Qs_EKF(i-6,i-6) = Qs_nominal(i-6,i-6);
    else
        % get R entry
        inp.R_EKF = R_nominal;
    end

    % simulate the run
    [~, ~, estimate_hist] = simRunEB(inp, K_star);
    P_hist = [estimate_hist.P_prior];
    Pbar = P_hist(:,(end-7):end);
    
    % enter the error table row
    error_table(i,:) = abs(diag(Pbar));
end
 
% get final error budget table
error_table(end,:) = sum(error_table,1);    % RMS row
error_table = error_table.^.5;              % sqrt everything

% get residual of how close the error budget table is to P_star
r = error_table(end,:) - (diag(P_star).^.5)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Display Error Budet Table

disp("Error Budget Table:")
disp(error_table)
disp("Residual from P*:")
disp(r)
end