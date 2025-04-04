function H = symbolicH(inp)
    
    % symbolic variavles
    syms r_x r_y v_x v_y Delta_h Delta_B Delta_p_0 Delta_k_p

    % radar height
    h_bar = inp.bar(1);
    h = h_bar + Delta_h;

    % state vector
    x = [r_x; 
         r_y; 
         v_x; 
         v_y; 
         Delta_h; 
         Delta_B; 
         Delta_p_0;
         Delta_k_p];

    % measurement equation
    y = sqrt( r_x^2 + (r_y - h)^2 );
    
    % jacobian matrix
    H = sym(zeros(1,8));
    for j = 1:8
        H(j) = diff(y, x(j));
    end
end

