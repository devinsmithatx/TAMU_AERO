clear; clc; close all;


%% USER INPUT

inp.r0 = [0; 1000];     % [m]           initial position
inp.v0 = [0; 0];        % [m/s]         initial velocity
inp.h = 2;              % [m]           height of radar
inp.R = 4;              % [m^2]         noise covariance
inp.dt = 0.5;           % [s]           measurement sampling period
inp.qs = .01;           % [m^2 / s^5]   spectral density
inp.Qs = [0 0 0 0       % [m^2 / s^5]   spectral density matrix
          0 0 0 0 
          0 0 0 0
          0 0 0 inp.qs];

%% SIM

[thist, xhist, yhist] = environment(inp);

%% ENVIRONMENT

function [thist, xhist, yhist] = environment(inp)
    syms delt;
    dt = inp.dt;

    % continuous-time dynamics
    g = 9.8066;         % [m/s^2]       gravitational acceleration
    u = [0; -g];        %               control vector
    F = [0 0 1 0        %               F matrix
         0 0 0 1
         0 0 0 0
         0 0 0 0];
    G = [0 0            %               G matrix
         0 0
         0 0
         0 1];
    H = [0 1 0 0];      %               H matrix
    b = -inp.h;         %               measurment bias

    % discrete-time dynamics
    ts = 0.01;                                      % [s] sim time step
    phi = expm(F*(delt));                           % phi (symbolically)
    uk1 = double(int(phi*G*u,delt,0, ts));          % u_k-1
    Qk1 = double(int(phi*inp.Qs*phi',delt,0,ts));   % Q_k-1
    phi = expm(F*(ts));                             % phi (numerically)

    % initial conditions
    xk = [inp.r0; inp.v0];
    uk = uk1;
    yk = H*xk + b;
    tk = 0;

    % simulate the dynamics
    thist = tk;
    xhist = xk;
    yhist = yk;
    count = 1;
    while xk(2) >= -b                           % simulate until r <= h
        count = count + 1;

        tk = tk + ts;                           % increment time step
        wk = Qk1*[0; 0; 0; 1]*sqrt(randn());    % process noise <-- check this
        xk = phi*xk + uk1;                      % update x_k

        if count == dt/ts                       % measurements sample at dt
            count = 0;
            vk = randn()*sqrt(inp.R);           % measurement noise
            yk = H*xk + b + vk;                 % update y_k
            yhist = [yhist, yk];                % store y_k
        end

        xhist = [xhist, xk];                    % store x_k
        thist = [thist, tk];                    % store t_k
    end
end
