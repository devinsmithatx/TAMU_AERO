clear; clc; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problem 1

% Open-loop Damping Ratio and Natural Frequency
zeta = -0.01;
omega_n = 3;

% Open-Loop Lransfer Function Coefficients 1/(s^2 + a1*s + a2)
a1 = 2*zeta*omega_n;
a2 = omega_n^2;

% Define A and B Matrices
A = [0  1; -a2 -a1;]; 
B = [0; 1];

% Verify System is in Controllable Canonical Form
C = ctrb(A, B);
disp(C*C^(-1))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problem 1.1

% closed-loop damping ratio and natural frequency
zeta1 = 0.05;
omega1 = omega_n;

% solve for the closed-loop poles
sigma = -zeta1*omega1;
omega  = omega1*sqrt(1-zeta1^2);
poles = [sigma + 1i*omega, sigma - 1i*omega];

% get the caracteristic equation
alpha = poly(poles);
alpha1 = alpha(2);
alpha2 = alpha(3);

% solve for the closed-loop gains
G1 = [(alpha2 - a2) (alpha1 - a1)];

% verify that closed-loop damping ratio and natural freq
sys1 = ss(A-B*G1, B, eye(2), 0);
damp(sys1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problem 1.2

% closed-loop damping ratio and natural frequency
zeta2 = 0.9;
omega2 = 5;

% solve for the closed-loop poles
sigma = -zeta2*omega2;
omega  = omega2*sqrt(1-zeta2^2);
poles = [sigma + 1i*omega, sigma - 1i*omega];

% get the caracteristic equation
alpha = poly(poles);
alpha1 = alpha(2);
alpha2 = alpha(3);

% solve for the closed-loop gains
G2 = [(alpha2 - a2) (alpha1 - a1)];

% verify that closed-loop damping ratio and natural freq
sys2 = ss(A-B*G2, B, eye(2), 0);
damp(sys2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Probelm 1.3

% Calculate the Controlled Response
t = 0:0.01:5;
x0 = [10, 5];
[y1, t1, x1] = initial(sys1, x0, t);
[y2, t2, x2] = initial(sys2, x0, t);

% Plot x1 for System 1
figure;
subplot(2,1,1)
plot(t1,y1(:,1), 'k'); grid on;
ylabel("$x_1$", Interpreter="latex");
title(['Controlled Response for $\zeta=' num2str(zeta1) ...
  '$, $\omega=' num2str(omega1) '$, $x_1(0) = 10$, and $x_2(0) = 5$'], ...
  Interpreter="latex");

% Plot x2 for System 1
subplot(2,1,2);
plot(t1,y1(:,2),'k'); grid on;
ylabel('$x_2$', Interpreter="latex")
xlabel('$t$ (s)', Interpreter="latex")

% Plot x1 for System 2
figure;
subplot(2,1,1)
plot(t2,y2(:,1), 'k'); grid on;
ylabel("$x_1$", Interpreter="latex"); 
title(['Controlled Response for $\zeta=' num2str(zeta2) ...
  '$, $\omega=' num2str(omega2) '$, $x_1(0) = 10$, and $x_2(0) = 5$'], ...
  Interpreter="latex");

% Plot x2 for System 2
subplot(2,1,2);
plot(t2,y2(:,2),'k'); grid on;
ylabel('$x_2$', Interpreter="latex")
xlabel('$t$ (s)', Interpreter="latex")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Probelm 1.4

% Frequency Responses 
w1 = log10(logspace(0.1, 100, 500));
w2 = log10(logspace(0.1, 1000, 5000));
[mag1, phase1, w1] = bode(sys1, w1);
[mag2, phase2, w2] = bode(sys2, w2);

% Magnitude and Phases
mag1_x1 = 20*log10(mag1(1,:));
mag1_x2 = 20*log10(mag1(2,:));
mag2_x1 = 20*log10(mag2(1,:));
mag2_x2 = 20*log10(mag2(2,:));
phase1_x1 = phase1(1,:);
phase1_x2 = phase1(2,:);
phase2_x1 = phase2(1,:);
phase2_x2 = phase2(2,:);

% Plot |G(s)| for System 1, x1
figure;
subplot(2,2,1)
sgtitle(['Bode Plots for $\zeta=' num2str(zeta1) ...
  '$, and $\omega=' num2str(omega1) '$'], ...
  Interpreter="latex");
semilogx(w1, mag1_x1, 'k'); grid on;
ylabel("$|G(j\omega)|$ (dB)", Interpreter="latex");
title('$x_1$', Interpreter='latex')

% Plot < G(s) for System 1, x1
subplot(2,2,3);
semilogx(w1, phase1_x1,'k'); grid on;
ylabel('$\angle G(j\omega)$ (deg)', Interpreter="latex")
xlabel('$\omega$ (rad/s)', Interpreter="latex")

% Plot |G(s)| for System 1, x2
subplot(2,2,2)
semilogx(w1, mag1_x2, 'k'); grid on;
title('$x_2$', Interpreter='latex')

% Plot < G(s) for System 1, x2
subplot(2,2,4);
semilogx(w1, phase1_x2,'k'); grid on;
xlabel('$\omega$ (rad/s)', Interpreter="latex")

% Plot |G(s)| for System 2, x1
figure;
subplot(2,2,1)
sgtitle(['Bode Plots for $\zeta=' num2str(zeta2) ...
  '$, and $\omega=' num2str(omega2) '$'], ...
  Interpreter="latex");
semilogx(w2, mag2_x1, 'k'); grid on;
ylabel("$|G(j\omega)|$ (dB)", Interpreter="latex");
title('$x_1$', Interpreter='latex')

% Plot < G(s) for System 2, x1
subplot(2,2,3);
semilogx(w2, phase2_x1,'k'); grid on;
ylabel('$\angle G(j\omega)$ (deg)', Interpreter="latex")
xlabel('$\omega$ (rad/s)', Interpreter="latex")

% Plot |G(s)| for System 2, x2
subplot(2,2,2)
semilogx(w2, mag2_x2, 'k'); grid on;
title('$x_2$', Interpreter='latex')

% Plot < G(s) for System 2, x2
subplot(2,2,4);
semilogx(w2, phase2_x2,'k'); grid on;
xlabel('$\omega$ (rad/s)', Interpreter="latex")