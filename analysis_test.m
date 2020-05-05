close all
clear

[hdr, record] = edfread('test11.edf')
hdr.label
% read data for O1 and O2 and remove the mean values
data_o1=record(9,:)-mean(record(9,:));
data_o2=record(10,:)-mean(record(10,:));
data_p7=record(8,:)-mean(record(8,:));
data_p8=record(11,:)-mean(record(11,:));

% select channel data
data=data_o2;

% note the number of samples corresponding to rest and ssvep time windows..
% in this case 9 min recording with 3 min rest, 3 min ssvep, and 3 min rest gave ca 68736 samples
data_rest=data(1,1:3900);
data_ssvep=data(1,3901:7800);
data_rest_ssvep=data(1,1:11800);


[r,c]=size(data_rest);
Fs = 128;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = c;             % Length of signal
t = (0:L-1)*T;        % Time vector

figure(1)
subplot(2,1,1)
    plot(t,data_rest)
    ylabel('EEG O1 [microV]')
subplot(2,1,2)
    plot(t,data_ssvep)
    ylabel('EEG O1 [microV]')
    xlabel('time [sec]')
    
   
Y_rest = fft(data_rest);
Y_ssvep = fft(data_ssvep);

% P2 = abs(Y_rest/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;


figure(2)
subplot(2,1,1)
    P2 = abs(Y_rest/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    %[b,a] = butter(4, 0.1/1200, 'high');
    %x1 = filtfilt(b,a,P1);
    %[b,a] = butter(4, 100/1200, 'low');
    %x2 = filtfilt(b,a,x1);
    %plot(f,x2)
    
    %a=fir1(2, [0.7 0.9], 'stop');
    %y2 = filter(a,1,P1);
    %d = designfilt('bandstopiir','FilterOrder',2, ...
               %'HalfPowerFrequency1',48,'HalfPowerFrequency2',52, ...
               %'DesignMethod','butter','SampleRate',Fs);
          %fvtool(d,'Fs',Fs);
          %noise = filtfilt(d,P1);
    %plot(f,P1)
    title('Single-Sided Amplitude Spectrum')
    ylabel('|P1(f)|')
    %[b,a] = butter(2, 49/Fs, 'high');
    %x1 = filtfilt(b,a,P1);
    %[b,a] = butter(2, 51/Fs, 'low');
    %x2 = filtfilt(b,a,x1);
    plot(f,P1)
subplot(2,1,2)
    P2 = abs(Y_ssvep/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    %a=fir1(2, [0.76 0.81], 'stop');
    %y2 = filter(a,1,P1);
    %d = designfilt('bandstopiir','FilterOrder',2, ...
              % 'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
              % 'DesignMethod','butter','SampleRate',Fs);
          %fvtool(d);
         % noise = filtfilt(d,P1)
    plot(f,P1)
    xlabel('f (Hz)')
ylabel('|P1(f)|')
figure(3)
spectrogram(data_rest_ssvep,128,120,128,Fs,'yaxis');
