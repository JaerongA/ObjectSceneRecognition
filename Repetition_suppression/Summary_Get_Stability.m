%% Created by AJR 2017/06/30 for PRC & POR analysis
%% Tests the stability of a neuron
%% Compares the waveform across trials by calculating waveform similiarity

function [summary,summary_header]= Summary_Get_Stability(summary, summary_header, dataROOT)


%% Output folder
saveROOT= [dataROOT '\Analysis\Repetition_Suppression\Stability\' date];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);



%% Fig parms
txt_size= 10;
r_plot=2;c_plot=4;
fig_pos= [150,300,1500,600]; %six-core

%% Parms
alpha= 0.01;
nb_block= 10;



%% Load output files

outputfile= 'Unit_Stability.csv';

fod = fopen(outputfile,'w');
txt_header = 'Key#, RatID, Session, Task_session, Task, Region, SubRegion, ClusterID, nTrials, Performance,';
fprintf(fod, txt_header);

txt_header = 'Mean_Peak, MeanFR(Epoch), CorrR, CorrPval, Pval_sig';
fprintf(fod, txt_header);

txt_header = '\n';
fprintf(fod, txt_header);
fclose(fod);



[r_s,c_s]=size(summary);



for i_s =  1:c_s
    
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) ...
    if       (str2num(summary(i_s).Epoch_FR) >= 0.5) && (str2num(summary(i_s).Zero_FR_Proportion) < 0.5)    %% For 2nd revision of CR
        
        
        
        %% Set cluster prefix
        
        set_cluster_prefix;
        
        %% Loading trial ts info from ParsedEvents.mat
        
        
        % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        % 13. StimulusCat
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load_ts_evt;
        
        
        %% Loading clusters
        
        load_clusters;
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        %% Get epoch firing rates  & significance test
        
        get_FR_significance;
        
        
        %% Get waveform
        
        [ClusterAP, ClusterHeader] = Nlx2MatSpike(ClusterID, [0 0 0 0 1], 1, 1, 0);
        
        
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
        
        
        ClusterAP = ClusterAP.* (ADBitVolts *10^6);
        
        
        %% Spike_alignment
        
        aligned_wave_mat = [];
        
        
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
        
        clear aligned_wave_mat
        
        
        max_amp= [];
        
        for TT_run = 1: 4
            
            max_amp(TT_run)=  max(thisMEANAP(:,TT_run));
            
        end
        
        max_test =find(max_amp == max(max_amp));
        

        %% Getting amp from max channel amp
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
        
        
        
        fig=figure('name', Prefix,'Color',[1 1 1],'Position',fig_pos);
     
        
        subplot(r_plot,c_plot,1:4);
        
%         scatter(ts_spk,max(aligned_wave_mat),5, 'k','filled');
%         
%         axis([min(ts_spk) max(ts_spk) 0 (max(max(aligned_wave_mat))*1.5)]);
%         xlabel(['Timestamp'],'fontsize',13,'fontweight','bold');
%         ylabel(['Peak Amplitude(\muV)'],'fontsize',13,'fontweight','bold');
        title(Prefix,'fontsize',13); hold on;
        
        nb_trial= size(ts_evt,1);
        trial_amp = nan(nb_trial,1);
        trial_wave = nan(32,nb_trial);
        trial_nb = [1:size(ts_evt,1)];
        
        for trial_run= 1:nb_trial
            trial_ts= ts_evt(trial_run,:);
            current_amp=find(ts_spk > trial_ts(StimulusOnset)& ts_spk < trial_ts(Choice));
            if current_amp ~= 0
                trial_amp(trial_run,1)=nanmean(max(aligned_wave_mat(:,current_amp)));
                trial_wave(:,trial_run)= mean(aligned_wave_mat(:,current_amp),2);
            end
        end
        
        
        %% Remove NaNs
        trial_wave(:,isnan(trial_amp))=[]; trial_amp(isnan(trial_amp))=[]; nb_trial= numel(trial_amp);
        
        
        subplot('position',[0.05 0.1 0.15 0.3]);
        
        
        scatter([1:nb_trial], trial_amp,12,'k','filled');
        set(gca,'ylim',[0 (max(max(aligned_wave_mat))*1.5)])
        title('Stability','fontsize',14); xlabel(['Trial #'],'fontsize',13,'fontweight','bold'); ylabel('Peak Amplitude(\muV)','fontsize',13,'fontweight','bold');
        box off;
        hold on;
        
        handle= hline(nanmean(trial_amp),'k:'); set(handle,'linewidth',1.5);
        %         handle= hline(mean(max(aligned_wave_mat)),'k:'); set(handle,'linewidth',1.5);
        
        
        [r p]= corrcoef([1:length(trial_nb(~isnan(trial_amp)))], trial_amp(~isnan(trial_amp)));
        
        CorrR=r(1,2);
        Corr_Pval=p(1,2);
        Pval_sig =  Corr_Pval < alpha  ;
        
        clear r p
        
        
        pfit= polyfit([1:length(trial_nb(~isnan(trial_amp)))],trial_amp(~isnan(trial_amp))',1);
        yfit= pfit(1)*[1:length(trial_nb(~isnan(trial_amp)))] + pfit(2);
        
        fitting_line= plot([1:max(get(gca,'xlim'))],pfit(1)*[1:max(get(gca,'xlim'))]+ pfit(2));
        
        
        if Pval_sig
            set(fitting_line,'LineStyle','-','Color','r')
        else
            set(fitting_line,'LineStyle',':','Color','b')
        end
        
        
        mean_peak_amp = nan(1,nb_block);
        mean_wave= nan(32,nb_block);
        
        %         trials_in_block = floor(length(trial_amp)/nb_block +1)
        trials_in_block = floor(length(trial_amp)/nb_block);
        
        for block_run = 0 : nb_block-1
            (trials_in_block*block_run)+1: trials_in_block*(block_run+1);
            try
                mean_peak_amp(:,block_run+1) = nanmean(trial_amp((trials_in_block*block_run)+1: trials_in_block*(block_run+1)));
                mean_wave(:,block_run+1) = nanmean(trial_wave(:,(trials_in_block*block_run)+1: trials_in_block*(block_run+1)),2);
            catch
                mean_peak_amp(:,block_run+1) = nanmean(trial_amp((trials_in_block*block_run)+1: end));
                mean_wave(:,block_run+1) = nanmean(trial_wave(:, (trials_in_block*block_run)+1: end),2);
            end
        end
        
        subplot('position',[0.25 0.1 0.15 0.3]);
        
        scatter([1:nb_block], mean_peak_amp, 25); box off; hold on;
        
        %         handle= hline(mean(mean_peak_amp),'k:'); set(handle,'linewidth',1.5);
        set(gca,'ylim',[0 (max(max(aligned_wave_mat))*1.5)]); xlabel(['Trial Block'],'fontsize',13,'fontweight','bold');
        title('Avg Peak Amplitude (10 Blocks)');
        [r p]= corrcoef([1:nb_block], mean_peak_amp);
        
        CorrR=r(1,2);
        Corr_Pval=p(1,2);
        
        Pval_sig =  Corr_Pval < alpha  ;
        
        clear r p
        
        
        pfit= polyfit([1:nb_block],mean_peak_amp,1);
        yfit= pfit(1)*[1:nb_block] + pfit(2);
        
        fitting_line= plot([0:max(get(gca,'xlim'))],pfit(1)*[0:max(get(gca,'xlim'))]+ pfit(2));
        
        if Pval_sig
            set(fitting_line,'LineStyle','-','Color','r');
        else
            set(fitting_line,'LineStyle',':','Color','b');
        end
        
        
        subplot('position',[0.45 0.1 0.12 0.3]);
        
        plot(mean_wave); box off; xlim([0 32]); set(gca,'Xtick',[0 32],'XtickLabel',sprintfc('%i',[0 1000]));
        title('Waveform (10 blocks)');
        xlabel(['(ms)'],'fontsize',10,'fontweight','bold');
        ylabel(['\muV'],'fontsize',13,'fontweight','bold');
        
        
        %         %% Waveform similaritiy (In blocks (10trial))
        %
        %         wave_similarity_ind =nan(1,nb_block);
        %
        %         for block_run= 1: nb_block
        %
        %             waveform =[];
        %             waveform.ref= mean_wave(:,1);
        %             waveform.target= mean_wave(:,block_run);
        %             nanind = isnan(waveform.ref)| isnan(waveform.target);
        %             waveform.ref(nanind)=[];
        %             waveform.target(nanind)=[];
        %
        %             wave_similarity_ind(block_run) = sum(waveform.ref .* waveform.target) / sqrt(sum(waveform.ref.^2) * sum(waveform.target.^2));
        %
        %         end
        %
        %
        %
        %
        %         scatter([1:nb_block], wave_similarity_ind, 25); box off; hold on;
        %         xlabel(['Trial Block'],'fontsize',13,'fontweight','bold');
        %         title('Waveform simliarity(10 Blocks)');
        %         [r p]= corrcoef([1:nb_block], wave_similarity_ind);
        %
        %         CorrR=r(1,2);
        %         Corr_Pval=p(1,2);
        %
        %         Pval_sig =  Corr_Pval < alpha  ;
        %
        %         clear r p
        %
        %
        %         pfit= polyfit([1:nb_block],wave_similarity_ind,1);
        %
        %         fitting_line= plot([0:max(get(gca,'xlim'))],pfit(1)*[0:max(get(gca,'xlim'))]+ pfit(2));
        %
        %         if Pval_sig
        %             set(fitting_line,'LineStyle','-','Color','r')
        %         else
        %             set(fitting_line,'LineStyle',':','Color','b')
        %         end
        
        
        subplot('position',[0.62 0.1 0.15 0.3]);
        
        %
        %         scatter([1:nb_block], wave_similarity_ind, 25); box off; hold on;
        %         xlabel(['Trial Block'],'fontsize',13,'fontweight','bold');
        %         title('Waveform simliarity(10 Blocks)');
        %         [r p]= corrcoef([1:nb_block], wave_similarity_ind);
        %
        %         CorrR=r(1,2);
        %         Corr_Pval=p(1,2);
        %
        %         Pval_sig =  Corr_Pval < alpha  ;
        %
        %         clear r p
        %
        %
        %         pfit= polyfit([1:nb_block],wave_similarity_ind,1);
        %
        %         fitting_line= plot([0:max(get(gca,'xlim'))],pfit(1)*[0:max(get(gca,'xlim'))]+ pfit(2));
        
        
        
        
        
        %% Waveform similaritiy
        
        wave_similarity_ind =nan(1,nb_trial);
        
        for trial_run= 1: nb_trial
            
            waveform =[]; nanind= [];
            waveform.ref= trial_wave(:,1);
            waveform.target= trial_wave(:,trial_run);
            nanind = isnan(waveform.ref)| isnan(waveform.target);
            waveform.ref(nanind)=[];
            waveform.target(nanind)=[];
            
            wave_similarity_ind(trial_run) = sum(waveform.ref .* waveform.target) / sqrt(sum(waveform.ref.^2) * sum(waveform.target.^2));
            
        end
        
        scatter([1:nb_trial], wave_similarity_ind, 25); box off; hold on;
        set(gca,'ylim',[0.6 1.2])
        xlabel(['Trial #'],'fontsize',13,'fontweight','bold');
        title('Waveform simliarity');
        [r p]= corrcoef([1:nb_trial], wave_similarity_ind);
        
        CorrR=r(1,2);
        Corr_Pval=p(1,2);
        
        Pval_sig =  Corr_Pval > alpha  ;
        
        clear r p
        
        
        pfit= polyfit([1:nb_trial],wave_similarity_ind,1);
        
        fitting_line= plot([0:max(get(gca,'xlim'))],pfit(1)*[0:max(get(gca,'xlim'))]+ pfit(2));
        
        
        
        if  ~Pval_sig
            set(fitting_line,'LineStyle','-','Color','r')
        else
            set(fitting_line,'LineStyle',':','Color','b')
        end
        
        
        summary(i_s).Stability_ok= sprintf('%d',Pval_sig);
        
        
        
        
        
        msg= sprintf('Cell CAT = %s', summary(i_s).Cell_Category);
        text(1.2,1.1,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('CorrR = %1.3f',CorrR);
        text(1.2,0.9,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('Pval =%1.3f', Corr_Pval);
        text(1.2,0.7,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('mean AP Peak = %1.2f (uV)', mean(max(aligned_wave_mat)));  %% Mean FR from the event period
        text(1.2,0.5,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('mean FR (Epoch) = %1.2f (Hz)', mean_fr.all);  %% Mean FR from the event period
        text(1.2,0.3,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('Zero spike proportion = %2.2f (%%)', str2num(summary(i_s).Zero_FR_Proportion)* 100);  %% Mean FR from the event period
        text(1.2,0.1,msg,'Fontsize',12,'units','normalized');
        
        
        
        %% Save root per session
        session_saveROOT=[saveROOT '\' summary(i_s).Task_name];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)
        
        
        %% Save figures
        filename_ai=[Prefix '.eps'];
        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
        %% Save output files
        
        
        
        % fod = fopen(outputfile,'w');
        % txt_header = 'Key#, RatID, Session, Task_session, Task, Region, ClusterID, nTrials, Performance,';
        % fprintf(fod, txt_header);
        %
        % txt_header = 'Mean_Peak, MeanFR(Epoch), CorrR, CorrPval, Pval_sig';
        % fprintf(fod, txt_header);
        %
        % txt_header = '\n';
        % fprintf(fod, txt_header);
        % fclose(fod);
        
        
        
        cd(saveROOT);
        
        fod=fopen(outputfile,'a');
        fprintf(fod,'%s ,%s ,%s ,%s , %s ,%s ,%s, %d ,%1.3f', Key, RatID, Session, Task_session, Task, Region, ClusterID ,nb_trial, nanmean(ts_evt(:,Correctness)));
        fprintf(fod,',%1.3f, %1.3f, %1.3f, %1.3f, %d,', mean(max(aligned_wave_mat)), mean_fr.all, CorrR, Corr_Pval, Pval_sig);
        fprintf(fod, '\n');
        fclose('all');
        
        
        clear nb_trial*
        
    end   %  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)'))
    
end   % i_s=  1 :c_s



end
