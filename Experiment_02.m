%% EXPERIMENT 02: EEG FREQUENCY BAND ANALYSIS
% Course: EC4414 / 19BM414 | CO1
% Synthetic EEG demonstration. Not suitable for clinical interpretation.
clear; close all; clc; rng(12);
fs = 256; duration = 12;
t = (0:1/fs:duration-1/fs)';
% Components are deliberately included to demonstrate canonical bands.
eeg = 18*sin(2*pi*2*t) + 10*sin(2*pi*6*t) + ...
      14*sin(2*pi*10*t) + 7*sin(2*pi*20*t) + ...
      3*sin(2*pi*36*t) + 5*randn(size(t));

N = numel(eeg);
Y = fft(eeg);
P2 = abs(Y/N).^2;
P1 = P2(1:floor(N/2)+1);
if numel(P1)>2, P1(2:end-1) = 2*P1(2:end-1); end
f = fs*(0:floor(N/2))/N;

bandNames = {'Delta';'Theta';'Alpha';'Beta';'Gamma'};
bandLimits = [0.5 4; 4 8; 8 13; 13 30; 30 45];
bandPower = zeros(size(bandLimits,1),1);
for k=1:size(bandLimits,1)
    idx = f>=bandLimits(k,1) & f<bandLimits(k,2);
    bandPower(k) = trapz(f(idx),P1(idx));
end
disp(table(bandNames,bandLimits(:,1),bandLimits(:,2),bandPower, ...
    'VariableNames',{'Band','Lower_Hz','Upper_Hz','Estimated_Power'}));

figure('Color','w','Name','EEG frequency band analysis');
subplot(2,1,1); plot(t,eeg); grid on;
xlabel('Time (s)'); ylabel('Amplitude (a.u.)'); title('Synthetic EEG signal');
subplot(2,1,2); plot(f,10*log10(P1+eps),'LineWidth',1.1); grid on;
xlim([0 50]); xlabel('Frequency (Hz)'); ylabel('Power (dB)');
title('Single-sided power spectrum');
outDir=fullfile(fileparts(mfilename('fullpath')),'..','results');
if ~exist(outDir,'dir'), mkdir(outDir); end
saveas(gcf,fullfile(outDir,'eeg_spectrum_result.png'));
