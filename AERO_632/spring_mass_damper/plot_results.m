function plot_results(P_nom, P_unc ,CL_nom, CL_unc, gamma)

% Gamma as state space for plotting
gamma = ss(gamma);

% Open-Loop Pole-Zero Map
figure; 
pzmap(P_unc, P_nom); 
title("Pole-Zero Map: Open-Loop")
legend();

% Closed-Loop Pole-Zero Map
figure; 
pzmap(CL_unc, CL_nom);
title("Pole-Zero Map: Closed-Loop")
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Step Response
figure; 
step(CL_unc, CL_nom); hold on; 
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Singular Values
figure; 
sigma(CL_unc, CL_nom, gamma);
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Bode Magnitude
figure; 
bodemag(CL_unc, CL_nom, gamma);
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Bode Magnitude + Phase
figure; 
bode(CL_unc, CL_nom, gamma);
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

end