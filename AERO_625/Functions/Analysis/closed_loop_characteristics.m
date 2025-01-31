function closed_loop_characteristics(inp)
% CALCULATES CLOSED-LOOP CHARACTERSTICS
A = inp.A;
B = inp.B;
C = inp.C;
D = inp.D;
T = inp.T;
K = inp.K;
phi = inp.phi;
gamma = inp.gamma;

% CLOSED-LOOP CHARACTERISTICS (DISCRETE)
[evec, eval] = eig(phi - gamma*K);
sys_ol = ss(phi, gamma, C, D, T);
sys_cl = ss(phi, gamma*K, C, D*K, T);
sys_cl_2 = ss(phi - gamma*K, 0*B, C - D*K, 0*D, T);
figure();
pzmap(sys_cl_2);
figure();
bode(sys_ol, "b", sys_cl, "r");
figure();
sigma(sys_ol, "b", sys_cl, "r");
ylim([-50 100]);

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

disp("CLOSED-LOOP DISCRETE CHARACTERISTICS")
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
end
