%% Symbolic Variables
syms r0 v0 dt qs g h rx ry vx vy

%% Continuous-time Model
% dx = Fx + Gu + w

x0 = [0; r0; 0; v0];
x = [rx; ry; vx; vy];
u = [0; -g];

F = [0 0 1 0; 0 0 0 1; 0 0 0 0; 0 0 0 0];
G = [0 0; 0 0; 0 0; 0 1];

Qs = [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 qs];

%% Discrete-time Model
% x_k = phi*x_k-1 + u_k-1 + w_k-1
% y_k = H*x_k + b + v_k

phi = expm(F*(dt));
uk1 = int(phi*G*u,dt,0, dt);
Qk1 = int(phi*Qs*phi',dt,0,dt);

H = [0 1 0 0];
b = -h;