function  dP_vec = odeP(t, P_vec, inp, F)

% reshape to P to matrrix;
P = reshape(P_vec, 8, 8);

% solve for dP/dt
dP_vec = F*P + P*(F.') + inp.Qs;

% output dP/dt reshaped to vector
dP_vec = dP_vec(:);
end

