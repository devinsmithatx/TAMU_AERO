clc; clear;

% Define F16 Model
% ================
load f16LongiLinear.mat
wd = 1; % Scaling to adjust alpha disturbance

A = f16ss.a;
Bu = f16ss.b;
Bd = [0;wd;0;0];
B = [Bd Bu];
Cy = [1  0 0 0;
      0 -1 1 0];

[ns,nu] = size(B);
ny = size(f16ss.c,1);
F16 = ss(A,B,f16ss.c,zeros(ny,nu));

% Filter Design for Reference
s = tf('s');
Gv = 1/(s+1);
Gg = 1/(s+1);
Gf = blkdiag(Gv,Gg);
S = ss(Gf);
Ar = S.a;
Br = S.b;
Cr = S.c;
Dr = S.d;

nrx = size(Ar,1);

% Define Weights
% ==============
% Wu = diag([1/1000,1/25]);
% We = diag([1/100, 1]);

Wu = diag([1/5000,1/25]);
We = diag([1/5, 1]);

nx = 4; nu = 2; nd = 1; nr = 2;
nz = nr+nu;  nw = nr+nd;

% Design Interconnection
Ac = blkdiag(A,Ar);
B1 = [zeros(nx,nr) Bd; Br zeros(nrx,nd)];
B2 = [Bu;zeros(nrx,nu)];
Cz = [-We*Cy We*Cr; zeros(nu,nx+nrx)];
Dzu = [zeros(nr,nu);Wu];

cvx_begin sdp
   variable X(size(Ac)) symmetric
   variable W(nz,nz) symmetric
   variable Z(nu,nx+nrx)

   [Ac B2]*[X;Z] + [X Z']*[Ac';B2'] + B1*B1' < 0
   [W (Cz*X + Dzu*Z); (Cz*X + Dzu*Z)' X] > 0
   minimize trace(W)
cvx_end

h2K = Z*inv(X);


%% Normalised Closed-loop Error Dynamics
Aclp = Ac + B2*h2K;
Bclp = B1;
Cclp1 = Cz + Dzu*h2K;
Gzw = ss(Aclp,Bclp,Cclp1,zeros(nz,nw));

T = [0:0.01:20];
w1 = 2*rand(length(T),1)-1;
w2 = 2*rand(length(T),1)-1;
X0 = zeros(6,1);
[U,T] = gensig('square',20,20,0.01);

[r,T] = impulse(Gv,T);
[V1err,T] = impulse(Gzw(1,1),T);
V1err =  lsim(Gzw(1,1),w2,T);
V2err =  lsim(Gzw(1,3),w1,T);

figure(1); clf;
subplot(2,1,1);plot(T,V1err,'b'); title('response to Vref');
subplot(2,1,2);plot(T,V2err); title('response to alpha dist');




