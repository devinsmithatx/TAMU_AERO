function F = symbolicF(inp)
    
    % symbolic variavles
    syms r_x r_y v_x v_y Delta_h Delta_B Delta_p_0 Delta_k_p

    % input parameters
    g       = inp.g;
    m       = inp.m;
    B_bar   = inp.bar(2);
    p_0_bar = inp.bar(3);
    k_p_bar = inp.bar(4);

    % aerodynamic parameters
    B = B_bar + Delta_B;
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
    
    % state vector
    x = [r_x; 
         r_y; 
         v_x;
         v_y; 
         Delta_h; 
         Delta_B; 
         Delta_p_0; 
         Delta_k_p];

    % derivatives of states
    dx = [v_x; 
          v_y; 
          d_x/m;
          d_y/m - g;
          0; 
          0; 
          0; 
          0];

    % jacobian matrix
    F = sym(zeros(8,8));
    for i = 1:8
         for j = 1:8
             F(i,j) = diff(dx(i), x(j));
         end
    end
end

