clear; clc; close all;
% Homework 2
% Devin Smith
% AERO 666

%% Problem 1.1
% Write a function to evaluate an arbitrary number of Chebyshef Polynomials
% (2nd kind) at a given x_j.

function Uj = Chebyshev(xj, n)
    Uj = zeros(1, n + 1);
    Uj(1) = 1;
    Uj(2) = 2*xj;
    for i = 2: n
        Uj(i+1) = (2*xj*Uj(i) - Uj(i-1));
    end
end

%% Problem 1.2
% Write a function to take n as an input and output the roots of the
% chebyshev polynomial in the form of a column vector.

function x = ChebyshevRoot(n)
    x = zeros(n,1);
    for i = 1:n
        x(i) = -cos(i*pi/(n+1));
    end
end

%% Problem 1.3
% Combine the results of 1.1 and 1.2 to get the chebyshev matrix.
% Investigate if the first n columns are orthogonal and verify discrete
% orthogonality.

function U = ChebyshevMatrix(n, x)
 
    U = zeros(n,n+1);
    for i = 1:n
        U(i,:) = Chebyshev(x(i), n);
    end
end

function orthogonal = orthogonal(U, weighted)
    n = height(U);
    x = ChebyshevRoot(n);
    
    if weighted
        for i = 1:n
            U(i,:) = U(i,:)*sqrt(1 - x(i)^2);
        end
    end

    sum = 0;
    for i = 1:n-1
        for j = (i+1):n
            dot = round(abs(U(:,i)'*U(:,j)),12);
            sum = sum + dot;
        end
    end
    
    if sum > 0
        orthogonal = false;
    else
        orthogonal = true;
    end
end

%% Problem 1.4
% Construct the integration matrix based on these evaluations. Write a
% function to evalueate the F matrix.

function F = FMatrix(n)
    F = zeros(n+1,n+1);
    for i = 1:n+1
        if i == 1
            F(i+1,i) = 1/2;
        elseif i == 2
            F(i-1,i) = 1/4;
            F(i+1,i) = 1/4;
        elseif i < n
            F(i-1, i) = -1/(2*n+2);
            F(i+1, i) = 1/(2*n+2);
        elseif i == n
            F(i-1, i) = -1/(2*n+2);
            F(i+1, i) = 1/(2*n+2);
        else
            F(i-1, i) = -(1/2*n);
        end
    end
end

%% Problem 1.5
% Implement the integration process. 

function a = ChebyshevODE(n, x, alpha1, y0)
    U = ChebyshevMatrix(n, x);
    F = FMatrix(n);
    o = ones(n, 1);
  
    A = U + alpha1*(U*F - o*U(1,:)*F);
    b = y0*o;
    a = A \ b;
end

%% Problem 1.6
% Compare the true solution and the approximation.

% let dy/dt = y, y(0) = 1, 
alpha = 1;
y0 = 1;

% chebyshev root nodes
n = 15;
x = ChebyshevRoot(n);

% map from t to x
t = linspace(0,1,1000);
alpha1 = alpha*t(end)/2;
x_mapped = (x - x(1))/2*t(end);

% chebyshev matrix and orthogonality
U = ChebyshevMatrix(n, x);
Orthogonality = orthogonal(U, 0);
discreteOrthogonality = orthogonal(U, 1);

% solution in x
a = ChebyshevODE(n, x, alpha1, y0);
yApprox = U*a;
yTrue = y0*exp(-alpha1*(x-x(1)));
yError = yApprox - y0*exp(-alpha1*(x-x(1)));

% solution in t
yApprox_t = U*a;
yTrue_t = y0*exp(-alpha*(t-t(1)));
yError_t = yApprox - y0*exp(-alpha*(x_mapped-t(1)));


%% Output Results
% F, U, orthogonality, approximate & analytical solution, and error.

% display F matrix and U matrix
disp("U Matrix: ")
disp(U)
disp("F Matrix: ")
disp(FMatrix(n))

% display orthogonality
disp(['U Orthogonality: ' num2str(Orthogonality)])
disp(['U Discrete Orthogonality: ' num2str(discreteOrthogonality)])

% plot the approximate and true solutions
figure;
plot(x,yTrue,'-'); hold on;
plot(x,yApprox, 'x');
xlabel('$x$', Interpreter="latex"); 
ylabel('$y(x)$', Interpreter="latex");
title('Solution to $\dot{y} = \alpha_1 y$', Interpreter="latex");
legend('Analytical', ['Chebyshev, n = ' num2str(n)], Location="best")
grid on;

% plot the error
figure;
plot(x, yError, 'x');
xlabel('$x$', Interpreter="latex"); 
ylabel('$e(x)$', Interpreter="latex");
title('Chebyshev Solution Error', Interpreter="latex");
legend(['Chebyshev, n = ' num2str(n)], Location="best")
grid on;


% plot the approximate and true solutions
figure;
plot(t,yTrue_t,'-'); hold on;
plot(x_mapped,yApprox_t, 'x');
xlabel('$t$', Interpreter="latex"); 
ylabel('$y(t)$', Interpreter="latex");
title('Solution to $\dot{y} = \alpha y$', Interpreter="latex");
legend('Analytical', ['Chebyshev, n = ' num2str(n)], Location="best")
grid on;

% plot the error
figure;
plot(x_mapped, yError_t, 'x');
xlabel('$t$', Interpreter="latex"); 
ylabel('$e(t)$', Interpreter="latex");
title('Chebyshev Solution Error', Interpreter="latex");
legend(['Chebyshev, n = ' num2str(n)], Location="best")
grid on;