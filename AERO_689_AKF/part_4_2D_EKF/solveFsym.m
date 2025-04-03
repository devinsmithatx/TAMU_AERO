function F = solveFsym(inp)
    
    syms r_x r_y v_x v_y Delta_h Delta_B Delta_p_0 Delta_k_p
    x = [r_x; r_y; v_x; v_y; Delta_h; Delta_B; Delta_p_0; Delta_k_p];

    g = inp.g;
    h = inp.bar(1) + Delta_h;
    B = inp.bar(2) + Delta_B;
    p_0 = inp.bar(3) + Delta_p_0;
    k_p = inp.bar(4) + Delta_k_p;
 
    rho = p_0*exp(-r_y/k_p);
    drag = rho*(v_x^2 + v_y^2)/(2*B);
    theta = atan2(v_y, v_x);
    
    f = [v_x;
         v_y;
         -drag*cos(theta);
         -drag*sin(theta) - g;
         0;
         0;
         0;
         0];

    F = sym(zeros(8,8));

    for i = 1:8
         for j = 1:8
             F(i,j) = diff(f(i), x(j));
         end
    end
end

