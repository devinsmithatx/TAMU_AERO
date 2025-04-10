clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% First Order Bode

% frequency range
T = 10;
w = log10(logspace(1/20/T, 20/T, 500));

% exact magnitude and phase
mag = -20*log10(sqrt(w.^2 * T^2 + 1));
phase = -atan(w*T)*180/pi;

% asymptotic magnitude
mag_asymptote = zeros(size(w));
mag_asymptote(w >= 1/T) = -20*log10(w(w >= 1/T)*T);

% magnitude plot
subplot(2, 1, 1);
semilogx(w, mag, 'k', 'LineWidth', 2); hold on;
semilogx(w, mag_asymptote, 'k--', 'LineWidth', 1.5); grid on;
ylabel('dB', Interpreter="latex");
title('First-Order Bode Diagram', Interpreter='latex');
legend('Exact', 'Asymptote', Interpreter="latex");

% phase plot
subplot(2, 1, 2);
semilogx(w, phase, 'k', 'LineWidth', 1.5); grid on;
xlabel('$\omega$', Interpreter="latex");
ylabel('$\phi$', Interpreter='latex');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Second Order Bode

% frequency range
w = log10(logspace(0.1, 10, 500));
s = 1i*w;

figure;
for z = [0.1, 0.2, 0.3, 0.5, 0.7, 1.0]
    % exact magnitude and phase
    G = 1./(s.^2 + 2*z*s + 1);
    mag = 20*log10(abs(G));
    phase = angle(G)*(180/pi);

    % magnitude plot
    subplot(2, 1, 1); zname = ['$\zeta$ = ' num2str(z)]; grid on;
    semilogx(w, mag, 'LineWidth', 2, "DisplayName",zname); hold on;
    ylabel('dB', Interpreter="latex");
    title('Second-Order Bode Diagram', Interpreter='latex');
    
    % phase plot
    subplot(2, 1, 2); grid on;
    semilogx(w, phase, 'LineWidth', 2, "DisplayName",zname); hold on;
    xlabel('$\frac{\omega}{\omega_n}$', Interpreter="latex");
    ylabel('$\phi$', Interpreter='latex');
end

% asymptotic magnitude
mag_asymptote = zeros(size(w));
mag_asymptote(w >= 1) = -40*log10(w(w >= 1));

% asymprotic plot;
subplot(2, 1, 1);
semilogx(w, mag_asymptote, 'k--', 'LineWidth', 1.5, "DisplayName",'Asymptote');
legend(Interpreter="latex");

tfestimate