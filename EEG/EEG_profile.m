%% Created by Jaerong 2017/03/16  for PER & POR ephys analysis


function [summary,summary_header]=EEG_profile(summary, summary_header,dataROOT)


cd(dataROOT);
pre_folder=[];



%% Spectrogram Parms

freq_range.all = [0 150];
freq_range.delta = [1 4]; freq_range.theta = [4 12]; freq_range.beta = [15 25]; freq_range.lowgamma = [30 50]; freq_range.highgamma = [70 120];
global sampling_freq
sampling_freq= 2000;
period=(1/sampling_freq)*10^6;
nb_data_points= 2000;



%% mtspecgramc parameter

movingwin = [0.3 .01];           %moving window [windowSIZE windowSTEP]; 500ms window and moving by 10ms
params.Fs = sampling_freq;               %frequency; here is EEG data frequency
params.tapers = [5 9];          %tapers [TimeBandWidth multipleTAPERS]; 5 is recommended for 500ms window (3 is recormended for 300ms window size)
params.fpass = freq_range.all;          %ROI freqency;
params.pad= 1;
params.trialave = 1;            %if trial to be averaged, set 1



timeSET = 0.5;
BROI = (timeSET)*1E6;               %set Big window for loading event EEG data; 1.5 times bigger than ROI



perf_str= {'Wrong','Correct'};




%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\EEG_profile\' ];
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


fig_pos = [255 200 1400 850];




[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if   strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
        
        
        
        
        set_eeg_prefix;
        
        
        
        
        if ~strcmp(pre_folder,Session_folder)
            
            
            load_ts_evt;
            
        
        %% Select trial types
        
        select_trial_type;
            
            
            pre_folder= Session_folder;
        else
        end %(pre_folder== Session_folder)
        
        
        if     strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
            
            stimulus_str= {'Icecream','House'};
            
        elseif    strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            stimulus_str= {'Icecream','House','Owl','Phone'};
            
        elseif    strcmp(summary(i_s).Task_name,'OCRS(Modality)')
            
            stimulus_str= {'Owl','Phone'};
            
        elseif    strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            stimulus_str=  {'Zebra','Pebbles','Owl','Phone'};
            
        end
        
        
        
        %% Load EEG
        
        csc_ID= sprintf('CSC%s_RateReduced.ncs',summary(i_s).TT);
        %         csc_ID= sprintf('CSC%s.ncs',summary(i_s).TT);
        cd(Session_folder);
        
        
        
        %% Look up the ADBitVolts
        
        [header] = Nlx2MatCSC(csc_ID, [0 0 0 0 0],1,1,[]); % look for ADBitVolts to convert eegs values from bits to volts
        bit2volt = str2num(header{15}(1, 14:end)); %read ADBitVolts
        clear header
        
        
        
        
        %% Extract EEG during the event period
        
        EEG_MAT=[];
        ts_vector= [];
        
        
        
        for trial_run= 1:size(ts_evt,1) % for each trial
            
            ts_vector = [];
            EEG = [];
            cd(Session_folder);
            
            ts_vector = [ts_evt(trial_run,StimulusOnset)-.5 ts_evt(trial_run,Choice)+.5];
            
            [EEG,EEGTS] = get_EEG(csc_ID, ts_vector, bit2volt);
            
            
            
            fig_name= sprintf('Trial = #%d  %s',trial_run, Prefix);
            
            fig=figure('name',fig_name,'Color',[1 1 1],'Position',fig_pos);
            
            subplot('Position', [0.3 0.98 0.3 0.15]);
            text(0,0,fig_name,'fontsize',12);
            axis off;
            
            
            
            
            
            EEGTS = EEGTS./1E6;
            subplot('Position', [0.2 0.4 0.55 0.2]);
            
            
            cwt(EEG, sampling_freq);
            %             [wt,F] = cwt(EEG, sampling_freq);
            %             freq_range_ind= find(F<=12 & F>=4);
            %             imagesc((EEGTS-EEGTS(1)),F(freq_range_ind),abs(wt(freq_range_ind,:))); set(gca,'YDir','Normal');
            colormap hot; box off;
            ch=colorbar;
            delete(ch);
            ch= colorbar('Position', [.77 .4 .02 .2]); ylabel(ch,'Magnitude');
            T_range= get(gca,'XLim');
            vhandle = vline(ts_evt(trial_run,StimulusOnset) - EEGTS(1),'w:','StimulusOnset'); set(vhandle,'linewidth',2);
            vhandle = vline(ts_evt(trial_run,Choice) - EEGTS(1),'w:','Choice'); set(vhandle,'linewidth',2);
            %
            
            
            
            
            
            %         imagesc(T,F(freq_range_ind,:),log10(abs(S(freq_range_ind,:))));
            
            %         colormap hot; box off;
            %         T_range= get(gca,'XLim');
            %         ylabel('Frequency (Hz)');
            %         handle= vline(ts_evt(trial_run,ChoiceLatency));  set(handle,'color',[1 1 1],'linewidth',2);
            
            
            %         power= abs(wt);
            %         figure, plot(mean(power))
            
            
            
            
            
            %         [S1,t,f] = mtspecgramc(EEG',movingwin, params); S1=S1';
            %         epoch_range= find(t<=  ts_evt(trial_run,ChoiceLatency)); S1= S1(:,epoch_range);
            
            subplot('Position', [0.2 0.67 0.55 0.25]);
            
            plot((EEGTS-EEGTS(1)), EEG,'Color',[.5 .5 .5]); box off;
            ylabel('\muV','fontsize',15);
            
            text(-.24,0.5,'Raw Trace','units','normalized','fontsize',15,'color',[.5 .5 .5]);
            xlim(T_range);
            
            vline(ts_evt(trial_run,StimulusOnset) - EEGTS(1),'r','StimulusOnset')
            vline(ts_evt(trial_run,Choice) - EEGTS(1),'r','Choice')
            
            
            msg= sprintf('Stimulus = %s', stimulus_str{ts_evt(trial_run,Stimulus)});
            text(1.1,0.7,msg,'units','normalized','fontsize',15);
            
            msg= sprintf('%s', perf_str{ts_evt(trial_run,Correctness)+1});
            text(1.1,0.5,msg,'units','normalized','fontsize',15);
            
            msg= sprintf('Latency= %1.2f (s)', ts_evt(trial_run,ChoiceLatency));
            text(1.1,0.3,msg,'units','normalized','fontsize',15);
            
            %         [S F T] =spectrogram(EEG,128,64,258,2000,'yaxis');
            %          freq_range_ind= find(F<=120 & F>=0);
            %         imagesc(T,F(freq_range_ind,:),log10(abs(S(freq_range_ind,:))));
            %         set(gca,'YDir','Normal');  colormap hot; box off;
            %         T_range= get(gca,'XLim');
            
            
            
            %         imagesc(t-(t(1)),f,S1); set(gca,'YDir','normal'); colormap hot; box off;
            %         xlim([0 ts_evt(trial_run,ChoiceLatency)])
            %         set(gca, 'Xtick',[1 ts_evt(trial_run,ChoiceLatency)], 'XTickLabel',sprintfc('%1.2f',[0  ts_evt(trial_run,ChoiceLatency)]),'fontsize',8);
            %         set(gca, 'XTick',[min(t) ts_evt(trial_run,ChoiceLatency)], 'XTickLabel',{'StimulusOnset' ;'Choice'},'fontsize',8);
            %         xlim([min(get(gca,'Xtick')) xaxis_max])
            
            
            %% Check the power density function (Raw)
            
            
            
            
            %% Reassemble the data block
            %% Number of data points (in blocks, the number in the power of 2)
            
            eeg_row= nb_data_points;
            
            eeg_col = floor(numel(EEG)/nb_data_points);
            
            if eeg_col
                
                EEG((eeg_row* eeg_col)+1:end) = [];  %% truncate the trailing values
                EEG= reshape(EEG, eeg_row, eeg_col);
                
            else
            end
            
            
            [S.epoch,f]=mtspectrumc(EEG,params);
            
            
            
            
            ts_vector = [ts_evt(trial_run,StimulusOnset)-1 ts_evt(trial_run,StimulusOnset)];
            
            EEG_baseline = get_EEG(csc_ID, ts_vector, bit2volt);
            S.baseline=mtspectrumc(EEG_baseline,params);
            
            subplot('Position', [0.2 0.15 0.2 0.2]);
            
            plot(f,S.epoch./S.baseline,'linewidth',1.5);
            box off; hold on;
            xlabel(['Frequency (Hz)']);
            ylabel(['Norm. Power']);
            handle= hline(1);  set(handle,'linewidth',1);
            
            
            
            
            % freq_range.all = [0 120];
            % freq_range.delta = [1 4]; freq_range.theta = [4 12]; freq_range.beta = [15 25]; freq_range.lowgamma = [30 50]; freq_range.highgamma = [70 110];
            
            
            
            %             thisPOWERLOWCUT = min(find(f >= 4)); thisPOWERHIGHCUT = max(find(f <= 12));
            %             power.norm.theta = trapz(S.epoch(thisPOWERLOWCUT:thisPOWERHIGHCUT))/ trapz(S.baseline(thisPOWERLOWCUT:thisPOWERHIGHCUT))
            %
            %             thisPOWERLOWCUT = min(find(f >= 15)); thisPOWERHIGHCUT = max(find(f <= 25));
            %             power.norm.beta = trapz(S.epoch(thisPOWERLOWCUT:thisPOWERHIGHCUT))/ trapz(S.baseline(thisPOWERLOWCUT:thisPOWERHIGHCUT))
            %
            %             thisPOWERLOWCUT = min(find(f >= 30)); thisPOWERHIGHCUT = max(find(f <= 50));
            %             power.norm.lowgamma = trapz(S.epoch(thisPOWERLOWCUT:thisPOWERHIGHCUT))/ trapz(S.baseline(thisPOWERLOWCUT:thisPOWERHIGHCUT))
            %
            %             thisPOWERLOWCUT = min(find(f >= 70)); thisPOWERHIGHCUT = max(find(f <= 110));
            %             power.norm.highgamma = trapz(S.epoch(thisPOWERLOWCUT:thisPOWERHIGHCUT))/ trapz(S.baseline(thisPOWERLOWCUT:thisPOWERHIGHCUT))
            
            
            
            pband.norm.theta(trial_run) = bandpower(S.epoch,f,freq_range.theta,'psd')/ bandpower(S.baseline,f,freq_range.theta,'psd');
            pband.norm.beta(trial_run) = bandpower(S.epoch,f,freq_range.beta,'psd')/ bandpower(S.baseline,f,freq_range.beta,'psd');
            pband.norm.lowgamma(trial_run) = bandpower(S.epoch,f,freq_range.lowgamma,'psd')/ bandpower(S.baseline,f,freq_range.lowgamma,'psd');
            pband.norm.highgamma(trial_run) = bandpower(S.epoch,f,freq_range.highgamma,'psd')/ bandpower(S.baseline,f,freq_range.highgamma,'psd');
            
            
            
            
            msg= sprintf('Norm Theta = %1.2f', pband.norm.theta(trial_run));
            text(1.2,0.7,msg,'units','normalized','fontsize',15);
            
            msg= sprintf('Norm Beta = %1.2f', pband.norm.beta(trial_run));
            text(1.2,0.5,msg,'units','normalized','fontsize',15);
            
            msg= sprintf('Norm LowGamma = %1.2f', pband.norm.lowgamma(trial_run));
            text(1.2,0.3,msg,'units','normalized','fontsize',15);
            
            msg= sprintf('Norm HighGamma = %1.2f', pband.norm.highgamma(trial_run));
            text(1.2,0.1,msg,'units','normalized','fontsize',15);
            
            fig_saveROOT=[dataROOT '\Analysis\EEG\EEG_profile' Prefix ];
            if ~exist(fig_saveROOT), mkdir(fig_saveROOT), end
            cd(fig_saveROOT);
            
            
            filename=[fig_name '.png'];
            saveImage(fig,filename,fig_pos);
            
            
            
            close all;
            
            clear eeg* nb_eeg nb_smp_eeg nb_smp_ts
            %             else
            %             end
            
        end
        
        mean(pband.norm.theta(select.Familiar))        
        mean(pband.norm.theta(select.Novel))        
        
        mean(pband.norm.beta(select.Familiar_Corr))        
        mean(pband.norm.beta(select.Novel_Corr))        
        
        mean(pband.norm.lowgamma(select.Familiar_Corr))        
        mean(pband.norm.lowgamma(select.Novel_Corr))        
        
        mean(pband.norm.highgamma(select.Familiar_Corr))        
        mean(pband.norm.highgamma(select.Novel_Corr))        
        
        
        figure()
        subplot(141), plot(pband.norm.theta(select.Stimulus1_Corr))
        subplot(142), plot(pband.norm.theta(select.Stimulus2_Corr))
        subplot(143), plot(pband.norm.theta(select.Stimulus3_Corr))
        subplot(144), plot(pband.norm.theta(select.Stimulus4_Corr))
        
        
        
        
        %% Save figure for verification
        
        cd(saveROOT)
        
        %         filename=[Prefix  '.png'];
        %         saveImage(fig,filename,fig_pos);
        %
        
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
