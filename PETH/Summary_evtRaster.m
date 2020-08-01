%% Created by Jaerong 2018/10/05 for 2nd revision in CR
%% Plots rasters during the event period


function Summary_evtRaster(summary, summary_header, dataROOT)


%% Output folder
saveROOT= [dataROOT '\Analysis\EvtRaster\' date];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% PETH parameters

get_PETH_parms;


[r_s,c_s]=size(summary);



for i_s=  1:c_s
    
    
    
    if  str2num(summary(i_s).Epoch_FR) > 0
        
        
        
        
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
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Drawing Raster and PETH
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Figure parms
        
        fig=figure('name',[  Prefix '_' date],'Color',[1 1 1],'Position',fig_pos);
        
        
        %% Print out cell ID
        
        subplot('Position', [0.13 0.98 0.4 0.2]);
        text(0,0,Prefix,'fontsize',14);
        axis off;
        
        
        %% Draw perievent time histogram
        
        subplot('position',[0.1 0.2 0.65 0.7]);
        
        ref_evt=Choice;
        
        
        %         Draw_PETH(ts_evt, ref_evt, ts_spk, nb_bins, bin_size, Stimulus_color, draw_mode); hold on;
        
        set(gca,'FontSize',5)
        draw_mode = 1;
        ref_evt = StimulusOnset;
        set(gca,'FontSize',5)
        Draw_PETH(ts_evt, ref_evt, ts_spk, nb_bins, bin_size, Stimulus_color, draw_mode); hold on;
        handle= vline(0, 'r:', 'Onset'); set(handle,'linewidth',1.5);  median(trial_latency)
        handle= vline(median(trial_latency), 'b:', 'Choice'); set(handle,'linewidth',1.5);
        set(gca,'ydir','reverse');
        ylim([0 size(ts_evt(select.Corr,:),1)]);
        set(gca, 'YTick',[0 size(ts_evt(select.Corr,:),1)], 'YTickLabel',sprintfc('%i',[0  size(ts_evt(select.Corr,:),1)]),'fontsize',8);
        set(gca,'yticklabel',flipud(get(gca,'yticklabel')));
        xlabel('Time(as)');
        ylabel('Trial #','fontsize',12);
        xlim([-PETH_winsize+2 PETH_winsize-1]);
        box off;
        
        
        %% Print out session info on the figure
        
        
        
        subplot('position',[0.75 0.2 0.2 0.2]);
        axis off
        
        
        msg= sprintf('# zero spike Trials = %d', sum(~logical(trial_fr)));
        text(0.2,2.5,msg,'fontsize',txt_size);
        
        
        msg= sprintf('FR epoch= %1.2f (Hz)', mean_fr.all);
        text(0.2,2.2,msg,'fontsize',txt_size);
        
        
        
        
        
        %% Save figures
        cd(saveROOT)
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);

        filename_ai=[Prefix '.eps'];
        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
      
  
        
    end   % strcmp(summary(i_s).Rat, 'r389') && strcmp(summary(i_s).Task_name, 'OCRS(FourOBJ)')
    
end  % i_s= 528:c_s


end
