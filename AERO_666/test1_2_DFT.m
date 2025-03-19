%% Problem 2, Test 1
% Devin Smth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use DFT to compute the Fourier transform of the function f(t) = 8rect(t)

clear; clc; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tasks

% 1. Calculate the discrete Fourier transform pair for N = 32, B = 4 Hz

B = 4;                          % bandwidth
N = 32;                         % sample count

T = 1/(2*B);                    % sampling frequency (nyquist criteria)
T0 = N*T;                       % final time 
t = T:T:T0;                     % time values

Ys = f(t);                      % sampled f(t)
Ys = pulstran(t,0:T0:T0,@rectpuls);

Ym = DFT(Ys, T, T0);            % DFT magnitude

rectPlot(t, Ys, B, Ym);         % plots of sampled f(t) and its DFT

% 2. Calculate the discrete Fourier transform pair for N = 216, B = 4 Hz

B = 4;                          % bandwidth
N = 216;                        % sample count

T = 1/(2*B);                    % sampling frequency (nyquist criteria)
T0 = N*T;                       % final time 
t = T:T:T0;                     % time values

Ys = f(t);                      % sampled f(t)
Ys = pulstran(t,0:T0:T0,@rectpuls);

Ym = DFT(Ys, T, T0);            % DFT magnitude

rectPlot(t, Ys, B, Ym);         % plots of sampled f(t) and its DFT

% Trying out a higher resultion just bc

B = 4*30;                          % bandwidth
N = 216*30;                        % sample count

T = 1/(2*B);                    % sampling frequency (nyquist criteria)
T0 = N*T;                       % final time 
t = T:T:T0;                     % time values

Ys = f(t);                      % sampled f(t)
% Ys = pulstran(t,0:T0:T0,@rectpuls);

Ym = DFT(Ys, T, T0);            % DFT magnitude

N = length(Ys);
w = B*linspace(0, 1, N/2 + 1);
    
% problem configuration
label = ['N = ' num2str(N) ', B = ' num2str(B) ' Hz'];

% plot DFT of f(t)

% w_end = N/2 + 1;         % full DFT
w_end = find(w==4);         % comparing to B = 4

figure; stem(w(1:N/2 + 1), Ym(1:N/2 + 1), 'k'); xlim([w(1) w(w_end)]);
title("DFT of $f(t)$", Interpreter='latex');
xlabel("$F$ (Hz)", Interpreter="latex");
ylabel('$F_r$', Interpreter='latex');
legend(label, Location="north"); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Functions

% rect(t) function
function yvals = rect(tvals, width)
    yvals = zeros(1,length(tvals));
    for i = 1:length(tvals)
        if abs(tvals(i)) == width/2 
            yvals(i) = 0.5;
        elseif abs(tvals(i)) < width/2 
            yvals(i) = 1;
        end
    end
end

% sampled f(t) function
function y = f(t)    
    y = 8*(rectpuls(t,1) + rectpuls(t-t(end), 1));
end

% DFT of f(t) function
function Ym = DFT(y, T, T0)
    N = T0/T;

    % DFT of y(t) and the magnitude of the DFT
    Ys = T0*fft(y, N)/N;
    Ym = round(abs(Ys(1:N/2 + 1)),10);

    % apply sign flips
    coeff = 1;
    for i = 2:(length(Ym) - 1)
        Ym(i) = Ym(i)*coeff;
        if abs(Ym(i - 1)) > abs(Ym(i)) && ...
                abs(Ym(i + 1)) > abs(Ym(i))
            coeff = -coeff;
            if abs(Ym(i + 1)) > abs(Ym(i - 1))
                Ym(i) = -Ym(i);
            end
        end   
    end
end

% plotting rect(t) and the DFT of f(t) function
function rectPlot(t, Ys, B, Ym)
    N = length(Ys);
    w = B*linspace(0, 1, N/2 + 1);
    
    % problem configuration
    label = ['N = ' num2str(N) ', B = ' num2str(B) ' Hz'];

    % plot sampled f(t)
    figure; stem(t, Ys, 'k'); xlim([t(1) t(end)]);
    title("Sampled $f(t)$", Interpreter='latex');
    xlabel("$t$ (s)", Interpreter="latex"); 
    ylabel('$f_k$', Interpreter='latex');
    legend(label, Location="north"); 
    
    % plot DFT of f(t)
    figure; stem(w, Ym, 'k'); xlim([w(1) w(end)]);
    title("DFT of $f(t)$", Interpreter='latex');
    xlabel("$F$ (Hz)", Interpreter="latex");
    ylabel('$F_r$', Interpreter='latex');
    legend(label, Location="north"); 
end