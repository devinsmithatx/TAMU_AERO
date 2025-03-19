function state = dynamics(dt, state, ss)
%DYNAMICS Simulates the dynamics
%   x_k1 = phi*xk + uk1 + wk1

x = [state.r; state.v]; % pull state

% simulate the dynamics
w = ss.Qk1*(randn(4,1));                      % process noise 
x = ss.phi*x + ss.uk1;                                % update x_k

% store the data
state.r = x(1:2);
state.v = x(3:4);
state.w = w;
state.t = state.t + dt;
end

