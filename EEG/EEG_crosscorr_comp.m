%% Created by Jaerong 2018/10/13 for 2nd revision of CR manuscript
%% Generates the crosscorrelations between event pair of tetrodes recorded within the same session

function [summary,summary_header]=EEG_crosscorr_comp(summary, summary_header,dataROOT)


cd(dataROOT);
pre_folder=[];



%% Load EEG Parms

EEG_parms;



%% Fig parms

fig_pos = [50 100 1700 800];
fig_ok= 0;



%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\CrossCorr\RegionalComparison\test' date];

if ~exist(saveROOT)
    mkdir(saveROOT);
end
cd(saveROOT)



%% Output file

outputfile= 'EEG_CrossCorrComparsion.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key(Ref), Key(Target), RatID, Session, Task_session, Task, TT(Ref), TT(Target), Region(Ref), Region(Target), RegionalPair,';
fprintf(fod, txt_header);
txt_header = 'MaxR,';
fprintf(fod, txt_header);
fprintf(fod,'\n');
fclose(fod);




DiffMAT =[];
SameMAT_PER= [];
SameMAT_HIPP= [];
                           


%% Summary
[r_s,c_s]=size(summary);


for i_s= 1:20
%     c_s
    
    
    %     if  strcmp(summary(i_s).Visual_Inspection, '1') && strcmp(summary(i_s).Power_criteria, '1') && strcmp(summary(i_s).Region, 'PER')
    %     if  (str2num(summary(i_s).Key) > 468) && strcmp(summary(i_s).Second_revision, '1')
    if  strcmp(summary(i_s).Second_revision, '1') 
%     if  strcmp(summary(i_s).Power_criteria, '1') && strcmp(summary(i_s).Region, 'PER')
        
        
        
        %% Set EEG info
        
        set_eeg_prefix;
        
        
        
        %% Select another TT from a different regions recorded in the same session
        
        
        nb_target =size(summary,2);
        
        
        
        for Target_run= 1: nb_target
            
            
            
            
            % Set EEG info
            
            target_set_prefix;
            
            
            
            
            if  strcmp(summary(Target_run).Second_revision, '1')  && strcmp(RatID, RatID2) && strcmp(Session, Session2)
%             if  strcmp(summary(Target_run).Power_criteria, '1')  && strcmp(RatID, RatID2) && strcmp(Session, Session2)
                
                Keysort= nan;
                
                if strcmp(Region, Region2)
                    
                    
                    Keysort= (str2num(Key)< str2num(Key2));
                    
                    if ~Keysort
                        continue
                        
                    end
                    
                end
                
                
                
                disp(['Ref TT... ' Prefix]);
                disp(['Target TT... : ' Prefix2 ]);
                
                
                
                if strcmp(Region, Region2)
                    RegionalPair = 'Same';
                else
                    RegionalPair = 'Diff';
                end
                
                
                
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
                    csc_REF= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
                    csc_TARGET= sprintf('CSC%s_Noise_filtered.ncs',summary(Target_run).TT);
                    
                    ts_vector = [ts_evt(trial_run,StimulusOnset), ts_evt(trial_run,Choice)];
                    
                    
                    [thisEEG.REF, thisEEGTS] = get_EEG(csc_REF, ts_vector, bit2micovolt);
                    [thisEEG.TARGET,thisEEGTS] = get_EEG(csc_TARGET, ts_vector, bit2micovolt);
                    
                    
                    if isempty(thisEEG.REF) || isempty(thisEEG.TARGET)
                        disp('no data');
                        continue
                    end
                    
                    
                    % Calculate Z-score to put the signal on the same scale
                    % (Normalization)
                    
                    thisEEG.REF = zscore(thisEEG.REF);
                    thisEEG.TARGET = zscore(thisEEG.TARGET);
                    
                    
                    
                    
                    %% Caculate CrossR
                    
                    [crossR,lag] = xcorr(thisEEG.REF,thisEEG.TARGET,'coeff');
                    %                     [crossR,lag] = xcorr(zscore(thisEEG.REF),zscore(thisEEG.TARGET),'coeff');
                    
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
                        
                        plot(((thisEEGTS-thisEEGTS(1))), thisEEG.REF,'b'); hold on;
                        plot(((thisEEGTS-thisEEGTS(1))), thisEEG.TARGET,'m'); box off;
                        %                     axis tight;
                        legend('TT1','TT2','location','eastoutside');
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
                        
                        msg= sprintf('Max CorrR = %1.3f ', Rmax(trial_run));
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
                
                if maxCrossR < CrossR_thresh
                    continue
                else
                end
                
                
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
                
                msg= sprintf('Max location = %1.3f (ms)', meanR_maxloc);
                text(-.3,1.3, msg, 'Fontsize',12);
                
                msg= sprintf('Max R = %1.3f ', max(meanCrossR));
                text(-.3,1.1, msg, 'Fontsize',12);
                
                
                
                cd(saveROOT);
                
                
                filename_ai=[fig_name  '.eps'];
                print( gcf, '-painters', '-r300', filename_ai, '-depsc');
                
                
                
                filename=[fig_name  '.png'];
                saveImage(fig,fig_name,fig_pos);
                
                mat_name =[Prefix ' -' Prefix2 ' -' RegionalPair '.mat'];
                save(mat_name,'meanCrossR');
                
                
                % fod=fopen(outputfile,'w');
                % txt_header = 'Key(PER), Key(HIPP), RatID, Session, Task_session, Task, TT(PER), TT(HIPP),';
                % fprintf(fod, txt_header);
                % txt_header = 'TrialAVG_Rmaxloc(ms), Rmaxloc(ms),';
                % fprintf(fod, txt_header);
                % fprintf(fod,'\n');
                % fclose(fod);
                
                
                
                if strcmp(RegionalPair,'Diff')
                    
                    DiffMAT= [DiffMAT ; meanCrossR];
                elseif strcmp(RegionalPair,'Same')
                    if strcmp(Region, 'PER')
                        SameMAT_PER= [SameMAT_PER ; meanCrossR];
                    elseif strcmp(Region,'IntHIPP')
                        SameMAT_HIPP= [SameMAT_HIPP ; meanCrossR];
                    end
                end
                
                
                
                
                
                %% Output file generation

                
                fod=fopen(outputfile,'a');
                fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, Key2, RatID, Session, Task_session,  Task, TTID, TTID2, Region, Region2, RegionalPair);
                fprintf(fod,',%1.5f,',max(meanCrossR));
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


cd(saveROOT);

% figure(); subplot(1,2,1); plot(mean(SameMAT)); title('WithinRegion'); ylim([-1 1]);
% subplot(1,2,2); plot(mean(DiffMAT)); title('BetweenRegion'); ylim([-1 1]);





fig= figure(); plot(mean(SameMAT_PER,1),'linewidth',2); title('CC comparison'); ylim([-1 1]); hold on;
plot(mean(SameMAT_HIPP,1),'linewidth',2); hold on;
plot(mean(DiffMAT,1),'linewidth',2); legend('Within(PER)','Within(HIPP)','Between'); box off;
saveas(fig,'CC_Comparison.png');
saveas(fig,'CC_Comparison','epsc')

end
