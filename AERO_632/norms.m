clc; clear; close all;
% homework 1

%% problem 6

% define G
s = tf('s');
G = 1/(2*s + 1);

% test submultiplicativity
test1 = norm(G*G,2);
test2 = norm(G,2)*norm(G,2);

disp(' ')
disp("Problem 6")
disp("G(s) = 1/(1s + 1)")
disp(['||G*G||_2 = ' num2str(test1)])
disp(['||G||_2 * ||G||_2 = ' num2str(test2)])

%% problem 7

% define G
s = tf('s');
G = 1/(s^2 + s/100 + 1);

% get impulse time response and compute 2 norm, equate using parsevals
[G_t, t] = impulse(G);
norm_2_me = sqrt(trapz(t, G_t.^2));

% matlab function
norm_2_maltab = norm(G,2);

disp(' ')
disp("Problem 7")
disp("G(s) = 1/(s^2 + s/100 + 1)")
disp(['My method: ' num2str(norm_2_me)])
disp(['Matlab: ' num2str(norm_2_maltab)])

%% problem 8

% define G
s = tf('s');
G = 1/(s^2 + s/100 + 1);

% get frequency response and get infinity norm
[G_abs, ~, omega] = bode(G);
norm_inf_me = max(G_abs(:));

% matlab function
norm_inf_matlab = norm(G,inf);

disp(' ')
disp("Problem 8")
disp("G(s) = 1/(s^2 + s/100 + 1)")
disp(['My method: ' num2str(norm_inf_me)])
disp(['Matlab: ' num2str(norm_inf_matlab)])
