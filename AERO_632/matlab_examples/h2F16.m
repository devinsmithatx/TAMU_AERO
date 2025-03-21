clc; clear;

% Define F16 Model
% ================
load f16LongiLinear.mat
wd = 1; % Scaling to adjust alpha disturbance

A = f16ss.a;
Bu = f16ss.b;
Bd = [0;wd;0;0];
B = [Bd Bu];

[ns,nu] = size(B);
ny = size(f16ss.c,1);
F16 = ss(A,B,f16ss.c,zeros(ny,nu));

% Define Weights
% ==============
Wu = diag([1/1000,1/25]);
We = diag([1/100, .1, .1, .01]);

nx = 4; nu = 2; nd = 1;
nz = nx+nu; nr = nx; nw = nr+nd;

% Filter Dynamics
Ar = -1*diag([1,1, 1, 1]);
Br = diag([100,1, 1, 1]);
Cr = eye(nr);

% Design Interconnection
Ac = [A A-Ar; zeros(nr,nx) Ar];
B1 = [-Br Bd;Br zeros(nr,nd)];
B2 = [Bu;zeros(nr,nu)]; 
Cz = [-We zeros(nx,nr);zeros(nu,nx+nr)];
Dzu = [zeros(nx,nu); Wu]; 

cvx_begin sdp
   variable X(nx+nr,nx+nr) symmetric
   variable W(nz,nz) symmetric
   variable Z(nu,nx+nr)

   [Ac B2]*[X;Z] + [X Z']*[Ac';B2'] + B1*B1' < 0
   [W (Cz*X + Dzu*Z); (Cz*X + Dzu*Z)' X] > 0
   minimize trace(W)
cvx_end

h2K = Z*inv(X);

Aclp = Ac + B2*h2K;
Bclp = B1;
Cclp = Cz + Dzu*h2K;


%% Closed-loop Error Dynamics
Gzw = ss(Aclp,Bclp,Cclp,zeros(nz,nw));
T = [0:0.01:40];
w = 2*rand(length(T),1)-1; % Disturbance
X0 = zeros(8,1);
[V1err,T1,X1] = impulse(Gzw(1,1),T); %reference
V2err =  lsim(Gzw(1,5),0.5*w,T,X0); % disturbance
plot(T,V1err+V2err)

