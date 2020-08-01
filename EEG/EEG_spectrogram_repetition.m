%% Created by Jaerong 2017/09/05  for PER & POR ephys analysis


function [summary,summary_header]=EEG_spectrogram_repetition(summary, summary_header,dataROOT)


pre_folder=[];



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
        
        
        
        
        if ~strcmp(pre_folder,Session_folder)
            
            
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
            
            
            
            pre_folder= Session_folder;
        else
        end %(pre_folder== Session_folder)
        
        
        
        
        % Maxout trial removal (for EEG only)
        
        cd([Session_folder '\EEG\']);
        load([Prefix '_maxout.mat' ]);
        ts_evt(maxout_MAT==1,:)=[];
        
        
        
        
        % Look up the ADBitVolts
        
        
        bit2micovolt = str2num(summary(i_s).ADBitmicrovolts); %read ADBitVolts

        
       
        
        
        %% Extract EEG during the event period
        
        EEG_MAT=[];
        
        
        for trial_run= 1:size(ts_evt,1) % for each trial
            
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
            
            EEGTS=zeros(1,nb_eeg);
            %         period=(1/sfreq(1))*1000000;
            
            
            
            for i=1:nb_smp_ts
                start=1+(512*(i-1));
                stop=(512*i);
                EEGTS(start:stop)=EEGTimestamps(i);
            end
            for i=1:nb_eeg
                EEGTS(i)=EEGTS(i)+(mod(i-1,512) *period);
            end        %                     EEGTS=EEG_MAT;
            
            
            EEG_ind= find(EEGTS <= ts.Choice & EEGTS >= ts.StimulusOnset);
            
            
            EEG= EEG(EEG_ind);
            EEGTS= EEGTS(EEG_ind);
            
            EEG= EEG.*bit2volt;
            EEG = EEG.*1E6;  %% microvolt conversion
            EEGTS = EEGTS./1E6;
            
            
            
            
            EEG_MAT{trial_run} = EEG;
            
        end
        
        
        clear EEG EEGTS
        
        
        
        %% Create figures
        %% Print out cell ID
        
        
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        
        subplot('Position', [0.35 0.98 0.3 0.2]);
        text(0,0,Prefix,'fontsize',14);
        axis off;
        
        
        
        
        for Stimulus_run = 1:4
            
            EEG_OBJ=[];
            
            
            eval(['EEG_OBJ= EEG_MAT(select.Stimulus' num2str(Stimulus_run) '_Corr);']);
            
            
            
            
            
            EEG_trial=[];
            
            for trial_run = 1: size(EEG_OBJ,2)
                
                
                
                EEG_trial= [EEG_trial EEG_OBJ{trial_run}];
                
                EEG_trial(end:end+10)=nan;
                
            end
            
            
            
            
            %% Draw spectrogram
            
            
            
                        
            
            
            [S F T] =spectrogram(EEG_trial,windowsize,noverlap,nfft,sampling_freq,'yaxis');
            freq_range_ind= find(F<=freq_range.all(end) & F>=freq_range.all(1));
            F= F(freq_range_ind,:); S= S(freq_range_ind,:);
            imagesc(T,F,10*log10(abs(S)));
            
            subplot('position',[0.08 0.8-((Stimulus_run-1)/4) 0.9 0.15]);

            
            
            
            %             [S,T,F] = mtspecgramc(EEG_trial',movingwin, params);
            %             imagesc(T,F,log10(abs(S))'); set(gca,'YDir','normal'); colorbar;  colormap jet;
            
            %             imagesc(T,F,mapminmax(abs(S)')); set(gca,'YDir','normal'); colorbar;
            
            
            set(gca,'YDir','Normal');
            set(gca, 'XTick',[]);
            colormap jet; box off;
            set(gca, 'XTick',[T(5) T(end)],'XTickLabel', sprintfc('%d',[1 size(find(ts_evt(:,Stimulus)== Stimulus_run & ts_evt(:,Correctness)==1))]));
            xlabel('Trial','Fontsize',13);  ylabel('Frequency','Fontsize',13);
            text(-0.09, 0.5, Stimulus_str{Stimulus_run},'units','normalized', 'fontsize', 11);
            
            
        end
        
        
        
        clear EEG_OBJ EEG_MAT EEG_trial
        
        %         imagesc(t,f,mapminmax((abs(S1))')); set(gca,'YDir','normal'); colorbar;  colormap jet;
        
        
        
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
