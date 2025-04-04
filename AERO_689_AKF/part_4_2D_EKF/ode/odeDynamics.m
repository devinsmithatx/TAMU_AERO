function dx = odeDynamics(t, x, inp, w)

% get parameters from state vector and input 
r_x       = x(1);
r_y       = x(2);
v_x       = x(3);
v_y       = x(4);
Delta_B   = x(6);
Delta_p_0 = x(7);
Delta_k_p = x(8);
B_bar     = inp.bar(2);
p_0_bar   = inp.bar(3);
k_p_bar   = inp.bar(4);
m         = inp.m;
g         = inp.g;

% aerodynamic parameters
B    = B_bar + Delta_B;
p_0  = p_0_bar + Delta_p_0;
k_p  = k_p_bar + Delta_k_p;

% atmospheric density
p = p_0*exp(-r_y/k_p);

% drag force magnitude
d = p*(v_x^2 + v_y^2)/(2*B);

% drag components
theta =  atan2(v_y, v_x);       
d_x = -d*cos(theta);
d_y = -d*sin(theta);
    
% derivatives of states
dx = [v_x; 
      v_y; 
      d_x/m;
      d_y/m - g;
      0; 
      0; 
      0; 
      0];

% add process noise
dx = dx + w;

end

