function open_loop_characteristics(inp)
% CALCULATES OPEN-LOOP; CHARACTERSTICS
A = inp.A;
B = inp.B;
C = inp.C;
D = inp.D;
T = inp.T;
phi = inp.phi;
gamma = inp.gamma;

% OPEN-LOOP CHARACTERISTICS (CONTINUOUS)
[evec, eval] = eig(A);  % open loop eigen values, eigenvectors
sys = ss(A, B, C, D);

figure();
pzmap(sys);
figure();
bode(sys);
figure();
sigma(sys);

tcs = [];
wns = [];
drs = [];
for i = 1:4
    if imag(eval(i,i)) == 0
        tc = abs(1/eval(i,i));
        tcs = [tcs tc];
    else
        wn = abs(eval(i,i));
        wns = [wns wn];
        dr = abs(real(eval(i,i))/wn);
        drs = [drs dr];
    end
end
M = ctrb(A, B);
N = obsv(A, C);
controllable = (rank(M) == height(A));   % rank(C) == n
observable = (rank(N) == height(A));     % rank(O) == n

disp("OPEN-LOOP CONTINUOUS CHARACTERISTICS")
disp("Eigenvectors")
disp(evec)
disp("Eigenvalues")
disp(eval)
disp("Time Constants")
disp(tcs)
disp("Natural Frequencies")
disp(wns)
disp("Damping Ratios")
disp(drs)
disp("M")
disp(M)
disp("Controllable")
disp(controllable)
disp("N")
disp(N)
disp("Observable")
disp(observable)

% OPEN-LOOP CHARACTERISTICS (DISCRETE)
[evec, eval] = eig(phi);   % open loop eigen values, eigenvectors
sys = ss(phi, gamma, C, D, T);

figure();
pzmap(sys);
figure();
bode(sys);
figure();
sigma(sys);

tcs = [];
wns = [];
drs = [];
for i = 1:4
    if imag(eval(i,i)) == 0
        tc = abs(1/eval(i,i));
        tcs = [tcs tc];
    else
        wn = abs(eval(i,i));
        wns = [wns wn];
        dr = abs(real(eval(i,i))/wn);
        drs = [drs dr];
    end
end
M = ctrb(phi, gamma);
N = obsv(phi, C);
controllable = (rank(M) == height(phi));   % rank(C) == n
observable = (rank(N) == height(phi));     % rank(O) == n

disp("OPEN-LOOP DISCRETE CHARACTERISTICS")
disp("Eigenvectors")
disp(evec)
disp("Eigenvalues")
disp(eval)
disp("Time Constants")
disp(tcs)
disp("Natural Frequencies")
disp(wns)
disp("Damping Ratios")
disp(drs)
disp("M")
disp(M)
disp("Controllable")
disp(controllable)
disp("N")
disp(N)
disp("Observable")
disp(observable)
end