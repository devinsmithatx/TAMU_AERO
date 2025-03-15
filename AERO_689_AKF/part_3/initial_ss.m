function ss = initial_ss(inp)
% Creates the state space matrices for dynamics and measurements

% definte the continuous dynamics
F = [0 0 1 0; 0 0 0 1; 0 0 0 0; 0 0 0 0];
G = [0 0; 0 0; 0 0; 0 1];
u = [0; -9.8066];                                       % [m/s^2] gravitaty

% calculate the discretized dynamics for time step and measurement step
syms delta_t;                                           % delta t
phi = expm(F*(delta_t));                                % phi symbolically

Qk1 = double(int(phi*inp.Qs*phi',delta_t,0,inp.dt));    % Q_k-1 (dt = 0.1)
Qk1_tm = double(int(phi*inp.Qs*phi',delta_t,0,inp.tm)); % Q_k-1 (dt = 0.5)

uk1 = double(int(phi*G*u,delta_t,0, inp.dt));           % u_k-1 (dt = 0.1)
uk1_tm = double(int(phi*G*u,delta_t,0, inp.tm));        % u_k-1 (dt = 0.5)

phi = expm(F*inp.dt);                                   % phi (dt = 0.1)
phi_tm = expm(F*inp.tm);                                % phi (dt = 0.5)

% calculate sqrt(Q_k-1) for 1 dimentional motion
Qk1_sqrt = [Qk1(2,2), Qk1(2,4); Qk1(4,2), Qk1(4,4)];
Qk1_sqrt = sqrtm(Qk1_sqrt);
Qk1_sqrt = [0, 0, 0, 0; 0, Qk1_sqrt(1,1), 0, Qk1_sqrt(1,2); 
            0, 0, 0, 0; 0, Qk1_sqrt(2,1), 0, Qk1_sqrt(2,2)];

% output discretized state space parameters for dynamics
ss.uk1 = uk1;
ss.phi = phi;
ss.Qk1 = Qk1;
ss.Qk1_sqrt = Qk1_sqrt;

% output discretized state stace parameters for measurements
ss.H = [0 1 0 0];
ss.b = -inp.h;
ss.R = inp.R;

% output discretized state space parameters for dynamics
ss.uk1 = uk1;
ss.phi = phi;
ss.Qk1 = Qk1;
ss.Qk1_sqrt = Qk1_sqrt;

% output discretized state stace parameters for estimates
ss.uk1_tm = uk1_tm;
ss.phi_tm = phi_tm;
ss.Qk1_tm = Qk1_tm;

end

