%% Created by Jaerong 2016/02/09 for PER & POR analysis
%% Examine the FR reduction in the first two trials


function [summary,summary_header]= Summary_Get_Repetition_Suppression_twotrial(summary, summary_header, dataROOT)


%% Output folder
% saveROOT= [dataROOT '\Analysis\Repetition_Suppression_twotrial\All_trial\' date];
saveROOT= [dataROOT '\Analysis\Repetition_Suppression_twotrial\Correct_trial\' date];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);




%% Fig parms
txt_size= 12;
r_plot=2;c_plot=5;
fig_pos= [80,450,1800,550];



%% Parms

bootstrap_nb = 10000;
alpha= 0.01;
change_direction = {'nan','nan','nan','nan'};



%% Load output files

%% FourOBJ

outputfile.FourOBJ= 'Repetition_Suppression_twotrial(FourOBJ).txt';
% if ~exist(outputfile)
fod.FourOBJ = fopen(outputfile.FourOBJ,'w');
fprintf(fod.FourOBJ,'Key \tRatID \tSession \tTask_session \tTask \tRegion \tClusterID');

% for Stimulus_run = 1: 4
%
%     fprintf(fod.FourOBJ, '\tFR_diff(Stimulus%d) \tFR_diff_sig(Stimulus%d) \tChange_Direction(Stimulus%d)' , Stimulus_run, Stimulus_run, Stimulus_run);
% end

fprintf(fod.FourOBJ, '\tFR_diff(Familiar) \tChange_Direction(Familiar) \tFR_diff(Novel) \tChange_Direction(Novel)');
fprintf(fod.FourOBJ,'\n');
fclose(fod.FourOBJ);




%% SceneOBJ


outputfile.SceneOBJ= 'Repetition_Suppression_twotrial(SceneOBJ).txt';
% if ~exist(outputfile)
fod.SceneOBJ = fopen(outputfile.SceneOBJ,'w');
fprintf(fod.SceneOBJ,'Key \tRatID \tSession \tTask_session \tTask \tRegion \tClusterID');

% for Stimulus_run = 1: 4
%
%     fprintf(fod.SceneOBJ, '\tFR_diff(Stimulus%d) \tFR_diff_sig(Stimulus%d) \tChange_Direction(Stimulus%d)' , Stimulus_run, Stimulus_run, Stimulus_run);
% end

fprintf(fod.FourOBJ, '\tFR_diff(Scene) \tChange_Direction(OBJ) \tFR_diff(Scene) \tChange_Direction(OBJ)');
fprintf(fod.SceneOBJ,'\n');
fclose(fod.SceneOBJ);





[r_s,c_s]=size(summary);



for i_s= 1:c_s
    
    
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?')
    if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')  && (str2num(summary(i_s).Epoch_FR) >= 0.5)  && (str2num(summary(i_s).Zero_FR_Proportion) < 0.5)...
            && ~strcmp(summary(i_s).Region,'POR') && (str2num(summary(i_s).Stability_ok)== 1)
        
        
        
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
        
        
%         %% Add stimulus category information
%         
%         if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
%             ts_evt= add_category_info(ts_evt,Task);
%         end
%         
%         
%         %% Eliminated void trials (trials with high latency (over 2 SD) and void signals)
%         
%         ts_evt= void_trial_elimination(ts_evt);
        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        
        
        %% Get epoch firing rates  & significance test
        
        get_FR_significance;
        
        
        
        %% Normalize firing rate (from 0 to 10)
        norm_trial_fr = mapminmax(trial_fr', 0, 10)';
        
        fr_diff=[];
        first_fr=[];
        second_fr=[];
        
        for Stimulus_run = 1:nb_stimulus
            fr_mat= [];
            
            
            eval(['trial_nb= [1:length(norm_trial_fr(select.Stimulus' num2str(Stimulus_run) '_Corr))];']);
            eval(['fr_mat= norm_trial_fr(select.Stimulus' num2str(Stimulus_run) '_Corr);']);
            %             eval(['trial_nb= [1:length(norm_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All))];']);
            %             eval(['fr_mat= norm_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All);']);
            
            first_fr(Stimulus_run) = fr_mat(1);
            second_fr(Stimulus_run)= fr_mat(2);
            
            %             fr_diff(Stimulus_run) = ((first_fr-second_fr)/(first_fr+second_fr));
            %             fr_diff(Stimulus_run) = (first_fr(Stimulus_run)-second_fr(Stimulus_run));
            fr_diff(Stimulus_run) = (second_fr(Stimulus_run) - first_fr(Stimulus_run));
            
        end
        
        max_fr =max(max(first_fr, second_fr));
        
        
        if ~max_fr
            continue
        end
        
        
        
        %         %% Bootstrapping
        %
        %             bootstrap_perf_ok =1;
        %             bootstrap_perf_ind =1;
        %
        %         while bootstrap_perf_ok
        
        
        
        
        
        for Stimulus_run = 1:nb_stimulus
            
            fr_mat= [];
            %             eval(['fr_mat= norm_trial_fr(select.Stimulus' num2str(Stimulus_run) '_Corr);']);
            eval(['fr_mat= norm_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All);']);
            
            fr_mat= fr_mat(3:end);
            
            bootstrap_ok=1;
            bootstrap_ind=1;
            
            while bootstrap_ok
                
                
                
                rand_ind= randperm(length(fr_mat),1);
                
                
                try
                    rand_fr_diff(bootstrap_ind, Stimulus_run)= fr_mat(rand_ind) - fr_mat(rand_ind-1);
                    
                    bootstrap_ind= bootstrap_ind+1;
                    
                catch
                    continue
                end
                
                
                if bootstrap_ind== bootstrap_nb+1
                    bootstrap_ok=0;
                end
                
            end % bootstrap_ok
            
        end
        
        
        
        
        pval_sig=zeros(1,4); pval=nan(1,4);
        
        
        
        
        
        %         for Stimulus_run = 1:nb_stimulus
        %
        %             mean(rand_fr_diff(:,(Stimulus_run)))
        %
        %             if mean(rand_fr_diff(:,(Stimulus_run))) <  fr_diff(Stimulus_run)
        %
        %
        %             [ pval(Stimulus_run) pval_sig(Stimulus_run)] = signtest(rand_fr_diff(:,(Stimulus_run)), fr_diff(Stimulus_run), 'tail','left','Alpha',alpha);
        %
        %
        %             elseif mean(rand_fr_diff(:,(Stimulus_run))) >  fr_diff(Stimulus_run)
        %
        %             [ pval(Stimulus_run) pval_sig(Stimulus_run)] = signtest(rand_fr_diff(:,(Stimulus_run)), fr_diff(Stimulus_run), 'tail','right','Alpha',alpha);
        %
        %             end
        %
        % %             [ pval2(Stimulus_run) pval_sig2(Stimulus_run)] = signtest(rand_fr_diff(:,(Stimulus_run)), 0, 'Alpha',alpha)
        %
        %         end
        
        
        
        
        %% Second criterion (the absolute value of mean of the bootstrapped FR difference is less than the FR difference between the first two trials
        %% we labeled them as not significant even though it had passed the one-sample sign test).
        
        
        for Stimulus_run = 1:nb_stimulus
            
            
            if mean(rand_fr_diff(:,(Stimulus_run))) + std(rand_fr_diff(:,(Stimulus_run))) <  abs(fr_diff(Stimulus_run))
                
                pval_sig(Stimulus_run) =1;
            end
            
            
        end
        
        
        
        
        
        if    strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            Diff.Familiar = nan;
            Diff.Novel = nan;
            Diff_direction.Familiar = nan;
            Diff_direction.Novel = nan;
            
            if sum((pval_sig(Icecream:House)))
                Diff.Familiar = fr_diff(abs(fr_diff) == max(abs(fr_diff(Icecream)),abs(fr_diff(House))));
                
                if Diff.Familiar < 0
                    Diff_direction.Familiar = 'decrease';
                else
                    Diff_direction.Familiar = 'increase';
                end
                
            end
            
            if sum((pval_sig(Owl:Phone)))
                Diff.Novel = fr_diff(abs(fr_diff)== max(abs(fr_diff(Owl)),abs(fr_diff(Phone))));
                
                if Diff.Novel < 0
                    Diff_direction.Novel = 'decrease';
                else
                    Diff_direction.Novel = 'increase';
                end
                
            end
            
            
        elseif    strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            Diff.Scene = nan;
            Diff.OBJ = nan;
            Diff_direction.Scene = nan;
            Diff_direction.OBJ = nan;
            
            
            if sum((pval_sig(Icecream:House)))
                Diff.Scene =  fr_diff(abs(fr_diff) == max(abs(fr_diff(Zebra)),abs(fr_diff(Pebble))));
                
                if Diff.Scene < 0
                    Diff_direction.Scene = 'decrease';
                else
                    Diff_direction.Scene = 'increase';
                end
                
            end
            
            
            if sum((pval_sig(Owl:Phone)))
                Diff.OBJ =  fr_diff(abs(fr_diff) == max(abs(fr_diff(Owl)),abs(fr_diff(Phone))));
                
                if Diff.OBJ < 0
                    Diff_direction.OBJ = 'decrease';
                else
                    Diff_direction.OBJ = 'increase';
                end
                
            end
        end
        
        
        
        
        
        
        %                     bootstrap_perf_ind= bootstrap_perf_ind+1;
        %
        %                 if bootstrap_perf_ind== bootstrap_perf_nb+1
        %                     bootstrap_perf_ok=0;
        %                 end
        %
        %         end
        % %
        %         for Stimulus_run = 1:nb_stimulus
        %
        %             mean(rand_fr_diff(:,(Stimulus_run)))
        %
        %             if mean(rand_fr_diff(:,(Stimulus_run))) <  fr_diff(Stimulus_run)
        %
        %
        %             [ pval(Stimulus_run) pval_sig(Stimulus_run)] = signtest(abs(rand_fr_diff(:,(Stimulus_run))), fr_diff(Stimulus_run), 'tail','right','Alpha',alpha)
        %
        %
        %             elseif mean(rand_fr_diff(:,(Stimulus_run))) >  fr_diff(Stimulus_run)
        %
        %             [ pval(Stimulus_run) pval_sig(Stimulus_run)] = signtest(abs(rand_fr_diff(:,(Stimulus_run))), fr_diff(Stimulus_run), 'tail','left','Alpha',alpha)
        %
        %             end
        %
        % %             [ pval2(Stimulus_run) pval_sig2(Stimulus_run)] = signtest(rand_fr_diff(:,(Stimulus_run)), 0, 'Alpha',alpha)
        %
        %         end
        %
        %
        
        
        
        
        
        
        Perf=[];
        
        for Stimulus_run = 1:nb_stimulus
            
            eval(['Perf(' num2str(Stimulus_run) ')= mean(ts_evt(select.Stimulus' num2str(Stimulus_run) '_All,Correctness));']);
            
        end
        
        
        
        
        
        
        %% Change direction
        
        
        for Stimulus_run = 1:nb_stimulus
            
            if fr_diff(Stimulus_run) < 0
                change_direction{Stimulus_run}= 'decrease';
            elseif  fr_diff(Stimulus_run) > 0
                change_direction{Stimulus_run}= 'increase';
            else
            end
        end
        
        
        
        
        
        %% Figure
        
        
        fig=figure('name',Prefix, 'Color',[1 1 1],'Position',fig_pos);
        
        subplot('Position', [0.4 0.99 0.4 0.2]);
        text(0,0,Prefix,'fontsize',12);
        axis off;
        
        
        
        for Stimulus_run = 1:nb_stimulus
            
            subplot(r_plot,c_plot,Stimulus_run)
            
            if pval_sig(Stimulus_run)
                
                bar(1:2,[first_fr(Stimulus_run) second_fr(Stimulus_run)],'r'); box off;
                
            else
                
                bar(1:2,[first_fr(Stimulus_run) second_fr(Stimulus_run)],'k'); box off;
                
            end
            
            
            set(gca,'xticklabel',{'1st FR','2nd FR'}); ylabel('Norm FR');
            
            
            %             ylim([0 ceil(max_fr)]);
            ylim([0 10]);
            
            title(Stimulus_str{Stimulus_run},'fontsize',12);
            
        end
        
        
        
        
        
        subplot(r_plot,c_plot,5);
        axis off
        
        
        for Stimulus_run = 1:nb_stimulus
            
            
            
            bgcol=[1 0.6 0.6];                     % pink
            if  pval_sig(Stimulus_run), bgcol=[0.6 1 0.6]; end   % green
            
            
            msg= sprintf('FR diff (%s) = %1.2f', Stimulus_str{Stimulus_run},fr_diff(Stimulus_run));
            text(0,1-(Stimulus_run/5),msg,'BackGroundColor',bgcol,'fontsize',txt_size);
            
        end
        
        msg= sprintf('1st FR - 2nd FR' );
        text(0,1,msg,'fontsize',15);
        
        
        
        
        
        
        for Stimulus_run = 1:nb_stimulus
            
            subplot(r_plot,c_plot,5+ Stimulus_run)
            
            hist(rand_fr_diff(:,(Stimulus_run))); box off;
            
            if  pval_sig(Stimulus_run)
                
                vhandle= vline(fr_diff(Stimulus_run),'r:'); set(vhandle,'linewidth',2.5);
            else
                vhandle= vline(fr_diff(Stimulus_run),'c:'); set(vhandle,'linewidth',2.5);
            end
            
            xlim([-10 10])
            ylabel('Count');
            title(Stimulus_str{Stimulus_run},'fontsize',12);
            
        end
        
        
        
        %         clear rand_fr_diff
        
        
        subplot(r_plot,c_plot,10);
        axis off
        
        
        for Stimulus_run = 1:nb_stimulus
            
            msg= sprintf('Perf (%s) = %1.2f', Stimulus_str{Stimulus_run},Perf(Stimulus_run));
            text(0,0.8-(Stimulus_run/5),msg,'fontsize',txt_size);
            
        end
        
        
        
        
        
        
        if    strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            
            msg= sprintf('FR diff Familiar = %1.2f', Diff.Familiar);
            text(0,1.2,msg,'fontsize',txt_size);
            
            msg= sprintf('FR diff Novel = %1.2f', Diff.Novel);
            text(0,1,msg,'fontsize',txt_size);
            
        elseif    strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            msg= sprintf('FR diff Scene = %1.2f', Diff.Scene);
            text(0,1.2,msg,'fontsize',txt_size);
            
            msg= sprintf('FR diff OBJ = %1.2f', Diff.OBJ);
            text(0,1,msg,'fontsize',txt_size);
            
            
        end
        
        
        
        
        
        %% Save root per session
        session_saveROOT=[saveROOT '\' Task];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)
        
        
        
        %% Save figures
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
        
        
        %% Save output files
        
        
        cd(saveROOT)
        
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            fod.FourOBJ=fopen(outputfile.FourOBJ,'a');
            fprintf(fod.FourOBJ,'%s \t%s \t%s \t%s \t%s \t%s \t%s', Key, RatID, Session, Task_session, Task, Region, ClusterID );
            
            %             for Stimulus_run = 1: 4
            %                 fprintf(fod.FourOBJ,' \t%1.3f \t%d \t%s', fr_diff(Stimulus_run), pval_sig(Stimulus_run), change_direction{Stimulus_run});
            %             end
            fprintf(fod.FourOBJ,'\t%1.3f \t%s \t%1.3f \t%s', Diff.Familiar, Diff_direction.Familiar, Diff.Novel, Diff_direction.Novel);
            fprintf(fod.FourOBJ, '\n');
            fclose('all');
            
            
        elseif  strcmp(Task,'OCRS(SceneOBJ)')
            
            fod.FourOBJ=fopen(outputfile.SceneOBJ,'a');
            fprintf(fod.FourOBJ,'%s \t%s \t%s \t%s \t%s \t%s \t%s', Key, RatID, Session, Task_session, Task, Region, ClusterID );
            
            %             for Stimulus_run = 1: 4
            %                 fprintf(fod.SceneOBJ,' \t%1.3f \t%d \t%s', fr_diff(Stimulus_run), pval_sig(Stimulus_run), change_direction{Stimulus_run});
            %             end
            fprintf(fod.FourOBJ,'\t%1.3f \t%s \t%1.3f \t%s', Diff.Scene, Diff_direction.Scene, Diff.OBJ, Diff_direction.OBJ);
            fprintf(fod.SceneOBJ, '\n');
            fclose('all');
            
        end
        
        
    end   %  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)'))
    
end   % i_s=  1 :c_s



end
