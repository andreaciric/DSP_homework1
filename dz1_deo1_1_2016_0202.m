close all
clear all
clc

%% 1.1

f1 = 1; %frekvencije odabiranja
f2 = 3;
f3 = 7;
fs = 100;
f = [f3 f1 f2]; %raspored  je drugaciji zbog sortiranja peak-ova u funkciji findpeaks

F1 = f1/fs; %relativne ucestanosti
F2 = f2/fs;
F3 = f3/fs;
Ts = 1/fs; %perioda odabiranja

N = [100 32 128 1024]; %broj tacaka

for i = 1:length(N)
    
    n = 0:N(i)-1;
    
    x = cos(2*pi*F1*n)+0.5*cos(2*pi*F2*n)+3*cos(2*pi*F3*n);
    
    %definisanje naziva y-ose
    if i==1
        y = 'x(t)';
        y_amp = '|X[n]|';
        y_amp_dB = '|X[n]|_{dB}';
    else
        y = ['x_' int2str(i-1) '(t)'];
        y_amp = ['X_' int2str(i-1) '[n]'];
        y_amp_dB = ['X_' int2str(i-1) '[n]_{dB}'];
    end
    
    %prikaz signala x(t)
    if i==1
        figure(1)
        %subplot(2,2,i)
        t = n/fs; %broj tacaka -> vreme
        plot(t,x,'r');
        xlabel('t');
        xlim([0 N(i)/fs])
        legend('x[k]','x(t)','Location', 'southwest')
        fig1 = gca; fig1.XAxis.TickLabelFormat = '%.1f s';
        fig1.XMinorTick = 'on';
        ylabel(y)
    end
    
    if i~=1
        
        %odredjivanje amplitudske karakteristike
        L = 2*N(4)*2^5;
        X = fft(x,L); %fft uradjen u 65536 ta?aka
        k = (0:L/2)*fs/L; %broj tacaka -> frekvencija 
        Xa = abs(X(1:length(k)));
        
        %crtanje amplitudske karakteristike
        figure(2)
        subplot(3,1,i-1)
        findpeaks(Xa,k,'SortStr', 'descend','NPeaks', 3)
        xlim([0 fs/5])
        xlabel('frequency')
        ylabel(y_amp)
        legend(y_amp,'peaks','Location', 'northeast')
        fig2 = gca; fig2.XAxis.TickLabelFormat = '%i Hz';
        fig2.XMinorTick = 'on';
        
%         %amplitudske karakteristike u dB
%
%         figure(3)
%         subplot(3,1,i-1)
%         plot(k,mag2db(Xa));
%         xlim([0 fs/5])
%         xlabel('frequency')
%         ylabel(y_amp_dB)
%         fig3 = gca; fig3.XAxis.TickLabelFormat = '%i Hz';
%         fig3.XMinorTick = 'on';
        
 %% 1.2   
        %odredjivanje frekvencija na osnovu peak-ova
        [pks, locs] = findpeaks(Xa,'SortStr', 'descend','NPeaks', 3);
        
        for c = 1:length(pks)
            peaks(i-1,c) = pks(c);
            frequencies(i-1,c) = k(locs(c)); %matrica frekvencija
            A(i-1,c) = abs(frequencies(i-1,c)-f(c)); %apsolutna greska
        end
  
%% 1.3        
        x_windowed = x.*blackman(N(i))';
        %x_windowed = x.*hann(N(i))';
        
        %H = sigwin.chebwin(N(i),50);
        %win = generate(H)';
        %x_windowed = x.*win;
        
        X_windowed = fft(x_windowed,L);
        Xa_windowed = abs(X_windowed(1:length(k)));
        
        figure(4)
        subplot(3,1,i-1)
        findpeaks(Xa_windowed,k,'SortStr', 'descend','NPeaks', 3)
        xlim([0 fs/5])
        xlabel('frequency')
        ylabel(y_amp)
        legend(y_amp,'peaks','Location', 'northeast')
        fig4 = gca; fig4.XAxis.TickLabelFormat = '%i Hz';
        fig4.XMinorTick = 'on';
 
%% 1.4        
        [pks_w, locs_w] = findpeaks(Xa_windowed,'SortStr', 'descend','NPeaks', 3);
    
        for c = 1:length(pks_w)
            peaks_w(i-1,c) = pks_w(c);
            frequencies_w(i-1,c) = k(locs_w(c)); %matrica frekvencija
            A_w(i-1,c) = abs(frequencies_w(i-1,c)-f(c)); %apsolutna greska
        end
        
%         %amplitudske karakteristike u dB
%
%         figure(5)
%         subplot(3,1,i-1)
%         plot(k,mag2db(Xa_windowed));
%         xlim([0 fs/5])
%         xlabel('frequency')
%         ylabel(y_amp_dB)
%         fig5 = gca; fig5.XAxis.TickLabelFormat = '%i Hz';
%         fig5.XMinorTick = 'on';
        
    end

end

%pamcenje slika
figure(1)
%suptitle('ulazni signal')
%savefig('ulazni signali')
%print('ulazni signali','-dsvg','-r0')
figure(2)
%suptitle('amplitudske karakteristike')
%savefig('amplitudske karakteristike')
%print('amplitudske karakteristike','-dsvg','-r0')
%figure(3)
%suptitle('amplitudske karakteristike u dB')
%savefig('amplitudske karakteristike u dB')
%print('amplitudske karakteristike u dB','-dsvg','-r0')
figure(4)
%suptitle('amplitudske karakteristike nakon Cebisevljeve prozorske funkcije')
%savefig('amplitudske karakteristike nakon Cebisevljeve prozorske funkcije')
%print('amplitudske karakteristike nakon Blackman-ove prozorske funkcije','-dsvg','-r0')
%figure(5)
%suptitle('amplitudske karakteristike u dB nakon Cebisevljeve prozorske funkcije')
%savefig('amplitudske karakteristike u dB nakon Cebisevljeve prozorske funkcije')
%print('amplitudske karakteristike u dB nakon Cebisevljeve prozorske funkcije','-dsvg','-r0')