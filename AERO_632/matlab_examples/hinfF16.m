
% Define F16 Model
% ================
load f16LongiLinear.mat
wd = 1; % Scaling to adjust alpha disturbance

A = f16ss.a;
Bu = f16ss.b;
Bd = [0;wd;0;0];
B = [Bu Bd];
I = eye(4);
Cy = [1  0 0 0; % Velocity
      0 -1 1 0]; % gamma
   

[ns,nu] = size(B);
F16 = ss(A,B,Cy,zeros(size(Cy,1),nu));

% Define Weights
% ==============
s = tf('s');

Wr = blkdiag(1/(s/1+1), 0.5/(s/1+1)^2);
Wu = blkdiag(1/15000,1/25);
Se = blkdiag((s/1+1)/(s/5+1),0.01*(s/1+1)/(s/20+1)); 
We = inv(Se);
Wd = 0.001;
Wn = 0.001;

figure(3); clf;
subplot(2,2,1); bodemag(Wr(1,1)); title('W Vref'); grid on;
subplot(2,2,2); bodemag(Wr(2,2)); title('W Gam ref');grid on;
subplot(2,2,3); bodemag(Se(1,1)); title('S V err');grid on;
subplot(2,2,4); bodemag(Se(2,2)); title('S Gam err');grid on;

%% Synthesis
% Interconnection for Design
% ==========================
r = icsignal(2);
d = icsignal(1);
n = icsignal(2);
u = icsignal(2); 
y = F16*[u;Wd*d];
ym = y+Wn*n;
e = (Wr*r - y);

G = iconnect;
G.input = [r;d;n;u];
G.output = [We*e;Wu*u;Wr*r-ym];

[K,F16cl,gam,info] = hinfsyn(G.System,2,2,'method','lmi');
disp(sprintf('Minimum gamma = %f',gam));

%bodemag(F16cl); grid on
% sigma(F16cl); grid on;
%% Interconnection for Simulation
G1 = iconnect;
G1.input = [r;d;n;u];
G1.output = [y;u;Wr*r-ym];
Gcl = lft(G1.System,K,2,2);

% Frequency Response S,T
figure(2); clf;
subplot(2,2,1); bodemag(F16cl(1,1), Gcl(1,1)); title('V->V');grid on;
subplot(2,2,2); bodemag(F16cl(1,2),Gcl(1,2)); title('V->Gam');grid on;
subplot(2,2,3); bodemag(F16cl(2,1),Gcl(2,1)); title('Gam->V');grid on;
subplot(2,2,4); bodemag(F16cl(2,2),Gcl(2,2)); title('Gam->Gam');grid on;
legend('ClP','OLP','Location','southeast');

%% Simulate
figure(1); clf;
[Y,T,X] = step(F16cl(:,2),30);

subplot(2,2,1);plot(T,Y(:,1),'r','linewidth',1); 
title('Step Response');
ylabel('Velocity (ft/s)');

subplot(2,2,2);plot(T,Y(:,2),'r','linewidth',1); 
title('Step Response');
ylabel('Gamma (rad)');

subplot(2,2,3);plot(T,Y(:,3),'r','linewidth',1); 
ylabel('Thrust (lb)');

subplot(2,2,4);plot(T,Y(:,4),'r','linewidth',1); 
title('Elevator');
ylabel('Elevator (deg)');


