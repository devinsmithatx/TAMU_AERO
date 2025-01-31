clear; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% symbolic stuff
syms z
sympref('FloatingPointOutput',true);

% problem setup
T = 0.1;
G = [1 T; 0 1];
H = [T^2/2; T];
C = [1 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a) controller

% z poles
z1 = exp(T*complex(-1.8,3.12));
z2 = exp(T*complex(-1.8,-3.12));

% z characteristic eq 
P = expand((z-z1)*(z-z2));
alphas = coeffs(P,z);
alpha1 = alphas(2);
alpha2 = alphas(1);

% G characteristic eq
phi = G^2 + alpha1*G + alpha2*eye(2,2);

% ackermanns
Mc = [H G*H];
K = [0 1]*Mc^-1*phi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% b) observers

% z poles
z1 = complex(0.4,0.4);
z2 = complex(0.4,-0.4);

% z characteristic eq
P = expand((z-z1)*(z-z2));
alphas = coeffs(P,z);
alpha1 = alphas(2);
alpha2 = alphas(1);

% G characteristic eq
phi = G^2 + alpha1*G + alpha2*eye(2,2);

% ackermanns prediction observer
O = [C; C*G];
Kc1 = double(phi*O^-1*[0;1]);

% achermanns current observer
OG = O*G;
Kc2 = double(phi*OG^-1*[0;1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% c) errors

e0 = [1; 1];
tf = 3;
t = 0:T:tf;
n = tf/T;

ek = e0;
e1 = ek;
for i = 1:n
    ek = (G-Kc1*C)*ek;
    e1 = [e1 ek];
end

ek = e0;
e2 = ek;
for i = 1:n
    ek = (G-Kc2*C*G)*ek;
    e2 = [e2 ek];
end

figure(); clf;
tiledlayout(2,1, 'Padding', 'none', 'TileSpacing', 'compact');
for i = 1:2
    nexttile; hold on;
    title("Estimation Error")
    scatter(t,e1(i, :),50, ".",'DisplayName','Prediction Error');
    scatter(t,e2(i, :),50, ".",'DisplayName','Current Error');
    xlabel('t (s)');
    ylabel(strcat('x', num2str(i)));
    legend();
end