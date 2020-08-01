%% Revised by Jaerong 2017/07/04 for PER & POR analysis
%% Examines the effect of repetition for all trials in a session

function [summary,summary_header]= Summary_Get_Repetition_Suppression_Performance(summary, summary_header, dataROOT)


%% Output folder
saveROOT= [dataROOT '\Analysis\Repetition_Suppression\LearningCurve'];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);

matbugROOT = 'F:\PRC-POR_ephys_toolbox\Learning_Analysis\IndividualAnalysisWinBUGS';



%% Fig parms
fig_pos= [100,250,1800,600];

bgcol=[1 0.6 0.6; 0.6 1 0.6];



%% Parms
alpha= 0.05;
xpos=0.8;
ypos=1.35;




% %% Load output files
%
% %% FourOBJ
% outputfile.FourOBJ= 'Repetition_Suppression(FourOBJ)5.csv';
% % if ~exist(outputfile)
% fod.FourOBJ = fopen(outputfile.FourOBJ,'w');
% txt_header = 'Key#, RatID, Session, Task_session, Task, Region, ClusterID, nTrials, Performance_all,';
% fprintf(fod.FourOBJ, txt_header);
%
% txt_header = 'CorrR(Icecream), CorrR(House), CorrR(Owl), CorrR(Phone), CorrR_b(Icecream), CorrR_b(House), CorrR_b(Owl), CorrR_b(phone), CorrR(familiar), CorrR(novel), CorrR_b(familiar), CorrR_b(novel), Corr_Sig(Icecream), Corr_Sig(House), Corr_Sig(Owl), Corr_Sig(phone), Corr_Sig_b(Icecream), Corr_Sig_b(House), Corr_Sig_b(Owl), Corr_Sig_b(phone), Corr_Sig(familiar), Corr_Sig(novel), Corr_Sig_b(familiar), Corr_Sig_b(novel), Slope(Icecream), Slope(House), Slope(Owl), Slope(Phone),  Slope_b(Icecream), Slope_b(House), Slope_b(Owl), Slope_b(Phone), Slope(fam), Slope(nov), Slope_b(fam), Slope_b(nov), Polarity(Icecream), Polarity(house), Polarity(owl), Polarity(phone), Polarity_b(Icecream) , Polarity_b(house), Polarity_b(owl), Polarity_(phone), Polarity(Fam), Polarity(nov), Polarity_b(Fam), Polarity_b(nov), Pval_sig_amp, percent_zero, p_amp, perf_fam, perf_nov, exclusion,';
% fprintf(fod.FourOBJ, txt_header);
%
% %CorrR{1}, CorrR{2}, CorrR{3},  CorrR{4}, CorrR{6}, CorrR{7}, CorrR{8}, CorrR{9}, CorrR{11}, CorrR{12}, CorrR{13}, CorrR{14}, Pval_sig{1}, Pval_sig{2}, Pval_sig{3}, Pval_sig{4}, Pval_sig{6}, Pval_sig{7}, Pval_sig{8}, Pval_sig{9}, Pval_sig{11}, Pval_sig{12}, Pval_sig{13}, Pval_sig{14}, Slope{1}, Slope{2}, Slope{3}, Slope{4}, Slope{6}, Slope{7}, Slope{8}, Slope{9}, Slope{11}, Slope{12}, Slope{13}, Slope{14}, Polarity{1}, Polarity{2}, Polarity{3}, Polarity{4},  Polarity{6}, Polarity{7}, Polarity{8}, Polarity{9}, Polarity{11}, Polarity{12}, Polarity{13}, Polarity{14}, Pval_sig_amp, percent_zero, p_amp,perf_fam, perf_nov, h
%
% txt_header = 'Perf(Stimulus1), Perf(Stimulus2), Perf(Stimulus3), Perf(Stimulus4),';
% fprintf(fod.FourOBJ, txt_header);
% txt_header = '\n';
% fprintf(fod.FourOBJ, txt_header);
% fclose(fod.FourOBJ);
% % end
%
%
%
% %% SceneOBJ
% outputfile.SceneOBJ= 'Repetition_Suppression(SceneOBJ)5.csv';
% fod.SceneOBJ = fopen(outputfile.SceneOBJ,'w');
% txt_header = 'Key#, RatID, Session, Task, Region, ClusterID, nTrials, Performance_all,';
% fprintf(fod.SceneOBJ, txt_header);
%
% txt_header = 'CorrR(Icecream), CorrR(House), CorrR(Owl), CorrR(Phone), CorrR_b(Icecream), CorrR_b(House), CorrR_b(Owl), CorrR_b(phone), CorrR(familiar), CorrR(novel), CorrR_b(familiar), CorrR_b(novel), Corr_Sig(Icecream), Corr_Sig(House), Corr_Sig(Owl), Corr_Sig(phone), Corr_Sig_b(Icecream), Corr_Sig_b(House), Corr_Sig_b(Owl), Corr_Sig_b(phone), Corr_Sig(familiar), Corr_Sig(novel), Corr_Sig_b(familiar), Corr_Sig_b(novel), Slope(Icecream), Slope(House), Slope(Owl), Slope(Phone),  Slope_b(Icecream), Slope_b(House), Slope_b(Owl), Slope_b(Phone), Slope(fam), Slope(nov), Slope_b(fam), Slope_b(nov), Polarity(Icecream), Polarity(house), Polarity(owl), Polarity(phone), Polarity_b(Icecream) , Polarity_b(house), Polarity_b(owl), Polarity_(phone), Polarity(Fam), Polarity(nov), Polarity_b(Fam), Polarity_b(nov), Pval_sig_amp, percent_zero, p_amp, perf_fam, perf_nov, exclusion,';
% fprintf(fod.SceneOBJ, txt_header);
%
% txt_header = '\n';
% fprintf(fod.SceneOBJ, txt_header);
% fclose(fod.SceneOBJ);




[r_s,c_s]=size(summary);



for i_s= 1:c_s
    
    
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?')
    %          if  strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')  && (str2num(summary(i_s).Epoch_FR) >= 0.5) &&  (str2num(summary(i_s).Task_session)== 1) && (str2num(summary(i_s).Repetition_ok)== 1)
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
            
            
            subplot('position',[((Stimulus_run-1)/4)+0.03 0.2 0.18 0.55]);
            
            
            %             eval(['trial_nb= [1:length(norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_Corr))];']);
            %             eval(['norm_trial_fr= norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_Corr);']);
            
           %% All trials
            eval(['trial_nb= [1:length(norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All))];']);
%             eval(['norm_trial_fr= norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All);']);
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
            
            
            
            set(gca, 'ylim',[0 12]);
            set(gca, 'xlim',[0 ceil(max(trial_nb)/5)* 5]);
            xlabel(['Trial #'],'fontsize',13,'fontweight','bold'); ylabel(['Norm FR'],'fontsize',13,'fontweight','bold');
            
            
            title(Stimulus_str{Stimulus_run},'fontsize',13);
            
            %% Draw the learning curve
            
            I=[];
            
            
            CvgceCrit = 1e-8;
            
            %----------------------------------------------------------------------------------
            
            xguess         = 0;
            NumberSteps  = 2000;
            BackgroundProb=0.5;
            MaxResponse=1;
            SigE = 0.005; %default variance of learning state process is sqrt(0.005)
            UpdaterFlag = 2;  %default allows bias
            startP = 0.5;  %expected initial probability
            
            
            
            
            
            I = [cell2mat(Corr_mat(Stimulus_run))'; MaxResponse*ones(1,length(cell2mat(Corr_mat(Stimulus_run))))];
            
            SigsqGuess  = SigE^2;
            
            %set the value of mu from the chance of correct
            mu = log(BackgroundProb/(1-BackgroundProb));
            
            %convergence criterion for SIG_EPSILON^2
            
            
            
            
            
            
            %loop through EM algorithm: forward filter, backward filter, then
            %M-step
            
            for i=1:NumberSteps
                
                %Compute the forward (filter algorithm) estimates of the learning state
                %and its variance: x{k|k} and sigsq{k|k}
                [p, x, Session_run, xold, sold] = forwardfilter(I, SigE, xguess, SigsqGuess, mu);
                
                %Compute the backward (smoothing algorithm) estimates of the learning
                %state and its variance: x{k|K} and sigsq{k|K}
                [xnew, signewsq, A]   = backwardfilter(x, xold, Session_run, sold);
                
                if (UpdaterFlag == 1)
                    xnew(1) = 0.5*xnew(2);   %updates the initial value of the latent process
                    signewsq(1) = SigE^2;
                elseif(UpdaterFlag == 0)
                    xnew(1) = 0;             %fixes initial value (no bias at all)
                    signewsq(1) = SigE^2;
                elseif(UpdaterFlag == 2)
                    xnew(1) = xnew(2);       %x(0) = x(1) means no prior chance probability
                    signewsq(1) = signewsq(2);
                end
                
                %Compute the EM estimate of the learning state process variance
                [newsigsq(i)]         = em_bino(I, xnew, signewsq, A, UpdaterFlag);
                
                xnew1save(i) = xnew(1);
                
                %check for convergence
                if(i>1)
                    a1 = abs(newsigsq(i) - newsigsq(i-1));
                    a2 = abs(xnew1save(i) -xnew1save(i-1));
                    if( a1 < CvgceCrit & a2 < CvgceCrit & UpdaterFlag >= 1)
                        fprintf(2, 'EM estimates of learning state process variance and start point converged after %d steps   \n',  i)
                        break
                    elseif ( a1 < CvgceCrit & UpdaterFlag == 0)
                        fprintf(2, 'EM estimate of learning state process variance converged after %d steps   \n',  i)
                        break
                    end
                end
                
                SigE   = sqrt(newsigsq(i));
                xguess = xnew(1);
                SigsqGuess = signewsq(1);
                
            end
            
            if(i == NumberSteps)
                fprintf(2,'failed to converge after %d steps; convergence criterion was %f \n', i, CvgceCrit)
            end
            
            %-----------------------------------------------------------------------------------
            %integrate and do change of variables to get confidence limits
            
            
            %-----------------------------------------------------------------------------------
            %integrate and do change of variables to get confidence limits
            
            [p05, p95, pmid, pmode, pmatrix] = pdistn(xnew, signewsq, mu, BackgroundProb);
            
            %-------------------------------------------------------------------------------------
            %find the last point where the 90 interval crosses chance
            %for the backward filter (cback)
            
            cback = find(p05 < BackgroundProb);
            
            if(~isempty(cback))
                if(cback(end) < size(I,2) )
                    cback = cback(end);
                else
                    cback = NaN;
                end
            else
                cback = NaN;
            end
            
            
            trial_nb = 1:length(cell2mat(norm_trial_fr(Stimulus_run))');
            
            ax = gca;
            yyaxis right
            set(gca,'Ycolor','b');             set(gca,'ylim',[0 1.2],'ytick',[0:0.2: 1]);
            %             h= plot(trial_nb, pmode(2:end),'b-','linewidth',1.5);
            h= plot([1:size(pmode(2:end),2)], pmode(2:end),'b-','linewidth',1.5);
            ylabel('Performance');
            %                 set(get(ax(2),'Ylabel'),'String','Performance');
            %                 set(ax,'xlim',[0 length(norm_trial_fr')+1]);
            %                 set(scatterh,'MarkerEdgeColor','k');
            %                 set(lineh,'linewidth','k');
            %         plot(trial_nb, pmode,'r-','linewidth',2);
            hold on;
            %         plot(trial_nb, p05,'k:', trial_nb, p95, 'k:');
            if(MaxResponse == 1)
                hold on; [y, x] = find(cell2mat(Corr_mat(Stimulus_run))' > 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y.*1 + .1 , 40,'b','filled');
                hold on; [y, x] = find(cell2mat(Corr_mat(Stimulus_run))' == 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y.*1 + .1, 40,'b');
                axis([0 trial_nb(end)+1  0 1.2]);
            else
                hold on; plot(trial_nb, cell2mat(Corr_mat(Stimulus_run))'./MaxResponse,'ko');
                axis([0 trial_nb(end)+1  0 1.2]);
            end
            %         line([1 t(end)], [BackgroundProb  BackgroundProb]);
            %         h= hline(.5,'b:'); v= vline(cback,'g:', num2str(cback)); set(h,'linewidth',1.5); set(v,'linewidth',1.5);
            %         title(['IO(0.95) Learning trial = ' num2str(cback) '   Learning state process variance = ' num2str(SigE^2) ]);
            hold off;
            xlabel('Trial #')
            box off;
            
            
            
            
            
            
            
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
            
            %             [Learning_curve(Stimulus_run) Learning_curve_lowerCI(Stimulus_run) Learning_curve_upperCI(Stimulus_run)] = get_latent_learning(cell2mat(Corr_mat(Stimulus_run)), startP, matbugROOT);
            
            
            
        end   %%  Stimulus_run = 1:4
        
        
        
        
        
        
        %% Save root per session
        
        session_saveROOT=[saveROOT '\' summary(i_s).Task_name];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)
        
        
        
        %% Save figures
        
        %         filename_ai=[Prefix '.eps'];
        %         print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
        %% Save output files
        
        %         cd(saveROOT);
        %
        %         if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
        %
        %             fod.FourOBJ=fopen(outputfile.FourOBJ,'a');
        %             fprintf(fod.FourOBJ,'%s ,%s ,%s ,%s , %s ,%s ,%s, %d ,%1.3f', Key, RatID, Session, Task_session, Task, Region, ClusterID ,nb_trial.all, nanmean(ts_evt(:,Correctness)));
        %             fprintf(fod.FourOBJ,',%1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f,', CorrR{1}, CorrR{2}, CorrR{3},  CorrR{4}, CorrR{6}, CorrR{7}, CorrR{8}, CorrR{9}, CorrR{11}, CorrR{12}, CorrR{13}, CorrR{14}, Pval_sig{1}, Pval_sig{2}, Pval_sig{3}, Pval_sig{4}, Pval_sig{6}, Pval_sig{7}, Pval_sig{8}, Pval_sig{9}, Pval_sig{11}, Pval_sig{12}, Pval_sig{13}, Pval_sig{14}, Slope{1}, Slope{2}, Slope{3}, Slope{4}, Slope{6}, Slope{7}, Slope{8}, Slope{9}, Slope{11}, Slope{12}, Slope{13}, Slope{14}, Polarity{1}, Polarity{2}, Polarity{3}, Polarity{4},  Polarity{6}, Polarity{7}, Polarity{8}, Polarity{9}, Polarity{11}, Polarity{12}, Polarity{13}, Polarity{14}, Pval_sig_amp, percent_zero, p_amp,perf_fam, perf_nov, exclusion);
        %             fprintf(fod.FourOBJ,',%1.3f, %1.3f, %1.3f, %1.3f,', Perf.Stimulus1, Perf.Stimulus2, Perf.Stimulus3, Perf.Stimulus4);
        %             fprintf(fod.FourOBJ, '\n');
        %             fclose('all');
        %
        %
        %         elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
        %
        %             fod.SceneOBJ=fopen(outputfile.SceneOBJ,'a');
        %             fprintf(fod.SceneOBJ,'%s ,%s ,%s ,%s ,%s ,%s ,%s, %d ,%1.3f', Key, RatID, Session, Task, Task_session, Region, ClusterID ,nb_trial.all, nanmean(ts_evt(:,Correctness)));
        %             fprintf(fod.SceneOBJ,',%1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f,', CorrR{1}, CorrR{2}, CorrR{3},  CorrR{4}, CorrR{6}, CorrR{7}, CorrR{8}, CorrR{9}, CorrR{11}, CorrR{12}, CorrR{13}, CorrR{14}, Pval_sig{1}, Pval_sig{2}, Pval_sig{3}, Pval_sig{4}, Pval_sig{6}, Pval_sig{7}, Pval_sig{8}, Pval_sig{9}, Pval_sig{11}, Pval_sig{12}, Pval_sig{13}, Pval_sig{14}, Slope{1}, Slope{2}, Slope{3}, Slope{4}, Slope{6}, Slope{7}, Slope{8}, Slope{9}, Slope{11}, Slope{12}, Slope{13}, Slope{14}, Polarity{1}, Polarity{2}, Polarity{3}, Polarity{4},  Polarity{6}, Polarity{7}, Polarity{8}, Polarity{9}, Polarity{11}, Polarity{12}, Polarity{13}, Polarity{14}, Pval_sig_amp, percent_zero, p_amp,perf_fam, perf_nov, exclusion);
        %             fprintf(fod.FourOBJ,',%1.3f, %1.3f, %1.3f, %1.3f,', Perf.Stimulus1, Perf.Stimulus2, Perf.Stimulus3, Perf.Stimulus4);
        %             fprintf(fod.SceneOBJ, '\n');
        %             fclose('all');
        %         end
        
        
    end   %  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)'))
    
end   % i_s=  1 :c_s



end
