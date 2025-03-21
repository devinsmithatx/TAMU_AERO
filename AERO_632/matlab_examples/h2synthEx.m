clear; clc;
% System Parameters
m1 = 290; % kg -- Body mass
m2 = 60;  % kg -- suspension mass

k1 = 16200; % N/m
k2 = 191000; % N/m
c1 = 1000; % Ns/m

A = [0 0 1 0;
    0 0 0 1;
    -k1/m1 k1/m1 -c1/m1 c1/m1;
    k1/m1 -(k1+k2)/m2 c1/m2 -c1/m2];
Bu = [0;0;1/m1;-1/m2];
Bd = [0;0;0;k2/m2];

nx = 4; nu = 1;
nz = 1; nw = 1;

Cz = [1,0,0,0];

sys = ss(A,[Bd Bu],Cz,[]);


%% Design

d = icsignal(1);
u = icsignal(1);
n = icsignal(1); % TBD
M = iconnect;

w = [d;n];

M.Input = [w;u];
x1 = sys*[d;u];
z = x1 + u;
ym = x1 + n;
M.Output = [z;ym];

minSys = minreal(M.System);
nmeas = 1;
ncon = 1;
[K,CL,GAM,INFO] = h2syn(minSys,nmeas,ncon);  

%% Sim
T = [0:0.01:20]
w = 2*rand(length(T),1)-1;
%w = 0.5*sin(10*T);
lsim(CL(1,1),w',T);

%% Weighted Design

% Weights
s = tf('s');
Wd = 0.1/(s/1+1);
Wn = 0.01*(s/5+1)/(s/10+1);
Wz = 10/(s/4+1);
Wu = 0.01*(s/3+1)/(s/6+1);

db = icsignal(1);
u = icsignal(1);
nb = icsignal(1); % TBD
M = iconnect;

wb = [db;nb];
M.Input = [wb;u];
x1 = sys*[Wd*db;u];
zb = [Wz*x1; Wu*u];
ym = x1 + Wn*nb;
M.Output = [zb;ym];

minSys = minreal(M.System);
nmeas = 1;
ncon = 1;
[K,CL,GAM,INFO] = h2syn(minSys,nmeas,ncon);  



