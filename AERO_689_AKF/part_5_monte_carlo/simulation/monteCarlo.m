function [sim_data, sample_data] = monteCarlo(inp, m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run Monte Carlo Simulations

% repeat simulation m times with sampled data each time
sim_data = cell(m,1);
for i = 1:m
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulate Run

    % change rng seed
    rng(i);
    
    % sample an initial estimate state vector
    inp.xh0 = sqrtm(inp.P0)*randn(8,1) + inp.x0;
    inp.xh0(5:end) = zeros(4,1);

    % run the environment / ekf simulation for the sampled vectors
    [state_hist, measurement_hist, estimate_hist] = simRun(inp);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process Simulation Run

    % pull environment data
    x_hist = [state_hist.x];
    Q_hist = [state_hist.Q];
    t_hist = [state_hist.t];
    tk_hist = [measurement_hist.t];
    
    % pull ekf data
    xprior_hist = [estimate_hist.x_prior];
    xpost_hist = [estimate_hist.x_post];
    Pprior_hist = [estimate_hist.P_prior];
    Ppost_hist = [estimate_hist.P_post];
    
    % calculate estimate errors
    eprior_hist = x_hist - xprior_hist;
    epost_hist = x_hist - xpost_hist;

    % calculate process noise & error covariance standard deviations
    SQ_hist = diag(Q_hist(:,1:8)).^.5;
    SPprior_hist = diag(Pprior_hist(:,1:8)).^.5;
    SPpost_hist = diag(Ppost_hist(:,1:8)).^.5;
    for j = 1:(length(t_hist) - 1)
        SQ = diag(Q_hist(:, 1 + j*8 : 8 + j*8)).^.5;
        SPprior = diag(Pprior_hist(:, 1 + j*8 : 8 + j*8)).^.5;
        SPpost = diag(Ppost_hist(:, 1 + j*8 : 8 + j*8)).^.5;
        SQ_hist = [SQ_hist SQ];
        SPprior_hist = [SPprior_hist SPprior];
        SPpost_hist = [SPpost_hist SPpost];
    end
    
    % zip together the apriori and aposteriori measurements
    xh_hist = zeros(8, length(t_hist)*2);
    e_hist = zeros(8,length(t_hist)*2);
    th_hist = zeros(1,length(t_hist)*2);
    SP_hist = zeros(8,length(t_hist)*2);
    for j = 1:length(t_hist)
        xh_hist(:,2*j - 1) = xprior_hist(:,j);
        xh_hist(:,2*j) = xpost_hist(:,j);
        e_hist(:,2*j - 1) = eprior_hist(:,j);
        e_hist(:,2*j) = epost_hist(:,j);
        SP_hist(:,2*j - 1) = SPprior_hist(:,j);
        SP_hist(:,2*j) = SPpost_hist(:,j);
        th_hist(:,2*j - 1) = t_hist(:,j);
        th_hist(:,2*j) = t_hist(:,j);
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
%% Process all Monte Carlo Runs

% % calculate the mean error
% e_bar = [];
% for j = 1:length(th_hist)
%     ei = sim_data{1}.e_hist;
%     ej_sum = ei(:,j);
%     for i = 2:m
%         ei = sim_data{i}.e_hist;
%         ej_sum = ej_sum + ei(:,j);
%     end
%     e_bar = [e_bar  ej_sum./m];
% end
% 
% % calculate sampled estimation error covariance
% P_bar = [];
% for j = 1:length(th_hist)
%     ei = sim_data{1}.e_hist;
%     Pj_sum = (ei(:,j) - e_bar(:,j))*(ei(:,j) - e_bar(:,j))';
%     for i = 2:m
%         ei = sim_data{i}.e_hist;
%         Pj = (ei(:,j) - e_bar(:,j))*(ei(:,j) - e_bar(:,j))';
%         Pj_sum = Pj_sum + Pj;
%     end
%     P_bar = [P_bar  Pj_sum./(m - 1)];
% end
% 
% % store the sampled data
% sample_data.e_bar_hist = e_bar;
% sample_data.P_bar_hist = P_bar;

sample_data = 0;

end