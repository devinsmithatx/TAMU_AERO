function plot_results(P_nominal, P_uncertain ,CL_nominal, CL_uncertain, gamma)

% Gamma as state space for plotting
gamma = ss(gamma);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plots

% Open-Loop Poles & Zeros
figure; 
pzmap(P_uncertain, P_nominal); 
title("Pole-Zero Map: Open-Loop")
legend();

% Closed-Loop Poles & Zeros
figure; 
pzmap(CL_uncertain, CL_nominal);
title("Pole-Zero Map: Closed-Loop")
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Step Response
figure; 
step(CL_uncertain, CL_nominal); hold on; 
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Impulse Response
figure; 
impulse(CL_uncertain, CL_nominal); hold on; 
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Singular Values
figure; 
sigma(CL_uncertain, CL_nominal, gamma);
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Bode Magnitude
figure; 
bodemag(CL_uncertain, CL_nominal, gamma);
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Bode Magnitude + Phase
figure; 
bode(CL_uncertain, CL_nominal, gamma);
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

end