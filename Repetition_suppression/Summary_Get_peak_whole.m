%% Created by AJR 2016/04/21 for PRC & POR analysis


function [summary,summary_header]= Summary_Get_peak_whole(summary, summary_header, dataROOT)


%% Output folder
saveROOT= [dataROOT '\Analysis\Repetition_Suppression_peak\' date];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);



%% FR criteria
fr_criteria= 0.5;  %% (in Hertz) firing rate criteria


%% Fig parms
txt_size= 10;
r_plot=2;c_plot=4;
fig_pos= [420,410,1300,700]; %six-core



%% Parms
Polarity=cell(1,4);
alpha= 0.05;
xpos=.95;
ypos=.9;


FourOBJ_str= {'Icecream', 'House','Owl','Phone'};
SceneOBJ_str= {'Zebra', 'Pebbles','Owl','Phone'};

FourOBJ_str2= {'Familiar', 'Novel'};
SceneOBJ_str2= {'Scene', 'OBJ'};



%% Load output files

%% FourOBJ
outputfile.FourOBJ= 'Repetition_Suppression(FourOBJ)_peak.csv';
% if ~exist(outputfile)
fod.FourOBJ = fopen(outputfile.FourOBJ,'w');
txt_header = 'Key#, RatID, Session, Task_session, Task, Region, ClusterID, nTrials, Performance_all,';
fprintf(fod.FourOBJ, txt_header);

txt_header = 'MeanPeak.PRE, MeanPeak.BEH, MeanPeak.POST, PeakDiff, PeakDiff_Norm, Waveform_similiarity_ind,';
fprintf(fod.FourOBJ, txt_header);

txt_header = 'Perf(Stimulus1), Perf(Stimulus2), Perf(Stimulus3), Perf(Stimulus4),';
fprintf(fod.FourOBJ, txt_header);


txt_header = '\n';
fprintf(fod.FourOBJ, txt_header);
fclose(fod.FourOBJ);
% end



%% SceneOBJ
outputfile.SceneOBJ= 'Repetition_Suppression(SceneOBJ)4.csv';
% if ~exist(outputfile)
fod.SceneOBJ = fopen(outputfile.SceneOBJ,'w');
txt_header = 'Key#, RatID, Session, Task, Region, ClusterID, nTrials, Performance_all,';
fprintf(fod.SceneOBJ, txt_header);

txt_header = 'MeanPeak.PRE, MeanPeak.BEH, MeanPeak.POST, PeakDiff, PeakDiff_Norm, Waveform_similiarity_ind,';
fprintf(fod.SceneOBJ, txt_header);

txt_header = 'Perf(Stimulus1), Perf(Stimulus2), Perf(Stimulus3), Perf(Stimulus4),';
fprintf(fod.SceneOBJ, txt_header);

txt_header = '\n';
fprintf(fod.SceneOBJ, txt_header);
fclose(fod.SceneOBJ);
% end




[r_s,c_s]=size(summary);



for i_s=  1:c_s
    
    
    
    if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?')
        
        
        
        
        
        %% Set cluster prefix
        
        set_cluster_prefix;
        
        
        
        %% Loading clusters
        
        load_clusters;
        
        
        %% Loading trial ts info from ParsedEvents.mat
        
        
        % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        % 13. StimulusCat
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load_ts_evt;
        
        %% Add stimulus category information
        
        if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            ts_evt= add_category_info(ts_evt,Task);
        end
        
        
        %% Eliminated void trials (trials with high latency (over 2 SD) and void signals)
        
        ts_evt= void_trial_elimination(ts_evt);
        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        
        %% Make a new matrix of timestamps with key events of our interest.
        
        ts_evt_new=[ts_evt(:,StimulusOnset) ts_evt(:,Choice) ];
        
        
        
        %% Get epoch firing rates  & significance test
        
        get_FR_significance;
        
        
        %% Performance
        
        Perf =[];
        
        for Stimulus_run = 1: 4
            
            eval(['Perf.Stimulus' num2str(Stimulus_run) ' = mean(ts_evt(select.Stimulus' num2str(Stimulus_run) '_All,Correctness));'])
            
        end
        
        
        
        
        %% Check for repetition suppression effect: slope and 1vs2 half comparison (following FR normalization from 0 to 10)
        
        CorrR= [];
        Corr_Pval =[];
        Pval_sig =[];
        Slope= [];
        Polarity =[];
        
        %         normalized all trial firing rate before stimulus_run
        norm_all_trial_fr = mapminmax(trial_fr', 0, 10)';
        
        
        
        
        %% amplitude by trials
        cd(TT_folder);
        if ~exist(TTID)
            findunderscore = findstr(TTID, '_');
            
            TTID = [TTID(1:findunderscore(1)-1) '.ntt'];
        end
        
        
        TTTS = Nlx2MatSpike(TTID, [1 0 0 0 0], 0, 1, 0);
        [ClusterTS, ClusterAP, ClusterHeader] = Nlx2MatSpike(ClusterID, [1 0 0 0 1], 1, 1, 0);
        
        
        for ADBit_ind=  10: 20
            findspace = findstr(ClusterHeader{ADBit_ind},' ');
            if numel(findspace)
                
                if ~strcmp(cellstr(ClusterHeader{ADBit_ind}(2:findspace(1))),'ADBitVolts')
                    ADBit_ind = ADBit_ind +1;
                else
                    ADBitVolts= str2double(ClusterHeader{ADBit_ind}(findspace(1)+1:findspace(2)));
                end
            end
        end
        
        %     TTAP = TTAP.* (ADBitVolts *10^6);
        ClusterAP = ClusterAP.* (ADBitVolts *10^6);
        
        % spike_alignment
        
        
        this_wave=[]; thisWidth=[];
        raw_wave_mat = [];
        aligned_wave_mat = [];
        amp_by_channel = [];
        
        
        %max amp
        for TT_run = 1:4
            
            [TT_max_amp(TT_run) TT_max_ind(TT_run)]= max(mean(squeeze(ClusterAP(:,TT_run,:)),2));
            
            
            %            for wave_run= 1: 50
            for wave_run= 1: size(ClusterAP,3)
                
                new_wave= nan(32,1);
                this_wave= ClusterAP(:,TT_run,wave_run);
                [max_amp max_ind] = max(this_wave);
                
                if max_ind ~= TT_max_ind(TT_run)
                    
                    max_diff= max_ind- TT_max_ind(TT_run);
                    
                    if max_diff > 0
                        
                        new_wave(1:end-max_diff)= this_wave(1+max_diff:end);
                        this_wave= new_wave;
                        
                    else
                        
                        new_wave(1-max_diff:end)= this_wave(1: end +max_diff);
                        this_wave= new_wave;
                    end
                    
                end
                aligned_wave_mat(:,wave_run)= this_wave;
                %            pause;
            end
            
            
            thisMEANAP(:,TT_run) = nanmean(aligned_wave_mat,2);
        end
        
        max_ch1 = max(thisMEANAP(:,1));
        max_ch2 = max(thisMEANAP(:,2));
        max_ch3 = max(thisMEANAP(:,3));
        max_ch4 = max(thisMEANAP(:,4));
        
        max_chs = [ max_ch1,  max_ch2,  max_ch3,  max_ch4];
        max_ch_value = max(max_chs);
        max_test=find(max_chs == max_ch_value);
        
        %getting amp from max channel amp
        for wave_run= 1: size(ClusterAP,3)
            
            new_wave= nan(32,1);
            this_wave= ClusterAP(:, max_test,wave_run);
            [max_amp max_ind] = max(this_wave);
            
            if max_ind ~= TT_max_ind(max_test)
                
                max_diff= max_ind- TT_max_ind(max_test);
                
                if max_diff > 0
                    
                    new_wave(1:end-max_diff)= this_wave(1+max_diff:end);
                    this_wave= new_wave;
                    
                else
                    
                    new_wave(1-max_diff:end)= this_wave(1: end +max_diff);
                    this_wave= new_wave;
                end
                
            end
            aligned_wave_mat(:,wave_run)= this_wave;
            
        end
        
        %time stamp
        ts_evt_new=[ts_evt(:,6) ts_evt(:,7) ];
        nb_trial_amp= size(ts_evt_new,1);
        current_amp_max = nan(nb_trial_amp,1);
        
        ClusterTS_new= ClusterTS/10^6;
        
        for trial_run= 1:nb_trial_amp
            trial_ts= ts_evt_new(trial_run,:);
            current_amp=find(ClusterTS_new > trial_ts(1)&ClusterTS_new < trial_ts(2));
            if current_amp ~= 0
                current_amp_max(trial_run,1)=nanmean(max(aligned_wave_mat(:,current_amp)));
            end
            
        end
        
        
        
        %         trials_nb = [1:nb_trial_amp]';
        %         fit_trials_nb =trials_nb;
        %         fit_current_amp_max = current_amp_max;
        %         % amp_max_smooth = smoothts(current_amp_max,'g',10);
        %
        %         subplot(1,1,1);
        %
        
        %%remove nan amp
        %         nan_amp = find(isnan(fit_current_amp_max));
        %         fit_current_amp_max(nan_amp,:) = [];
        %         fit_trials_nb(nan_amp,:) = [];
        %         %         [r p]=corrcoef(trials_nb,current_amp_max, 'rows', 'complete');
        %         [r p]=corrcoef(fit_trials_nb',fit_current_amp_max);
        %
        %         CorrR_amp=r(1,2);
        %         Corr_Pval_amp=p(1,2);
        %         Pval_sig_amp =  Corr_Pval_amp < alpha  ;
        %         pfit= polyfit(fit_trials_nb,fit_current_amp_max,1);
        %         yfit= pfit(1)*fit_trials_nb + pfit(2);
        %         Slope_amp=pfit(1);
        
        
        
        fig=figure('position',fig_pos);
        subplot(r_plot,c_plot,1:4);
        %          TS_row = (1:length(ClusterTS_new));
        %         scatter(TS_row,max(aligned_wave_mat),10, 'k','filled');
        scatter(ClusterTS_new,max(aligned_wave_mat),10, 'k','filled');
        
        axis([min(ClusterTS_new) max(ClusterTS_new) 0 (max(max(aligned_wave_mat))*1.5)]);
        xlabel(['Timestamp'],'fontsize',13,'fontweight','bold');
        
        ylabel(['Amp(Peak)'],'fontsize',13,'fontweight','bold');
        title(prefix,'fontsize',13); hold on;
        
        
        
        
        %vertical lines seperating PRE-BEH-POST
        Ex_Start=min(ClusterTS_new);
        Pre_END = str2num(summary(i_s).Pre_End)/10^6;
        StartTS = str2num(summary(i_s).StartTS)/10^6;
        EndTS = str2num(summary(i_s).EndTS)/10^6;
        Post_Start = str2num(summary(i_s).Post_Start)/10^6;
        Ex_End=max(ClusterTS_new);
        
        %
        %         line([Pre_END Pre_END], get(gca, 'ylim'));
        %         line([BEH_Start BEH_Start], get(gca, 'ylim'),'Color','r');
        %         line([BEH_End BEH_End], get(gca, 'ylim'),'Color','r');
        %         line([Post_Start Post_Start], get(gca, 'ylim'));
        
        line([Pre_END Pre_END], get(gca, 'ylim'),'Color','k');
        line([StartTS StartTS], get(gca, 'ylim'),'Color','r');
        line([EndTS EndTS], get(gca, 'ylim'),'Color','r');
        line([Post_Start Post_Start], get(gca, 'ylim'),'Color','b');
        
        
        %amplitude(peak)
        
        Amp_Peak = max(aligned_wave_mat);
        
        Epoch.PRE = find(ClusterTS_new >= Ex_Start &ClusterTS_new < StartTS);
        Epoch.BEH = find(ClusterTS_new > StartTS &ClusterTS_new < EndTS);
        Epoch.POST = find(ClusterTS_new > Post_Start);
        
        PeakAMP.PRE = Amp_Peak(Epoch.PRE);
        TS.PRE = ClusterTS_new(Epoch.PRE);
        
        PeakAMP.BEH =Amp_Peak(Epoch.BEH);
        TS.BEH = ClusterTS_new(Epoch.BEH);
        
        PeakAMP.POST = Amp_Peak(Epoch.POST);
        TS.POST = ClusterTS_new(Epoch.POST);
        
        scatter(TS.BEH,PeakAMP.BEH,10, 'r','filled');
        scatter(TS.POST,PeakAMP.POST,10, 'b','filled')
        
        Max_amp = max(thisMEANAP(:,max_test));
        Min_amp = min(thisMEANAP(:,max_test));
        
        
        BEH_Start=max(find(ClusterTS_new <= StartTS));
        BEH_End=max(find(ClusterTS_new < EndTS));
        
        
        %mean, sd, limits
        peak_mean = nanmean(PeakAMP.BEH);
        peak_sd = nanstd(PeakAMP.BEH);
        
        
        MeanPeak.PRE = nanmean(PeakAMP.PRE);
        MeanPeak.BEH = nanmean(PeakAMP.BEH);
        MeanPeak.POST = nanmean(PeakAMP.POST);
        
        PeakDiff= abs(MeanPeak.BEH - MeanPeak.POST);
        
        
        
        
        
        
        
        %waveform
        thisMEANAP_PRE = nanmean(aligned_wave_mat(:,Epoch.PRE),2);
        thisMEANAP_BEH = nanmean(aligned_wave_mat(:,BEH_Start:BEH_End),2);
        if isempty(BEH_Start)
            thisMEANAP_BEH = nanmean(aligned_wave_mat(:,1:BEH_End),2);
        end
        
        thisMEANAP_POST = nanmean(aligned_wave_mat(:,BEH_End:end),2);
        %         aligned_wave_mat(:,1:BEH_Start);
        %         aligned_wave_mat(:,BEH_Start:BEH_End);
        %         aligned_wave_mat(:,BEH_End:end);
        
        
        
        
        %% Normalization
        PeakAMP_Norm.BEH = mapminmax(PeakAMP.BEH, 0, 1);
        PeakAMP_Norm.POST = mapminmax(PeakAMP.POST, 0, 1);
        
        MeanPeak_Norm.BEH = nanmean(PeakAMP_Norm.BEH);
        MeanPeak_Norm.POST = nanmean(PeakAMP_Norm.POST);
        
        PeakDiff_Norm= abs(MeanPeak_Norm.BEH - MeanPeak_Norm.POST);
        
        
        Waveform_similiarity_ind =sum(thisMEANAP_BEH .* thisMEANAP_POST)/ sqrt(sum(thisMEANAP_BEH.^2) * sum(thisMEANAP_POST.^2));
        
        
        %Spike display
        %1.spike: PRE
        hold on;
        subplot(r_plot,c_plot,5);
        %                     h2=shadedErrorBar([0:size(aligned_wave_mat,1)-1].*32,nanmean(aligned_wave_mat,2),nanstd(aligned_wave_mat,[],2) / sqrt(size(aligned_wave_mat,2)),{'b-','markerfacecolor','b'}); hold on; box off;
        plot([0:size(aligned_wave_mat(:,1:BEH_Start),1)-1].*32,thisMEANAP_PRE, 'k', 'linewidth',2); hold on; box off;
        title(sprintf('PRE')); xlabel('time(ms)'); ylabel('amplitude(\muV)');
        ylim([(round((Min_amp)/10)-5)*10   ceil((Max_amp/10)+5)*10])
        box off;
        hold on;
        
        %2.spike: BEH
        subplot(r_plot,c_plot,6);
        
        plot([0:size(aligned_wave_mat(:,BEH_Start:BEH_End),1)-1].*32,thisMEANAP_BEH, 'r', 'linewidth',2); hold on; box off;
        title(sprintf('BEH')); xlabel('time(ms)'); ylabel('amplitude(\muV)');
        ylim([(round((Min_amp)/10)-5)*10   ceil((Max_amp/10)+5)*10])
        box off;
        hold on;
        
        
        %3.spike: POST
        subplot(r_plot,c_plot,7);
        
        plot([0:size(aligned_wave_mat(:,BEH_End:end),1)-1].*32,thisMEANAP_POST, 'b', 'linewidth',2); hold on; box off;
        title(sprintf('POST')); xlabel('time(ms)'); ylabel('amplitude(\muV)');
        ylim([(round((Min_amp)/10)-5)*10   ceil((Max_amp/10)+5)*10])
        box off;
        hold on;
        
        %4.spike: Combined
        subplot(r_plot,c_plot,8);
        
        plot([0:size(aligned_wave_mat(:,1:BEH_Start),1)-1].*32,thisMEANAP_PRE, 'k', 'linewidth',2);  hold on;
        plot([0:size(aligned_wave_mat(:,BEH_Start:BEH_End),1)-1].*32,thisMEANAP_BEH, 'r', 'linewidth',2);  hold on;
        plot([0:size(aligned_wave_mat(:,BEH_End:end),1)-1].*32,thisMEANAP_POST, 'b', 'linewidth',2);  hold on;
        
        title(sprintf('Combined')); xlabel('time(ms)'); ylabel('amplitude(\muV)');
        ylim([(round((Min_amp)/10)-5)*10   ceil((Max_amp/10)+5)*10])
        box off;
        
        %         if Pval_sig_amp
        %             plot(fit_trials_nb,yfit,'b');
        %         else
        %             plot(fit_trials_nb,yfit,'b--');
        %         end
        %
        %         current_amp_max_zero = current_amp_max;
        %         current_amp_max_zero(nan_amp,:) = 0;
        %
        %         %  Z = zscore(current_amp_max_zero);
        %         Norm_amp.minmax = mapminmax(current_amp_max_zero', 0, 1);
        %         Norm_amp.mean = current_amp_max_zero./mean(current_amp_max_zero);
        %         sd_amp.minmax = std(Norm_amp.minmax);
        %         sd_amp.mean = std(Norm_amp.mean);
        %
        
        %
        %         msg= sprintf('CorrR= %1.3f',CorrR_amp);        text(xpos,ypos,msg,'units','normalized')
        %
        %         msg= sprintf('Pval=%1.3f', Corr_Pval_amp);        text(xpos,ypos-.1,msg,'units','normalized')
        %
        %         msg= sprintf('Slope=%1.3f', Slope_amp);        text(xpos,ypos-.2,msg,'units','normalized')
        %
        %         msg= sprintf('S.D. ofAmp(minmax) =%1.3f', sd_amp.minmax);        text(xpos,ypos-.3,msg,'units','normalized')
        %
        %         msg= sprintf('S.D of Amp(mean) =%1.3f', sd_amp.mean);        text(xpos,ypos-.4,msg,'units','normalized')
        % %
        %
        
        % %% normalized amp max
        % normalized_amp_max = mapminmax(fit_current_amp_max', 0, 10);
        % subplot(r_plot,c_plot,9); hold on;
        % axis([0 length(fit_trials_nb) 0 10]);
        % scatter(fit_trials_nb,normalized_amp_max,'filled');
        %
        %  [r p]=corrcoef(fit_trials_nb',normalized_amp_max);
        %
        %             CorrR_amp=r(1,2);
        %             Corr_Pval_amp=p(1,2);
        %             Pval_sig_amp =  Corr_Pval_amp < alpha  ;
        %             pfit= polyfit(fit_trials_nb,normalized_amp_max',1);
        %             yfit= pfit(1)*fit_trials_nb + pfit(2);
        %             Slope_amp=pfit(1);
        %
        %              if Pval_sig_amp
        %             plot(fit_trials_nb,yfit,'b');
        %         else
        %             plot(fit_trials_nb,yfit,'b--');
        %  end
        %
        %              msg1= sprintf('CorrR= %1.3f',CorrR_amp);
        %         msg2= sprintf('Pval=%1.3f', Corr_Pval_amp);
        %         msg3= sprintf('Slope=%1.3f', Slope_amp);
        %
        %         text(xpos,ypos,msg1,'units','normalized')
        %         text(xpos,ypos-.1,msg2,'units','normalized')
        %         text(xpos,ypos-.2,msg3,'units','normalized')
        % hold off;
        
        
        
        
        %% Save root per session
        session_saveROOT=[saveROOT '\' summary(i_s).Task_name];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)
        
        
        %% Save figures
        %         filename_ai=[prefix '.eps'];
        %         print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        filename=[prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
        %% Save output files
        
        cd(saveROOT);
        
        
        
        if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            fod.FourOBJ=fopen(outputfile.FourOBJ,'a');
            fprintf(fod.FourOBJ,'%s ,%s ,%s ,%s , %s ,%s ,%s, %d ,%1.3f', Key, RatID, Session, Task_session, Task, Region, ClusterID ,nb_trial.all, nanmean(ts_evt(:,Correctness)));
            fprintf(fod.FourOBJ,',%1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f,', MeanPeak.PRE, MeanPeak.BEH, MeanPeak.POST, PeakDiff, PeakDiff_Norm, Waveform_similiarity_ind);
            fprintf(fod.FourOBJ,',%1.3f, %1.3f, %1.3f, %1.3f,', Perf.Stimulus1, Perf.Stimulus2, Perf.Stimulus3, Perf.Stimulus4);
            fprintf(fod.FourOBJ, '\n');
            fclose('all');
            
        elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            fod.SceneOBJ=fopen(outputfile.SceneOBJ,'a');
            fprintf(fod.SceneOBJ,'%s ,%s ,%s ,%s ,%s ,%s ,%s, %d ,%1.3f', Key, RatID, Session, Task, Task_session, Region, ClusterID ,nb_trial.all, nanmean(ts_evt(:,Correctness)));
            fprintf(fod.SceneOBJ,'%1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f,', MeanPeak.PRE, MeanPeak.BEH, MeanPeak.POST, PeakDiff , PeakDiff_Norm, Waveform_similiarity_ind);
            fprintf(fod.SceneOBJ, '\n');
            fclose('all');
        end
        
        
    end   %  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)'))
    
end   % i_s=  1 :c_s



end
