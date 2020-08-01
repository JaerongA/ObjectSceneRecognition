%% Created by Jaerong 2017/02/22 for PER & POR analysis
%% This version applies a nonlinear (2nd order curvelinear fit to the data)


function [summary,summary_header]= Summary_Get_Repetition_Suppression_Nonlinear(summary, summary_header, dataROOT)


%% Output folder
% saveROOT= [dataROOT '\Analysis\Repetition_Suppression\' date];
saveROOT= [dataROOT '\Analysis\Repetition_Suppression\Nonlinear(Rsquare)'];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);



%% Fig parms
fig_pos= [100,250,1600,550];
bgcol=[1 0.6 0.6; 0.6 1 0.6];



%% Parms
alpha= 0.05;
xpos=0.8;
ypos=1.6;

stability_alpha= 0.01;
nb_block = 10;


BestModel = {'Linear','Nonlin'};
fun.lin= @(p,trial_nb) p(1) +  p(2)*trial_nb;
fun.quad= @(p,trial_nb) p(1) +  p(2)*trial_nb + p(3)* trial_nb.^2;
Rsquare_crit= 0.3;



%% Load output files
%% FourOBJ
outputfile.FourOBJ= 'Repetition_Suppression(FourOBJ).csv';
fod.FourOBJ = fopen(outputfile.FourOBJ,'w');
txt_header = 'Key#, RatID, Session, Region, ClusterID, nTrials, Performance_All, MeanFR(Epoch), ZeroSpkProportion, Cell_Category, Fitting_Category,';
fprintf(fod.FourOBJ, txt_header);
txt_header = 'BestModel, Rsquare, Polarity, Perf_Stimulus, Stability_OK,';
fprintf(fod.FourOBJ, txt_header);
txt_header = '\n';
fprintf(fod.FourOBJ, txt_header);
fclose(fod.FourOBJ);



[r_s,c_s]=size(summary);



for i_s= 1:c_s
    
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?')
    %          if  strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')  && (str2num(summary(i_s).Epoch_FR) >= 0.5) &&  (str2num(summary(i_s).Task_session)== 1) && (str2num(summary(i_s).Repetition_ok)== 1)
    %     if  strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')  && (str2num(summary(i_s).Epoch_FR) >= 0.5) &&  (str2num(summary(i_s).Repetition_ok)== 1)
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
        
        for Stimulus_run = 1: 4
            
            %             eval(['Perf.Stimulus' num2str(Stimulus_run) ' = mean(ts_evt(select.Stimulus' num2str(Stimulus_run) '_All,Correctness));'])
            eval(['Perf(Stimulus_run) = mean(ts_evt(select.Stimulus' num2str(Stimulus_run) '_All,Correctness));'])
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Drawing Raster and PETH
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Figure parms
        
        fig=figure('name',[  Prefix '_' date],'Color',[1 1 1],'Position',fig_pos);
        
        
        %% Print out cell ID
        
        subplot('Position', [0.35 0.98 0.4 0.2]);
        text(0,0,Prefix,'fontsize',14);
        axis off;
        
        
        
        %% Check for repetition suppression effect: slope and 1vs2 half comparison (following FR normalization from 0 to 10)
        
        Rsquare_sig =zeros(1,4);
        Polarity =[];
        BestModel= cell(1,4);
        Rsquare_best = [];
        norm_all_trial_fr = mapminmax(trial_fr', 0, 10)';
        
        
        
        for Stimulus_run = 1:4
            
            
            subplot('position',[((Stimulus_run-1)/5)+0.03 0.28 0.16 0.4]);
            
            %% Correct trials only
            eval(['trial_nb= [1:length(norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_Corr))];']);
            eval(['norm_trial_fr{Stimulus_run}= norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_Corr);']);
            
            %% All trials only
            %             eval(['trial_nb= [1:length(norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All))];']);
            %             eval(['norm_trial_fr= norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All);']);
            trial_nb = 1:length(cell2mat(norm_trial_fr(Stimulus_run))');
            
            
            scatter(trial_nb, cell2mat(norm_trial_fr(Stimulus_run)),'k','filled'); hold on;
            
            
            %%  linear curve fitting for sampling %% 2013-09-23
            
            
            p_lin  = nlinfit(trial_nb, cell2mat(norm_trial_fr(Stimulus_run))',fun.lin,[1 1]);
            mdl_lin = NonLinearModel.fit(trial_nb,cell2mat(norm_trial_fr(Stimulus_run)),fun.lin,[1 1]);
            bic_lin(Stimulus_run) = mdl_lin.ModelCriterion.BIC;
            Rsquare_lin(Stimulus_run)=mdl_lin.Rsquared.Ordinary;
            Slope(Stimulus_run)=p_lin(2);
            
            
            p_quad  = nlinfit(trial_nb, cell2mat(norm_trial_fr(Stimulus_run))',fun.quad,[1 1 1]);
            mdl_quad = NonLinearModel.fit(trial_nb, cell2mat(norm_trial_fr(Stimulus_run)),fun.quad,[1 1 1]);
            bic_quad(Stimulus_run) = mdl_quad.ModelCriterion.BIC;
            Rsquare_quad(Stimulus_run)=mdl_quad.Rsquared.Ordinary;
            
            
            trial_nb = 0: (ceil(max(trial_nb)/5)* 5);
            
            lineh=line(trial_nb, fun.lin(p_lin,trial_nb)); set(lineh,'linewidth',0.5,'color','k');
            
            
            if (Rsquare_lin(Stimulus_run) >= Rsquare_crit) && (bic_lin(Stimulus_run) < bic_quad(Stimulus_run))
                lineh.Color= 'b';
                lineh.LineWidth= 1.5;
            end
            
            
            lineh=line(trial_nb, fun.quad(p_quad,trial_nb)); set(lineh,'linewidth',0.5,'color','k');
            
            if Rsquare_quad(Stimulus_run) >= Rsquare_crit && (bic_lin(Stimulus_run) > bic_quad(Stimulus_run))
                lineh.Color= 'r';
                lineh.LineWidth= 1.5;
            end
            
            
            if (Rsquare_lin(Stimulus_run) >= Rsquare_crit) &&  (bic_lin(Stimulus_run) < bic_quad(Stimulus_run))
                
                
                Rsquare_sig(Stimulus_run) =  1;
                
            elseif (Rsquare_quad(Stimulus_run) >= Rsquare_crit) &&  (bic_lin(Stimulus_run) > bic_quad(Stimulus_run))
                
                Rsquare_sig(Stimulus_run) =  1;
                
                
            end
            
            
            %% Best Model
            
            if Rsquare_sig(Stimulus_run)
                if (bic_lin(Stimulus_run) < bic_quad(Stimulus_run))
                    BestModel{Stimulus_run}= 'Linear';
                elseif  (bic_lin(Stimulus_run) > bic_quad(Stimulus_run))
                    BestModel{Stimulus_run}= 'Nonlin';
                end
            else
                BestModel{Stimulus_run}= 'Non';
                
            end
            
            
            
            %% Polarity for original
            
            if Slope(Stimulus_run) < 0
                Polarity{Stimulus_run}= 'Negative';
            else
                Polarity{Stimulus_run}= 'Positive';
            end
            
            
            
            title(Stimulus_str{Stimulus_run},'fontsize',13);
            xlabel(['Trial #'],'fontsize',13,'fontweight','bold'); ylabel(['Norm FR'],'fontsize',13,'fontweight','bold');
            
            
            
            msg= sprintf('R^2(Linear) = %1.2f',Rsquare_lin(Stimulus_run));
            text(xpos-.1,ypos,msg,'units','normalized')
            
            msg= sprintf('R^2(Nonlin) = %1.2f',Rsquare_quad(Stimulus_run));
            text(xpos-.1,ypos-.1,msg,'units','normalized')
            
            msg= sprintf('Performance = %1.2f', Perf(Stimulus_run));
            text(xpos-.1,ypos-.2,msg,'units','normalized')
            
            msg= sprintf('BIC(Linear) = %1.2f', bic_lin(Stimulus_run));
            handle_lin= text(xpos-.1,ypos-.3,msg,'units','normalized');
            msg= sprintf('BIC(Nonlin) = %1.2f', bic_quad(Stimulus_run));
            handle_quad= text(xpos-.1,ypos-.4,msg,'units','normalized');
            
            
            
            if   (bic_lin(Stimulus_run) < bic_quad(Stimulus_run)) && Rsquare_sig(Stimulus_run)
                
                set(handle_lin,'backgroundcolor',bgcol(2,:))
                
            elseif (bic_lin(Stimulus_run) > bic_quad(Stimulus_run)) && Rsquare_sig(Stimulus_run)
                
                set(handle_quad,'backgroundcolor',bgcol(2,:))
            end
            
            
            set(gca, 'ylim',[0 10]);
            set(gca, 'xlim',[0 ceil(max(trial_nb)/5)* 5]);
            
            
            
        end   %%  Stimulus_run = 1:4
        
        

        %% New categorization based on Rsquare value (2017/08/01)
        
        
        % fitting_cat= {'NoFitting','Non_specific','Familiar','Novel'};
        
        fitting_cat ='Nonspecific';
        
        
        switch sum(Rsquare_sig)
            
            case 0
                
                fitting_cat ='Nofitting';
                
            case 1
                
                if Rsquare_sig(Icecream) || Rsquare_sig(House)
                    
                    fitting_cat ='SingleOBJ(Familiar)';
                    
                elseif  Rsquare_sig(Owl) || Rsquare_sig(Phone)
                    
                    fitting_cat ='SingleOBJ(Novel)';
                    
                end
                
                
            case 2
                
                if Rsquare_sig(Icecream) && Rsquare_sig(House)
                    
                    fitting_cat ='Familiar';
                    
                elseif  Rsquare_sig(Owl) && Rsquare_sig(Phone)
                    
                    fitting_cat ='Novel';
                    
                elseif   Rsquare_sig(Icecream) && Rsquare_sig(Owl)
                    
                    fitting_cat ='Response';
                    
                elseif   Rsquare_sig(House) && Rsquare_sig(Phone)
                    
                    fitting_cat ='Response';
                    
                end
                
        end
        
        

        
 
        
        for Stimulus_run= 1:4
            
            if strcmp(BestModel{Stimulus_run},'Linear')
            
            Rsquare_best(Stimulus_run)=  Rsquare_lin(Stimulus_run);
            
            else
            Rsquare_best(Stimulus_run)=  Rsquare_quad(Stimulus_run);
                
            end
            
        end
        
                
        %% Based on the representative fitting (higher R square)
        
        if sum(Rsquare_sig)==1
            
            if strcmp(BestModel{logical(Rsquare_sig)},'Linear')
                
            
            Rsquare = Rsquare_lin(logical(Rsquare_sig));
            BestModel= 'Linear';
            Polarity = cell2mat(Polarity(logical(Rsquare_sig)));
            Perf= Perf(logical(Rsquare_sig));
            
            
            elseif  strcmp(BestModel{logical(Rsquare_sig)},'Nonlin')
            
            Rsquare = Rsquare_quad(logical(Rsquare_sig));
            BestModel= 'Nonlin';
            Polarity = cell2mat(Polarity(logical(Rsquare_sig)));
            Perf= Perf(logical(Rsquare_sig));

            end
            
            
            
        elseif  sum(Rsquare_sig)> 1
            
            ind= find(abs(Rsquare_best) == max(abs(Rsquare_best)));
            
            if Rsquare_sig(ind)
            
            Rsquare = Rsquare_best(ind);
            Polarity =cell2mat(Polarity(ind));
            Perf= Perf(ind);
            BestModel= BestModel{ind};
            end
            
            
        else
            
            
            Rsquare= nan;
            BestModel= 'Non';
            Polarity = nan;
            Perf= nan;
            
            
        end
        
        
        subplot('position',[0.85 0.35 0.15 0.25]); axis off;
        
        msg= sprintf('Best Model= %s',BestModel);
        text(-.1,1.0,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('Rsquare(BestModel) = %1.2f',Rsquare);
        text(-.1,0.8,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('Fitting CAT = %s',fitting_cat);
        text(-.1,0.6,msg,'Fontsize',12,'units','normalized');
        
        
        msg= sprintf('Cell CAT = %s', summary(i_s).Cell_Category);
        text(-.1,0.4,msg,'Fontsize',12,'units','normalized');
        
        
        msg= sprintf('mean FR (Epoch) = %1.2f (Hz)', mean_fr.all);  %% Mean FR from the event period
        text(-.1,0.2,msg,'Fontsize',12,'units','normalized');
        
        msg= sprintf('Zero spike proportion = %2.2f (%%)', str2num(summary(i_s).Zero_FR_Proportion)* 100);  %% Mean FR from the event period
        text(-.1,0,msg,'Fontsize',12,'units','normalized');

        
        %% Save root per session
        
        session_saveROOT=[saveROOT '\' fitting_cat];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)

        
        %% Save figures
        
        %         filename_ai=[Prefix '.eps'];
        %         print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        % Save output files
        
        cd(saveROOT);
        
        
        fod.FourOBJ=fopen(outputfile.FourOBJ,'a');
        fprintf(fod.FourOBJ,'%s ,%s ,%s ,%s , %s ,%d ,%1.3f, %1.3f, %2.1f, %s, %s', Key, RatID, Task_session, Region, ClusterID ,nb_trial.all, nanmean(ts_evt(:,Correctness)),  mean_fr.all, str2num(summary(i_s).Zero_FR_Proportion)* 100, summary(i_s).Cell_Category, fitting_cat);
        fprintf(fod.FourOBJ,',%s, %1.2f, %s, %1.2f, %d,', BestModel, Rsquare, Polarity, Perf, str2num(summary(i_s).Stability_ok));
        fprintf(fod.FourOBJ, '\n');
        fclose('all');
        
        
        
        clear nb_trial
        
        
        
    end   %  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)'))
    
end   % i_s=  1 :c_s



end
