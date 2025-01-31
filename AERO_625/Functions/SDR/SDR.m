function SDR(inp)
% RUNS THE SIMULATION AND ANALYSIS FOR SDR

% PULL INPUTS
A = inp.A;
B = inp.B;
C = inp.C;
D = inp.D;
T = inp.T;
phi = inp.phi;
gamma = inp.gamma;
nx = width(A);
nu = width(B);

% CALCULATE GAIN
inp.Q = eye(nx,nx);
inp.Q(3,3) = 40;
inp.Q(5,5) = 0;
inp.Q(6,6) = 0;
inp.R = [5 0;0 20];
[inp.K, Qh, Rh, M] = LQRDJV(A,B,inp.Q,inp.R,T);

% SIMULATION
inp.t_f = 20;                                   % Simulation Length (s)
inp.t_s = 0.01;                                 % Simulation Step Size (s)

% run the simulation and plot
out = SDR_run_sim(inp);
SDR_plot_sim(out);

% CLOSED-LOOP CHARACTERISTICS
closed_loop_characteristics(inp)
disp("Q")
disp(inp.Q)
disp("R")
disp(inp.R)
disp("K")
disp(inp.K)
disp("R_hat")
disp(Rh)
disp("Q_hat")
disp(Qh)
disp("M")
disp(M)
end