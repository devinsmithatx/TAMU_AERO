function dx = dynamics(t, x, inp)
%nonlinearDynamics Summary of this function goes here
%   Detailed explanation goes here

% aerodyanmic inputs
beta = inp.bar(2) + inp.x0(6);
rho0 = inp.bar(3) + inp.x0(7);
kp   = inp.bar(4) + inp.x0(8);

% position and velocity inputs;
ry = x(2);
vx = x(3);
vy = x(4);

% solve atmospheric density
rho = rho0*exp(-ry/kp);

% solve drag magnitude
drag_x = (rho*vx^2)/(2*beta);
drag_y = (rho*vy^2)/(2*beta);

% make sure drag is in oppoiste direction of velocity
if vx > 0
    drag_x = -drag_x;
end

if vy > 0
    drag_y = -drag_y;
end

% solve process noise
% nothing atm

% get derivatives of each state
drx = vx;
dry = vy;
dvx = drag_x/inp.m;
dvy = drag_y/inp.m - inp.g;

% output state derivatives
dx = [drx; dry; dvx; dvy; 0; 0; 0; 0];
end

