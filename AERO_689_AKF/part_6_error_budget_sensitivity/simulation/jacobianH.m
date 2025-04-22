%% jacobianH

function H = jacobianH(inp,x)
 
r_x = x(1);
r_y = x(2);
delta_h = x(5);
h_bar = inp.bar(1);

h = h_bar + delta_h;
y = sqrt(r_x^2 + (r_y - h)^2);

H1 = r_x/y;
H2 = (r_y - h)/y;
H3 = 0;
H4 = 0;
H5 = -(r_y - h)/y;
H6 = 0;
H7 = 0;
H8 = 0;

H = [H1 H2 H3 H4 H5 H6 H7 H8];
end