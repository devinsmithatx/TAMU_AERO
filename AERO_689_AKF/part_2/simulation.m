function simulation(inp, dt, plot_data)
%SIMULATION Simulates the entire falling object problem (part 2)
%   Detailed explanation goes here

% set default parameters
if nargin < 2; dt = 0.01;   end
if nargin < 3; plot_data = 1; end

% get state space parameters
ss = state_space(inp, dt);

% initialize the state
state = initial_state(inp, ss);
state_hist = state;

% loop through the simulation
i = 1;
while state.falling
    state = env_sim(state, inp, dt, i, ss);
    state_hist = [state_hist, state];
    i = i + 1;
end

% pull stored data
r_hist = [state_hist.r];
v_hist = [state_hist.v];
t_hist = [state_hist.t];
w_hist = [state_hist.w];
nu_hist = unique([state_hist.nu]',"rows", "stable")';
y_hist = unique([state_hist.y]',"rows", "stable")';
tk_hist = unique([state_hist.tk]', "rows", "stable")';

if plot_data
    figure; plot(t_hist,r_hist(2,:)); 
    title("Position"); xlabel("t (s)"); ylabel("r_y (m)");
    figure; plot(t_hist,v_hist(2,:));
    title("Velocity"); xlabel("t (s)"); ylabel("v_y (m/s)");
    figure; plot(t_hist,w_hist(4,:)); 
    title("Process Noise"); xlabel("t (s)"); ylabel("w (m/s^2)");
    figure; plot(tk_hist,y_hist, 'x');
    title("Range"); xlabel("t (s)"); ylabel("y (m)");
    figure; plot(tk_hist,nu_hist, 'x'); 
    title("Measurement Noise"); xlabel("t (s)"); ylabel("nu (m)");
end
end
