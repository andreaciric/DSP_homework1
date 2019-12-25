close all
clear all
clc

%% 1.6

Fs = 8000;
Ts = 1/Fs;
t = 0:Ts:5;
xc =  chirp(t,0,5,4000,'linear');

%chirp u vremenu
figure(5)
plot(t(1:length(t)/10),xc(1:length(t)/10))
xlabel('time');
fig5 = gca; fig5.XAxis.TickLabelFormat = '%.2f s';
print('Chirp vremenski','-dsvg','-r0')

signal = audioplayer(xc,Fs);

%chirp spektrogram
figure(1)
subplot(3,1,1)
pspectrum(xc,Fs,'spectrogram')
%title('Spektogram signala x_{chirp}[n], x_{chirp,d2}[n] i x_{chirp,d5}[n]')
title ('')

%% 1.7 i 1.8

t2 = 0:2*Ts:5;
xc_d2 = chirp(t2,0,5,4000,'linear');
signal2 = audioplayer(xc_d2,Fs/2);

subplot(3,1,2)
pspectrum(xc_d2,Fs/2,'spectrogram')
title('')

t5 = 0:5*Ts:5;
xc_d5 = chirp(t5,0,5,4000,'linear');
signal5 = audioplayer(xc_d5,Fs/5);

subplot(3,1,3)
pspectrum(xc_d5,Fs/5,'spectrogram')
title('')

%savefig('Spektogram signala x_{chirp}[n], x_{chirp,d2}[n] i x_{chirp,d5}[n]')
%print('Spektogram signala x_{chirp}[n], x_{chirp,d2}[n] i x_{chirp,d5}[n]','-dpng','-r0')

%% 1.9

[song,Fs_song]=audioread('dz1_signali\chopin.wav'); 
nocturno=audioplayer(song,Fs_song);

nfft = 2^12;
overlap = 3/4*nfft;
window = kaiser(nfft, 7); %kajzerova prozorska funkcija je najpogodnija za spektrogram jer se na 
                          %optimalan nacin ostvaruje kompromis izmedju
                          %duzine sekvence, frekvencijske rezolucije i
                          %curenja spektra **beta [4,10] pa je 7 sredina** :))))

[s,f,t] = spectrogram(song, window, overlap, nfft, Fs_song);
s_dB = 20*log10(abs(s));

figure(2)
imagesc(t, f(1:end/3), s_dB(1:end/3,:)), title('Spektogram signala');
axis('xy');
xlabel('Time');
ylabel('Frequency');
fig2 = gca; fig2.XAxis.TickLabelFormat = '%i s';
fig2.XMinorTick = 'on';
fig2.YAxis.TickLabelFormat = '%i Hz';
fig2.YMinorTick = 'on';

% savefig('Spektogram signala')
% print('Spektogram signala','-dpng','-r0')

%nedegradirani signal sa smanjenom frekvencijom odabiranja
fx=4;
song_new=song(1:1*fx:end);

new=audioplayer(song_new,Fs_song/fx);

[s_new,f_new,t_new] = spectrogram(song_new, window, overlap, nfft, Fs_song/fx);
s_new_dB = 20*log10(abs(s_new)); 

figure(3)
imagesc(t_new, f_new, s_new_dB), title('Spektogram nedegradiranog signala sa smanjenom frekvencijom odabiranja');
axis('xy');
xlabel('Time');
ylabel('Frequency');
fig3 = gca; fig3.XAxis.TickLabelFormat = '%i s';
fig3.XMinorTick = 'on';
fig3.YAxis.TickLabelFormat = '%i Hz';
fig3.YMinorTick = 'on';

% savefig('Spektogram nedegradiranog')
% print('Spektogram nedegradiranog','-dpng','-r0')

%% 1.10

%degradirani signal
fx=10;
song_new=song(1:1*fx:end);

new=audioplayer(song_new,Fs_song/fx);

[s_new,f_new,t_new] = spectrogram(song_new, window, overlap, nfft, Fs_song/fx);
s_new_dB = 20*log10(abs(s_new)); 

figure(4)
imagesc(t_new, f_new, s_new_dB), title('Spektogram degradiranog signala');
axis('xy');
xlabel('Time');
ylabel('Frequency');
fig4 = gca; fig4.XAxis.TickLabelFormat = '%i s';
fig4.XMinorTick = 'on';
fig4.YAxis.TickLabelFormat = '%i Hz';
fig4.YMinorTick = 'on';

% savefig('Spektogram degradiranog')
% print('Spektogram degradiranog','-dpng','-r0')