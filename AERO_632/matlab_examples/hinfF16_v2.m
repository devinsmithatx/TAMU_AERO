clear all;

% Define F16 Model
% ================
load f16LongiLinear.mat
wd = 1; % Scaling to adjust alpha disturbance

A = f16ss.a;
Bu = f16ss.b;
Bd = [0;wd;0;0];
B = [Bu Bd];
I = eye(4);
Cy = [0 -1 1 0]; % gamma

[ns,nu] = size(B);
F16 = ss(A,B,Cy,zeros(size(Cy,1),nu));

% Define Weights
% ==============
s = tf('s');
Wr = blkdiag(1/(s/1+1));
Wu = blkdiag(1/25,1/5000);
Se = 0.1*(s/1+1)/(s/10+1);
We = 1/Se;
Wd = 0.01; %/(s/10+1);
Wn = 0.01;

figure(3);
subplot(2,1,1); bodemag(Wr); title('W Gref');
subplot(2,1,2); bodemag(Se); title('S G err');

%% System Interconnection
% ======================
r = icsignal(1);
d = icsignal(1);
n = icsignal(1);
u = icsignal(2); 
y = F16*[u;Wd*d];
e = (Wr*r - y);

G = iconnect;
G.input = [r;d;n;u];
G.output = [We*e;Wu*u;Wr*r-y-Wn*n];

[K,F16cl,gam,info] = hinfsyn(G.System,1,2,'method','lmi');
disp(sprintf('Minimum gamma = %f',gam));
%% FRsp
figure(2); clf;
bodemag(F16cl(1,1)); title('Gam->Game');


%% Simulate
figure(1); clf;
[Y,T,X] = step(F16cl(:,3));

subplot(3,1,1);plot(T,Y(:,1),'r','linewidth',2); 
title('Gamma Error ');
ylabel('Gamma (rad)');

subplot(3,1,2);plot(T,Y(:,2),'r','linewidth',2); 
title('Thrust due to velocity step 1ft/s');
ylabel('Thrust (lb)');

subplot(3,1,3);plot(T,Y(:,3),'r','linewidth',2); 
title('Elevator due to velocity step 1ft/s');
ylabel('Elevator (deg)');
