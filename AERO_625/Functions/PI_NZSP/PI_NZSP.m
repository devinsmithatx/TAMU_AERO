function PI_NZSP(inp)
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

% NEW STATE SPACE WITH INTEGRAL ON P
inp.A = [A zeros(nx,1) ;
        [1 0 0 0 0 0] 0];    
inp.B = [B       ;
         zeros(1,nu)];
inp.C = [C        zeros(height(D),1) ;
         zeros(1,width(C)) eye(1,1)          ];
inp.D = [D           ; 
         zeros(1,nu)];

phi_aug = [phi            zeros(nx,1) ;
          [1 0 0 0 0 0]*T 1           ];    
gamma_aug = [gamma       ;
             zeros(1,nu)];

% CALCULATE GAIN
inp.Q = eye(nx + 1,nx + 1);
inp.Q(1,1) = 20;
inp.Q(3,3) = 30;
inp.Q(4,4) = 20;
inp.Q(5,5) = 0;
inp.Q(6,6) = 0;
inp.R = eye(nu,nu);
inp.R = [5 0;0 30];
[inp.K, Qh, Rh, M] = LQRDJV(inp.A,inp.B,inp.Q,inp.R, inp.T);

% SIMULATION
inp.x_0 = [inp.x_0; 0];
inp.t_f = 20;                                % Simulation Length (s)
inp.t_s = .01;                               % Simulation Step Size (s)

% run the simulation and plot
out = PI_NZSP_run_sim(inp);
PI_NZSP_plot_sim(out);

% CLOSED-LOOP CHARACTERISTICS
[inp.phi, inp.gamma] = c2d(inp.A, inp.B, inp.T);
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
disp("AUGMENTED PHI MATRIX")
disp(phi_aug)
disp("AUGMENTED GAMMA MATRIX")
disp(gamma_aug)
end