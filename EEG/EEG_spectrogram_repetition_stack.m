%% Created by Jaerong 2017/09/05  for PER & POR ephys analysis


function [summary,summary_header]=EEG_spectrogram_repetition_stack(summary, summary_header,dataROOT)



%% Load EEG Parms

EEG_parms;


%% Fig parms

fig_pos = [150 150 1200 600];



%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\Spectrogram(Repetition)\Stack\'  date];
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



[r_s,c_s]=size(summary);



for i_s= 1:c_s
    
    
    if  strcmp(summary(i_s).Visual_Inspection, '1')  && strcmp(summary(i_s).Power_criteria, '1')
        
        
        
        
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
        
        
        
        %% Maxout trial removal (for EEG only)
        
        cd([Session_folder '\EEG\']);
        load([Prefix '_maxout.mat' ]);
        ts_evt(maxout_MAT==1,:)=[];
        
        
        
        
        %% Look up the ADBitVolts
        
        bit2milivolt = str2num(summary(i_s).ADBitmilivolts); %read ADBitVolts
        
        
        %% Spectrogram window size
        
        SpectroWin= ceil(median(ts_evt(:,ChoiceLatency)));
        
        
        
        %% Extract EEG during the event period
        
        EEG_MAT=[];
        
        
        for trial_run= 1:size(ts_evt,1) % for each trial
            
            ts_vector = [];
            EEG = [];
            
            
            cd([Session_folder '\EEG\Noise_reduction']);
            csc_ID= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
            
            
            ts_vector = [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
            
            
            EEG = get_EEG(csc_ID, ts_vector, bit2milivolt);
            
            EEG_MAT{trial_run} = EEG;
            
        end
        
        
        clear EEG
        

        %% Noisy trial elimination
        
        thisPower =[];
        
        for trial_run= 1:size(EEG_MAT,2)
            
            
            thisPower(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)));
            
            
        end
        
        
        EEG_MAT(thisPower > (mean(thisPower) + std(thisPower)*2)) =[];
        ts_evt(thisPower > (mean(thisPower) + std(thisPower)*2),:) =[];
        
        

        %% Select trial types
        
        select_trial_type;
        
        
        
        %% Calculate the frequency power
        
        Power_All=[];
        Power_Theta=[];
        Power_GammaLow=[];
        Power_GammaHigh=[];
        
        
        
        
        
        
        for trial_run= 1:size(EEG_MAT,2)
            
            Power_Theta(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.theta);
            Power_GammaLow(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.lowgamma);
            Power_GammaHigh(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.highgamma);
            
        end
        
        criteria = mean(Power_Theta) + std(Power_Theta)*2;
        to_be_voided.theta= (Power_Theta > criteria);
        
        criteria = mean(Power_GammaLow) + std(Power_GammaLow)*2;
        to_be_voided.lowgamma= (Power_GammaLow > criteria);
        
        criteria = mean(Power_GammaHigh) + std(Power_GammaHigh)*2;
        to_be_voided.highgamma= (Power_GammaHigh > criteria);
        
        
        
        
        
        %% Create figures
        %% Print out cell ID
        
        
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        
        subplot('Position', [0.35 0.98 0.3 0.2]);
        text(0,0,Prefix,'fontsize',14);
        axis off;
        
        
        
        %% Draw spectrogram
        
        
        subplot('position',[0.05 0.1 0.25 0.8]);
        

        SpectrumLength= [];
        thisSpectum=[];
        thisMAT= EEG_MAT;
        thisMAT(to_be_voided.theta)=[];
        
%         EEG_MAT= EEG_MAT(select.Novel);
        
        for trial_run = 1:size(thisMAT,2)
        
        [S,T,F] = mtspecgramc(thisMAT{trial_run}',movingwin, params); S=abs(S)';
        freq_range_ind= find(F<=freq_range.theta(end) & F>=freq_range.theta(1));
        thisSpectum= mean(10*log(S(freq_range_ind,:)));  SpectrumLength(trial_run)= numel(thisSpectum);
        imagesc(T-T(1),size(thisMAT,2)-(trial_run-1),thisSpectum); colorbar;  hold on;
        end
        
        set(gca, 'YTick',[1 size(thisMAT,2)], 'YTickLabel',sprintfc('%i',[size(thisMAT,2) 1]),'fontsize',10);
        set(gca,'YDir','Normal');
        xlim([0 SpectroWin]); ylim([0.5 size(thisMAT,2)+0.5]);
        cb= colorbar; ylabel(cb, 'Power(dB)'); box off;
        ylabel('Trial #','Fontsize',13); xlabel('Time (s)','Fontsize',13);title('Theta','Fontsize',14);
        colormap jet;
        
        
        
        subplot('position',[0.35 0.1 0.25 0.8]);
        
        

        SpectrumLength= [];
        thisSpectum=[];
        thisMAT= EEG_MAT;
        thisMAT(to_be_voided.lowgamma)=[];
        
        for trial_run = 1:size(thisMAT,2)
        
        [S,T,F] = mtspecgramc(thisMAT{trial_run}',movingwin, params); S=abs(S)';
        freq_range_ind= find(F<=freq_range.lowgamma(end) & F>=freq_range.lowgamma(1));
        thisSpectum= mean(10*log(S(freq_range_ind,:)));  SpectrumLength(trial_run)= numel(thisSpectum);
        imagesc(T-T(1),size(thisMAT,2)-(trial_run-1),thisSpectum); colorbar;  hold on;
        end
        
        set(gca, 'YTick',[1 size(thisMAT,2)], 'YTickLabel',sprintfc('%i',[size(thisMAT,2) 1]),'fontsize',10);
        set(gca,'YDir','Normal');
        xlim([0 SpectroWin]); ylim([0.5 size(thisMAT,2)+0.5]);
        cb= colorbar; ylabel(cb, 'Power(dB)'); box off;
        xlabel('Time (s)','Fontsize',13);title('LowGamma','Fontsize',14);
        colormap jet;
        
        
        
        
        
        subplot('position',[0.7 0.1 0.25 0.8]);
        
        

        SpectrumLength= [];
        thisSpectum=[];
        thisMAT= EEG_MAT;
        thisMAT(to_be_voided.highgamma)=[];
        
        
        for trial_run = 1:size(thisMAT,2)
        
        [S,T,F] = mtspecgramc(thisMAT{trial_run}',movingwin, params); S=abs(S)';
        freq_range_ind= find(F<=freq_range.highgamma(end) & F>=freq_range.highgamma(1));
        thisSpectum= mean(10*log(S(freq_range_ind,:)));  SpectrumLength(trial_run)= numel(thisSpectum);
        imagesc(T-T(1),size(thisMAT,2)-(trial_run-1),thisSpectum); colorbar;  hold on;
        end
        
        set(gca, 'YTick',[1 size(thisMAT,2)], 'YTickLabel',sprintfc('%i',[size(thisMAT,2) 1]),'fontsize',10);
        set(gca,'YDir','Normal');
        xlim([0 SpectroWin]); ylim([0.5 size(thisMAT,2)+0.5]);
        cb= colorbar; ylabel(cb, 'Power(dB)'); box off;
        xlabel('Time (s)','Fontsize',13);title('HiGamma','Fontsize',14);
        colormap jet;        
        
        
        
        
        %% Save figure
        
        cd(saveROOT)
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
    end  %  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
    
    
end %   i_s= 1:c_s



end  % function
