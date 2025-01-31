clc; clear; close all

% given moments of inertia
I1 = 120;           % [kg*m^2]
I2 = 100;           % [kg*m^2]
I3 = 80;            % [kg*m^2]

% given angular momentum
H = sqrt(308);      % [kg*m^2/s]

% generate grid of spherical coordinates for theta and phi
theta = linspace(0,pi,100);
phi = linspace(0,2*pi,2*100);
[theta_grid, phi_grid] = meshgrid(theta, phi);

%% a)
% given rotatational kinetic energy
T_rot = 1.8;        % [J]

% create momentum sphere
r = H;                                      % radius
x_H = r.*sin(theta_grid).*cos(phi_grid);
y_H = r.*sin(theta_grid).*sin(phi_grid);
z_H = r.*cos(theta_grid);

% create energy sphere
r1 = (2*I1*T_rot)^0.5;                       % semi-axis for x-axis
r2 = (2*I2*T_rot)^0.5;                       % semi-axis for x-axis
r3 = (2*I3*T_rot)^0.5;                       % semi-axis for x-axis
x_T = r1.*sin(theta_grid).*cos(phi_grid);
y_T = r2.*sin(theta_grid).*sin(phi_grid);
z_T = r3.*cos(theta_grid);

% convert to ax^2 + by^2 + z^2 = 1 form for sphere and ellipsoid
semis_H = [r, r, r];    % semi-axis for sphere
semis_T = [r1, r2, r3]; % semi-axis for elliospoid

abc_H = 1./semis_H.^2;   % a, b, c for sphere
abc_T = 1./semis_T.^2;   % a, b, c for ellipsoid

abc = [abc_H; abc_T];    % matrix of a, b, c coefficiets

% solve [r r r; r1 r2 r3][x^2; y^2; z^2] = [1;1] for an [x^2; y^2; z^2]
% provides an x0 for using x0 + n*(free var) to get all possible solutions
x0 = abc\[1;1];

% solve for null space (all x^2 y^2 z^2 that make [0; 0])
n = -null(abc);

% solve for the free variable values & get all possible intersections
% will provide only one quarter of the polhode
free_max = -x0(1)/(n(1)); % test index until only positive square roots
free = 0:.005:free_max;
x = x0 + n.*free;
xyz = sqrt(x);           % all positive square roots

% plot momentum sphere and energy sphere
figure(1);
surf(x_H,y_H,z_H,LineStyle="none",FaceColor='r', FaceAlpha='0.3'); hold on;
surf(x_T,y_T,z_T,LineStyle="none",FaceColor='b', FaceAlpha='0.4');
xlabel('$H_1$ $[kg*m^2/s]$', Interpreter='latex');
ylabel('$H_2$ $[kg*m^2/s]$', Interpreter='latex');
zlabel('$H_3$ $[kg*m^2/s]$', Interpreter='latex');
title('$Plot$ $with$ $T_{rot} = 1.8$ $[J]$', interpreter='latex');

% plot all polhode lines 
plot3(xyz(1,:),xyz(2,:),xyz(3,:),'linewidth',2,'color','k');
plot3(xyz(1,:),-xyz(2,:),-xyz(3,:),'linewidth',2,'color','k');
plot3(xyz(1,:),xyz(2,:),-xyz(3,:),'linewidth',2,'color','k');
plot3(xyz(1,:),-xyz(2,:),xyz(3,:),'linewidth',2,'color','k');
plot3(-xyz(1,:),-xyz(2,:),-xyz(3,:),'linewidth',2,'color','k');
plot3(-xyz(1,:),xyz(2,:),xyz(3,:),'linewidth',2,'color','k');
plot3(-xyz(1,:),-xyz(2,:),xyz(3,:),'linewidth',2,'color','k');
plot3(-xyz(1,:),xyz(2,:),-xyz(3,:),'linewidth',2,'color','k'); 

% legend
l1 = "Momentum Sphere";
l2 = "Energy Ellipsoid";
l3 = "Polhode";
l4 = '';
legend({l1, l2, l3, l4, l4, l4, l4, l4, l4, l4});
hold off;

%% a)
% given rotatational kinetic energy
T_rot = 1.5;        % [J]

% create momentum sphere
r = H;                                      % radius
x_H = r.*sin(theta_grid).*cos(phi_grid);
y_H = r.*sin(theta_grid).*sin(phi_grid);
z_H = r.*cos(theta_grid);

% create energy sphere
r1 = (2*I1*T_rot)^0.5;                       % semi-axis for x-axis
r2 = (2*I2*T_rot)^0.5;                       % semi-axis for x-axis
r3 = (2*I3*T_rot)^0.5;                       % semi-axis for x-axis
x_T = r1.*sin(theta_grid).*cos(phi_grid);
y_T = r2.*sin(theta_grid).*sin(phi_grid);
z_T = r3.*cos(theta_grid);

% convert to ax^2 + by^2 + z^2 = 1 form for sphere and ellipsoid
semis_H = [r, r, r];    % semi-axis for sphere
semis_T = [r1, r2, r3]; % semi-axis for elliospoid

abc_H = 1./semis_H.^2;   % a, b, c for sphere
abc_T = 1./semis_T.^2;   % a, b, c for ellipsoid

abc = [abc_H; abc_T];    % matrix of a, b, c coefficiets

% solve [r r r; r1 r2 r3][x^2; y^2; z^2] = [1;1] for an [x^2; y^2; z^2]
% provides an x0 for using x0 + n*(free var) to get all possible solutions
x0 = abc\[1;1];

% solve for null space (all x^2 y^2 z^2 that make [0; 0])
n = -null(abc);

% solve for the free variable values & get all possible intersections
% will provide only one quarter of the polhode
free_max = -x0(3)/(n(3)); % test index until only positive square roots
free = 0:.005:free_max;
x = x0 + n.*free;
xyz = sqrt(x);           % all positive square roots

% plot momentum sphere and energy sphere
figure(2);
surf(x_H,y_H,z_H,LineStyle="none",FaceColor='r', FaceAlpha='0.3'); hold on;
surf(x_T,y_T,z_T,LineStyle="none",FaceColor='b', FaceAlpha='0.4');
xlabel('$H_1$ $[kg*m^2/s]$', Interpreter='latex');
ylabel('$H_2$ $[kg*m^2/s]$', Interpreter='latex');
zlabel('$H_3$ $[kg*m^2/s]$', Interpreter='latex');
title('$Plot$ $with$ $T_{rot} = 1.5$ $[J]$', interpreter='latex');

% plot all polhode lines 
plot3(xyz(1,:),xyz(2,:),xyz(3,:),'linewidth',2,'color','k');
plot3(xyz(1,:),-xyz(2,:),-xyz(3,:),'linewidth',2,'color','k');
plot3(xyz(1,:),xyz(2,:),-xyz(3,:),'linewidth',2,'color','k');
plot3(xyz(1,:),-xyz(2,:),xyz(3,:),'linewidth',2,'color','k');
plot3(-xyz(1,:),-xyz(2,:),-xyz(3,:),'linewidth',2,'color','k');
plot3(-xyz(1,:),xyz(2,:),xyz(3,:),'linewidth',2,'color','k');
plot3(-xyz(1,:),-xyz(2,:),xyz(3,:),'linewidth',2,'color','k');
plot3(-xyz(1,:),xyz(2,:),-xyz(3,:),'linewidth',2,'color','k');

% legend
l1 = "Momentum Sphere";
l2 = "Energy Ellipsoid";
l3 = "Polhode";
l4 = '';
legend({l1, l2, l3, l4, l4, l4, l4, l4, l4, l4});
hold off;