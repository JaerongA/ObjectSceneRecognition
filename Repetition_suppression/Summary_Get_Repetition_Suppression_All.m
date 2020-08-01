%% Created by Jaerong 2017/02/22 for PER & POR analysis


function [summary,summary_header]= Summary_Get_Repetition_Suppression_All(summary, summary_header, dataROOT)


%% Output folder
% saveROOT= [dataROOT '\Analysis\Repetition_Suppression\AllTrials\' date ];
saveROOT= [dataROOT '\Analysis\Repetition_Suppression\AllTrials\' date ];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);



%% Fig parms
fig_pos= [100,150,1700,800];
bgcol=[1 0.6 0.6; 0.6 1 0.6];



%% Parms
alpha= 0.05;
xpos=0.8;
ypos=1.35;

nb_block = 10;

% fitting_cat= {'NoFitting','Non_specific','Familiar','Novel'};



%% Load output files

%% FourOBJ
outputfile.FourOBJ= 'Repetition_Suppression(FourOBJ).csv';
fod.FourOBJ = fopen(outputfile.FourOBJ,'w');
txt_header = 'Key#, RatID, Session, Region, Bregma, ClusterID, nTrials, Performance_All, MeanFR(Epoch), ZeroSpkProportion, Cell_Category, Fitting_Category,';
fprintf(fod.FourOBJ, txt_header);
txt_header = 'BestFittingOBJ, CorrR, Corr_Pval, Slope, Polarity, Perf_Stimulus, Stability_OK,';
fprintf(fod.FourOBJ, txt_header);
txt_header = '\n';
fprintf(fod.FourOBJ, txt_header);
fclose(fod.FourOBJ);

% txt_header = 'Slope(Icecream), Slope(House), Slope(Owl), Slope(Phone), Polarity(Icecream), Polarity(house), Polarity(owl), Polarity(phone), Pval_sig_amp, percent_zero, p_amp, perf_fam, perf_nov, exclusion,';
% txt_header = 'CorrR(Icecream), CorrR(House), CorrR(Owl), CorrR(Phone), Corr_Sig(Icecream), Corr_Sig(House), Corr_Sig(Owl), Corr_Sig(phone),';



%% SceneOBJ
outputfile.SceneOBJ= 'Repetition_Suppression(SceneOBJ).csv';
fod.SceneOBJ = fopen(outputfile.SceneOBJ,'w');
txt_header = 'Key#, RatID, Session, Region, ClusterID, nTrials, Performance_All, MeanFR(Epoch), ZeroSpkProportion, Fitting_Category,';
fprintf(fod.SceneOBJ, txt_header);
txt_header = 'CorrR, Corr_Pval, Slope, Polarity, Perf_Stimulus, Stability_OK';
fprintf(fod.SceneOBJ, txt_header);
txt_header = '\n';
fprintf(fod.SceneOBJ, txt_header);
fclose(fod.SceneOBJ);




[r_s,c_s]=size(summary);



for i_s=  1:c_s
    
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?')
    %          if  strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')  && (str2num(summary(i_s).Epoch_FR) >= 0.5) &&  (str2num(summary(i_s).Task_session)== 1) && (str2num(summary(i_s).Repetition_ok)== 1)
    %     if  strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')  && (str2num(summary(i_s).Epoch_FR) >= 0.5) &&  (str2num(summary(i_s).Repetition_ok)== 1)
%     if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')  && (str2num(summary(i_s).Epoch_FR) >= 0.5)  && (str2num(summary(i_s).Zero_FR_Proportion) < 0.5)...
%             && ~strcmp(summary(i_s).Region,'POR') && (str2num(summary(i_s).Stability_ok)== 1)
        
        
        if ~strcmp(summary(i_s).Region,'POR') && (str2num(summary(i_s).Quality_ok)== 1)
        
            
        %% Set cluster Prefix
        
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
        
        
        
        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        
        %% Get epoch firing rates  & significance test
        
        get_FR_significance;
        
        
        
        %% Performance
        
        Perf =[];
        Corr_mat =[];
        
        for Stimulus_run = 1: 4
            
            eval(['Corr_mat{Stimulus_run} = ts_evt(select.Stimulus' num2str(Stimulus_run) '_All,Correctness);']);
            Perf(Stimulus_run)= mean(cell2mat(Corr_mat(Stimulus_run)));
        end
        
        
        
        
        %% Figure parms
        
        fig=figure('name',[  Prefix '_' date],'Color',[1 1 1],'Position',fig_pos);
        
        
        %% Print out cell ID
        
        subplot('Position', [0.35 0.98 0.4 0.2]);
        text(0,0,Prefix,'fontsize',14);
        axis off;
        
        
        
        %% Check for repetition suppression effect: slope and 1vs2 half comparison (following FR normalization from 0 to 10)
        
        CorrR= [];
        Corr_Pval =[];
        Pval_sig =[];
        Slope= [];
        Polarity =[];
        
        norm_all_trial_fr = mapminmax(trial_fr', 0, 10)';
        
        
        for Stimulus_run = 1:4
            
            
            subplot('position',[((Stimulus_run-1)/4)+0.03 0.5 0.18 0.3]);
            
            
            %% All trials
            eval(['trial_nb= [1:length(norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All))];']);
            eval(['norm_trial_fr{Stimulus_run}= norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All);']);
            trial_nb = 1:length(cell2mat(norm_trial_fr(Stimulus_run))');
            
            %             axis([0 ceil(length(trial_nb)) 0 10]);
            [r p]=corrcoef(trial_nb,cell2mat(norm_trial_fr(Stimulus_run)));
            
            CorrR(Stimulus_run)=r(1,2);
            Corr_Pval(Stimulus_run)= p(1,2);  clear r p
            
            
            Pval_sig(Stimulus_run) =  Corr_Pval(Stimulus_run) < alpha;
            
            if Pval_sig(Stimulus_run)
                scatter(trial_nb, cell2mat(norm_trial_fr(Stimulus_run)),'k','filled'); hold on;
            else
                scatter(trial_nb, cell2mat(norm_trial_fr(Stimulus_run)),'k'); hold on;
            end
            
            
            pfit= polyfit(trial_nb,cell2mat(norm_trial_fr(Stimulus_run))',1);
            
            
            Slope(Stimulus_run)=pfit(1);
            trial_nb = 0: (ceil(max(trial_nb)/5)* 5);
            yfit= pfit(1)*trial_nb + pfit(2);
            
            
            if Pval_sig(Stimulus_run)
                plot(trial_nb,yfit,'r','linewidth',2);
            else
                plot(trial_nb,yfit,'k');
            end
            
            
            
            set(gca, 'ylim',[0 12]); ytick = get(gca,'YTick');  ytick(end)=[]; set(gca,'YTick',ytick);
            set(gca, 'xlim',[0 ceil(max(trial_nb)/5)* 5]);
            xlabel(['Trial #'],'fontsize',13,'fontweight','bold'); ylabel(['Norm FR'],'fontsize',13,'fontweight','bold');
            
            
            title(Stimulus_str{Stimulus_run},'fontsize',13);
            
            
            
            %% Trial-by-Trial correctness in scatter
            
            
            trial_nb = 1:length(cell2mat(norm_trial_fr(Stimulus_run))');
            
            hold on; [y, x] = find(cell2mat(Corr_mat(Stimulus_run))' > 0);
            scatter(x, y.*10+ 1 , 40,'b','filled');
            hold on; [y, x] = find(cell2mat(Corr_mat(Stimulus_run))' == 0);
            scatter(x, y.*10 + 1, 40,'b');
            box off;
            
            
            
            
            %% Print out parameters
            
            msg= sprintf('CorrR = %1.2f',CorrR(Stimulus_run));
            text(xpos,ypos,msg,'units','normalized')
            msg= sprintf('Pval = %1.2f', Corr_Pval(Stimulus_run));
            text(xpos,ypos-.1,msg,'units','normalized','backgroundcolor',bgcol(Pval_sig(Stimulus_run)+1,:));
            msg= sprintf('Slope = %1.2f', Slope(Stimulus_run));
            text(xpos,ypos-.2,msg,'units','normalized')
            msg= sprintf('Performance = %1.2f', Perf(Stimulus_run));
            text(xpos,ypos-.3,msg,'units','normalized')
            
            
            %% Polarity for original
            
            if CorrR(Stimulus_run)< 0
                Polarity{Stimulus_run}= 'negative';
            else
                Polarity{Stimulus_run}= 'positive';
            end
            
            
        end   %%  Stimulus_run = 1:4
        
        
        
        
        %         fitting_cat= {};
        %
        %         if sum(Pval_sig)
        %
        %             if  (sum(Pval_sig) <=2 ) && (Pval_sig(Icecream) || Pval_sig(House))
        %                 fitting_cat ='Familiar';
        %
        %             elseif  (sum(Pval_sig) <=2 ) && (Pval_sig(Owl) || Pval_sig(Phone))
        %                 fitting_cat ='Novel';
        %
        %             elseif  (sum(Pval_sig)== 3) || (sum(Pval_sig)== 4)
        %                 fitting_cat ='Nonspecific';
        %             end
        %         else
        %             fitting_cat ='NoFitting';
        %         end
        %
        
        
        
        %% New categorization (2017/07/26)
        
        fitting_cat ='Nonspecific';
        
        
        switch sum(Pval_sig)
            
            case 0
                
                fitting_cat ='Nofitting';
                
            case 1
                
                if Pval_sig(Icecream) || Pval_sig(House)
                    
                    fitting_cat ='SingleOBJ(Familiar)';
                    
                elseif  Pval_sig(Owl) || Pval_sig(Phone)
                    
                    fitting_cat ='SingleOBJ(Novel)';
                    
                end
                
                
            case 2
                
                if Pval_sig(Icecream) && Pval_sig(House)
                    
                    fitting_cat ='Familiar';
                    
                elseif  Pval_sig(Owl) && Pval_sig(Phone)
                    
                    fitting_cat ='Novel';
                    
                elseif   Pval_sig(Icecream) && Pval_sig(Owl)
                    
                    fitting_cat ='Response';
                    
                elseif   Pval_sig(House) && Pval_sig(Phone)
                    
                    fitting_cat ='Response';
                    
                end
                
        end
        
        
        
        
        
        
        
        
        
        %         if sum(Pval_sig)
        %
        %             if  (sum(Pval_sig) <=2 ) && (Pval_sig(Icecream) || Pval_sig(House))
        %                 fitting_cat ='Familiar';
        %
        %             elseif  (sum(Pval_sig) <=2 ) && (Pval_sig(Owl) || Pval_sig(Phone))
        %                 fitting_cat ='Novel';
        %
        %             elseif  (sum(Pval_sig)== 3) || (sum(Pval_sig)== 4)
        %                 fitting_cat ='Nonspecific';
        %             end
        %         else
        %             fitting_cat ='NoFitting';
        %         end
        
        
        
        
        
        optimal_fr =nan(1,nb_block);
        BestFittingOBJ = [];
        
        
        if sum(Pval_sig)==1
            
            CorrR= CorrR(logical(Pval_sig));
            Corr_Pval = Corr_Pval(logical(Pval_sig));
            Slope = Slope(logical(Pval_sig));
            Polarity = cell2mat(Polarity(logical(Pval_sig)));
            Perf= Perf(logical(Pval_sig));
            BestFittingOBJ = cell2mat(Stimulus_str(logical(Pval_sig)));
            
            
            optimal_fr= cell2mat(norm_trial_fr(logical(Pval_sig)))';
            
        elseif  sum(Pval_sig)> 1
            
            ind= find(abs(CorrR) == max(abs(CorrR)));
            CorrR= CorrR(ind);
            Corr_Pval = Corr_Pval(ind);
            Slope = Slope(ind);
            Polarity =cell2mat(Polarity(ind));
            Perf= Perf(ind);
            %             BestFittingOBJ = cell2mat(Stimulus_str(ind));
            BestFittingOBJ= nan;
            
            optimal_fr= cell2mat(norm_trial_fr(ind))';
            
        else
            
            
            CorrR= nan;
            Corr_Pval = nan;
            Slope = nan;
            Polarity = nan;
            Perf= nan;
            BestFittingOBJ= nan;
            
        end
        
        
        
        
%         if ~isnan(sum(optimal_fr))
%             
%             mean_fr_block = nan(1,nb_block);
%             
%             %         trials_in_block = floor(length(trial_amp)/nb_block +1)
%             trials_in_block = floor(length(optimal_fr)/nb_block);
%             
%             for block_run = 0 : nb_block-1
%                 (trials_in_block*block_run)+1: trials_in_block*(block_run+1);
%                 try
%                     mean_fr_block(:,block_run+1) = nanmean(optimal_fr((trials_in_block*block_run)+1: trials_in_block*(block_run+1)));
%                 catch
%                     mean_fr_block(:,block_run+1) = nanmean(optimal_fr((trials_in_block*block_run)+1: end));
%                 end
%             end
%             
%             cd(saveROOT);
%             save([Prefix '-' Polarity '.mat'], 'mean_fr_block');
%             
%         end
        
        
        
        
        
        
        
        %% Get waveform
        
        
        cd(TT_folder);
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
        
        
        
        
        
        
        nb_trial= size(ts_evt,1);
        trial_amp = nan(nb_trial,1);
        trial_wave = nan(32,nb_trial);
        trial_nb = [1:size(ts_evt,1)];
        mean_wave = nan(32,1);
        
        
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
        
        mean_wave = nanmean(trial_wave,2);
        
        subplot('position',[0.05 0.1 0.15 0.3]);
        
        plot(mean_wave,'k','LineWidth',2); box off; axis off; hold on;
        scaleline = line([35 35],[0 50]);
        scaleline.Color = 'k';
        scaleline.LineWidth = 4;
        text(38,25,'50 (\muV)','FontSize',15);
        
        scaleline = line([1 16],[floor(min(mean_wave))-20 floor(min(mean_wave))-20]);
        scaleline.Color = 'k';
        scaleline.LineWidth = 3;
        text(4,floor(min(mean_wave))-40,'500 (\mus)','FontSize',10);
        
        
        
        %         %% Waveform similaritiy
        %
        %         wave_similarity_ind =nan(1,nb_trial);
        %
        %         for trial_run= 1: nb_trial
        %
        %             waveform =[]; nanind= [];
        %             waveform.ref= trial_wave(:,1);
        %             waveform.target= trial_wave(:,trial_run);
        %             nanind = isnan(waveform.ref)| isnan(waveform.target);
        %             waveform.ref(nanind)=[];
        %             waveform.target(nanind)=[];
        %
        %             wave_similarity_ind(trial_run) = sum(waveform.ref .* waveform.target) / sqrt(sum(waveform.ref.^2) * sum(waveform.target.^2));
        %
        %         end
        %
        %
        %
        %
        %         subplot('position',[0.28 0.1 0.25 0.3]);
        %
        %
        %         scatter([1:nb_trial], wave_similarity_ind, 20,'k'); box off; hold on;
        % %         set(gca,'ylim',[0.6 1.2])
        %         xlabel(['Trial Block'],'fontsize',13,'fontweight','bold');
        %         title('Waveform simliarity');
        %         [r p]= corrcoef([1:nb_trial], wave_similarity_ind);
        %
        %
        %         Stability= [];
        %
        %
        %         Stability.CorrR=r(1,2);
        %         Stability.Corr_Pval=p(1,2);
        %
        %         Stability.Pval_sig =  Stability.Corr_Pval > stability_alpha  ;
        %
        %         clear r p
        %
        %
        %         pfit= polyfit([1:nb_trial],wave_similarity_ind,1);
        %
        %         fitting_line= plot([0:max(get(gca,'xlim'))],pfit(1)*[0:max(get(gca,'xlim'))]+ pfit(2));
        %         set(fitting_line,'LineWidth',1.5);
        %
        %
        %         if ~Stability.Pval_sig
        %             set(fitting_line,'LineStyle','-','Color','r')
        %         else
        %             set(fitting_line,'LineStyle',':','Color','b')
        %         end
        %
        %
        %         msg= sprintf('Stability CorrR = %1.3f',Stability.CorrR);
        %         text(1.2,1.1,msg,'Fontsize',12,'units','normalized');
        %
        %         msg= sprintf('Stability Pval =%1.3f', Stability.Corr_Pval);
        %         text(1.2,0.9,msg,'Fontsize',12,'units','normalized');
        %
        %
        %
        
        
        
        
        
        
        msg= sprintf('BestFittingOBJ = %s',BestFittingOBJ);
        text(1.3,1.0,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('Fitting CAT = %s',fitting_cat);
        text(1.3,0.8,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('Cell CAT = %s', summary(i_s).Cell_Category);
        text(1.3,0.6,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('mean AP Peak = %1.2f (uV)', mean(max(aligned_wave_mat)));  %% Mean FR from the event period
        text(1.3,0.4,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('mean FR (Epoch) = %1.2f (Hz)', mean_fr.all);  %% Mean FR from the event period
        text(1.3,0.2,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('Zero spike proportion = %2.2f (%%)', str2num(summary(i_s).Zero_FR_Proportion)* 100);  %% Mean FR from the event period
        text(1.3,0,msg,'Fontsize',12,'units','normalized');
        
        
        
        
        
        
        %% Save root per session
        
        cd(saveROOT);
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        session_saveROOT=[saveROOT '\' fitting_cat];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)
        
        
        
        %% Save figures
        
        filename_ai=[Prefix '.eps'];
        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
        
        % outputfile.FourOBJ= 'Repetition_Suppression(FourOBJ).csv';
        % fod.FourOBJ = fopen(outputfile.FourOBJ,'w');
        % txt_header = 'Key#, RatID, Session, Region, Bregma, ClusterID, nTrials, Performance_All, MeanFR(Epoch), ZeroSpkProportion, Cell_Category, Fitting_Category,';
        % fprintf(fod.FourOBJ, txt_header);
        % txt_header = 'BestFittingOBJ, CorrR, Corr_Pval, Slope, Polarity, Perf_Stimulus, Stability_OK,';
        % fprintf(fod.FourOBJ, txt_header);
        % txt_header = '\n';
        % fprintf(fod.FourOBJ, txt_header);
        % fclose(fod.FourOBJ);
        
        
        
        
        
        % Save output files
        
        cd(saveROOT);
        
        if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            fod.FourOBJ=fopen(outputfile.FourOBJ,'a');
            fprintf(fod.FourOBJ,'%s ,%s ,%s ,%s ,%s , %s ,%d ,%1.3f, %1.3f, %2.1f, %s, %s', Key, RatID, Task_session, Region, Bregma, ClusterID ,nb_trial, nanmean(ts_evt(:,Correctness)),  mean_fr.all, str2num(summary(i_s).Zero_FR_Proportion)* 100, summary(i_s).Cell_Category, fitting_cat);
            fprintf(fod.FourOBJ,',%s, %1.2f, %1.2f, %1.2f, %s, %1.2f, %d,',BestFittingOBJ, CorrR, Corr_Pval, Slope, Polarity, Perf, str2num(summary(i_s).Stability_ok));
            fprintf(fod.FourOBJ, '\n');
            fclose('all');
            
            
            
        elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            fod.SceneOBJ=fopen(outputfile.SceneOBJ,'a');
            fprintf(fod.SceneOBJ,'%s ,%s ,%s ,%s ,%s ,%s ,%s, %d ,%1.3f', Key, RatID, Session, Task, Task_session, Region, ClusterID ,nb_trial, nanmean(ts_evt(:,Correctness)));
            fprintf(fod.SceneOBJ,',%1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f,', CorrR{1}, CorrR{2}, CorrR{3},  CorrR{4}, CorrR{6}, CorrR{7}, CorrR{8}, CorrR{9}, CorrR{11}, CorrR{12}, CorrR{13}, CorrR{14}, Pval_sig{1}, Pval_sig{2}, Pval_sig{3}, Pval_sig{4}, Pval_sig{6}, Pval_sig{7}, Pval_sig{8}, Pval_sig{9}, Pval_sig{11}, Pval_sig{12}, Pval_sig{13}, Pval_sig{14}, Slope{1}, Slope{2}, Slope{3}, Slope{4}, Slope{6}, Slope{7}, Slope{8}, Slope{9}, Slope{11}, Slope{12}, Slope{13}, Slope{14}, Polarity{1}, Polarity{2}, Polarity{3}, Polarity{4},  Polarity{6}, Polarity{7}, Polarity{8}, Polarity{9}, Polarity{11}, Polarity{12}, Polarity{13}, Polarity{14}, Pval_sig_amp, percent_zero, p_amp,perf_fam, perf_nov, exclusion);
            fprintf(fod.FourOBJ,',%1.3f, %1.3f, %1.3f, %1.3f,', Perf.Stimulus1, Perf.Stimulus2, Perf.Stimulus3, Perf.Stimulus4);
            fprintf(fod.SceneOBJ, '\n');
            fclose('all');
        end
        
        
        
        clear nb_trial
        
        
        
        
        
        
    end   %  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)'))
    
end   % i_s=  1 :c_s



end
