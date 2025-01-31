% problem 3b

k1 = 2;
k2 = 1;
t = 5;

sys = tf([(k1-k2*t) (k1-k2)],[t (t+1) 1]);
step(sys);

% 4)
syms z

% a) 

zI_A = [[(z+1)/(z^2+z+0.24),   (1)/(z^2+z+0.24)],;
        [(-0.24)/(z^2+z+0.24), (z)/(z^2+z+0.24)]];

% set up prob 5
syms z
coeffs = z^2 - 1.3*z + 0.4; % coeffs for X(z) of LHS of z transform

U1 = z/(z-1);   % case 1 U(z)
U2 = 1;         % case 2 U(z)

% solve case 1
X = U1/coeffs;
iztrans(X)

% solve case 2
X = U2/coeffs;
iztrans(X)

iztrans(zI_A)

% 6)

[A, B, C, D] = tf2ss([3 10 1], [1 8 5])
[A, B, C, D] = tf2ss([1 4], [1 3  3 1])

% 7) 

g1 = (z^2 + z)/(z^3 - 2.6*z^2 + 2.24*z -0.64)
g2 = (z^2 + 6*z + 8)/(z^2 + 4*z + 3)

roots([1 -2.6 2.24 -0.64])

partfrac(g1, z)
partfrac(g2)


% 8

syms lambda g m L

M = [[2*m*L m*L]; [L L]];
K = [[2*m*g 0]; [0 g]];

lam_vec = solve(det(K-lambda*M), lambda);

lm1 = lam_vec(1)
lm2 = lam_vec(2)

K - lm1*M

rref(K-lm2*M)