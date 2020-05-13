close all
clear
fig_count = 1;
file_names = zeros(1,60);
file_names_number = 1;
stimulus_1 = 20; % left stimulus freq
stimulus_2 = 15; % right stimulus freq
stimulus_3 = 12; % up stimulus freq
stimulus_4 = 8.57; % bottom stimulus freq

addpath 'C:\Users\Damian\Documents\OneDrive - Aalborg Universitet\4_Semester\P4\Source\EEGrecordings'
for group = 1:1:4
    switch group
        case 1
            file_group = stimulus_1;
        case 2
            file_group = stimulus_2;
        case 3
            file_group = stimulus_3;
        case 4
            file_group = stimulus_3; %8;
    end
        
    for trial_number = 1:15
        file_name = sprintf("test%d_%d.edf",file_group,trial_number);
        file_names(file_names_number) = file_name;
        file_names_number = file_names_number+1;
        fprintf(file_name)
        %%
        %file_name = 'test8_1.edf';
        [hdr, record] = edfread(file_name);
%         [hdr, record] = edfread('test11.edf');

        % read data for O1 and O2 and remove the mean values
        data_o1=record(9,:)-mean(record(9,:));
        data_o2=record(10,:)-mean(record(10,:));
        data_p7=record(8,:)-mean(record(8,:));
        data_p8=record(11,:)-mean(record(11,:));

        % select channel data
        data=data_o1;
        
        [r,c]=size(data);
        Fs = 128;            % Sampling frequency
        Fn = Fs/2;           % Nyquist frequency
        T = 1/Fs;             % Sampling period
        L = c;             % Length of signal
        t = (0:L-1)*T;        % Time vector
        trial_duration = t(L);
        
        
        % plot raw data
        figure(fig_count); 
            fig_count = fig_count+1;
            plot(t,data)
%     end
% end
        %%
        
        if trial_duration > 35
            % slice the recording
            data_rest=data(1,1:Fs*20);
            data_ssvep=data(1,Fs*20:Fs*40);
            data_after_ssvep=data(1,Fs*40:L);
            
            t_rest=t(1,1:Fs*20);
            t_ssvep=t(1,Fs*20:Fs*40);
            t_after_ssvep=t(1,Fs*40:L);
        else
            % slice the recording 
            data_rest=data(1,1:Fs*11);
            data_ssvep=data(1,Fs*11:Fs*22);
            data_after_ssvep=data(1,Fs*20:L);

            t_rest=t(1,1:Fs*11);
            t_ssvep=t(1,Fs*11:Fs*22);
            t_after_ssvep=t(1,Fs*20:L);
        end
        L_rest = length(t_rest);
        L_ssvep = length(t_ssvep);
        L_after_ssvep = length(t_after_ssvep);
        
        %Plot raw data
        figure(fig_count); 
        fig_count = fig_count+1;
        subplot(3,1,1)
            plot(t_rest,data_rest)
            ylabel('rest before ssvep EEG O1 [microV]')
        subplot(3,1,2)
            plot(t_ssvep,data_ssvep)
            ylabel('ssvep EEG O1 [microV]')
            xlabel('time [sec]')
        subplot(3,1,3)
            plot(t_after_ssvep,data_after_ssvep)
            ylabel('after ssvep EEG O1 [microV]')
            xlabel('time [sec]')

        %% filtering
        %{
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

        figure(fig_count); 
        fig_count = fig_count+1;
        subplot(2,1,1)
            plot(t,data_rest_filtered)
            ylabel('rest EEG O1 filtered [microV]')
        subplot(2,1,2)
            plot(t,data_ssvep_filtered)
            ylabel('ssvep EEG O1 filtered [microV]')
            xlabel('time [sec]')
        %}
        %% Fast fourier transform of unfiiltered data
        Y_rest = fft(data_rest);
        Y_ssvep = fft(data_ssvep);
        Y_after = fft(data_after_ssvep);
        thresholdEeg = 0.5;
        
        f = Fs*(0:(L_rest/2))/L_rest; 
        P2 = abs(Y_rest/L_rest);
        P1 = P2(1:L_rest/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
       
        
        
        figure(fig_count); 
        fig_count = fig_count+1;
        subplot(3,1,1)
        plot(f, P1), hold on
        line( xlim, [ thresholdEeg thresholdEeg ], 'Color', 'g' );
        title_string = 'Single-Sided Amplitude Spectrum, trial label :' + file_name;
        title(title_string);
        ylabel('rest before ssvep |P1(f)|');
        %plot(f,P1)
        
        f = Fs*(0:round(L_ssvep/2))/L_ssvep;
        P2 = abs(Y_ssvep/L_ssvep);
        P1 = P2(1:round(L_ssvep/2+1));
        P1(2:end-1) = 2*P1(2:end-1);

        %% find STRONGEST SSVEP
        % frequency in graph closest to stimulus_1 freq.
        [c, index_s_1] = min(abs(f-stimulus_1));
        s_1_val = P1(index_s_1);
        fprintf('value pre-range: %d', s_1_val)
        [pks, locs] = findpeaks(P1);

        % frequency in graph closest to stimulus_1 freq.
        [c, index_s_2] = min(abs(f-stimulus_2));
        s_2_val = P1(index_s_2);
        fprintf('value pre-range: %d', s_2_val)
        
        % frequency in graph closest to stimulus_1 freq.
        [c, index_s_3] = min(abs(f-stimulus_3));
        s_3_val = P1(index_s_3);
        fprintf('value pre-range: %d', s_3_val)
        
        % frequency in graph closest to stimulus_1 freq.
        [c, index_s_4] = min(abs(f-stimulus_4));
        s_4_val = P1(index_s_4);
        fprintf('value pre-range: %d', s_4_val)
        
        % find the strongest stimulus freq
        strongest_stimulus = max([s_1_val, s_2_val, s_3_val, s_4_val]);

        %just for reference
        %stimulus_1 = 20; % left stimulus freq
        %stimulus_2 = 15; % right stimulus freq
        %stimulus_3 = 12; % up stimulus freq
        %stimulus_4 = 8.57; % bottom stimulus freq

        if strongest_stimulus >= thresholdEeg
            if strongest_stimulus == s_1_val
                strongest_stimulus_idx = index_s_1;
                disp("LEFT")
            elseif strongest_stimulus == s_2_val
                strongest_stimulus_idx = index_s_2;
                disp("RIGHT")
            elseif strongest_stimulus == s_3_val
                strongest_stimulus_idx = index_s_3;
                disp("UP")
            elseif strongest_stimulus == s_4_val
                strongest_stimulus_idx = index_s_4;
                disp("DOWN")
            end
        else
            disp("no SSVEP strong enough")
            strongest_stimulus_idx = 0;
        end

        subplot(3,1,2)    
        plot(f,P1), hold on
        line( xlim, [ thresholdEeg thresholdEeg ], 'Color', 'g' );
        plot(f(strongest_stimulus_idx), strongest_stimulus,'ro')
        xlabel('f (Hz)')
        ylabel('ssvep stimulus |P1(f)|')

        % plot the fft of signal after ssvep stimulus
        f = Fs*(0:round(L_after_ssvep/2))/L_after_ssvep;
        P2 = abs(Y_after/L_after_ssvep);
        P1 = P2(1:round(L_after_ssvep/2+1));
        P1(2:end-1) = 2*P1(2:end-1);
        
        subplot(3,1,3)    
        plot(f,P1), hold on
        xlabel('f (Hz)')
        ylabel('rest after ssvep |P1(f)|')

        %% Fast fourie transform of fiiltered data
        %{
        Y_rest_filtered = fft(data_rest_filtered);
        Y_ssvep_filtered = fft(data_ssvep_filtered);

        % P2 = abs(Y_rest/L);
        % P1 = P2(1:L/2+1);
        % P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L; % what does this mean???


        figure(fig_count); 
        fig_count = fig_count+1;
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
        %}
        %% Spectogram
        figure(fig_count); 
        fig_count = fig_count+1;
            spectrogram(data,128,120,128,Fs,'yaxis');
    end
end
%% EXAMPLE - FIND AMPLITUDE AT SPECIFIC FREQUENCY
%{
L = 5000;                                               % Create Data
t = linspace(0, 10*pi, L);
y = sin(t*2) .* cos(t*5);
Ts = mean(diff(t));                                     % Calculate Foureir Transform
Fs = 1/Ts;
Fn = Fs/2;
Fy = fft(y)/L;
Fv = linspace(0, 1, fix(L/2)+1)*Fn;
Iv = 1:length(Fv);
aFy = abs(Fy(Iv))*2;
ampHz = @(Hz) interp1(Fv, aFy, Hz, 'linear');           % Interpolation Anonymous Function
amp60 = ampHz(60)                                       % Find Amplitude At 60 Hz
figure(fig_count); 
fig_count = fig_count+1;
semilogy(Fv, aFy, '-b')
hold on
plot(60, amp60, 'rp', 'MarkerFaceColor','g')
hold off
grid
xlabel('Frequency (Hz)')
ylabel('Amplitude')
legend('Fourier Transform', 'Amplitude at Desired Frequency')

figure(fig_count); 
fig_count = fig_count+1;
plot(t, y)
grid
%}
