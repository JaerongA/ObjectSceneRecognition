%% Created by Jaerong on 2018/09/26 for second revision in CR
%% Plots PSDs from PER and HIPP recorded from the same session on the same plot


function [summary,summary_header]=EEG_PSD_interregion(summary, summary_header,dataROOT)


cd(dataROOT);
pre_folder=[];


%% Load EEG Parms

freq_range.all = [0 140];
freq_range.delta = [1 4]; freq_range.theta = [4 12]; freq_range.beta = [15 25]; freq_range.lowgamma = [30 50]; freq_range.highgamma = [70 120];
global sampling_freq
global period
sampling_freq= 2000;
period=(1/sampling_freq)*10^6;
% nb_data_points= 512;
nb_data_points= 2000;  % Number of data points increased to 2000 and zero padded (2018/10/02)



%% mtspecgramc parameter

% movingwin = [0.1 .05];           %moving window [windowSIZE windowSTEP]; 500ms window and moving by 10ms
movingwin = [0.3 .01];           %moving window [windowSIZE windowSTEP]; 300ms window and moving by 10ms
params.Fs = sampling_freq;               %frequency; here is EEG data frequency
params.tapers = [3 5];          %tapers [TimeBandWidth multipleTAPERS]; 5 is recommended for 500ms window (3 is recormended for 300ms window size)
params.fpass = freq_range.all;          %ROI freqency;
params.pad= 1;
params.trialave = 1;            %if trial to be averaged, set 1
params.err = [1 0.05] ;            % error bar on, p-value


baseline_second= 0.5;  %% Duration of the baseline period



%% Fig parms

fig_ok= 1;


%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\PSD\Interregion\' date ];

if ~exist(saveROOT)
    mkdir(saveROOT);
end
cd(saveROOT)



%% Output file

outputfile= 'EEG_PSD.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key(PER), Key(HIPP), RatID, Session, Task_session, Task, TT(PER), TT(HIPP),';
txt_header = 'Power_criteria(Both)';
fprintf(fod, txt_header);
% txt_header = 'TrialAVG_Rmaxloc(ms), Rmaxloc(ms),';
fprintf(fod, txt_header);
fprintf(fod,'\n');
fclose(fod);





%% Summary
[r_s,c_s]=size(summary);


for i_s= 1:c_s
    %     2:c_s
    
    
    if  strcmp(summary(i_s).Region, 'PER') &&  strcmp(summary(i_s).Key, '64')
        
        
        %% Set EEG info
        
        set_eeg_prefix;
        
        
        
        %% Select another TT from a different regions recorded in the same session
        
        
        nb_target =size(summary,2);
        
        
        
        for Target_run= 1: nb_target
            
            
            
            
            % Set EEG info
            
            target_set_prefix;
            
            
            if  strcmp(summary(Target_run).Region, 'IntHIPP') && strcmp(RatID, RatID2) && strcmp(Session, Session2)
                
                
                %% Set EEG info
                
                set_eeg_prefix;
                
                
                
                disp(['Ref TT... ' Prefix]);
                disp(['Target TT... : ' Prefix2]);
                
                
                
                
                
                %% Loading trial ts info from ParsedEvents.mat
                
                
                % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
                %
                % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
                % 13. StimulusCat
                %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                load_ts_evt;
                
                
                
                %% Maxout trial removal
                
                cd([Session_folder '\EEG\']);
                load([Prefix '_maxout.mat' ]);
                ts_evt(maxout_MAT==1,:)=[];
                
                
                
                
                %% Select trial types
                
                select_trial_type;
                
                
                %                 ts_evt = ts_evt(select.Corr,:);  %% Correct trials only
                %
                %
                %                 select_trial_type;
                
                
                
                
                %% Look up the ADBitVolts
                
                bit2micovolt = str2num(summary(i_s).ADBitmicrovolts); %read ADBitVolts
                
                
                
                
                %% Extract EEG during the event period
                
                
                thisEEG = [];
                thisEEGTS = [];
                
                
                
                Rmaxloc =[];
                Rmax =[];
                CrossR_MAT =[];
                Leading_region='';
                
                
                
                
                
                
                Prefix = [Prefix ' - ' Ref_Region];
                Prefix2 = [Prefix2 ' - ' Ref_Region2];
                
                
                
                for trial_run= 1:size(ts_evt,1) % for each trial
                    
                    ts_vector = [];
                    
                    
                    
                    cd([Session_folder '\EEG\Noise_reduction']);
                    csc_PER= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
                    csc_HIPP= sprintf('CSC%s_Noise_filtered.ncs',summary(Target_run).TT);
                    
                    ts_vector = [ts_evt(trial_run,StimulusOnset), ts_evt(trial_run,Choice)];
                    
                    
                    [thisEEG.PER.epoch{trial_run}, thisEEGTS] = get_EEG(csc_PER, ts_vector, bit2micovolt);
                    [thisEEG.HIPP.epoch{trial_run},thisEEGTS] = get_EEG(csc_HIPP, ts_vector, bit2micovolt);
                    
                    
                    ts_vector = [];
                    
                    ts_vector = [ts_evt(trial_run,StimulusOnset)-0.5 ts_evt(trial_run,StimulusOnset)];
                    
                    
                    thisEEG.PER.baseline{trial_run} = get_EEG(csc_PER, ts_vector, bit2micovolt);
                    thisEEG.HIPP.baseline{trial_run} = get_EEG(csc_HIPP, ts_vector, bit2micovolt);
                    
                    
                    
                    %% Caculate CrossR
                    
                    crossR = [];
                    lag = [];
                    
                    
                    %                     [crossR,lag] = xcorr(thisEEG.PER,thisEEG.HIPP);
                    [crossR,lag] = xcorr(thisEEG.PER.epoch{trial_run},thisEEG.HIPP.epoch{trial_run},'coeff');
                    
                    %                     [~,I] = max(abs(crossR));
                    [CorrR,I] = max(crossR);
                    lagDiff = lag(I);
                    
                    thisEEGTS = thisEEGTS./1E6;
                    lag= lag./sampling_freq;  lag = lag.*1E3;  %% ms conversion
                    Rmaxloc(trial_run) = (lagDiff/sampling_freq)*1E3;
                    Rmax(trial_run)= CorrR;
                    
                    
                    
                    %% Store trial correlation coefficient
                    
                    CrossR_MAT(trial_run,:) = crossR(find(lag>-500 & lag<=500));
                    
                    
                    
                    
                    %% Generate figures
                    
                    if fig_ok
                        
                        
                        
                        
                        %% Fig parms
                        
                        fig_pos = [400 400 1500 600];
                        
                        
                        ind= findstr(Prefix,'-');
                        
                        
                        
                        switch length(sprintf('%d',ts_evt(trial_run,Trial)))
                            
                            case 1
                                fig_name= ['Trial# 00' sprintf('%d',ts_evt(trial_run,Trial)) ' - ' Prefix ' vs. ' Key2 '-' Prefix2(ind(5)+1:end)  '.png'];
                            case 2
                                fig_name= ['Trial# 0' sprintf('%d',ts_evt(trial_run,Trial)) ' - ' Prefix ' vs. ' Key2 '-' Prefix2(ind(5)+1:end)  '.png'];
                            case 3
                                fig_name= ['Trial# ' sprintf('%d',ts_evt(trial_run,Trial)) ' - ' Prefix ' vs. ' Key2 '-' Prefix2(ind(5)+1:end)  '.png'];
                        end
                        
                        
                        
                        
                        
                        %% Create figures
                        
                        fig=figure('name',fig_name(1:end-4),'Color',[1 1 1],'Position',fig_pos);
                        
                        subplot('Position', [0.25 0.98 0.3 0.2]);
                        
                        
                        if (str2double(summary(i_s).Power_criteria) * str2double(summary(Target_run).Power_criteria))
                            text(0,0,[fig_name(1:end-4) '- CriteriaOK'],'fontsize',11);
                        else
                            text(0,0,[fig_name(1:end-4) '- NoCriteria'],'fontsize',11);
                        end
                        
                        
                        axis off;
                        
                        
                        
                        %% Raw signal
                        
                        
                        subplot('Position', [0.05 0.67 0.6 0.25]);
                        
                        thisEEGTS = thisEEGTS./1E6;
                        plot(((thisEEGTS-thisEEGTS(1))), thisEEG.PER.epoch{trial_run},'b'); hold on;
                        plot(((thisEEGTS-thisEEGTS(1))), thisEEG.HIPP.epoch{trial_run},'m'); box off;
                        %                     axis tight;
                        legend('PER','HIPP','location','eastoutside');
                        ylabel('\muV','fontsize',15);
                        xlabel('Time(s)'); title('Event period');
                        
                        
                        subplot('Position', [0.05 0.27 0.6 0.25]);
                        
                        plot([0:length(thisEEG.PER.baseline{trial_run})-1]./sampling_freq, thisEEG.PER.baseline{trial_run},'b'); hold on;
                        plot([0:length(thisEEG.PER.baseline{trial_run})-1]./sampling_freq, thisEEG.HIPP.baseline{trial_run},'m'); box off;
                        %                     axis tight;
                        legend('PER','HIPP','location','eastoutside');
                        ylabel('\muV','fontsize',15);
                        xlabel('Time(s)'); title('Baseline');
                        
                        
                        
                        
                        
                        
                        
                        subplot('Position', [0.7 0.4 0.25 0.3]);
                        
                        
                        plot(lag,crossR,'k','linewidth',1.5); box off; xlabel('Lag(ms)'); ylabel('Correlation Coefficient');
                        xlim([-500 500]); ylim([-1 1]); title('Cross Correlation'); vhandle= vline(Rmaxloc(trial_run),'r:'); set(vhandle,'linewidth',1.5);
                        
                        
                        
                        
                        
                        %% Save figures per trial
                        
                        
                        
                        %                         fig_saveROOT= [saveROOT '\' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)];
                        
                        
                        
                        if (str2double(summary(i_s).Power_criteria) * str2double(summary(Target_run).Power_criteria))
                            fig_saveROOT= [saveROOT '\' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end) '- CriteriaOK'];
                        else
                            fig_saveROOT= [saveROOT '\' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end) '- NoCriteria'];
                            
                        end
                        
                        
                        
                        
                        
                        
                        if ~exist(fig_saveROOT)
                            mkdir(fig_saveROOT);
                        end
                        
                        
                        cd(fig_saveROOT)
                        
                        
                        filename_ai=sprintf('Trial %d.eps', trial_run);
                        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
                        
                        
                        filename= sprintf('Trial %d.png', trial_run);
                        saveImage(fig,filename,fig_pos);
                        
                        
                    end  % fig_ok
                    
                    
                end
                
                
                
                EEG=[];
                
                EEG.PER.epoch = cell2mat(thisEEG.PER.epoch);
                EEG.HIPP.epoch = cell2mat(thisEEG.HIPP.epoch);
                
                EEG.PER.baseline = cell2mat(thisEEG.PER.baseline);
                EEG.HIPP.baseline = cell2mat(thisEEG.HIPP.baseline);
                
                clear thisEEG
                
                
                
                
                
                
                %% Reassemble the data block
                %% Number of data points (in blocks, the number in the power of 2)
                
                EEG_row= nb_data_points;
                EEG_col = floor(numel(EEG.PER.epoch)/nb_data_points);
                
                EEG.PER.epoch((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
                EEG.PER.epoch= reshape(EEG.PER.epoch, EEG_row, EEG_col);
                
                
                EEG.HIPP.epoch((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
                EEG.HIPP.epoch= reshape(EEG.HIPP.epoch, EEG_row, EEG_col);
                
                
                
                clear EEG_row EEG_col
                
                
                
                
                %% Reassemble the data block
                %% Number of data points (in blocks, the number in the power of 2)
                
                EEG_row= nb_data_points;
                EEG_col = floor(numel(EEG.PER.baseline)/nb_data_points);
                
                EEG.PER.baseline((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
                EEG.PER.baseline= reshape(EEG.PER.baseline, EEG_row, EEG_col);
                
                
                EEG.HIPP.baseline((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
                EEG.HIPP.baseline= reshape(EEG.HIPP.baseline, EEG_row, EEG_col);
                
                
                clear EEG_row EEG_col
                
                
                
                
                %% Plot power spectral density functions
                
                S_epoch= [];
                S_baseline= [];
                
                
                
                [S_epoch.PER,F] =mtspectrumc(EEG.PER.epoch,params);
                [S_epoch.HIPP,F] =mtspectrumc(EEG.HIPP.epoch,params);
                
                
                [S_baseline.PER,F] =mtspectrumc(EEG.PER.baseline,params);
                [S_baseline.HIPP,F] =mtspectrumc(EEG.HIPP.baseline,params);
                
                
                
                
                %% Calculate the trial-averaged crossR
                
                
                lag=[];
                CrossR_thresh =[];
                
                
                lag=[-499.5:0.5:500];
                meanCrossR= nanmean(CrossR_MAT);
                [maxCrossR,I] = max(meanCrossR);
                meanR_maxloc= (I-(length(lag)/2))*0.5;
                
                %% CrossCorr threshold
                
                CrossR_thresh= mean(meanCrossR) + (3*std(meanCrossR));
                %
                %                 if maxCrossR < CrossR_thresh
                %                     continue
                %                 else
                %                 end
                
                
                
                
                %% Create figures
                %% Print out cell ID
                
                
                cd(saveROOT);
                
                ind= findstr(Prefix2,'-');
                fig_name = [Prefix ' vs. '  Key2 '-' Prefix2(ind(5)+1:end) '.png'];
                fig_pos= [200 200 1400 500];
                
                
                fig=figure('name',fig_name(1:end-4),'Color',[1 1 1],'Position',fig_pos);
                
                subplot('Position', [0.01 0.98 0.3 0.2]);
                text(0.5,0,fig_name(1:end-4),'fontsize',11); axis off;
                
                
                
                subplot('position',[0.05 0.15 0.25 0.7]);
                
                
                plot(F,10*log(S_epoch.PER)); hold on;
                plot(F,10*log(S_epoch.HIPP));   legend('PER','HIPP');
                title('Epoch');         box off; hold on;
                
                vline(4,'k:');vline(12,'k:');
                vline(70,'k:');vline(120,'k:');
                
                xlabel('Frequency (Hz)','fontsize',15); xlim([0 120]);
                ylabel('Power (dB)','fontsize',15);
                
                
                
                subplot('position',[0.35 0.15 0.25 0.7]);
                
                plot(F,10*log(S_baseline.PER)); hold on;
                plot(F,10*log(S_baseline.HIPP));   legend('PER','HIPP');
                title('Baseline');         box off; hold on;
                
                
                vline(4,'k:');vline(12,'k:');
                vline(70,'k:');vline(120,'k:');
                xlabel('Frequency (Hz)','fontsize',15); xlim([0 120]);
                
                
                
                
                
                subplot('Position', [0.65 0.2 0.25 0.5]);
                
                shadedErrorBar(lag, meanCrossR, nanstd(CrossR_MAT,1),{'k-','markerfacecolor','k'}); ylim([-1 1]); title('Cross Correlation');
                box off; xlabel('Lag(ms)'); ylabel('Correlation Coefficient');
                handle= vline(meanR_maxloc,'r:',sprintf('%1.2f (ms)',meanR_maxloc)); set(handle,'linewidth',1.5);
                handle= hline(CrossR_thresh,'y:'); set(handle,'linewidth',1.5);
                
                
                
                
                filename_ai=[fig_name(1:end-4) '.eps'];
                print( gcf, '-painters', '-r300', filename_ai, '-depsc');
                
                
                filename=[fig_name(1:end-4)  '.png'];
                saveImage(fig,filename,fig_pos);
                
                
                
                
                
                % fod=fopen(outputfile,'w');
                % txt_header = 'Key(PER), Key(HIPP), RatID, Session, Task_session, Task, TT(PER), TT(HIPP),';
                % fprintf(fod, txt_header);
                % txt_header = 'TrialAVG_Rmaxloc(ms), Rmaxloc(ms),';
                % fprintf(fod, txt_header);
                % fprintf(fod,'\n');
                % fclose(fod);
                
                
                
                
                %                 %% Output file generation
                %
                %
                %                 fod=fopen(outputfile,'a');
                %                 fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, Key2, RatID, Session, Task_session,  Task, TTID, TTID2);
                %                 fprintf(fod,',%1.5f, %1.5f',mean(Rmaxloc), meanR_maxloc);
                %                 fprintf(fod,'\n');
                %                 fclose('all');
                
            end %   i_s= 1:c_s
            
        end
        
        
    end
end


