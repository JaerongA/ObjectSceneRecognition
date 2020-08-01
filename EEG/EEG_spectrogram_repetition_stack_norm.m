%% Created by Jaerong 2017/09/26  for PER & POR ephys analysis
%% Make a trial-stacked spectrogram based on the time-normalized spectrograms


function [summary,summary_header]=EEG_spectrogram_repetition_stack_norm(summary, summary_header,dataROOT)



%% Load EEG Parms

EEG_parms;


%% Fig parms

fig_pos = [150 150 1200 900];


nb_win =30;


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



for i_s=  1:c_s
    
    
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
        
        
        
        %% Remove low latency trials (likely to be a noise)
        ts_evt((ts_evt(:,ChoiceLatency) < 0.6),:)=[];
        




        
        %% Select trial types (Correct trial only)
        
        select_trial_type;
        
        
        ts_evt= ts_evt(select.Corr,:);
        
        
        
        
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
        
        
        
        
        
        %% Calculate the frequency power
        
        Power_Theta=[];
        Power_GammaLow=[];
        Power_GammaHigh=[];
        
        
        diff_mat=[];
        
        for trial_run= 1:size(EEG_MAT,2)
            
            Power_Theta(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.theta);
            Power_GammaLow(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.lowgamma);
            Power_GammaHigh(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.highgamma);

            
        end
        
        
        criteria = mean(Power_Theta) + std(Power_Theta)*1.5;
        to_be_voided.theta= (Power_Theta > criteria);
        
        criteria = mean(Power_GammaLow) + std(Power_GammaLow)*1.5;
        to_be_voided.lowgamma= (Power_GammaLow > criteria);
        
        criteria = mean(Power_GammaHigh) + std(Power_GammaHigh)*1.5;
        to_be_voided.highgamma= (Power_GammaHigh > criteria);
        
        
        
        
        
        %% Create figures
        %% Print out cell ID
        
        
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        
        subplot('Position', [0.35 0.98 0.3 0.2]);
        text(0,0,Prefix,'fontsize',14);
        axis off;
        
        
        
        %% Draw spectrogram
        %% Theta
        
        
        subplot('position',[0.05 0.45 0.25 0.45]);
        
        
        SpectrumLength= [];
        thisSpectrum=[];
        thisMAT= EEG_MAT;
        thisMAT(to_be_voided.lowgamma)=[];
        spectrumMAT= [];
        
        trial_ind= 0;
        
        
%         for trial_run = 1:size(thisMAT,2)
%             
%             normSpectrum =[];
%             
%             [S,T,F] = mtspecgramc(thisMAT{trial_run}',movingwin, params); S=abs(S)';
%             freq_range_ind= find(F<=freq_range.theta(end) & F>=freq_range.theta(1));
%             thisSpectrum= mean(10*log(S(freq_range_ind,:)));  SpectrumLength(trial_run)= numel(thisSpectrum);
%             
%             
%             bin_size = ceil(length(thisSpectrum)/nb_win)-1;
%             
%             if bin_size
%                 trial_ind= trial_ind + 1;
%             else
%                 continue;
%             end
%             
%             for bin_run = 1:nb_win
%                 
% %                 disp([(bin_size*bin_run)-(bin_size-1):(bin_size*bin_run)])
%                 
%                 if ~(bin_run == nb_win) 
%                     normSpectrum(bin_run) = mean(thisSpectrum((bin_size*bin_run)-(bin_size-1):(bin_size*bin_run)));
%                 else
%                     normSpectrum(bin_run) = mean(thisSpectrum((bin_size*bin_run)-(bin_size-1):end));
%                 end
%                 
%             end
%             
%             
%             spectrumMAT(trial_ind,:,1) = normSpectrum;
%             imagesc([0:numel(normSpectrum)-1],trial_ind-(trial_ind-1),normSpectrum); colorbar;  hold on;
%         end
%         
%         
%         
%         
%         set(gca, 'YTick',[1 trial_ind], 'YTickLabel',sprintfc('%i',[trial_ind 1]),'fontsize',10);
%         set(gca, 'XTick',[]);
%         set(gca,'YDir','Normal');
%         xlim([0 size(spectrumMAT,2)-1]); ylim([0.5 size(spectrumMAT,1)+0.5]);
%         cb= colorbar; ylabel(cb, 'Power(dB)'); box off;
%         ylabel('Trial #','Fontsize',13); xlabel('Norm. Time','Fontsize',13);title('Theta','Fontsize',14);
        
        

        for trial_run = 1:size(thisMAT,2)
            
            normSpectrum =[];
            
            [S,T,F] = mtspecgramc(thisMAT{trial_run}',movingwin, params); S=abs(S)';
            freq_range_ind= find(F<=freq_range.theta(end) & F>=freq_range.theta(1));
            thisSpectrum= mean(10*log(S(freq_range_ind,:)));  SpectrumLength(trial_run)= numel(thisSpectrum);
            
            
            bin_size = ceil(length(thisSpectrum)/nb_win)-1;
            
            for bin_run = 1:nb_win
                
%                 disp([(bin_size*bin_run)-(bin_size-1):(bin_size*bin_run)])
                
                if ~(bin_run == nb_win) 
                    normSpectrum(bin_run) = mean(thisSpectrum((bin_size*bin_run)-(bin_size-1):(bin_size*bin_run)));
                else
                    normSpectrum(bin_run) = mean(thisSpectrum((bin_size*bin_run)-(bin_size-1):end));
                end
                
            end
            
            spectrumMAT_theta(trial_run,:) = normSpectrum;
            if isnan(mean(spectrumMAT_theta(trial_run,:))), disp(trial_run); end
            imagesc([0:numel(normSpectrum)-1],size(thisMAT,2)-(trial_run-1),normSpectrum); colorbar;  hold on;
        end
        
        set(gca, 'YTick',[1 size(thisMAT,2)], 'YTickLabel',sprintfc('%i',[size(thisMAT,2) 1]),'fontsize',10);
        set(gca, 'XTick',[]);
        set(gca,'YDir','Normal');
        xlim([0 size(spectrumMAT_theta,2)-1]); ylim([0.5 size(thisMAT,2)+0.5]);
        cb= colorbar; ylabel(cb, 'Power(dB)'); box off;
        ylabel('Trial #','Fontsize',13); xlabel('Norm. Time','Fontsize',13);title('Theta','Fontsize',14);
        colormap jet;





        
        
        %% LowGamma
        
        
        
        subplot('position',[0.35 0.45 0.25 0.45]);
        
        
        
        
        SpectrumLength= [];
        thisSpectrum=[];
        thisMAT= EEG_MAT;
        thisMAT(to_be_voided.theta)=[];
        
        for trial_run = 1:size(thisMAT,2)
            
            normSpectrum =[];
            
            [S,T,F] = mtspecgramc(thisMAT{trial_run}',movingwin, params); S=abs(S)';
            freq_range_ind= find(F<=freq_range.lowgamma(end) & F>=freq_range.lowgamma(1));
            thisSpectrum= mean(10*log(S(freq_range_ind,:)));  SpectrumLength(trial_run)= numel(thisSpectrum);
            
            
            bin_size = ceil(length(thisSpectrum)/nb_win)-1;
            
            for bin_run = 1:nb_win
                
%                 disp([(bin_size*bin_run)-(bin_size-1):(bin_size*bin_run)])
                
                if ~(bin_run == nb_win) 
                    normSpectrum(bin_run) = mean(thisSpectrum((bin_size*bin_run)-(bin_size-1):(bin_size*bin_run)));
                else
                    normSpectrum(bin_run) = mean(thisSpectrum((bin_size*bin_run)-(bin_size-1):end));
                end
                
            end
            
            spectrumMAT_lowgamma(trial_run,:) = normSpectrum;
            imagesc([0:numel(normSpectrum)-1],size(thisMAT,2)-(trial_run-1),normSpectrum); colorbar;  hold on;
        end
        
        set(gca, 'YTick',[1 size(thisMAT,2)], 'YTickLabel',sprintfc('%i',[size(thisMAT,2) 1]),'fontsize',10);
        set(gca, 'XTick',[]);
        set(gca,'YDir','Normal');
        xlim([0 size(spectrumMAT_lowgamma,2)-1]); ylim([0.5 size(thisMAT,2)+0.5]);
        cb= colorbar; ylabel(cb, 'Power(dB)'); box off;
        xlabel('Norm. Time','Fontsize',13);title('LowGamma','Fontsize',14);
        
        
        
        
        %% HighGamma
        
        
        
        subplot('position',[0.65 0.45 0.25 0.45]);
        
        
        
        
        SpectrumLength= [];
        thisSpectrum=[];
        thisMAT= EEG_MAT;
        thisMAT(to_be_voided.highgamma)=[];
        
        for trial_run = 1:size(thisMAT,2)
            
            normSpectrum =[];
            
            [S,T,F] = mtspecgramc(thisMAT{trial_run}',movingwin, params); S=abs(S)';
            freq_range_ind= find(F<=freq_range.highgamma(end) & F>=freq_range.highgamma(1));
            thisSpectrum= mean(10*log(S(freq_range_ind,:)));  SpectrumLength(trial_run)= numel(thisSpectrum);
            
            
            bin_size = ceil(length(thisSpectrum)/nb_win)-1;
            
            for bin_run = 1:nb_win
                
%                 disp([(bin_size*bin_run)-(bin_size-1):(bin_size*bin_run)]);
                
                if ~(bin_run == nb_win) 
                    normSpectrum(bin_run) = mean(thisSpectrum((bin_size*bin_run)-(bin_size-1):(bin_size*bin_run)));
                else
                    normSpectrum(bin_run) = mean(thisSpectrum((bin_size*bin_run)-(bin_size-1):end));
                end
                
            end
            
            spectrumMAT_highgamma(trial_run,:) = normSpectrum;
            imagesc([0:numel(normSpectrum)-1],size(thisMAT,2)-(trial_run-1),normSpectrum); colorbar;  hold on;
        end
        
        set(gca, 'YTick',[1 size(thisMAT,2)], 'YTickLabel',sprintfc('%i',[size(thisMAT,2) 1]),'fontsize',10);
        set(gca, 'XTick',[]);
        set(gca,'YDir','Normal');
        xlim([0 size(spectrumMAT_highgamma,2)-1]); ylim([0.5 size(thisMAT,2)+0.5]);
        cb= colorbar; ylabel(cb, 'Power(dB)'); box off;
        xlabel('Norm. Time','Fontsize',13);title('HighGamma','Fontsize',14);
        
             
        
        
        %% Power Avg
        
        norm_power= [];
%         
%         norm_power.theta=     mapminmax(mean(spectrumMAT(:,1:end-1,1),1),0,1);
%         norm_power.lowgamma=  mapminmax(mean(spectrumMAT(:,1:end-1,2),1),0,1);
%         norm_power.highgamma= mapminmax(mean(spectrumMAT(:,1:end-1,3),1),0,1);
        
        norm_power.theta=     mapminmax(mean(spectrumMAT_theta(:,1:end-1,1)),0,1);
        norm_power.lowgamma=  mapminmax(mean(spectrumMAT_lowgamma(:,1:end-1),1),0,1);
        norm_power.highgamma= mapminmax(mean(spectrumMAT_highgamma(:,1:end-1),1),0,1);
        
        
        
        subplot('position',[0.33 0.1 0.35 0.25]);
        
        plot([0:nb_win-2], norm_power.theta,'k','linewidth',2); hold on;
        plot([0:nb_win-2], norm_power.lowgamma,'b','linewidth',2); 
        plot([0:nb_win-2], norm_power.highgamma,'r','linewidth',2); 
        box off; lg= legend('\Theta','Low \gamma','High \gamma','location','EastOutside'); 
        set(gca, 'XTick',[]);
        xlabel('Norm. Time','Fontsize',12);
        ylabel('Norm. Power','Fontsize',12);
        
        
        
        
        
        %% Save figure
        
        cd(saveROOT)
        
        
        save([Prefix '.mat'],'norm_power');
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
        
        
    end  %  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
    
    
end %   i_s= 1:c_s



end  % function
