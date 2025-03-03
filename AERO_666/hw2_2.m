clear; clc; close all;
% Homework 2
% Devin Smith
% AERO 666

%% Problem 2.1
% Sample the true signal u = cos(w_c * t) with w_c = 3pi rad.
% Sample with a frequency of 4 hz and a time period of 256 seconds.

function u = y(t, coeff)
    u = cos(coeff*pi*t);
end

fs = 4;
T = 256;
Ns = T*fs;

%% Problem 2.2
% Compute the discrete fourier transformation with Np = 1024. Plot the
% magnitude and phase of the signal.

Np = Ns;
w = 0.5*fs*linspace(0, 1, Np/2 + 1);

Ys = fft(y(1/fs:1/fs:T, 3),Np)/Np;
Ymag = abs(round(Ys(1:Np/2 + 1),10));
Yphase = angle(round(Ys(1:Np/2 + 1),10));
        
% plot data
figure;
omega = ['\omega_c = ' num2str(3) '\pi'];
subplot(2,1,1); plot(w,Ymag, "k");
title(omega);
xlabel('\omega (Hz)'); ylabel('Magnitude'); grid on;
subplot(2,1,2); plot(w,Yphase, "k");
xlabel('\omega (Hz)'); ylabel('Phase (rad)'); grid on;

%% Problem 2.3
% Repeat the process, but repeat for varying the frequency from w_c = 1pi
% to w_c = 5pi.

fstep = 0.25;   % step size for varying frequency from 1pi to 5pi
combined = 1;   % plot together or separately

if combined
    figure;
    for i = 1:fstep:5
        % fft
        Ys = fft(y(1/fs:1/fs:T, i),Np)/Np;
        Ymag = abs(round(Ys(1:Np/2 + 1),10));
        Yphase = angle(round(Ys(1:Np/2 + 1),10));
        
        % get text placement
        mag_text = max(Ymag) + max(Ymag)*.1;
        phase_text = max(Yphase) + max(Yphase)*.1;
        omega_text = w(find(Ymag==max(Ymag)));
        if phase_text == 0
            phase_text = 0.3;
        end
        if i > 4 && i < 8
            mag_text = mag_text + 0.1;
            phase_text = phase_text + 0.3;
        end
        
        % plot data and text
        omega = ['\omega_c = ' num2str(i) '\pi'];
        subplot(2,1,1); plot(w,Ymag, 'k', DisplayName=omega); hold on;
        xlim([0 2.1]); ylim([0 1.3])
        text(omega_text, mag_text, omega, HorizontalAlignment='center')
        xlabel('\omega (Hz)'); ylabel('Magnitude'); grid on;
        subplot(2,1,2); plot(w,Yphase, 'k', DisplayName=omega); hold on;
        text(omega_text, phase_text, omega, HorizontalAlignment='center')
        xlim([0 2.1]); ylim([0 4]);
        xlabel('\omega (Hz)'); ylabel('Phase (rad)'); grid on;
    end
else
    for i = 1:fstep:5
        % fft
        Ys = fft(y(1/fs:1/fs:T, i),Np)/Np;
        Ymag = abs(round(Ys(1:Np/2 + 1),10));
        Yphase = angle(round(Ys(1:Np/2 + 1),10));
        
        % plot data
        figure;
        omega = ['\omega_c = ' num2str(i) '\pi'];
        subplot(2,1,1); plot(w,Ymag);
        title(omega);
        xlabel('\omega (Hz)'); ylabel('Magnitude'); grid on;
        subplot(2,1,2); plot(w,Yphase);
        xlabel('\omega (Hz)'); ylabel('Phase (rad)'); grid on;
    end
end