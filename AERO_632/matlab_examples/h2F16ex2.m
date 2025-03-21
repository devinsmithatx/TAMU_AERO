clc; clear;

% Define F16 Model
% ================
load f16LongiLinear.mat
wd = 1; % Scaling to adjust alpha disturbance

A = f16ss.a;
Bu = f16ss.b;
Bd = [0;wd;0;0];
B = [Bu Bd];
Cy = [1  0 0 0;
      0 -1 1 0];

[ns,nu] = size(B);
ny = size(f16ss.c,1);
F16 = ss(A,B,f16ss.c,zeros(ny,nu));

% Define Weights
% ==============
% Wu = diag([1/1000,1/25]);
% We = diag([1/100, 1]);

Wu = diag([1/5000,1/25]);
%We = diag([1/100, .1, .1 , 0.01]);
We = diag([1/100, .5, .5 , 0.01]);

nx = 4; nu = 2; nd = 1;
nz = nx+nu;  nw = nd;

% Design Interconnection
Ac = A;
B1 = Bd;
B2 = Bu;
Cz = [We;zeros(nu,nx)];
Dzu = [zeros(nx,nu);Wu];
eps = 1E-6;

cvx_begin sdp
cvx_precision best
cvx_solver sdpt3
   variable X(nx,nx) symmetric
   variable W(nz,nz) symmetric
   variable Z(nu,nx)

   [Ac B2]*[X;Z] + [X Z']*[Ac';B2'] + B1*B1' <= -eps*eye(4)
   [W (Cz*X + Dzu*Z); (Cz*X + Dzu*Z)' X] >= eps*eye(10)
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
X0 = zeros(6,1);

V1err =  lsim(Gzw(1,1),w1,T);
V2err =  lsim(Gzw(2,1),w1,T);
V3err =  lsim(Gzw(3,1),w1,T);
f1 = figure(1); clf;
set(f1,'defaulttextinterpreter','latex');
subplot(2,1,1);plot(T,V1err,'Linewidth',2); ylabel('$V$ ft/s');xlabel('Time');
subplot(2,1,2);plot(T,(V3err-V2err)*180/pi,'Linewidth',2); ylabel('$\gamma$ deg'); xlabel('Time');
print -depsc f16dist.eps

%% Tracking Controller
ny = size(Cy,1);
M = [A Bu;Cy zeros(2,2)];
b = [zeros(nx,ny); -eye(ny,ny)];
X = -inv(M)*b;
PI = X(1:nx,:);
GAM = X(nx+1:end,:);
Br = GAM - h2K*PI;

Gry = ss(A+Bu*h2K,Bu*Br,Cy,zeros(0,0));
Gdy = ss(A+Bu*h2K,Bd,Cy,zeros(0,0));
figure(1); clf;
subplot(2,1,1); hold on;
%step(50*Gry(1,1),T);
[Vr,T,tmp,tmp] = step(50*Gry(1,1),T);
Vd = lsim(Gdy(1),w1,T);
plot(T,Vr+50*V1err,'r','Linewidth',2);
ylabel('Velocity (ft/s)');
subplot(2,1,2); hold on;
%step(Gry(2,2),T);
[Gr,T,tmp,tmp] = step(Gry(2,2),T);
plot(T,Gr+V2err,'r','Linewidth',2);
ylabel('FPA (Gamma rad)');

%%
d2r = pi/180;
Vstep = 50;
Gstep = 45*d2r;
wd = 1;
sim('simF162');
f=figure(3); clf;
set(f,'defaulttextinterpreter','latex');

subplot(2,2,1); plot(ysim.Time,ysim.Data(:,1),'Linewidth',2);
ylabel('V (ft/s)');
subplot(2,2,2); plot(ysim.Time,ysim.Data(:,2)/d2r,'Linewidth',2);
ylabel('Gamma (deg)');
subplot(2,2,3); plot(usim.Time,usim.Data(:,1),'Linewidth',2);
ylabel('Thrust (lb)'); xlabel('Time');
subplot(2,2,4); plot(usim.Time,usim.Data(:,2),'Linewidth',2);
ylabel('Elevator (deg)');xlabel('Time'); 
print -depsc f16h2VG.eps








