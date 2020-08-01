%% Created by Jaerong 2015/09/24 for PRC & POR analysis
%% This created global PETH for all trials.
%% Plots raster, PETH and runs stat testings to compare firings for different stimuli.


function Summary_evtPETH(summary, summary_header, dataROOT)


%% Output folder
saveROOT= [dataROOT '\Analysis\EvtPETH\' date];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% PETH parameters

get_PETH_parms;


%% Load PETH output files

load_PETH_outputfile;



[r_s,c_s]=size(summary);



for i_s=  1:c_s
    
    %         if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?') && ~strcmp(summary(i_s).Region,'x') && ~strcmp(summary(i_s).Region,'AC')
    if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)') &&  str2num(summary(i_s).Epoch_FR) >= 0.5  && ~strcmp(summary(i_s).Region,'IntHIPP')
        
        
        
        
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
        
        
        %% Add stimulus category information
        
        if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            ts_evt= add_category_info(ts_evt,Task);
        end
        
        
        %% Eliminated void trials
        
        ts_evt= void_trial_elimination(ts_evt);
        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        
        %% Get epoch firing rates  & significance test
        
        [mean_fr.all sem_fr.all trial_fr trial_latency]= get_epoch_FR(ts_spk, ts_evt);
        
        
        %         trial_fr(~logical(trial_fr))= nan;
        
        
        %         %%  Store trial info matrix for Statview verification
        %
        %         cd(saveROOT)
        %         dataoutput= [prefix '.txt'];
        %         fod.mat=fopen(dataoutput,'w');
        %
        %         if      ~strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
        %             fprintf(fod.mat,'Trial# \tStimulus \tCat \tResp \tPerf \tFR \n');
        %             dlmwrite(dataoutput,  [ts_evt(:,Trial) ts_evt(:,Stimulus) ts_evt(:,StimulusCAT) ts_evt(:,Response) ts_evt(:,Correctness) trial_fr] , '-append','delimiter','\t','precision','%1.4f');
        %
        %         else
        %             fprintf(fod.mat,'Trial# \tStimulus \tResp \tPerf \tFR \n');
        %             dlmwrite(dataoutput,  [ts_evt(:,Trial) ts_evt(:,Stimulus) ts_evt(:,Response) ts_evt(:,Correctness) trial_fr] , '-append','delimiter','\t','precision','%1.4f');
        %
        %             fclose(fod.mat);
        %
        %         end
        
        %% Session performance
        
        trial_perf= ts_evt(:,Correctness);
        
        
        
        %%  Statistical testing (two sample t test, ranksum test)
        
        get_PETH_stats;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Drawing Raster and PETH
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Figure parms
        
        fig=figure('name',[Prefix '_' date],'Color',[1 1 1],'Position',fig_pos);
        
        
        %% Print out cell ID
        
        subplot('Position', [0.33 0.99 0.4 0.2]);
        text(0,0,Prefix,'fontsize',15);
        axis off;
        
        
        %% Draw perievent time histogram
        
        subplot('position',[0.1 0.71 0.25 0.25]);
        
        ref_evt=Choice;
        get_PETH;
        
        
        %% Plot smoothed SDF during the event period only
        
        subplot('position',[0.1 0.57 0.25 0.12]);
        
        get_SDF_smoothed;
        
        
        
        %% Plot normalized SDF during the event period only
        
        subplot('position',[0.14 0.41 0.18 0.13]);
        
        get_PETH_SDF_normalized;
        
        
        %         %% Get the ROC curve per condition
        %
        %         subplot('position',[0.14 0.25 0.18 0.13]);
        %
        %         get_PETH_AUC;
        %
        %
        %
        %         %% Get epoch firing rates per stimulus (correct vs. incorrect)
        %
        %         get_PETH_meanFR;
        %
        %
        %         %% Draw mean FR bar plots
        %
        %         get_PETH_bar;
        %
        %
        %         %% RMI (Rate modulation index)
        %
        %         get_PETH_RMI;
        %
        %
        %         %%  Linear classification (leave one out method)
        %
        %         get_PETH_classification;
        %
        %
        %         %% Print out session info on the figure
        %
        %         printout_PETH_results;
        %
        %
        %         %% Output file generation
        %
        %         write_PETH_outputfile;
        
        session_saveROOT=[saveROOT '\' summary(i_s).Task_name];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)
        
        
        %% Save figures
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        filename_ai=[Prefix '.eps'];
        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        
        
        
        
%         memory;
        
    end   % strcmp(summary(i_s).Rat, 'r389') && strcmp(summary(i_s).Task_name, 'OCRS(FourOBJ)')
    
end  % i_s= 528:c_s


end
