%% Created by Jaerong 2015/09/24 for PRC & POR analysis
%% This created global PETH for all trials.
%% Plots raster, PETH and runs stat testings to compare firings for different stimuli.
%% In this version (Summary_GetPETH_onset.m), alignment set at stimulus onset


function Summary_GetPETH_onset(summary, summary_header, dataROOT)


%% Output folder
saveROOT= [dataROOT '\Analysis\PETH\StimulusOnset'];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% PETH parameters

get_PETH_parms;


% %% Load PETH output files
%
% load_PETH_outputfile;


[r_s,c_s]=size(summary);


for i_s=  1:c_s
    
    %         if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?') && ~strcmp(summary(i_s).Region,'x') && ~strcmp(summary(i_s).Region,'AC')
    if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)') &&  str2num(summary(i_s).Epoch_FR) >= 0.5
        
        
        
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
        
        
        
        %% Session performance
        
        trial_perf= ts_evt(:,Correctness);
        
        
        %%  Statistical testing (two sample t test, ranksum test)
        
        get_PETH_stats;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Drawing Raster and PETH
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Figure parms
        
        fig=figure('name',[  Prefix '_' date],'Color',[1 1 1],'Position',fig_pos);
        
        
        %% Print out cell ID
        
        subplot('Position', [0.33 0.99 0.4 0.2]);
        text(0,0,Prefix,'fontsize',15);
        axis off;
        
        
        %% Draw perievent time histogram
        
        subplot('position',[0.1 0.71 0.25 0.25]);
        
        title('<StimulusOnet>')
        draw_mode = 1;
        ref_evt=StimulusOnset;
        set(gca,'FontSize',5)
        PETH.all= Draw_PETH_condition(ts_evt(select.Corr,:), ref_evt, ts_spk, nb_bins, bin_size, Stimulus_color, draw_mode); hold on;
        handle= vline(0, 'r:', []); set(handle,'linewidth',1.5);
        handle = hline(size(select.Stimulus4_Corr,1),'k-');
        handle = hline(size(select.Stimulus4_Corr,1)+size(select.Stimulus3_Corr,1),'k-');
        handle = hline(size(select.Stimulus4_Corr,1)+size(select.Stimulus3_Corr,1)+size(select.Stimulus2_Corr,1),'k-');
        handle = hline(size(select.Stimulus4_Corr,1),'k-');
        set(gca,'ydir','reverse');
        ylim([0 size(ts_evt(select.Corr,:),1)]);
        set(gca, 'YTick',[0 size(ts_evt(select.Corr,:),1)], 'YTickLabel',sprintfc('%i',[0  size(ts_evt(select.Corr,:),1)]),'fontsize',8);
        set(gca,'yticklabel',flipud(get(gca,'yticklabel')));
        set(gca,'xticklabel',[])
        ylabel('Trial #','fontsize',12);
        xlim([-PETH_winsize+3 PETH_winsize-1]);
        
        
        %% Plot smoothed SDF during the event period only
        
        subplot('position',[0.1 0.57 0.25 0.12]);
        
        draw_mode= 0;
        
        PETH.Stimulus1_Corr= Draw_PETH(ts_evt(select.Stimulus1_Corr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
        PETH.Stimulus2_Corr= Draw_PETH(ts_evt(select.Stimulus2_Corr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
        PETH.Stimulus3_Corr= Draw_PETH(ts_evt(select.Stimulus3_Corr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
        PETH.Stimulus4_Corr= Draw_PETH(ts_evt(select.Stimulus4_Corr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
        
        
        PETH_FR.all= nansum(PETH.all)/(size(PETH.all,1)*bin_size);
        PETH_FR.Stimulus1_Corr= nansum(PETH.Stimulus1_Corr)/(size(PETH.Stimulus1_Corr,1)*bin_size);
        PETH_FR.Stimulus2_Corr= nansum(PETH.Stimulus2_Corr)/(size(PETH.Stimulus2_Corr,1)*bin_size);
        PETH_FR.Stimulus3_Corr= nansum(PETH.Stimulus3_Corr)/(size(PETH.Stimulus3_Corr,1)*bin_size);
        PETH_FR.Stimulus4_Corr= nansum(PETH.Stimulus4_Corr)/(size(PETH.Stimulus4_Corr,1)*bin_size);
        
        
        
        %% Gaussain convolution for smoothing
        
        PETH_FR_smoothed.all = conv(PETH_FR.all, gaussFilter);
        PETH_FR_smoothed.Stimulus1_Corr = conv(PETH_FR.Stimulus1_Corr, gaussFilter);
        PETH_FR_smoothed.Stimulus2_Corr = conv(PETH_FR.Stimulus2_Corr, gaussFilter);
        PETH_FR_smoothed.Stimulus3_Corr = conv(PETH_FR.Stimulus3_Corr, gaussFilter);
        PETH_FR_smoothed.Stimulus4_Corr = conv(PETH_FR.Stimulus4_Corr, gaussFilter);
        
        FR_max = [max(PETH_FR_smoothed.Stimulus1_Corr) max(PETH_FR_smoothed.Stimulus2_Corr) max(PETH_FR_smoothed.Stimulus3_Corr) max(PETH_FR_smoothed.Stimulus4_Corr)];
        FR_max = max(FR_max);
        PETH_FR = [];
        
        %% Plot smoothed SDF
        x= linspace(-half_PETH_size+(bin_size/2),half_PETH_size-(bin_size/2), length(PETH_FR_smoothed.all));
        hold on;
        plot(x,PETH_FR_smoothed.Stimulus1_Corr,'color',Stimulus_color(1,:),'LineStyle','-','LineWidth',3);
        plot(x,PETH_FR_smoothed.Stimulus2_Corr,'color',Stimulus_color(2,:),'LineStyle','-','LineWidth',3);
        plot(x,PETH_FR_smoothed.Stimulus3_Corr,'color',Stimulus_color(3,:),'LineStyle','-','LineWidth',3);
        plot(x,PETH_FR_smoothed.Stimulus4_Corr,'color',Stimulus_color(4,:),'LineStyle','-','LineWidth',3);
        
        handle= vline(0, 'r:','Onset'); set(handle,'linewidth',2)
        handle= vline(nanmedian(trial_latency), 'b:', 'Choice'); set(handle,'linewidth',2)
        ylim([0 ceil(FR_max)]);
        set(gca, 'YTick',[0 ceil(FR_max)], 'YTickLabel',sprintfc('%i',[0 ceil(FR_max)]),'fontsize',8);
        ylabel('FR (Hz)','fontsize',12)
        xlim([-PETH_winsize+3 PETH_winsize-1]);
        
        
        clear PETH_FR* x
        
        
        
        %% Plot normalized SDF during the event period only
        
        subplot('position',[0.14 0.41 0.18 0.13]);
        
        get_PETH_SDF_normalized;
        
        
        
        %% Draw perievent time histogram
        
        subplot('position',[0.55 0.71 0.25 0.25]);
        
        ref_evt=Choice;
        title('<Choice>')
        
        get_PETH;
        xlim([-PETH_winsize+1 PETH_winsize-3]);
        
        
        
        %% Plot smoothed SDF during the event period only
        
        subplot('position',[0.55 0.57 0.25 0.12]);
        
        get_SDF_smoothed;
        
        
        
        %% Plot normalized SDF during the event period only
        
        subplot('position',[0.6 0.41 0.18 0.13]);
        
        get_PETH_SDF_normalized;
        
        
        
        %% Save root
        session_saveROOT=[saveROOT '\' summary(i_s).Task_name];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)
        
        
        %% Save figures
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);

        
    end   % strcmp(summary(i_s).Rat, 'r389') && strcmp(summary(i_s).Task_name, 'OCRS(FourOBJ)')
    
end  % i_s= 528:c_s


end
