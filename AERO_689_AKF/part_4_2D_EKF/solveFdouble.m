function F = solveFdouble(F, xh)
    syms r_x r_y v_x v_y Delta_h Delta_B Delta_p_0 Delta_k_p
    x = [r_x; r_y; v_x; v_y; Delta_h; Delta_B; Delta_p_0; Delta_k_p];

    F = double(subs(F, x, xh));
end

