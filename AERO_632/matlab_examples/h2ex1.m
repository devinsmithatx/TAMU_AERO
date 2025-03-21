clear; clc;

A = [-3 -2 1;
      1 2 1;
      1 -1 -1;];
Bu = [2 0; 0 2; 0 1];
Bw = [3;0;1];

Cz = [1 0 1; 0 1 1];
Du = [1 1; 0 1];

nx = 3;
nu = 2;
nz = 2;
nw = 1;

cvx_begin sdp
variable X(nx,nx) symmetric
variable W(nz,nz) symmetric
variables Z(nu,nx) gam

[A Bu]*[X;Z] + [X Z']*[A';Bu'] + Bw*Bw' < 0
[W (Cz*X + Du*Z); (Cz*X + Du*Z)' X] > 0
minimize trace(W)
cvx_end

h2K = Z*inv(X);
[lqrK,S,E] = lqr(A,Bu,Cz'*Cz,Du'*Du);

h2G = ss(A+Bu*h2K, Bw, Cz + Du*h2K, zeros(nw,1));
lqrG = ss(A-Bu*lqrK, Bw, Cz + Du*lqrK , zeros(nw,1));
T = [0:0.01:20];
w = 5*randn(length(T),1);
[y1,t1,x1] = lsim(h2G,w,T);
[y2,t2,x2] = lsim(lqrG,w,T);
f1=figure(1); clf;
set(f1,'defaulttextinterpreter','latex');

for i=1:2
    subplot(2,1,i); plot(t1,y1(:,i),'r',t2,y2(:,i),'b:','linewidth',2);
    xlabel('Time(s)');
    ylabel(sprintf('Output $z_%d$',i));
end
subplot(2,1,1); legend('H_2','LQR');
print -depsc h2ex1.eps

