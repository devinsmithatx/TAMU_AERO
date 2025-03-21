clc; clear;

% Define F16 Model
% ================
load f16LongiLinear.mat

A = f16ss.a;
Bu = f16ss.b;
Bd = [0;1;0;0];
B = [Bd Bu];
Cy = [1  0 0 0;
    0 -1 1 0];

[ns,nu] = size(B);
ny = size(Cy,1);

F16 = ss(A,B,Cy,zeros(ny,nu));
s = tf('s');

% Define Weights
% ==============
Wu = diag([1/10000,1/25]);
We = blkdiag(1/(s/.5+1), 5/(s/1+1));
Wn = blkdiag(1E-2, 1E-2);
Wd = 1;%(s/0.5+1);
Wr = blkdiag(50/(s/0.5+1), 1/(s/1+1));

nx = 4; nu = 2; nd = 1; nr = 2;
nz = nx+nu;  nw = nd + nr;

% Normalized signals
r = icsignal(2); % For V, gam -- reference
n = icsignal(2); % For V, gam -- sensor noise
d = icsignal(1); % disturbance along alphdot
u = icsignal(2); % T, dele

y = F16*[Wd*d;u];
ym = y + Wn*n;

e = Wr*r - y;
z = [We*e;Wu*u];

M = iconnect;
w = [r;d;n];
M.Input = [w;u];
M.Output = [z;Wr*r-ym];

%M.Output = [z;Wr*r;ym];


G = ss(M.System);
Gm = minreal(G);

[K,CL,GAM,INFO] = hinfsyn(Gm,2,2); 
fprintf(1,'GAM = %f\n',GAM);
%bodemag(CL); grid on;


