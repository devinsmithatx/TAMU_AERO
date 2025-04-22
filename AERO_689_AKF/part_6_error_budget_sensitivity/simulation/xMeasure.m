%% xMeasure.m

function y = xMeasure(inp, x)

% get variables from state vector and input 
r_x     = x(1);
r_y     = x(2);
Delta_h = x(5);
h_bar   = inp.bar(1);

% get the measurement
h = h_bar + Delta_h;
y = sqrt( r_x^2 + (r_y - h)^2 );

end