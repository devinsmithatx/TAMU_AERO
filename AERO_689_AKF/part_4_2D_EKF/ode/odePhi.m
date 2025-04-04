function  dPhi_vec = odePhi(t, Phi_vec, F)

% reshape to Phi to matrrix;
Phi = reshape(Phi_vec, 8, 8);

% solve for dPhi/dt
dPhi_vec = F*Phi;

% output dPhi/dt reshaped to vector
dPhi_vec = dPhi_vec(:);
end

