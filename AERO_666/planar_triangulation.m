clear all; close all; clc;

%% PROBLEM SETUP


xT = [4; 4];                        % true value
xj1 = [0.00, 0.25,  0.50, 1.00 ;    % measurement base set 1
       0.00, 0.01, -0.10, 0.10];
xj2 = [0.00, 1.50,  3.00, 4.00 ;    % measurement base set 2
       0.00, 0.00, -0.10, 0.10];
sig = 0.1*pi/180;                   % measurement standard derivation


%% PROBLEM SOLUTION


xG = [3; 3]; % initial guess

% GLSDC SET 1
[xhat1, H1] = monte_carlo(xT, xG, xj1, sig, "GLSDC", 1);
plot_mc(xhat1, xT, xj1, sig, H1);
title("GLSDC Measurement Set 1")

% GLSDC SET 1
[xhat_mc1, H_mc1] = monte_carlo(xT, xG, xj1, sig, "GLSDC", 1000);
plot_mc(xhat_mc1, xT, xj1, sig, H_mc1);
title("GLSDC Measurement Set 1")

% GLSDC SET 2
[xhat2, H2] = monte_carlo(xT, xG, xj2, sig, "GLSDC", 1);
plot_mc(xhat2, xT, xj2, sig, H2);
title("GLSDC Measurement Set 2")

% GLSDC SET 2
[xhat_mc2, H_mc2] = monte_carlo(xT, xG, xj2, sig, "GLSDC", 1000);
plot_mc(xhat_mc2, xT, xj2, sig, H_mc2);
title("GLSDC Measurement Set 2")

% LINEAR PROGRAM SET 2
[xhat_mc3, H3] = monte_carlo(xT, xG, xj2, sig, "LINPROG", 1000);
plot_mc(xhat_mc3, xT, xj2, sig, H3);
title("LINPROG Measurement Set 2")



%% FUNCTIONS


% Gaussian Least Squares Differential Corrections Model
function [xhat, H] = GLSDC(xhat, xj, th)
m = width(xj); tol = 1e-8; ctr = 1;
xhist(:,1) = xhat; Jhist = 10; 
H = zeros(m,2); W = 1e2*eye(m);
for k = 1: 10
    yhat = atan2(xhat(2,1) - xj(2,:), xhat(1,1) - xj(1,:))';
    dy = (th - yhat);
    H(:,1) = -(xhat(2,1) - xj(2,:))./((xhat(2,1) - xj(2,:)).^2 + (xhat(1,1) - xj(1,:)).^2);
    H(:,2) = (xhat(1,1) - xj(1,:))./((xhat(2,1) - xj(2,:)).^2 + (xhat(1,1) - xj(1,:)).^2);
    
    dx = inv(H'*W*H)*H'*W*dy;
    xhat = xhat + dx;
    
    Jhist(ctr+1,1) = dy'*W*dy; xhist(:,ctr+1) = xhat;
    if(k > 1)
        if(abs(Jhist(ctr,1)- Jhist(ctr+1,1)) < tol*Jhist(ctr,1))
            break
        end
        ctr = ctr + 1;
    end
end
end

% Linear Program Model
function [xhat, H] = LINPROG(xhat, xj, th)
m = width(xj); tol = 1e-8; ctr = 1;
xhist(:,1) = xhat; Jhist = 10; 
H = zeros(m,2);
for k = 1: 10
    yhat = atan2(xhat(2,1) - xj(2,:), xhat(1,1) - xj(1,:))';
    dy = (th - yhat);
    H(:,1) = -(xhat(2,1) - xj(2,:))./((xhat(2,1) - xj(2,:)).^2 + (xhat(1,1) - xj(1,:)).^2);
    H(:,2) = (xhat(1,1) - xj(1,:))./((xhat(2,1) - xj(2,:)).^2 + (xhat(1,1) - xj(1,:)).^2);
    
    f = [zeros(1,2), ones(1,m)];            % J
    A = [-H, -eye(m,m); H, -eye(m,m)];      % -Hx - s, Hx - s
    b = [-dy; dy];                          % -y, y
    lb = [-inf,-inf, zeros(1,m)];           % s > 0
    options = optimoptions('linprog','Display','off');
    z = linprog(f,A,b,[],[],lb,[], options);
    xhat = xhat + z(1:2);

    Jhist(ctr+1,1) = f*z; xhist(:,ctr+1) = xhat;
    if(k > 1)
        if(abs(Jhist(ctr,1)- Jhist(ctr+1,1)) < tol*Jhist(ctr,1))
            break
        end
        ctr = ctr + 1;
    end
end
end

% Monte Carlo Simulation
function [xhat_mc, H] = monte_carlo(xT, xG, xj, sig, algorithm, Nmc)
thj = atan2(xT(2,1)-xj(2,:), xT(1,1)-xj(1,:))';
xhat_mc = zeros(2,Nmc);
m = width(xj);
for j1 = 1:Nmc
    thjtil = thj + sig*randn(m,1);
    if strcmp(algorithm, "GLSDC") 
        [xhat, H] = GLSDC(xG, xj, thjtil);
    else
        [xhat, H] = LINPROG(xG, xj, thjtil);
    end
    xhat_mc(:,j1) = xhat;
end
end

% Plotting Results
function plot_mc(xhat_mc, xT, xj, sig, H)
m = width(xj);
R = eye(m)*(sig^2); Ri= inv(R);
P = inv(H'*Ri*H);
Npts = 50;
th = linspace(0, 2*pi, Npts);
[V, D] = eig(P);

xc1(1,1:Npts) = sqrt(D(1,1))*cos(th); xc1(2,1:Npts) = sqrt(D(2,2))*sin(th);
xc2(1,1:Npts) = 2*sqrt(D(1,1))*cos(th); xc2(2,1:Npts) = 2*sqrt(D(2,2))*sin(th);
xc3(1,1:Npts) = 3*sqrt(D(1,1))*cos(th); xc3(2,1:Npts) = 3*sqrt(D(2,2))*sin(th);
xc1 = V*xc1; xc2 = V*xc2; xc3 = V*xc3;

thT = atan2(xT(1,1),xT(2,1))*ones(1,length(xhat_mc))*180/pi;
thhat_mc = atan2(xhat_mc(2,:),xhat_mc(1,:))*180/pi - thT;

figure
plot(thhat_mc, '+'); hold on;
plot(thT*0, '-k');
legend('Converged Solution', 'True Solution');
xlabel("Iteration #");
ylabel("Azimuth Error (Deg)");

figure
plot(xc1(1,:)+xT(1,1),xc1(2,:)+xT(2,1),'-b'); hold on; axis equal;
plot(xc2(1,:)+xT(1,1),xc2(2,:)+xT(2,1),'-g');
plot(xc3(1,:)+xT(1,1),xc3(2,:)+xT(2,1),'-r');
plot(xhat_mc(1,:), xhat_mc(2,:),'+');
plot(xT(1,1), xT(2,1), '*');
plot(xj(1,:),xj(2,:),'d');
xlim([0, 12]); ylim([0, 12]);
legend('1 \sigma', '2 \sigma', '3 \sigma', 'Converged Solution', 'True Solution', 'Observation Coordinates')
xlabel('$x$', Interpreter='latex'); 
ylabel('$y$', Interpreter='latex');

end

