function plot_results(P, CL, gamma)

% Gamma as state space for plotting
gamma = ss(gamma);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Open-Loop Poles & Zeros
figure; 
pzmap(P); 
title("Pole-Zero Map: Open-Loop")
legend();

% Closed-Loop Poles & Zeros
figure; 
pzmap(CL);
title("Pole-Zero Map: Closed-Loop")
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Step Response
figure; 
step(CL); hold on; 
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% impulse Response
figure; 
impulse(CL); hold on; 
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Singular Values
figure; 
sigma(CL, gamma);
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Bode Magnitude
figure; 
bodemag(CL, gamma);
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

% Bode Magnitude + Phase
figure; 
bode(CL, gamma);
set(findall(gcf,'type','line'),'linewidth',1.5);
legend()

end