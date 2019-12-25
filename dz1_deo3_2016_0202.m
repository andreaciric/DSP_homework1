close all
clear all
clc

tic
load('dz1_signali\sonar_signals.mat');
load('dz1_signali\lp_filter.mat');

Fs = 200000;
t = 0:1/Fs:1.1;

figure(2)
subplot(2,1,1)
plot(t,txSignal(1:length(t)))
title('poslati signal')
xlim([0 1.1])
fig3 = gca;
fig3.XAxis.TickLabelFormat = '%.1f s';
fig3.XMinorTick = 'on';

subplot(2,1,2)
plot(t,rxSignal(1:length(t)))
title('primljeni signal')
xlim([0 1.1])
fig2 = gca;
fig2.XAxis.TickLabelFormat = '%.1f s';
fig2.XMinorTick = 'on';

% savefig('sonar')
% print('sonar','-dsvg','-r0')

% ovde sam htela da odredim K tako da mi treba najmanje vremena da se izvsi
% funkcija block_convolution i iz nekoliko iteracija dobila da je to K = 15
% 
% for K = 5:5:50
%     L = floor(length(rxSignal)/K);
%     tic
%     filtered = block_convolution(rxSignal.*txSignal,lp_filter,L);
%     toc
% end

K = 15;
L = floor(length(rxSignal)/K);
filtered = block_convolution(rxSignal.*txSignal,lp_filter,L);

% spektrogram signala
nfft = 2^18;
overlap = 3/4*nfft;
window = kaiser(nfft, 7); % beta [4,10] pa je 7 sredina :))))
Fs = 200000;

c = 1500;
b = (60-20)/0.01;

[s2,f2,t2] = spectrogram(rxSignal.*txSignal, window, overlap, nfft, Fs);
s2_dB = 20*log10(abs(s2));

figure(1)
imagesc(t2, f2, s2_dB), title('Spektogram nefiltriranog signala');
axis('xy');
xlabel('vreme [s]');
ylabel('frequency [Hz]');

savefig('sonar nefiltriran')
print('sonar nefiltriran','-dpng','-r0')

[s1,f1,t1] = spectrogram(filtered, window, overlap, nfft, Fs);
s1_dB = 20*log10(abs(s1));

figure(3)
imagesc(t1, f1*c/(2*b), s1_dB), title('Spektogram filtriranog signala');
axis('xy');
ylim([0 8000])
xlabel('vreme [s]');
ylabel('rastojanje [m]');

savefig('sonar filtriran')
print('sonar filtriran','-dpng','-r0')

toc