function SINUSOID(inp)
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

% NZSP FOR TWO OF THE STATES
H = [1 0 0 0 0 0;
     0 0 0 1 0 0;];
D2 = [0 0;
     0 0;];

qpm  = [phi - eye(nx,nx), gamma ; H, D2]   ;
qpmi = inv(qpm)        ;
[rowa, cola] = size(phi) ;
[~, colb] = size(gamma) ;
[rowc, ~] = size(H) ;
inp.pi12 = qpmi(1:rowa, cola+1:cola+colb)           ;
inp.pi22 = qpmi(rowa+1:rowa+rowc, cola+1:cola+colb) ;

% NEW STATE SPACE WITH CONTROL RATE WEIGHTING AND INTEGRAL ON P
inp.A = [phi gamma zeros(nx,1);
        zeros(2,nx) eye(2,2) zeros(2,1);
        [T 0 0 0 0 0] zeros(1,2) 1];  

inp.B = [zeros(nx,nu) ;
         T*eye(2,2);
         zeros(1,2)];
    
inp.C = eye(height(inp.A),width(inp.A));
inp.D = zeros(height(inp.B), width(inp.B));
inp.phi = inp.A;
inp.gamma = inp.B;


phi_aug = inp.A;  
gamma_aug = inp.B;

% % CALCULATE GAIN
inp.Q = eye(nx + 3,nx + 3);
inp.Q(1,1) = 60;
inp.Q(3,3) = 30;
inp.Q(4,4) = 20;
inp.Q(5,5) = 0;
inp.Q(6,6) = 0;
inp.Q(7,7) = 5;
inp.Q(8,8) = 30;
inp.R = eye(nu,nu);
inp.R = [20 0; 0 200];
inp.K = dlqr(inp.A,inp.B,inp.Q,inp.R);

% SIMULATION
inp.x_0 = [inp.x_0; 0; 0; 0;];
inp.t_f = 40;                                % Simulation Length (s)
inp.t_s = .01;                               % Simulation Step Size (s)

[phi, gamma] = c2d(A,B,inp.t_s);
inp.phi= [phi gamma zeros(nx,1);
        zeros(2,nx) eye(2,2) zeros(2,1);
        [inp.t_s 0 0 0 0 0] zeros(1,2) 1];  

inp.gamma = [zeros(nx,nu) ;
         inp.t_s*eye(2,2);
         zeros(1,2)];

% run the simulation and plot
out = SINUSOID_run_sim(inp);
SINUSOID_plot_sim(out);

% CLOSED-LOOP CHARACTERISTICS
% closed_loop_characteristics(inp)
disp("Q")
disp(inp.Q)
disp("R")
disp(inp.R)
disp("K")
disp(inp.K)
% disp("R_hat")
% disp(Rh)
% disp("Q_hat")
% disp(Qh)
% disp("M")
% disp(M)
disp("QPM")
disp(qpm)
disp("QPM Inverse")
disp(qpmi)
disp("AUGMENTED PHI MATRIX")
disp(phi_aug)
disp("AUGMENTED GAMMA MATRIX")
disp(gamma_aug)
end