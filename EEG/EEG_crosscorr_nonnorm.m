%% Created by AJR 2018/06/13  for CR revision
%% Calculates the crosscorrelation bewteen the PER and HIPP recorded within the session
%% If the location value exceeds zero HIPP leads, otherwise PER leads
%% Revised on 2018/09/26 for second revision in CR


function [summary,summary_header]=EEG_crosscorr_nonnorm(summary, summary_header,dataROOT)


cd(dataROOT);
pre_folder=[];



%% Load EEG Parms

EEG_parms;



%% Fig parms

fig_pos = [50 100 1700 800];
fig_ok= 1;


%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\CrossCorr\2nd_revision' ];

if ~exist(saveROOT)
    mkdir(saveROOT);
end
cd(saveROOT)



%% Output file

outputfile= 'EEG_CrossCorr.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key(PER), Key(HIPP), RatID, Session, Task_session, Task, TT(PER), TT(HIPP),';
fprintf(fod, txt_header);
txt_header = 'TrialAVG_Rmaxloc(ms), Rmaxloc(ms),';
fprintf(fod, txt_header);
fprintf(fod,'\n');
fclose(fod);





%% Summary
[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if  strcmp(summary(i_s).Visual_Inspection, '1') && strcmp(summary(i_s).Power_criteria, '1') && strcmp(summary(i_s).Region, 'PER')
        
        
        
        %% Set EEG info
        
        set_eeg_prefix;
        
        
        
        %% Select another TT from a different regions recorded in the same session
        
        
        nb_target =size(summary,2);
        
        
        
        for Target_run= 1: nb_target
            
            
            
            
            % Set EEG info
            
            target_set_prefix;
            
            
            if  strcmp(summary(Target_run).Visual_Inspection, '1') && strcmp(summary(Target_run).Power_criteria, '1') && strcmp(summary(Target_run).Region, 'IntHIPP') && strcmp(RatID, RatID2) && strcmp(Session, Session2)
                
                
                
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
                
                
                ts_evt = ts_evt(select.Corr,:);
                
                
                select_trial_type;
                
                
                
                
                %% Look up the ADBitVolts
                
                bit2micovolt = str2num(summary(i_s).ADBitmicrovolts); %read ADBitVolts
                
                
                
                
                %% Extract EEG during the event period
                
                fig_pos = [400 400 1500 600];
                
                
                
                Rmaxloc =[];
                Rmax =[];
                CrossR_MAT =[];
                Leading_region='';
                
                
                for trial_run= 1:size(ts_evt,1) % for each trial
                    
                    ts_vector = [];
                    thisEEG = [];
                    thisEEGTS = [];
                    crossR = [];
                    lag = [];
                    
                    
                    
                    cd([Session_folder '\EEG\Noise_reduction']);
                    csc_PER= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
                    csc_HIPP= sprintf('CSC%s_Noise_filtered.ncs',summary(Target_run).TT);
                    
                    ts_vector = [ts_evt(trial_run,StimulusOnset), ts_evt(trial_run,Choice)];
                    
                    
                    [thisEEG.PER, thisEEGTS] = get_EEG(csc_PER, ts_vector, bit2micovolt);
                    [thisEEG.HIPP,thisEEGTS] = get_EEG(csc_HIPP, ts_vector, bit2micovolt);
                    
                    
%                     % Calculate Z-score to put the signal on the same scale
%                     % (Normalization)
%                     
%                     thisEEG.PER = zscore(thisEEG.PER);
%                     thisEEG.HIPP = zscore(thisEEG.HIPP);
                    
                    
                    %% Caculate CrossR
                    
                    %                     [crossR,lag] = xcorr(thisEEG.PER,thisEEG.HIPP);
                    [crossR,lag] = xcorr(thisEEG.PER,thisEEG.HIPP,'coeff');
                    
                    %                     [~,I] = max(abs(crossR));
                    [CorrR,I] = max(crossR);
                    lagDiff = lag(I);
                    
                    thisEEGTS = thisEEGTS./1E6;
                    lag= lag./sampling_freq;  lag = lag.*1E3;  %% ms conversion
                    Rmaxloc(trial_run) = (lagDiff/sampling_freq)*1E3;
                    Rmax(trial_run)= CorrR;
                    
                    
                    
                    
                    
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
                        text(0,0,fig_name(1:end-4),'fontsize',11);
                        axis off;
                        
                        
                        
                        %% Raw signal (zscore)
                        
                        
                        subplot('Position', [0.15 0.67 0.65 0.25]);
                        
                        plot(((thisEEGTS-thisEEGTS(1))), thisEEG.PER,'b'); hold on;
                        plot(((thisEEGTS-thisEEGTS(1))), thisEEG.HIPP,'m'); box off;
                        %                     axis tight;
                        legend('PER','HIPP','location','eastoutside');
                        %                         ylabel('\muV','fontsize',15);
                        ylabel('Normalized EEG','fontsize',15);
                        xlabel('Time(s)');
                        
                        
                        
                        
                        
                        subplot('Position', [0.26 0.23 0.43 0.28]);
                        
                        
                        plot(lag,crossR,'k','linewidth',1.5); box off; xlabel('Lag(ms)'); ylabel('Correlation Coefficient');
                        xlim([-500 500]); ylim([-1 1]); title('Cross Correlation'); vhandle= vline(Rmaxloc(trial_run),'r:'); set(vhandle,'linewidth',1.5);
                        
                        clear thisEEG*
                        
                        
                        %% Print results
                        
                        subplot('Position', [0.8 0.1 0.2 0.3]);
                        axis off;
                        
                        msg= sprintf('Max location = %1.3f (ms)', Rmaxloc(trial_run));
                        text(-.3,1.3, msg, 'Fontsize',12);
                        
                        msg= sprintf('Max CorrR = %1.3f (ms)', Rmax(trial_run));
                        text(-.3,1.1, msg, 'Fontsize',12);
                        
                        
                        
                        
                        
                        
                        %% Save figures per trial
                        
                        
                        
                        fig_saveROOT= [saveROOT '\' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)];
                        
                        
                        if ~exist(fig_saveROOT)
                            mkdir(fig_saveROOT);
                        end
                        
                        
                        cd(fig_saveROOT)
                        
                        
                                                filename_ai=sprintf('Trial %d.eps', trial_run);
                                                print( gcf, '-painters', '-r300', filename_ai, '-depsc');
                        
                        
                        filename= sprintf('Trial %d.png', trial_run);
                        saveImage(fig,filename,fig_pos);
                        
                        
                    end  % fig_ok
                    
                    
                    %% Store trial correlation coefficient
                    
                    CrossR_MAT(trial_run,:) = crossR(find(lag>-500 & lag<=500));
                    %                     CrossR_MAT(trial_run,:) = crossR;
                    
                    
                    
                end
                
                
                
                %                 if mean(Rmaxloc) > 0
                %                     Leading_region = 'HIPP';
                %                 else
                %                     Leading_region = 'PER';
                %                 end
                
                
                
                
                
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
                
                
                %% Save figure per TT pair
                
                cd(saveROOT);
                
                ind= findstr(Prefix2,'-');
                fig_name = [Prefix ' vs.'  Key2 '-' Prefix2(ind(5)+1:end) '.png'];
                fig_pos= [400 400 900 500];
                
                
                fig=figure('name',fig_name(1:end-4),'Color',[1 1 1],'Position',fig_pos);
                
                subplot('Position', [0.01 0.98 0.3 0.2]);
                text(0.5,0,fig_name(1:end-4),'fontsize',11); axis off;
                
                
                subplot('Position', [0.2 0.25 0.5 0.45]);
                
                
                
                shadedErrorBar(lag, meanCrossR, nanstd(CrossR_MAT,1),{'b-','markerfacecolor','b'}); ylim([-1 1]); title('Cross Correlation');
                box off; xlabel('Lag(ms)'); ylabel('Correlation Coefficient');
                handle= vline(meanR_maxloc,'r:',sprintf('%1.2f (ms)',meanR_maxloc)); set(handle,'linewidth',1.5);
                handle= hline(CrossR_thresh,'y:'); set(handle,'linewidth',1.5);
                
                
                
                %% Print results
                
                subplot('Position', [0.8 0.1 0.2 0.3]);
                axis off;
                
                msg= sprintf('Trial AVG max loc= %1.3f (ms)', mean(Rmaxloc));
                text(-.3,1.3, msg, 'Fontsize',12);
                
                

                cd(saveROOT);
                
                
                filename_ai=[fig_name  '.eps'];
                print( gcf, '-painters', '-r300', filename_ai, '-depsc');
                
                
                
                filename=[fig_name  '.png'];
                saveImage(fig,fig_name,fig_pos);
                
                
                
                
                % fod=fopen(outputfile,'w');
                % txt_header = 'Key(PER), Key(HIPP), RatID, Session, Task_session, Task, TT(PER), TT(HIPP),';
                % fprintf(fod, txt_header);
                % txt_header = 'TrialAVG_Rmaxloc(ms), Rmaxloc(ms),';
                % fprintf(fod, txt_header);
                % fprintf(fod,'\n');
                % fclose(fod);
                
                
                
                
                %% Output file generation
                
                
                fod=fopen(outputfile,'a');
                fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, Key2, RatID, Session, Task_session,  Task, TTID, TTID2);
                fprintf(fod,',%1.5f, %1.5f',mean(Rmaxloc), meanR_maxloc);
                fprintf(fod,'\n');
                fclose('all');
                
                %
                %
                %         filename_png=[Prefix '-' date '.png'];
                %         saveImage(fig,filename_png,fig_pos);
                
                
                
            end %   i_s= 1:c_s
            
        end
        
        
    end
end


