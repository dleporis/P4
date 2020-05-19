% filtering -doesn't work
% O1 O2 electrodes comparison
% O1 O2 averaging
% excel write
% plot ranges 

close all;
clc;
clear all;
echo off;
fig_count = 1;


plot_all = true;
% resuls matrix - final database containng results
% filename, label - supposed stimulus freq,//closest frequency method// found frequency, result command, correctness 
% //peaks in range method// found frequency, result command, correctness
results = cell(60,6);
results_row = 1;
results(results_row, 1) = cellstr("Filename");
results(results_row, 2) = cellstr("Correct command");
results(results_row, 3) = cellstr("Detected cmd (single value)");
results(results_row, 4) = cellstr("Cmd correct?");
results(results_row, 5) = cellstr("Detected cmd (ramge area)");
results(results_row, 6) = cellstr("Cmd correct?");
results_row = results_row + 1;
correct_instances = 0;
correct_instances_area = 0;
stimulus_1 = 20; % left stimulus freq
stimulus_2 = 15; % right stimulus freq
stimulus_3 = 12; % up stimulus freq
stimulus_4 = 8.57; % bottom stimulus freq

if ispc
    addpath 'C:\Users\Damian\Documents\OneDrive - Aalborg Universitet\4_Semester\P4\Source\EEGrecordings'
    addpath 'C:\Users\Damian\Documents\OneDrive - Aalborg Universitet\4_Semester\P4\Source\EEGrecordings\test_60sec'

elseif ismac
    % Code to run on Mac platform
    addpath '/Users/Damian/Documents/OneDrive - Aalborg Universitet/4_Semester/P4/Source/EEGrecordings/'
    addpath '/Users/Damian/Documents/OneDrive - Aalborg Universitet/4_Semester/P4/Source/EEGrecordings/test_60sec'
end

for group = 1:1:4
    switch group
        case 1
            file_group = 8;
            correct_command = "DOWN"; %stimulus_4 = 8.57
        case 2
            file_group = stimulus_3; %stimulus_3 = 12;
            correct_command = "UP";
        case 3
            file_group = stimulus_2; %stimulus_2 = 15
            correct_command = "RIGHT"; 
        case 4
            file_group = stimulus_1; %stimulus_1 = 20
            correct_command = "LEFT";
    end
        
    for trial_number = 1:15
        file_name = "test" + string(file_group)+ "_" + string(trial_number) + ".edf";
        results(results_row, 1) = cellstr(file_name);
        results(results_row, 2) = cellstr(correct_command);
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
        
        plot_all = false;
        if plot_all == true
            % plot raw data
            figure(fig_count); 
            fig_count = fig_count+1;
            plot(t,data)
        end
%     end
% end
        %%
        
        if trial_duration > 35
            % slice the recording
            data_rest=data(1,Fs*5:Fs*15);
            data_ssvep=data(1,Fs*25:Fs*35);
            data_after_ssvep=data(1,Fs*45:Fs*55);
            
            t_rest=t(1,Fs*5:Fs*15);
            t_ssvep=t(1,Fs*25:Fs*35);
            t_after_ssvep=t(1,Fs*45:Fs*55);
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
        
        plot_all = false;
        if plot_all == true
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
        end
        %% filtering - unfortunatelly doesn't bring good results
        %{
        %high-pass filter
        fc = 3; %cuttoff freq
        [ b, a ] = butter( 4, fc / Fn, 'high' ); % compute low-pass filter coefficients
        data_rest_high_pass = filtfilt( b, a, abs( data_rest ) ); % rectify and low-pass filter
        
        fc = 1; %cuttoff freq
        [ b, a ] = butter( 2, fc / Fn, 'high' ); % compute low-pass filter coefficients
        data_ssvep = filtfilt( b, a, abs( data_ssvep ) ); % rectify and low-pass filter

        
        %low-pass filter
        fc = 50; %cuttoff freq 
        [ b, a ] = butter( 2, fc / Fn, 'low' ); % compute low-pass filter coefficients
        data_ssvep = filtfilt( b, a, abs( data_ssvep ) ); % rectify and low-pass filter

        %}
        %% Fast fourier transform of data
        Y_rest = fft(data_rest);
        Y_ssvep = fft(data_ssvep);
        Y_after = fft(data_after_ssvep);
        thresholdEeg = 0.5;
        
        f = Fs*(0:round(L_rest/2))/L_rest; 
        P2 = abs(Y_rest/L_rest);
        P1 = P2(1:round(L_rest/2+1));
        P1(2:end-1) = 2*P1(2:end-1);
        
        f = Fs*(0:round(L_ssvep/2))/L_ssvep;
        P2 = abs(Y_ssvep/L_ssvep);
        P1 =  P2(1:round(L_ssvep/2+1));
        
        P1(2:end-1) = 2*P1(2:end-1);

        %% find STRONGEST SSVEP
        % frequency in graph closest to stimulus_1 freq.
        s_freq_marg = 25;
        [c, index_s_1] = min(abs(f-stimulus_1));
        s_1_val = P1(index_s_1);
        % fprintf('value pre-range: %d', s_1_val)
        
        %calculate the area between stimulus-1Hz and stimulus+1Hz
        s_1_area = 0;
        for i = index_s_1-s_freq_marg: index_s_1+s_freq_marg
            trapezoid_area = 0.5*(f(i+1)-f(i))*(P1(i)+P1(i+1));
            s_1_area = s_1_area + trapezoid_area;
        end
        
        %[pks, locs] = findpeaks(P1);

        % frequency in graph closest to stimulus_2 freq.
        [c, index_s_2] = min(abs(f-stimulus_2));
        s_2_val = P1(index_s_2);
        % fprintf('value pre-range: %d', s_2_val)
        
        %calculate the area between stimulus-1Hz and stimulus+1Hz
        s_2_area = 0;
        for i = index_s_2-s_freq_marg: index_s_2+s_freq_marg
            trapezoid_area = 0.5*(f(i+1)-f(i))*(P1(i)+P1(i+1));
            s_2_area = s_2_area + trapezoid_area;
        end
        
        
        % frequency in graph closest to stimulus_3 freq.
        [c, index_s_3] = min(abs(f-stimulus_3));
        s_3_val = P1(index_s_3);
        % fprintf('value pre-range: %d', s_3_val)
        
        %calculate the area between stimulus-1Hz and stimulus+1Hz
        s_3_area = 0;
        for i = index_s_3-s_freq_marg: index_s_3+s_freq_marg
            trapezoid_area = 0.5*(f(i+1)-f(i))*(P1(i)+P1(i+1));
            s_3_area = s_3_area + trapezoid_area;
        end
        
        
        % frequency in graph closest to stimulus_4 freq.
        [c, index_s_4] = min(abs(f-stimulus_4));
        s_4_val = P1(index_s_4);
        % fprintf('value pre-range: %d', s_4_val)
        
        %calculate the area between stimulus-1Hz and stimulus+1Hz
        s_4_area = 0;
        for i = index_s_4-s_freq_marg: index_s_4+s_freq_marg
            trapezoid_area = 0.5*(f(i+1)-f(i))*(P1(i)+P1(i+1));
            s_4_area = s_4_area + trapezoid_area;
        end
        
        
        %% find the strongest stimulus freq value
        strongest_stimulus = max([s_1_val, s_2_val, s_3_val, s_4_val]);

        %just for reference
        %stimulus_1 = 20; % left stimulus freq
        %stimulus_2 = 15; % right stimulus freq
        %stimulus_3 = 12; % up stimulus freq
        %stimulus_4 = 8.57; % bottom stimulus freq
        
        % the strongest stimulus value found, classify the command and
        % evaluate if the classification is "spot on"
        thresholdEeg = 0.02;
        if strongest_stimulus >= thresholdEeg
            if strongest_stimulus == s_1_val
                strongest_stimulus_idx = index_s_1;
                if file_group == 20
                    spot_on = 1;
                else
                    spot_on = 0;
                end
                command = "LEFT";
            elseif strongest_stimulus == s_2_val
                strongest_stimulus_idx = index_s_2;
                if file_group == 15
                    spot_on = 1;
                else
                    spot_on = 0;
                end
                command = "RIGHT";
            elseif strongest_stimulus == s_3_val
                strongest_stimulus_idx = index_s_3;
                if file_group == 12
                    spot_on = 1;
                else
                    spot_on = 0;
                end
                command = "UP";
            elseif strongest_stimulus == s_4_val
                strongest_stimulus_idx = index_s_4;
                if file_group == 8
                    spot_on = 1;
                else
                    spot_on = 0;
                end
                command = "DOWN";
            end
            ssvep_selected = true;
        else
            fprintf("no SSVEP strong enough")
            spot_on = 0;
            ssvep_selected = false;
        end
        disp(spot_on)
        results(results_row, 3) = cellstr(command);
        results(results_row, 4) = num2cell(spot_on);
        correct_instances = correct_instances + spot_on;
        
         %% find the strongest stimulus AREA
        strongest_stimulus_area = max([s_1_area, s_2_area, s_3_area, s_4_area]);

        %just for reference
        %stimulus_1 = 20; % left stimulus freq
        %stimulus_2 = 15; % right stimulus freq
        %stimulus_3 = 12; % up stimulus freq
        %stimulus_4 = 8.57; % bottom stimulus freq
        
        % the strongest stimulus area found, classify the command and
        % evaluate if the classification is "spot on"
        thresholdEegarea = 0.01 ;
        if strongest_stimulus_area >= thresholdEegarea
            
            if strongest_stimulus_area == s_1_area
                strongest_stimulus_idx = index_s_1;
                if file_group == 20
                    spot_on = 1;
                else
                    spot_on = 0;
                end
                command = "LEFT";
                
            elseif strongest_stimulus_area == s_2_area
                strongest_stimulus_idx = index_s_2;
                if file_group == 15
                    spot_on = 1;
                else
                    spot_on = 0;
                end
                command = "RIGHT";
                
            elseif strongest_stimulus_area == s_3_area
                strongest_stimulus_idx = index_s_3;
                if file_group == 12
                    spot_on = 1;
                else
                    spot_on = 0;
                end
                command = "UP";
                
            elseif strongest_stimulus_area == s_4_area
                strongest_stimulus_idx = index_s_4;
                if file_group == 8
                    spot_on = 1;
                else
                    spot_on = 0;
                end
                command = "DOWN";
            end
            
            ssvep_selected = true;
        else
            fprintf("no SSVEP area strong enough")
            spot_on = 0;
            ssvep_selected = false;
        end
        results(results_row, 5) = cellstr(command);
        results(results_row, 6) = num2cell(spot_on)
        %fprintf('area: %s',strongest_stimulus_area)
        correct_instances_area = correct_instances_area + spot_on;
        %% Plotting
        figure(fig_count); 
        fig_count = fig_count+1;
        subplot(3,1,1)
        plot(f, P1), hold on
        xlim([0 45])
        ylim([0 10])
        %line( xlim, [ thresholdEeg thresholdEeg ], 'Color', 'g' );
        title_string = 'SSVEP Amplitude Spectrum, trial label :' + file_name;
        title(title_string);
        ylabel('rest before ssvep |P1(f)|');
        %plot(f,P1)
        
        subplot(3,1,2)    
        plot(f,P1), hold on
        xlim([0 45])
        ylim([0 10])
        line( xlim, [ thresholdEeg thresholdEeg ], 'Color', 'g' );
        if ssvep_selected == true
            plot(f(strongest_stimulus_idx), strongest_stimulus,'ro')
        end
        xlabel('f (Hz)')
        ylabel('ssvep stimulus |P1(f)|')

        % plot the fft of signal after ssvep stimulus
        f = Fs*(0:round(L_after_ssvep/2))/L_after_ssvep;
        P2 = abs(Y_after/L_after_ssvep);
        P1 = P2(1:round(L_after_ssvep/2+1));
        P1(2:end-1) = 2*P1(2:end-1);
        
        subplot(3,1,3)    
        plot(f,P1), hold on
        xlim([0 45])
        ylim([0 10])
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
        plot_all = false;
        if plot_all == true
            figure(fig_count); 
            fig_count = fig_count+1;
            spectrogram(data,128,120,128,Fs,'yaxis');
        end
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
