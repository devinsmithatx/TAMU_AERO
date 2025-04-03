function F = symbolicF(inp)
    
    % define symbolic variavles
    syms r_x r_y v_x v_y Delta_h Delta_B Delta_p_0 Delta_k_p
    x = [r_x; r_y; v_x; v_y; Delta_h; Delta_B; Delta_p_0; Delta_k_p];

    % aerodyanmic variables
    beta = inp.bar(2) + Delta_B;
    rho0 = inp.bar(3) + Delta_p_0;
    kp   = inp.bar(4) + Delta_k_p;

    % position and velocity variables;
    ry = r_x;
    vx = v_x;
    vy = v_y;
    theta =  atan2(vy, vx);

    % atmospheric density
    rho = rho0*exp(-ry/kp);

    % drag force in each direction
    drag = rho*(vx^2 + vy^2)/(2*beta);
    drag_x = -drag*cos(theta);
    drag_y = -drag*sin(theta);

    % derivatives of each state
    drx = vx;
    dry = vy;
    dvx = drag_x/inp.m;
    dvy = drag_y/inp.m - inp.g;

    % all derivatives of states
    f = [drx; dry; dvx; dvy; 0; 0; 0; 0];

    % jacobian
    F = sym(zeros(8,8));
    for i = 1:8
         for j = 1:8
             F(i,j) = diff(f(i), x(j));
         end
    end
end

