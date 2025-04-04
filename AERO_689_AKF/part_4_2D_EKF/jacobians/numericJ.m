function J = numericJ(J, x)

    % symbolic variables
    syms r_x r_y v_x v_y Delta_h Delta_B Delta_p_0 Delta_k_p

    % symbolic state vector
    x_sym = [r_x; 
             r_y; 
             v_x; 
             v_y; 
             Delta_h; 
             Delta_B; 
             Delta_p_0; 
             Delta_k_p];

    % substitute numerical x into J
    J = double(subs(J, x_sym, x));
end

