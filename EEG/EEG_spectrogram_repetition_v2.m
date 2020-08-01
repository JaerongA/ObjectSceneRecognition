%% Created by Jaerong 2017/09/05  for PER & POR ephys analysis


function [summary,summary_header]=EEG_spectrogram_repetition_v2(summary, summary_header,dataROOT)



%% Load EEG Parms

EEG_parms;


%% Fig parms

fig_pos = [100 200 1600 850];



%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\Spectrogram(Repetition)\'  date];
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
        

        % Set EEG info
        
        set_eeg_prefix;
        
        
        %% Loading trial ts info from ParsedEvents.mat
        
        
        % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        % 13. StimulusCat
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load_ts_evt;
        
        
        % Maxout trial removal (for EEG only)
        
        cd([Session_folder '\EEG\']);
        load([Prefix '_maxout.mat' ]);
        ts_evt(maxout_MAT==1,:)=[];
        
        
        %% Look up the ADBitVolts
        
        bit2milivolt = str2num(summary(i_s).ADBitmilivolts); %read ADBitVolts
        
        
        
        %         % Extract EEG during the event period
        %
        %         eventEEG=[];
        %
        %
        %         for trial_run= 1:size(ts_evt,1) % for each trial
        %
        %
        %             ts_vector = [];
        %             EEG = [];
        %
        %
        %
        %             ts_vector =  [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
        %
        %
        %             cd([Session_folder '\EEG\Noise_reduction']);
        %             csc_ID= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
        %
        %
        %
        %             EEG = get_EEG(csc_ID, ts_vector, bit2milivolt);
        %
        %             EEG= EEG(1:nb_data_points);
        %
        %
        %             eventEEG(trial_run,:) = EEG;   %% Raw EEG for trials
        %
        %         end
        %
        %
        %         clear EEG
        
        
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
        
        
        % Noisy trial elimination
        
        thisPower =[];
        
        for trial_run= 1:size(EEG_MAT,2)
            
            
            thisPower(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)));
            
            %         plot(cell2mat(EEG_MAT(trial_run)));
            
        end
        
        %         plot(cell2mat(EEG_MAT(10)));
        
        
        EEG_MAT(thisPower > (mean(thisPower) + std(thisPower)*2)) =[];
        ts_evt(thisPower > (mean(thisPower) + std(thisPower)*2),:) =[];
        
        
        %% Select trial types
        
        select_trial_type;
        
        clear EEG
        
        
        %% Built a spectral matrix based on the EEG trace from the novel and familiar trials
        
        EEG_OBJ=[];
        
        EEG_OBJ = EEG_MAT(select.Familiar_Corr);
        
        EEG_trial.Familiar=[]; 
        
        for trial_run = 1: size(EEG_OBJ,2)
            
            
            EEG_trial.Familiar= [EEG_trial.Familiar EEG_OBJ{trial_run}];
            EEG_trial.Familiar(end:end+10)=nan;
            
        end
        
        
        
        EEG_OBJ=[];
        
        EEG_OBJ = EEG_MAT(select.Novel_Corr);
        
        EEG_trial.Novel=[]; 
        
        for trial_run = 1: size(EEG_OBJ,2)
            
            
            EEG_trial.Novel= [EEG_trial.Novel EEG_OBJ{trial_run}];
            EEG_trial.Novel(end:end+10)=nan;
            
        end
        
        
        %% Create figures
        %% Print out cell ID
        
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        
        subplot('Position', [0.35 0.98 0.3 0.2]);
        text(0,0,Prefix,'fontsize',14);
        axis off;
        
        %% Draw spectrogram
        
        subplot('position',[0.08 0.8 0.9 0.10]);
        
        %         [S F T] =spectrogram(EEG_trial,windowsize,noverlap,nfft,sampling_freq,'yaxis');
        %         freq_range_ind= find(F<=freq_range.all(end) & F>=freq_range.all(1));
        %         F= F(freq_range_ind,:); S= S(freq_range_ind,:);
        %         imagesc(T,F,10*log10(abs(S)));
        
        [S,T,F] = mtspecgramc(EEG_trial.Familiar',movingwin, params); S=abs(S)';
        freq_range_ind= find(F<=freq_range.highgamma(end) & F>=freq_range.highgamma(1));
        
        imagesc(T,F(freq_range_ind),10*log(S(freq_range_ind,:))); set(gca,'YDir','normal'); colorbar;  cb= colorbar; ylabel(cb, 'Power(dB)'); colormap jet;
        set(gca,'YDir','Normal');
        set(gca, 'XTick',[]);
%         colormap(flipud(hot)); box off;
        colormap(jet); box off;
        ylabel('Frequency','Fontsize',13);
        
        subplot('position',[0.08 0.6 0.9 0.13]);
        
        %         [S F T] =spectrogram(EEG_trial,windowsize,noverlap,nfft,sampling_freq,'yaxis');
        %         freq_range_ind= find(F<=freq_range.all(end) & F>=freq_range.all(1));
        %         F= F(freq_range_ind,:); S= S(freq_range_ind,:);
        %         imagesc(T,F,10*log10(abs(S)));
        
        [S,T,F] = mtspecgramc(EEG_trial.Novel',movingwin, params);
        imagesc(T,F,10*log10(abs(S))'); set(gca,'YDir','normal'); colorbar;  colormap jet;
        set(gca,'YDir','Normal');
        set(gca, 'XTick',[]);
        colormap jet; box off;
        xlabel('Trial','Fontsize',13);  ylabel('Frequency','Fontsize',13);
        title('Novel(Corr)');
        
        clear EEG_OBJ EEG_MAT EEG_trial
        
        %% Save figure
        
        cd(saveROOT)
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        %         theta_ind= find(F<=freq_range.theta(end) & F>=freq_range.theta(1));
        %         lowgamma_ind= find(F<=freq_range.lowgamma(end) & F>=freq_range.lowgamma(1));
        %         highgamma_ind= find(F<=freq_range.highgamma(end) & F>=freq_range.highgamma(1));
        %
        %
        %
        %         S_theta= S(theta_ind,:);
        %         S_lowgamma= S(lowgamma_ind,:);
        %         S_highgamma= S(highgamma_ind,:);
        %
        %         figure();
        %         plot(mean(abs(S_theta)),'r','linewidth',2); hold on;
        %         plot(mean(abs(S_lowgamma)),'b','linewidth',2);  hold on;
        %         plot(mean(abs(S_highgamma)),'g','linewidth',2);  legend('theta','loGamma','hiGamma');
        
        
        
        
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
        
        
    end  %  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
    
    
end %   i_s= 1:c_s



end  % function
