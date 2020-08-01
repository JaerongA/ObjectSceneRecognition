%% Created by Jaerong 2017/09/17  for PER & POR ephys analysis
%% Count the # of EEG samples that maxed out per channel


function [summary,summary_header]=EEG_maxout_trials(summary, summary_header,dataROOT)


cd(dataROOT);



%% EEG Parms

EEG_parms


%% Fig parms

fig_pos = [255 200 1200 500];




[r_s,c_s]=size(summary);


for i_s=    1:c_s
    
    
%     if       strcmp(summary(i_s).Rat,'r558')
        
        
        %% Set EEG info
        
        set_eeg_prefix;
        
        
        
        %% Loading trial ts info from ParsedEvents.mat
        
        
        % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        % 13. StimulusCat
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load_ts_evt;
        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        
        %% Look up the ADBitVolts
        
        bit2microvolt = str2num(summary(i_s).ADBitmicrovolts);
        
        %% Load EEG
        
        csc_ID= sprintf('CSC%s_RateReduced.ncs',summary(i_s).TT);
        cd(Session_folder);
        
        
        
        
        %% Extract EEG during the event period
        
        maxout_MAT=zeros(1,size(ts_evt,1));
        
        for trial_run= 1 :size(ts_evt,1) % for each trial
            
            
            ts_vector = [];
            EEG = [];
            
            ts_vector = [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
            
            cd(Session_folder);
            
            ts_vector= ts_vector.* 1E6;
            
            timeSET=1;
            BROI = (timeSET)*1E6;               %set Big window for loading event EEG data;
            
            EEG_wind = [ts_vector(1)-BROI ts_vector(2)+BROI];
            
            [EEGTimestamps, EEG] = Nlx2MatCSC(csc_ID, [1 0 0 0 1], 0, 4, EEG_wind);
            
            
            nb_smp_ts=size(EEGTimestamps,2);
            nb_smp_eeg=size(EEG,2);
            EEG=reshape(EEG,1,512*nb_smp_eeg);
            nb_eeg=size(EEG,2);
            
            EEG_ts=zeros(1,nb_eeg);
            
            
            
            
            for i=1:nb_smp_ts
                start=1+(512*(i-1));
                stop=(512*i);
                EEG_ts(start:stop)=EEGTimestamps(i);
            end
            for i=1:nb_eeg
                EEG_ts(i)=EEG_ts(i)+(mod(i-1,512) *period);
            end
            
            
            EEG_ind= find(EEG_ts <= ts_vector(2) & EEG_ts >=  ts_vector(1));
            EEG= EEG(EEG_ind);
            
            %             [EEG,EEGTS] = get_EEG(csc_ID, ts_vector, bit2microvolt, removenoise)
            %EEG = get_EEG(csc_ID, ts_vector, bit2microvolt);
            
            
            
            %             fig_name= sprintf('Trial = #%d  %s',ts_evt(trial_run,Trial), Prefix);
            %
            %
            %             fig=figure('name',fig_name,'Color',[1 1 1],'Position',fig_pos);
            %
            %             subplot('Position', [0.3 0.98 0.3 0.15]);
            %             text(0,0,fig_name,'fontsize',12);
            %             axis off;
            %
            %             subplot(1,1,1)
            %             plot(((EEGTS-EEGTS(1))), EEG,'Color',[.5 .5 .5]); box off;
            %             ylabel('\muV','fontsize',12); xlabel('Time(s)');
            %
            %             text(-.15 ,0.5,'Raw Trace','units','normalized','fontsize',12,'color',[.5 .5 .5]);
            
            
            if sum((abs(EEG) == 32767))
                
                maxout_MAT(trial_run)= 1;
                
            end
            
            
            clear EEG*
            close all;
            
            
            
        end
        
        maxoutprob=(sum(maxout_MAT)/numel(maxout_MAT))*100;
        disp(sprintf('max out proportion = %1.2f %%',maxoutprob));
        
        maxout_MAT =maxout_MAT';
        
        saveROOT= [Session_folder '\EEG'];
        if ~exist(saveROOT), mkdir(saveROOT); end
        cd(saveROOT)
        
%         delete('*.mat');
        save([Prefix '_maxout.mat'],'maxout_MAT');
        
        
        %% Add to summary
        
        summary(i_s).MaxoutTrials= sprintf('%1.2f',(sum(maxout_MAT)/numel(maxout_MAT))*100);
        
        
        
    end  %     strcmp(summary(i_s).Rat,'r558')
    
    
% end %   i_s= 1:c_s



end  % function
