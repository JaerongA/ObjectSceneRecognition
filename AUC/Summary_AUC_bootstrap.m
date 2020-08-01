%% Created by Jaerong 2017/10/22 for PRC & POR analysis.
%% Calculates the SI based on the bootstrapped baseline.
%% Revision on 2018/03/21


function Summary_AUC_bootstrap(summary, summary_header, dataROOT)


%% Output folder
saveROOT= [dataROOT '\Analysis\AUC\bootstrap(100)\std2_crit5_win5\' date];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% PETH parameters

load_parms;


%% AUC parms (std2_crit5_win5 works well)


bootstrap_nb = 100;  % # of bootstrap iterations
global AUC_std_criteria
AUC_std_criteria= 2; % over 2s.d.

global consecutive_crit
consecutive_crit= 5;  % Required number of consecutive numbers following a first one
global sliding_win
sliding_win = 5;


%% Load output files

load_outputfile;



[r_s,c_s]=size(summary);



for i_s= 1:c_s
    
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?') && ~strcmp(summary(i_s).Region,'x') && ~strcmp(summary(i_s).Region,'AC')
    %         if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)') &&  strcmp(summary(i_s).Region,'PER')
    %     if  strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')  &&  str2num(summary(i_s).Epoch_FR) >= 0.5 && (str2num(summary(i_s).Repetition_ok)== 1)
    if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)') &&  str2num(summary(i_s).Epoch_FR) >= 0.5 && ~strcmp(summary(i_s).Region,'IntHIPP')
        %     if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)') &&  str2num(summary(i_s).Epoch_FR) >= 0.5 && strcmp(summary(i_s).Region,'POR')
        
        
        %% Set cluster prefix
        
        set_cluster_prefix;
        
        
        
        %% Loading clusters
        
        load_clusters;
        
        
        %% Loading trial ts info from ParsedEvents.mat
        
        % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        % 13. StimulusCAT
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load_ts_evt;
        
        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        
        
        %% Session performance
        %         trial_latency = ts_evt(:,ChoiceLatency);
        trial_perf= ts_evt(:,Correctness);
        
        [mean_fr.all sem_fr.all trial_fr trial_latency]= get_epoch_FR(ts_spk, ts_evt);
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Drawing Raster and PETH
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Figure parms
        
        fig=figure('name',[  Prefix '_' date],'Color',[1 1 1],'Position',fig_pos);
        
        
        %% Print out cell ID
        
        subplot('Position', [0.33 0.99 0.2 0.2]);
        text(0,0,Prefix,'fontsize',15);
        axis off;
        
        
        %% Draw perievent time histogram
        
        subplot('position',[0.1 0.71 0.25 0.25]);
        
        get_PETH;
        
        
        
        %% Plot smoothed SDF during the event period only
        
        subplot('position',[0.1 0.57 0.25 0.12]);
        
        get_SDF_smoothed;
        
        
        
        %% Plot normalized SDF during the event period only
        
        subplot('position',[0.14 0.41 0.18 0.13]);
        
        
        get_SDF_norm;
        
        
        %% Get the ROC curve per condition
        
        subplot('position',[0.14 0.24 0.18 0.13]);
        
        plot_AUC;
        
        
        
        %% Get selectivity latency & selectivity index
        
        
        Selectivity_index=[];
        Selectivit_onset=[];
        nb_overbaseline=[];
        SI_diff= nan;
        
        %         get_AUC_SI_bootstrap(AUC, AUC_baseline, AUC_color)
        
        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            [Selectivity_peakloc.Familiar, Selectivity_duration.Familiar, Selectivity_index.Familiar, Selectivity_onset.Familiar]  = get_AUC_SI_bootstrap(AUC.Familiar, AUC_color(1,:));
              
            [Selectivity_peakloc.Novel, Selectivity_duration.Novel, Selectivity_index.Novel, Selectivity_onset.Novel] = get_AUC_SI_bootstrap(AUC.Novel, AUC_color(2,:));
            
        elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            [Selectivity_peakloc.Scene, Selectivity_duration.Scene, Selectivity_index.Scene, Selectivity_onset.Scene, Sig_ind.Scene] = get_AUC_SI_bootstrap(AUC.Scene, AUC.Scene_bootstrapped, AUC_color(1,:));
            
            [Selectivity_peakloc.OBJ, Selectivity_duration.OBJ, Selectivity_index.OBJ, Selectivity_onset.OBJ, Sig_ind.OBJ] = get_AUC_SI_bootstrap(AUC.OBJ, AUC.OBJ_bootstrapped, AUC_color(2,:));
            
        end
        
        if Selectivity_index.Scene | Selectivity_index.OBJ
        SI_diff= Selectivity_index.Scene - Selectivity_index.OBJ;
        end
        
        
        %% Get the heatmap for stimulus selectivity
        
        subplot('position',[0.14 0.08 0.18 0.03]);
        
        
        
        plot_AUC_heatmap;
        
        
        
        
        %         %% Integrate over baseline subtracted ROC area
        %
        %
        %
        %         if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
        %
        %             %         AUC_overbaseline.Familiar= sum(AUC.Familiar - AUC.Familiar_bootstrapped);
        %             %         AUC_overbaseline.Novel= sum(AUC.Novel - AUC.Novel_bootstrapped);
        %
        %             %% Sum the positive values only (revised 2016/10/19)
        %             AUC_overbaseline.Familiar= AUC.Familiar - AUC.Familiar_bootstrapped;
        %             AUC_overbaseline.Novel= AUC.Novel - AUC.Novel_bootstrapped;
        %
        %             AUC_overbaseline.Scene= sum(AUC_overbaseline.Scene(find(AUC_overbaseline.Scene> 0)));
        %             AUC_overbaseline.OBJ= sum(AUC_overbaseline.OBJ(find(AUC_overbaseline.OBJ> 0)));
        %
        %         else
        %             %         AUC_overbaseline.Scene= sum(AUC.Scene - AUC.Scene_bootstrapped);
        %             %         AUC_overbaseline.OBJ= sum(AUC.OBJ - AUC.OBJ_bootstrapped);
        %
        %             %% Sum the positive values only (revised 2016/10/19)
        %             AUC_overbaseline.Scene= AUC.Scene - AUC.Scene_bootstrapped;
        %             AUC_overbaseline.OBJ= AUC.OBJ - AUC.OBJ_bootstrapped;
        %
        %
        %             AUC_overbaseline.Scene= sum(AUC_overbaseline.Scene(find(AUC_overbaseline.Scene> 0)));
        %             AUC_overbaseline.OBJ= sum(AUC_overbaseline.OBJ(find(AUC_overbaseline.OBJ> 0)));
        %
        %         end
        
        
        
        %% Store the AUC vectors into a .mat file
        
        cd(saveROOT);
        save([Prefix '.mat'],'AUC','Sig_ind','Selectivity*');
        cd(dataROOT);
        
        
        
        %         clear SDF  AUC
        
        
        %% Print out session info & stats on the figure
        
        printout_results;
        
        
        
        %% Write to the output file
        
        write_outputfile;
        
        %         memory;
        
    end   % strcmp(summary(i_s).Rat, 'r389') && strcmp(summary(i_s).Task_name, 'OCRS(FourOBJ)')
    
end  % i_s= 1:c_s


end
