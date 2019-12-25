close all
clear all
clc

[song,Fs_song]=audioread('dz1_signali\birds_airplane.wav'); 
twitter=audioplayer(song,Fs_song);

load('dz1_signali\impulse_response_birds.mat');

figure(3)
plot(impulse_response)
xlim([0 223])

savefig('Impulsni odziv')
print('Impulsni odziv','-dsvg','-r0')

K = 3;
L = floor(length(song)/K);
konv = block_convolution(song', impulse_response, L);

% figure(1)
% plot(0:length(konv)-1,konv)
% title('Rezultat funkcije block-convolution')
% xlabel('n')
% ylabel('Block-convolution')
% 
% savefig('Rezultat funkcije block-convolution')
% print('Rezultat funkcije block-convolution','-dpng','-r0')

% spektrogram signala
nfft = 2^12;
overlap = 3/4*nfft;
window = kaiser(nfft, 7); % beta [4,10] pa je 7 sredina :))))

[s,f,t1] = spectrogram(song, window, overlap, nfft, Fs_song);
s_dB = 20*log10(abs(s));

figure(2)
subplot(1,2,1)
imagesc(t1, f/1000, s_dB), title('Spektogram signala');
axis('xy');
ylim([0 Fs_song/2000])
xlabel('vreme [s]');
ylabel('ucestanost [kHz]');

% spektrogram ociscenog signala
[s1,f1,t1] = spectrogram(konv', window, overlap, nfft, Fs_song);
s1_dB = 20*log10(abs(s1));

subplot(1,2,2)
imagesc(t1, f1/1000, s1_dB), title('Spektogram ociscenog signala');
axis('xy');
ylim([0 Fs_song/2000])
xlabel('vreme [s]');
ylabel('ucestanost [kHz]');

savefig('Spektogram signala')
print('Spektogram signala','-dpng','-r0')

twitter2=audioplayer(konv',Fs_song);
audiowrite('pticice.wav',konv',Fs_song);

twitter10000=audioplayer(10000*konv',Fs_song);
audiowrite('pticice10000.wav',10000*konv',Fs_song);

