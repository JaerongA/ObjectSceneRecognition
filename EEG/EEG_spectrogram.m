% Created by Jaerong 2017/09/21  for PER & POR ephys analysis


function [summary,summary_header]=EEG_spectrogram(summary, summary_header,dataROOT)


%% Load EEG Parms

EEG_parms;


%% Fig parms

fig_pos = [50 100 1700 800];



%% Save folder

saveROOT= [dataROOT '\Analysis\EEG\Spectrogram(EventPeriod)\NoiseRemoved(PowerCorrelation)\CriteriaOnly'];

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
        
        
        %         %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        %         1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        %         13. StimulusCat
        %
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load_ts_evt;
        
        
        
        %% Maxout trial removal (for EEG only)
        
        cd([Session_folder '\EEG\']);
        load([Prefix '_maxout.mat' ]);
        ts_evt(maxout_MAT==1,:)=[];
        
        
        
        %% Look up the ADBitVolts
        
        
        bit2micovolt = str2num(summary(i_s).ADBitmicrovolts); %read ADBitVolts
        
        
        %% Spectrogram window size
        
        SpectroWin= ceil(median(ts_evt(:,ChoiceLatency)));
        
        nb_data_points= sampling_freq *SpectroWin;
        
        
        
        %% Extract EEG during the event period
        
        eventEEG=[];
        
        
        for trial_run= 1:size(ts_evt,1) % for each trial
            
            
            ts_vector = [];
            EEG = [];
            
            
            
            ts_vector =  [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,StimulusOnset)+SpectroWin];
            
            
            cd([Session_folder '\EEG\Noise_reduction']);
            csc_ID= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
            
            
            
            EEG = get_EEG(csc_ID, ts_vector, bit2micovolt);
            
            EEG= EEG(1:nb_data_points);
            
            
            eventEEG(trial_run,:) = EEG;   %% Raw EEG for trials
            
        end
        
        
        clear EEG
        
        
        
        % Noisy trial elimination
        
        
        meanEEG =[];
        thisEEG= sumsqr(eventEEG);
        
        meanEEG = var(thisEEG,[],2);
        
        eventEEG((meanEEG > (mean(meanEEG) + sem(meanEEG,1)*1)),:)=[];
        ts_evt((meanEEG > (mean(meanEEG) + sem(meanEEG,1)*1)),:)=[];
        
        
        
        
        
        
        %         plot(eventEEG')
        
        maxEEG =[];
        for trial_run = 1: size(eventEEG,1)
            
            trialEEG = eventEEG(trial_run,:);
            %             plot(trialEEG);
            maxEEG(trial_run)= max(abs(trialEEG))/1E3;
        end
        
        
        eventEEG((maxEEG > (median(maxEEG) + sem(maxEEG,1)*2)),:)=[];
        ts_evt((maxEEG > (median(maxEEG) + sem(maxEEG,1)*2)),:)=[];
        
        clear maxEEG
        
        
        
        
        
        % Select trial types
        
        select_trial_type;
        
        
        
        
        % Create figures
        % Print out cell ID
        
        %         set(0,'DefaultFigureVisible','off');
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        subplot('Position', [0.35 0.98 0.3 0.2]);
        text(0,0,Prefix,'fontsize',14);
        axis off;
        
        
        
        
        
        
        % Spectrogram (Familiar)
        
        S=[];T=[];F=[];
        
        
        
        
        subplot('Position', [0.03 0.75 0.2 0.15]);
        
        
        
        [S.Familiar,T,F] = mtspecgramc(eventEEG(select.Familiar_Corr,:)',movingwin, params);
        S.Familiar=S.Familiar';
        freq_range_ind= find(F<=freq_range.theta(end) & F>=freq_range.theta(1));
        
        imagesc(T-T(1),F(freq_range_ind),10*log(S.Familiar(freq_range_ind,:))); cb= colorbar; ylabel(cb, 'Power(dB)');
        ax1= gca;
        set(gca,'YDir','Normal');  colormap jet; box off;
        title('Theta(Familiar)'); ylabel('Frequency(Hz)','fontsize',12);
        power_range(1,:)= caxis;
        
        
        
        
        subplot('Position', [0.03 0.5 0.2 0.15]);
        
        
        [S.Novel,T,F] = mtspecgramc(eventEEG(select.Novel_Corr,:)',movingwin, params);
        S.Novel=S.Novel';
        
        imagesc(T-T(1),F(freq_range_ind),10*log(S.Novel(freq_range_ind,:))); cb= colorbar; ylabel(cb, 'Power(dB)');
        ax2= gca;
        set(gca,'YDir','Normal');  colormap jet; box off;
        title('Theta(Novel)'); ylabel('Frequency(Hz)','fontsize',12);
        power_range(2,:)= caxis;
        
        caxis(ax1, [min(power_range(:,1)) max(power_range(:,2))]);
        caxis(ax2, [min(power_range(:,1)) max(power_range(:,2))]);
        
        
        
        
        subplot('Position', [0.03 0.3 0.16 0.15]);
        
        plot(T-T(1), mean(S.Familiar(freq_range_ind,:))/1E3,'b','linewidth',2); box off; hold on;
        plot(T-T(1), mean(S.Novel(freq_range_ind,:))/1E3,'r','linewidth',2); box off; hold on;
        ylabel('Power (mV^2)','fontsize',12);
        xlim(ax2.XLim);
        lh= legend('Familiar','Novel'); lh.FontSize = 8; set(lh,'Box','off','location','Northeast')
        set(lh,'pos',[0.2, 0.35, 0.04, 0.09],'units','Normalized');
        
        
        
        
        
        
        % Spectrogram (Beta)
        
        S=[]; T=[]; F=[];
        
        
        subplot('Position', [0.28 0.75 0.2 0.15]);
        
        
        
        [S.Familiar,T,F] = mtspecgramc(eventEEG(select.Familiar_Corr,:)',movingwin, params);
        S.Familiar=S.Familiar';
        freq_range_ind= find(F<=freq_range.beta(end) & F>=freq_range.beta(1));
        
        imagesc(T-T(1),F(freq_range_ind),10*log(S.Familiar(freq_range_ind,:))); cb= colorbar; ylabel(cb, 'Power(dB)');
        ax1= gca;
        set(gca,'YDir','Normal');  colormap jet; box off;
        title('Beta(Familiar)'); ylabel('Frequency(Hz)','fontsize',12);
        power_range(1,:)= caxis;
        
        
        
        
        subplot('Position', [0.28 0.5 0.2 0.15]);
        
        
        [S.Novel,T,F] = mtspecgramc(eventEEG(select.Novel_Corr,:)',movingwin, params);
        S.Novel=S.Novel';
        
        imagesc(T-T(1),F(freq_range_ind),10*log(S.Novel(freq_range_ind,:))); cb= colorbar; ylabel(cb, 'Power(dB)');
        ax2= gca;
        set(gca,'YDir','Normal');  colormap jet; box off;
        title('Beta(Novel)'); ylabel('Frequency(Hz)','fontsize',12);
        power_range(2,:)= caxis;
        
        caxis(ax1, [min(power_range(:,1)) max(power_range(:,2))]);
        caxis(ax2, [min(power_range(:,1)) max(power_range(:,2))]);
        
        
        
        
        subplot('Position', [0.28 0.3 0.16 0.15]);
        
        
        plot(T-T(1), mean(S.Familiar(freq_range_ind,:))/1E3,'b','linewidth',2); box off; hold on;
        plot(T-T(1), mean(S.Novel(freq_range_ind,:))/1E3,'r','linewidth',2); box off; hold on;
        ylabel('Power (mV^2)','fontsize',12);
        xlim(ax2.XLim);
        lh= legend('Familiar','Novel'); lh.FontSize = 8; set(lh,'Box','off','location','Northeast')
        set(lh,'pos',[0.45, 0.35, 0.04, 0.09],'units','Normalized');
        
        
        
        
        
        
        % Spectrogram (LowGamma)
        
        
        S=[]; T=[]; F=[];
        
        
        subplot('Position', [0.53 0.75 0.2 0.15]);
        
        
        [S.Familiar,T,F] = mtspecgramc(eventEEG(select.Familiar_Corr,:)',movingwin, params);
        S.Familiar=S.Familiar';
        freq_range_ind= find(F<=freq_range.lowgamma(end) & F>=freq_range.lowgamma(1));
        
        imagesc(T-T(1),F(freq_range_ind),10*log(S.Familiar(freq_range_ind,:))); cb= colorbar; ylabel(cb, 'Power(dB)');
        ax1= gca;
        set(gca,'YDir','Normal');  colormap jet; box off;
        title('LowGamma(Familiar)'); ylabel('Frequency(Hz)','fontsize',12);
        power_range(1,:)= caxis;
        
        
        
        
        subplot('Position', [0.53 0.5 0.2 0.15]);
        
        
        [S.Novel,T,F] = mtspecgramc(eventEEG(select.Novel_Corr,:)',movingwin, params);
        S.Novel=S.Novel';
        
        imagesc(T-T(1),F(freq_range_ind),10*log(S.Novel(freq_range_ind,:))); cb= colorbar; ylabel(cb, 'Power(dB)');
        ax2= gca;
        set(gca,'YDir','Normal');  colormap jet; box off;
        title('LowGamma(Novel)'); ylabel('Frequency(Hz)','fontsize',12);
        power_range(2,:)= caxis;
        
        caxis(ax1, [min(power_range(:,1)) max(power_range(:,2))]);
        caxis(ax2, [min(power_range(:,1)) max(power_range(:,2))]);
        
        
        
        
        
        subplot('Position', [0.53 0.3 0.16 0.15]);
        
        
        plot(T-T(1), mean(S.Familiar(freq_range_ind,:))/1E3,'b','linewidth',2); box off; hold on;
        plot(T-T(1), mean(S.Novel(freq_range_ind,:))/1E3,'r','linewidth',2); box off; hold on;
        ylabel('Power (mV^2)','fontsize',12);
        xlim(ax2.XLim);
        lh= legend('Familiar','Novel'); lh.FontSize = 8; set(lh,'Box','off','location','Northeast')
        set(lh,'pos',[0.70, 0.35, 0.04, 0.09],'units','Normalized');
        
        
        
        
        
        % Spectrogram (HighGamma)
        
        
        S=[]; T=[]; F=[];
        
        subplot('Position', [0.78 0.75 0.2 0.15]);
        
        
        [S.Familiar,T,F] = mtspecgramc(eventEEG(select.Familiar_Corr,:)',movingwin, params);
        S.Familiar=S.Familiar';
        freq_range_ind= find(F<=freq_range.highgamma(end) & F>=freq_range.highgamma(1));
        
        imagesc(T-T(1),F(freq_range_ind),10*log(S.Familiar(freq_range_ind,:))); cb= colorbar; ylabel(cb, 'Power(dB)');
        ax1= gca;
        set(gca,'YDir','Normal');  colormap jet; box off;
        title('HighGamma(Familiar)'); ylabel('Frequency(Hz)','fontsize',12);
        power_range(1,:)= caxis;
        
        
        
        
        
        subplot('Position', [0.78 0.5 0.2 0.15]);
        
        
        [S.Novel,T,F] = mtspecgramc(eventEEG(select.Novel_Corr,:)',movingwin, params);
        S.Novel=S.Novel';
        
        imagesc(T-T(1),F(freq_range_ind),10*log(S.Novel(freq_range_ind,:))); cb= colorbar; ylabel(cb, 'Power(dB)');
        ax2= gca;
        set(gca,'YDir','Normal');  colormap jet; box off;
        title('HighGamma(Novel)'); ylabel('Frequency(Hz)','fontsize',12);
        power_range(2,:)= caxis;
        
        caxis(ax1, [min(power_range(:,1)) max(power_range(:,2))]);
        caxis(ax2, [min(power_range(:,1)) max(power_range(:,2))]);
        
        
        
        subplot('Position', [0.78 0.3 0.16 0.15]);
        
        
        plot(T-T(1), mean(S.Familiar(freq_range_ind,:))/1E3,'b','linewidth',2); box off; hold on;
        plot(T-T(1), mean(S.Novel(freq_range_ind,:))/1E3,'r','linewidth',2); box off; hold on;
        ylabel('Power (mV^2)','fontsize',12);
        xlim(ax2.XLim);
        lh= legend('Familiar','Novel'); lh.FontSize = 8; set(lh,'Box','off','location','Northeast')
        set(lh,'pos',[0.95, 0.35, 0.04, 0.09],'units','Normalized');
        
        

        
        
        
        % Spectrogram (ALL)
        
        
        
        subplot('Position', [0.2 0.07 0.2 0.15]);
        
        
        [S.ALL,T,F] = mtspecgramc(eventEEG',movingwin, params);
        S.ALL=S.ALL';
        
        freq_range_ind= find(F<=freq_range.highgamma(end) & F>=0);
        
        S_norm= mapminmax(S.ALL,0,1);
%         imagesc(T-T(1),F(freq_range_ind),10*log(S.Novel(freq_range_ind,:))); cb= colorbar; ylabel(cb, 'Power(dB)');
        imagesc(T-T(1),F(freq_range_ind),S_norm(freq_range_ind,:)); cb= colorbar; ylabel(cb, 'Norm. Power');
        set(gca,'YDir','Normal');  colormap jet; box off;
        title('All'); ylabel('Frequency(Hz)','fontsize',12);
        
        
        
        
        
        
        %% Power Correlation
        
        corrMAT=nan(numel(F));
        
        for row_run= 1: numel(F)
            
            for row_run2= 1:numel(F)

                
                corrR= corrcoef(S.ALL(row_run,:),S.ALL(row_run2,:));
                
                
                corrMAT(row_run2,row_run)= corrR(1,2);
            end
        end
        
        
        corrMAT= flipud(corrMAT);

        
        
        subplot('position',[0.45 0.06 0.11 0.18]);
        imagesc(F,fliplr(F),corrMAT); 
%         imagesc(F(freq_range_ind),fliplr(F),corrMAT(freq_range_ind,freq_range_ind)); 
        set(gca,'YDir','normal');  xlabel('Freq (Hz)'); ylabel('Freq (Hz)');
        caxis([-1 1]);  colormap(jet)
        title('Power correlation(ALL)'); box off;
        xlim([4 120]); ylim([4 120]);
        h= hline([30 50 70 120],'w'); set(h,'linewidth',1.5);
        h= vline([30 50 70 120],'w'); set(h,'linewidth',1.5);
        
        
        
        
        
        %% Power Correlation (Familiar)
        
        corrMAT=nan(numel(F));
        
        for row_run= 1: numel(F)
            
            for row_run2= 1:numel(F)

                corrR= corrcoef(S.Familiar(row_run,:),S.Familiar(row_run2,:));
                
                
                corrMAT(row_run2,row_run)= corrR(1,2);
            end
        end
        
        
        corrMAT= flipud(corrMAT);

        
        
        subplot('position',[0.65 0.06 0.11 0.18]);
        imagesc(F,fliplr(F),corrMAT); 
        set(gca,'YDir','normal');  xlabel('Freq (Hz)'); ylabel('Freq (Hz)');
        caxis([-1 1]);  colormap(jet)
        title('Power correlation(Familiar)'); box off;
        xlim([4 120]); ylim([4 120]);
        h= hline([30 50 70 120],'w'); set(h,'linewidth',1.5);
        h= vline([30 50 70 120],'w'); set(h,'linewidth',1.5);
        
        
        
        
        
        %% Power Correlation (Novel)
        
        corrMAT=nan(numel(F));
        
        for row_run= 1: numel(F)
            
            for row_run2= 1:numel(F)

                corrR= corrcoef(S.Novel(row_run,:),S.Novel(row_run2,:));
                
                
                corrMAT(row_run2,row_run)= corrR(1,2);
            end
        end
        
        
        corrMAT= flipud(corrMAT);

        
        
        subplot('position',[0.85 0.06 0.11 0.18]);
        imagesc(F,fliplr(F),corrMAT); 
        set(gca,'YDir','normal');  xlabel('Freq (Hz)'); ylabel('Freq (Hz)');
        caxis([-1 1]);  colormap(jet)
        title('Power correlation(Novel)'); box off;
        xlim([4 120]); ylim([4 120]);
        h= hline([30 50 70 120],'w'); set(h,'linewidth',1.5);
        h= vline([30 50 70 120],'w'); set(h,'linewidth',1.5);
        
        
        
        
        
        
        
        % Save figure for verification
        
        cd(saveROOT)
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
%         saveas(fig,filename);
        
        
        
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
