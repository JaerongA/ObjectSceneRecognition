%% Created by Jaerong 2017/02/27  for PER & POR ephys analysis


function [summary,summary_header]=EEG_detrending(summary, summary_header,dataROOT)


cd(dataROOT);
pre_folder=[];




freq_range.all = [0 150];
freq_range.delta = [1 4]; freq_range.theta = [4 12]; freq_range.lowgamma = [30 50]; freq_range.highgamma = [70 110];
nb_data_points= 2000;
sampling_freq= 2000;
period=(1/sampling_freq)*10^6;



%% mtspectrumc parameter
params.Fs = 2000;               %frequency; here is EEG data frequency
params.tapers = [5 9];          %tapers [TimeBandWidth multipleTAPERS]; 5 is recommended for 500ms window (3 is recormended for 300ms window size)
params.trialave = 1;            %if trial to be averaged, set 1
params.err = 1;
params.fpass = [0 200];
params.pad= 0;


timeSET=1;
BROI = (timeSET)*1E6;               %set Big window for loading event EEG data; 1.5 times bigger than ROI



%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\Detrending\' date];
% saveROOT= [dataROOT '\Analysis\EEG\Power\'];

if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)



% %% Output file
%
% outputfile= ['EEG_POWER_' date '.txt'];
%
% fod=fopen(outputfile,'w');
% fprintf(fod,'Rat \tsession \tTT \ttask \tRegion \tlayer \ttheta_power(sampling) \tgamma_low_power(sampling) \tgamma_high_power(sampling) \ttheta_power(choice) \tgamma_low_power(choice) \tgamma_high_power(choice)');
% fprintf(fod,'\n');
% fclose(fod);


fig_pos = [320 600 950 350];




[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    %     if  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
    
    
    
    set_eeg_prefix;
    
    
    
    if ~strcmp(pre_folder,Session_folder)
        
        
        load_ts_evt;
        
        
        
        pre_folder= Session_folder;
    else
    end %(pre_folder== Session_folder)
    
    
    %     csc_ID= sprintf('CSC%s_60HZ_filtered.ncs',summary(i_s).TT);
    %
    %     filtering_root= [Session_folder '\EEG\60HZ_filtered'];
    %
    %     cd(filtering_root);
    
    
    cd(Session_folder);
    
    
    csc_ID= sprintf('CSC%s_RateReduced.ncs',summary(i_s).TT);
    
    
    [header] = Nlx2MatCSC(csc_ID, [0 0 0 0 0],1,1,[]); % look for ADBitVolts to convert eegs values from bits to volts
    bit2volt = str2num(header{15}(1, 14:end)); %read ADBitVolts
    clear header
    
    
    
    %% Extract EEG during samplig period (object sampling to object touch)
    
    EEG_MAT=[];
    ts_vector= [];
    
    
    for trial_run=1:size(ts_evt,1) % for each trial
        
        ts_vector = [];
        EEG = [];
        
        
        ts.StimulusOnset = (ts_evt(trial_run,StimulusOnset)*1E6);
        ts.Choice = (ts_evt(trial_run,Choice)*1E6);
        
        ts_vector = [ts.StimulusOnset-BROI ts.Choice+BROI];
        
        
        [EEGTimestamps, EEG] = Nlx2MatCSC(csc_ID, [1 0 0 0 1], 0, 4, ts_vector);
        
        %         [ts, ChannelNumbers, sampling_freq, NumValSamples, eeg, header] = Nlx2MatCSC(csc_ID, [1 1 1 1 1], 1, 1,[]);
        
        nb_smp_ts=size(EEGTimestamps,2);
        nb_smp_eeg=size(EEG,2);
        EEG=reshape(EEG,1,512*nb_smp_eeg);
        nb_eeg=size(EEG,2);
        
        eeg_ts=zeros(1,nb_eeg);
        %         period=(1/sfreq(1))*1000000;
        
        
        
        for i=1:nb_smp_ts
            start=1+(512*(i-1));
            stop=(512*i);
            eeg_ts(start:stop)=EEGTimestamps(i);
        end
        for i=1:nb_eeg
            eeg_ts(i)=eeg_ts(i)+(mod(i-1,512) *period);
        end        %                     eeg_ts=EEG_MAT;
        
        
        eeg_ind= find(eeg_ts <= ts.Choice & eeg_ts >= ts.StimulusOnset);
        
        EEG= EEG(eeg_ind);
        
        
        noise_ratio= sum(sum(EEG==-32767 | EEG==32767)) / numel(EEG)
        
        %         EEG= EEG.*bit2volt;
        %         EEG= EEG.*10^6;
        
        EEG_MAT{trial_run} = EEG;
        
        figure(), plot(EEG_MAT{trial_run}), box off; hold on;
        
        clear eeg* nb_eeg nb_smp_eeg nb_smp_ts
        %             else
        %             end
    end
    
    
    
    y = doFilter(EEG);
    plot(y);
    
    
    figure();
    [S,f]=mtspectrumc(EEG,params);
    plot(f,10*log10(S),'linewidth',2); box off;hold on;
    xlim(freq_range.all);
    xlabel('Frequency (Hz)');
    ylabel('Power(dB)');
    
    [S,f]=mtspectrumc(y,params);
    plot(f,10*log10(S),'r','linewidth',2); box off;
    
    
    
    
    
    
    
    
    
    n=3;
    Wn=[59 61];
    Fn= sampling_freq(1)/2;  %% Nyquist frequency
    ftype='stop';
    [b,a]= butter(n, Wn/Fn, ftype);
    eeg_filtered= filter(b,a,eeg_filtered);
    
    
    
    
    
    
    
    
    n=5;
    Wn=4;
    Fn= sampling_freq(1)/2;  %% Nyquist frequency
    ftype='high';
    [b,a]= butter(n, Wn/Fn, ftype);
    eeg_filtered= filter(b,a,EEG);
    
    
    
    figure();
    [S,f]=mtspectrumc(eeg_filtered,params);
    plot(f,10*log10(S),'linewidth',2); box off;hold on;
    xlim(freq_range.all);
    xlabel('Frequency (Hz)');
    ylabel('Power(dB)');
    
    
    
    %     figure(), for i= 1:4, subplot(1,4,i), plot(EEG_MAT{i}), box off; hold on; end
    
    
    EEG = cell2mat(EEG_MAT);
    EEG = EEG.*1E6;  %% microvolt conversion
    
    
    
    
    %% Reassemble the data block
    %% Number of data points (in blocks, the number in the power of 2)
    
    EEG_row= nb_data_points;
    EEG_col = floor(numel(EEG)/nb_data_points);
    
    EEG((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
    EEG= reshape(EEG, EEG_row, EEG_col);
    
    clear EEG_row EEG_col
    
    
    
    
    %% Create figures
    %% Print out cell ID
    
    
    fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
    
    subplot('Position', [0.3 0.98 0.3 0.2]);
    text(0,0,Prefix,'fontsize',12);
    axis off;
    
    
    %% Check the power density function in the event period
    
    subplot('Position', [0.1 0.15 0.4 0.7]);
    figure();
    [S,f]=mtspectrumc(EEG,params);
    plot(f,10*log10(S),'linewidth',2); box off;
    xlim(freq_range.all);
    xlabel('Frequency (Hz)');
    ylabel('Power(dB)');
    
    
    
    n=3;
    Wn=[59 61];
    Fn= sampling_freq(1)/2;  %% Nyquist frequency
    ftype='stop';
    [b,a]= butter(n, Wn/Fn, ftype);
    eeg_filtered= filter(b,a,EEG);
    
    
    %
    %     %% mtspectrumc parameter
    % params.Fs = 2000;               %frequency; here is EEG data frequency
    % params.tapers = [5 9];          %tapers [TimeBandWidth multipleTAPERS]; 5 is recommended for 500ms window (3 is recormended for 300ms window size)
    % params.trialave = 1;            %if trial to be averaged, set 1
    % params.err = 0;
    % params.fpass = [0 200];
    % params.pad= 0;
    %
    %
    %
    % figure();
    %     [S,f]=mtspectrumc(filteredEEG,params);
    %     plot(f,10*log10(S),'linewidth',2); box off;hold on;
    %     xlim(freq_range.all);
    %     xlabel('Frequency (Hz)');
    %         ylabel('Power(dB)');
    %
    %
    %     n=4;
    %     Wn=[59 61];
    %     Fn= sampling_freq(1)/2;  %% Nyquist frequency
    %     ftype='stop';
    %     [b,a]= butter(n, Wn/Fn, ftype);
    %     eeg_filtered= filter(b,a,EEG);
    %
    %
    %
    %
    %
    %
    %
    %     figure();
    %
    %     plot(EEG); hold on;
    %
    %         %% 60 Hz elimination (using butter function)
    %
    %     n=4;
    %     Wn=[3 300];
    %     Fn= sampling_freq(1)/2;  %% Nyquist frequency
    %     ftype='bandpass';
    %     [b,a]= butter(n, Wn/Fn, ftype);
    %
    %
    % filteredEEG = filtfilt(b, a, EEG);
    %
    % plot(filteredEEG);
    %
    %
    %
    %     Wn=[59 61];
    %     Fn= sampling_freq(1)/2;  %% Nyquist frequency
    %     ftype='stop';
    %     [b,a]= butter(n, Wn/Fn, ftype);
    %     filteredEEG= filter(b,a,filteredEEG);  plot(filteredEEG);
    %
    %
    
    
    %% Calculate the frequency power
    
    
    Power.all = bandpower(S,f,'psd');
    
    Power.delta = bandpower(S,f,freq_range.delta,'psd');
    
    Power.theta = bandpower(S,f,freq_range.theta,'psd');
    
    Power.gamma_low = bandpower(S,f,freq_range.lowgamma,'psd');
    
    Power.gamma_high = bandpower(S,f,freq_range.highgamma,'psd');
    
    %     per_power.theta.choice = 100*(Power.theta/Power.all  );
    
    
    %             per_power.theta = 100*(Power.theta/ptot );
    %             per_power.theta.choice = 100*(Power.theta.choice/Power.all );
    %
    %             per_power.gamma_low = 100*(Power.gamma_low/ptot );
    %             per_power.gamma_low.choice = 100*(Power.gamma_low.choice/ptot.choice );
    %
    %             per_power.gamma_high = 100*(Power.gamma_high/ptot );
    %             per_power.gamma_high.choice = 100*(Power.gamma_high.choice/ptot.choice );
    
    
    
    
    subplot('Position', [0.65 0.15 0.2 0.3]);
    axis off;
    
    msg= sprintf('Total power  = %1.2f (mV^2)', Power.all/1E3);
    text(0,2,msg,'units','normalized','fontsize',13);
    
    
    msg= sprintf('gamma(high) power  = %1.2f (mV^2)', Power.gamma_high/1E3);
    text(0,1.6, msg,'fontsize',13);
    
    msg= sprintf('gamma(low) power  = %1.2f (mV^2)', Power.gamma_low/1E3);
    text(0,1.2, msg,'fontsize',13);
    
    msg= sprintf('theta power  = %1.2f (mV^2)', Power.theta/1E3);
    text(0,.8, msg,'fontsize',13);
    
    msg= sprintf('delta power  = %1.2f (mV^2)', Power.delta/1E3);
    text(0,.4, msg,'fontsize',13);
    
    
    
    %% Save figure for verification
    
    cd(saveROOT)
    
    filename=[Prefix  '.png'];
    saveImage(fig,filename,fig_pos);
    
    
    %         cd(saveROOT);
    %
    %
    %         % fprintf(fod,'Rat \tsession \tTT \ttask \tRegion \tlayer \ttheta_power(sampling) \tgamma_low_power(sampling) \tgamma_high_power(sampling) \ttheta_power(choice) \tgamma_low_power(choice) \tgamma_high_power(choice)');
    %
    %         fod=fopen(outputfile,'a');
    %         fprintf(fod,'%s \t%s \t%s \t%s \t%s \t%s \t%1.2f \t%1.2f \t%1.2f \t%1.2f \t%1.2f \t%1.2f', rat, session, TT, task, region, layer...
    %             , Power.theta/1E3, Power.gamma_low/1E3, Power.gamma_high/1E3, Power.theta.choice/1E3, Power.gamma_low.choice/1E3, Power.gamma_high.choice/1E3);
    %         fprintf(fod, '\n');
    %         fclose('all');
    %
    %
    %         filename_png=[Prefix '-' date '.png'];
    %         saveImage(fig,filename_png,fig_pos);
    
    
    %     end  %  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
    
    
end %   i_s= 1:c_s



end  % function
