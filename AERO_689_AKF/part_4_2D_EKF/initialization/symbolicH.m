function H = symbolicH(inp)
    
    % define symbolic variavles
    syms r_x r_y v_x v_y Delta_h Delta_B Delta_p_0 Delta_k_p
    x = [r_x; r_y; v_x; v_y; Delta_h; Delta_B; Delta_p_0; Delta_k_p];

    % measurement equation
    radar_height = inp.bar(1) + Delta_h;
    h = sqrt(r_x^2 + (r_y - radar_height)^2);
    
    % jacobian
    H = sym(zeros(1,8));
    for j = 1:8
        H(j) = diff(h, x(j));
    end
end

