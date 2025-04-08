function F = jacobianF(inp, x)

    % get parameters from state vector and input 
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
    B    = B_bar   + Delta_B;
    p_0  = p_0_bar + Delta_p_0;
    k_p  = k_p_bar + Delta_k_p;

    % atmospheric density
    p = p_0*exp(-r_y/k_p);

    % drag force magnitude
    v = sqrt(v_x^2 + v_y^2);
    d = p*(v^2)/(2*B);

    % drag components   
    d_x = -d*v_x/v;
    d_y = -d*v_y/v;
       
    F1 = [0 0 1 0 0 0 0 0];                     % r_x dynamics
    F2 = [0 0 0 1 0 0 0 0];                     % r_y dynamics
    
    F3 = [ 0                         ...        % v_x dynamics
          -1/k_p*d_x/m               ...
          -p/(2*B)*(v + v_x/v*v_x)/m ...
          -p/(2*B)*(0 + v_x/v*v_y)/m ...
           0                         ...
          -1/B*d_x/m                 ...
           1/p_0*d_x/m               ...
          -r_y/k_p^2*d_x/m];

    F4 = [ 0                         ...        % v_y dynamics
          -1/k_p*d_y/m               ...
          -p/(2*B)*(0 + v_y/v*v_x)/m ...
          -p/(2*B)*(v + v_y/v*v_y)/m ...
           0                         ...
          -1/B*d_y/m                 ...
           1/p_0*d_y/m               ...
          -r_y/k_p^2*d_y/m];

    F = [F1; F2; F3; F4; zeros(4,8)];           % all dynamics

end

