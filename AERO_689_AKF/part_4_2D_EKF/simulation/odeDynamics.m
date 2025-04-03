function dx = odeDynamics(t, x, inp, w)

% aerodyanmic inputs
beta = inp.bar(2) + inp.x0(6);
rho0 = inp.bar(3) + inp.x0(7);
kp   = inp.bar(4) + inp.x0(8);

% position and velocity inputs;
ry = x(2);
vx = x(3);
vy = x(4);
theta =  atan2(vy, vx);

% solve atmospheric density
rho = rho0*exp(-ry/kp);

% solve drag force in each direction
drag = rho*(vx^2 + vy^2)/(2*beta);
drag_x = -drag*cos(theta);
drag_y = -drag*sin(theta);

% get derivatives of each state
drx = vx;
dry = vy;
dvx = drag_x/inp.m;
dvy = drag_y/inp.m - inp.g;

% output derivatives of states
dx = [drx; dry; dvx; dvy; 0; 0; 0; 0] + w;

end

