function  dQ_vec = odeQ(t, Q_vec, inp, F)

% reshape to Q to matrrix;
Q = reshape(Q_vec, 8, 8);

% solve for dQ/dt
dQ_vec = F*Q + Q*F.' + inp.Qs;

% output dQ/dt reshaped to vector
dQ_vec = dQ_vec(:);
end

