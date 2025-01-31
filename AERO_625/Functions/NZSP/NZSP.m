function NZSP(inp)
% RUNS THE SIMULATION AND ANALYSIS FOR PI-SDR

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

% NEW STATE SPACE WITH NZSP FOR TWO OF THE STATES
C = [1 0 0 0 0 0;
     0 0 0 1 0 0;];
D = [0 0;
     0 0;];

qpm  = [phi - eye(nx,nx), gamma ; C, D]   ;
qpmi = inv(qpm)        ;
[rowa, cola] = size(phi) ;
[~, colb] = size(gamma) ;
[rowc, ~] = size(C) ;
inp.pi12 = qpmi(1:rowa, cola+1:cola+colb)           ;
inp.pi22 = qpmi(rowa+1:rowa+rowc, cola+1:cola+colb) ;

% CALCULATE GAIN
inp.Q = eye(nx,nx);
inp.Q(3,3) = 30;
inp.Q(5,5) = 0;
inp.Q(6,6) = 0;
inp.R = eye(nu,nu);
inp.R = [5 0;0 30];
[inp.K, Qh, Rh, M] = LQRDJV(A,B,inp.Q,inp.R, T);

% SIMULATION
inp.t_f = 20;                                % Simulation Length (s)
inp.t_s = .01;                                 % Simulation Step Size (s)

% run the simulation and plot
out = NZSP_run_sim(inp);
NZSP_plot_sim(out);

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
disp("QPM")
disp(qpm)
disp("QPM Inverse")
disp(qpmi)
end