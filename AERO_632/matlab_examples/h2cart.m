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
Bw = [0;0;0;k2/m2];

nx = 4; nu = 1;
nz = 1; nw = 1;

Cz = [1,0,0,0];
Du = 1*ones(nz,nu);
%%
cvx_solver mosek
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

%% Sim
h2G = ss(A+Bu*h2K, Bw, Cz + Du*h2K, zeros(nz,nw));
lqrG = ss(A-Bu*lqrK, Bw, Cz + Du*lqrK, zeros(nz,nw));


T = [0:0.01:20];
w = 2*rand(length(T),1)-1;
%w = 0.5*sin(10*T);
[y1,t1,x1] = lsim(h2G,w,T);
[y2,t2,x2] = lsim(lqrG,w,T);

f1 = figure(1); clf;
set(f1,'defaulttextinterpreter','latex');
plot(t1,y1,'r',t2,y2,'b:','Linewidth',2);
xlabel('Time'); ylabel('output $z(t)$');
%title('$d(t) =  0.5*\sin\;\; (5*T)$ m');
title('$d(t)$ =  white noise $\in [-1,\;1]$ m');
legend('H2','LQR');
print -depsc h2qcar2.eps



