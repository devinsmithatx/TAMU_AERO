function output = PI_SDR_run_sim(inp)
% RUN_SIM SIMULATES A RESPONSE FOR STATE-SPACE LQRD CONTROL 
% PULL INPUT
A = inp.A;
B = inp.B;
C = inp.C;
D = inp.D;
K = inp.K;
T = inp.T;
Gw = inp.Gw;
x_0 = inp.x_0;
t_f = inp.t_f;
t_s = inp.t_s;

% SIMULATION PARAMS
t = 0.0:t_s:t_f;                    % sim time values 
[phi, gam] = c2d(A, B, t_s);

% SIMULATE RESPONSE
u_0 = -K*x_0;                % initial control
y_0 = C*x_0 + D*u_0;                % initial output
x_k = phi*x_0 + gam*u_0;            % calculate x1
y   = y_0;                          % store y0
u   = u_0;                          % store u0
for i = 1:(t_f/t_s)                 % loop time steps             
    if rem(t(i), T) == 0        % update control w/ T
        u_k = -K*x_k;     
    end
    y_k = C*x_k + D*u_k;            % update y_k w/ t_s
    y = [y y_k];                    % store y_k
    u = [u u_k];                    % store u_k
    x_k = phi*x_k + gam*u_k + Gw*t_s;        % calculate x_(k+1)
end

% OUTPUT RESULTS
output.u = u;
output.y = y;
output.t = t;
end

