function ss = state_space(inp, dt)
%STATE_SPACE Summary of this function goes here
%   Detailed explanation goes here

% definte the continuous dynamics
syms delt;          % symbolic delta t
g = 9.8066;         % [m/s^2] gravitational acceleration
u = [0; -g];
F = [0 0 1 0; 0 0 0 1; 0 0 0 0; 0 0 0 0];
G = [0 0; 0 0; 0 0; 0 1];

% calculate the discretized dynamics
phi = expm(F*(delt));                           % phi (symbolically)
Qk1 = double(int(phi*inp.Qs*phi',delt,0,dt));       % Q_k-1
Qk1 = [Qk1(2,2), Qk1(2,4); Qk1(4,2), Qk1(4,4)];
Qk1 = sqrtm(Qk1);

% get finalized discrete state space stuff
ss.uk1 = double(int(phi*G*u,delt,0, dt));          % u_k-1
ss.phi = expm(F*(dt));                             % phi (numerically)
ss.Qk1 = [0, 0, 0, 0; 0, Qk1(1,1), 0, Qk1(1,2); 
          0, 0, 0, 0; 0 Qk1(2,1), 0, Qk1(2,2)];
ss.H = [0 1 0 0];
ss.b = -inp.h;
ss.R = inp.R;
end

