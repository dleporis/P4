close all
clear

[hdr, record] = edfread('test11.edf')
hdr.label

% read data for O1 and O2 and DON'T remove the mean values
% data_o1=record(9,:);%-mean(record(9,:));
% data_o2=record(10,:);%-mean(record(10,:));
% data_p7=record(8,:);%-mean(record(8,:));
% data_p8=record(11,:);%-mean(record(11,:));

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
Fn = Fs/2;           % Nyquist frequency
T = 1/Fs;             % Sampling period
L = c;             % Length of signal
t = (0:L-1)*T;        % Time vector

%Plot raw data
figure(1)
subplot(2,1,1)
    plot(t,data_rest)
    ylabel('rest EEG O1 [microV]')
subplot(2,1,2)
    plot(t,data_ssvep)
    ylabel('ssvep EEG O1 [microV]')
    xlabel('time [sec]')
    
%% filtering
    
%high-pass filter
fc = 3; %cuttoff freq
[ b, a ] = butter( 4, fc / Fn, 'high' ); % compute low-pass filter coefficients
data_rest_high_pass = filtfilt( b, a, abs( data_rest ) ); % rectify and low-pass filter
    
[ b, a ] = butter( 4, fc / Fn, 'high' ); % compute low-pass filter coefficients
data_ssvep_high_pass = filtfilt( b, a, abs( data_ssvep ) ); % rectify and low-pass filter
    
    
%low-pass filter
fc = 40; %cuttoff freq 
[ b, a ] = butter( 4, fc / Fn, 'low' ); % compute low-pass filter coefficients
data_rest_filtered = filtfilt( b, a, abs( data_rest_high_pass ) ); % rectify and low-pass filter
    
[ b, a ] = butter( 4, fc / Fn, 'low' ); % compute low-pass filter coefficients
data_ssvep_filtered = filtfilt( b, a, abs( data_ssvep_high_pass ) ); % rectify and low-pass filter

figure(2)
subplot(2,1,1)
    plot(t,data_rest_filtered)
    ylabel('rest EEG O1 filtered [microV]')
subplot(2,1,2)
    plot(t,data_ssvep_filtered)
    ylabel('ssvep EEG O1 filtered [microV]')
    xlabel('time [sec]')

%% Fast fourier transform of unfiiltered data
Y_rest = fft(data_rest);
Y_ssvep = fft(data_ssvep);

stimulus_1 = 20; % left stimulus freq
stimulus_2 = 15; % right stimulus freq
stimulus_3 = 12; % up stimulus freq
stimulus_4 = 8.57; % bottom stimulus freq


%%
disp("IMPORTANT FFT PLOTTING")
disp("IMPORTANT FFT PLOTTING")
disp("IMPORTANT FFT PLOTTING")

% what does this part mean???
%  P2 = abs(Y_rest/L);
%  P1 = P2(1:L/2+1);
%  P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L; 

thresholdEeg = 5;
figure(3) 
subplot(2,1,1)
    P2 = abs(Y_rest/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(f, P1), hold on
    line( xlim, [ thresholdEeg thresholdEeg ], 'Color', 'g' );

    title('Single-Sided Amplitude Spectrum')
    ylabel('rest |P1(f)|')
    %plot(f,P1)
subplot(2,1,2)
    P2 = abs(Y_ssvep/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
%     plot(f,P1), hold on
%     line( xlim, [ thresholdEeg thresholdEeg ], 'Color', 'g' );
    %find peaks
    
    [peak, peak_location] = findpeaks(P1,f);
    plot(f,P1,peak_location,peak,'o'), hold on
    line( xlim, [ thresholdEeg thresholdEeg ], 'Color', 'g' );
    xlabel('f (Hz)')
ylabel('ssvep |P1(f)|')


%p = bandpower(signal,samplingRate,freqrange)
P_stimulus_1 = bandpower(data_ssvep,Fs, [stimulus_1-1, stimulus_1+1])

disp("END OF IMPORTANT FFT PLOTTING")
disp("END OF IMPORTANT FFT PLOTTING")
disp("END OF IMPORTANT FFT PLOTTING")

%% Fast fourie transform of fiiltered data
Y_rest_filtered = fft(data_rest_filtered);
Y_ssvep_filtered = fft(data_ssvep_filtered);

% P2 = abs(Y_rest/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L; % what does this mean???


figure(4)
subplot(2,1,1)
    P2 = abs(Y_rest_filtered/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(f,P1)

    title('Single-Sided Amplitude Spectrum')
    ylabel('|P1(f)|')
    plot(f,P1)
subplot(2,1,2)
    P2 = abs(Y_ssvep_filtered/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(f,P1)
    xlabel('f (Hz)')
ylabel('|P1(f)|')

%% Spectogram
figure(5)
    spectrogram(data_rest_ssvep,128,120,128,Fs,'yaxis');
