%% Revised by Jaerong 2016/11/05 for plotting the PETH for error trials
%% The program plots AUC of ROC values across the time bin during the event period (from object onset to choice).
%% Plots raster, PETH and runs stat testings to compare firings for different stimuli.


function Summary_AUC_incorr(summary, summary_header, dataROOT)


%% Output folder
saveROOT= [dataROOT '\Analysis\AUC\Incorr_' date ];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% PETH parameters

load_parms;


%% Load output files

load_outputfile;



[r_s,c_s]=size(summary);



for i_s=   1:1:c_s
    %     1500:c_s
    
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?') && ~strcmp(summary(i_s).Region,'x') && ~strcmp(summary(i_s).Region,'AC')
    %     if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)') &&  strcmp(summary(i_s).Region,'PER')
    if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')  &&  str2num(summary(i_s).Epoch_FR) >= 0.5
        
        
        
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
        
        
        
        if ((size(select.Stimulus1_Incorr,1)<3) || (size(select.Stimulus2_Incorr,1)<3) ||  (size(select.Stimulus3_Incorr,1)<3) ||  (size(select.Stimulus4_Incorr,1)<3))
            disp('Not enough error trials !');
        continue;
        end
        
        
        %% Session performance
        
        trial_latency = ts_evt(:,ChoiceLatency);
        trial_perf= ts_evt(:,Correctness);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Drawing Raster and PETH
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Figure parms
        
        fig=figure('name',[  prefix '_' date],'Color',[1 1 1],'Position',fig_pos);
        
        
        %% Print out cell ID
        
        subplot('Position', [0.33 0.99 0.2 0.2]);
        text(0,0,prefix,'fontsize',15);
        axis off;
        
        
        %% Draw perievent time histogram
        
        subplot('position',[0.1 0.71 0.25 0.25]);
        
        
        ref_evt=Choice;
        set(gca,'FontSize',5)
        draw_mode = 1;
        PETH.all= Draw_PETH_condition(ts_evt(select.Corr,:), ref_evt, ts_spk, nb_bins, bin_size, Stimulus_color, draw_mode); hold on;
        xlim([-PETH_winsize+1 PETH_winsize-3]);
        handle= vline(0, 'b:', []); set(handle,'linewidth',1.5);
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
        
        
        
        
        subplot('position',[0.55 0.71 0.25 0.15]);
        
        
        set(gca,'FontSize',5)
        draw_mode = 1;
        PETH.all= Draw_PETH_condition(ts_evt(select.Incorr,:), ref_evt, ts_spk, nb_bins, bin_size, Stimulus_color, draw_mode); hold on;
        xlim([-PETH_winsize+1 PETH_winsize-3]);
        handle= vline(0, 'b:', []); set(handle,'linewidth',1.5);
        handle = hline(size(select.Stimulus4_Incorr,1),'k-');
        handle = hline(size(select.Stimulus4_Incorr,1)+size(select.Stimulus3_Incorr,1),'k-');
        handle = hline(size(select.Stimulus4_Incorr,1)+size(select.Stimulus3_Incorr,1)+size(select.Stimulus2_Incorr,1),'k-');
        handle = hline(size(select.Stimulus4_Incorr,1),'k-');
        set(gca,'ydir','reverse');
        ylim([0 size(ts_evt(select.Incorr,:),1)]);
        set(gca, 'YTick',[0 size(ts_evt(select.Incorr,:),1)], 'YTickLabel',sprintfc('%i',[0  size(ts_evt(select.Incorr,:),1)]),'fontsize',8);
        set(gca,'yticklabel',flipud(get(gca,'yticklabel')));
        set(gca,'xticklabel',[])
        ylabel('Trial #','fontsize',12);
        
        
        
        
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
        
        handle= vline(0, 'b:','Choice'); set(handle,'linewidth',2)
        handle= vline(-nanmedian(trial_latency), 'r:', 'Onset'); set(handle,'linewidth',2)
        xlim([-PETH_winsize+1 PETH_winsize-3]);
        %         ylim([0 ceil(max(PETH_FR_smoothed.all))]);
        ylim([0 ceil(FR_max)]);
        set(gca, 'YTick',[0 ceil(FR_max)], 'YTickLabel',sprintfc('%i',[0 ceil(FR_max)]),'fontsize',8);
        ylabel('FR (Hz)','fontsize',12)
        
        
        subplot('position',[0.55 0.57 0.25 0.12]);
        
        
        draw_mode= 0;
        
        PETH.Stimulus1_Incorr= Draw_PETH(ts_evt(select.Stimulus1_Incorr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
        PETH.Stimulus2_Incorr= Draw_PETH(ts_evt(select.Stimulus2_Incorr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
        PETH.Stimulus3_Incorr= Draw_PETH(ts_evt(select.Stimulus3_Incorr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
        PETH.Stimulus4_Incorr= Draw_PETH(ts_evt(select.Stimulus4_Incorr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
        
        
        PETH_FR.all= nansum(PETH.all)/(size(PETH.all,1)*bin_size);
        PETH_FR.Stimulus1_Incorr= nansum(PETH.Stimulus1_Incorr)/(size(PETH.Stimulus1_Incorr,1)*bin_size);
        PETH_FR.Stimulus2_Incorr= nansum(PETH.Stimulus2_Incorr)/(size(PETH.Stimulus2_Incorr,1)*bin_size);
        PETH_FR.Stimulus3_Incorr= nansum(PETH.Stimulus3_Incorr)/(size(PETH.Stimulus3_Incorr,1)*bin_size);
        PETH_FR.Stimulus4_Incorr= nansum(PETH.Stimulus4_Incorr)/(size(PETH.Stimulus4_Incorr,1)*bin_size);
        
        
        
        %% Gaussain convolution for smoothing
        
        PETH_FR_smoothed.all = conv(PETH_FR.all, gaussFilter);
        PETH_FR_smoothed.Stimulus1_Incorr = conv(PETH_FR.Stimulus1_Incorr, gaussFilter);
        PETH_FR_smoothed.Stimulus2_Incorr = conv(PETH_FR.Stimulus2_Incorr, gaussFilter);
        PETH_FR_smoothed.Stimulus3_Incorr = conv(PETH_FR.Stimulus3_Incorr, gaussFilter);
        PETH_FR_smoothed.Stimulus4_Incorr = conv(PETH_FR.Stimulus4_Incorr, gaussFilter);
        
        FR_max = [max(PETH_FR_smoothed.Stimulus1_Incorr) max(PETH_FR_smoothed.Stimulus2_Incorr) max(PETH_FR_smoothed.Stimulus3_Incorr) max(PETH_FR_smoothed.Stimulus4_Incorr)];
        FR_max = max(FR_max);
        PETH_FR = [];
        
        %% Plot smoothed SDF
        x= linspace(-half_PETH_size+(bin_size/2),half_PETH_size-(bin_size/2), length(PETH_FR_smoothed.all));
        hold on;
        plot(x,PETH_FR_smoothed.Stimulus1_Incorr,'color',Stimulus_color(1,:),'LineStyle','-','LineWidth',3);
        plot(x,PETH_FR_smoothed.Stimulus2_Incorr,'color',Stimulus_color(2,:),'LineStyle','-','LineWidth',3);
        plot(x,PETH_FR_smoothed.Stimulus3_Incorr,'color',Stimulus_color(3,:),'LineStyle','-','LineWidth',3);
        plot(x,PETH_FR_smoothed.Stimulus4_Incorr,'color',Stimulus_color(4,:),'LineStyle','-','LineWidth',3);
        
        handle= vline(0, 'b:','Choice'); set(handle,'linewidth',2)
        handle= vline(-nanmedian(trial_latency), 'r:', 'Onset'); set(handle,'linewidth',2)
        xlim([-PETH_winsize+1 PETH_winsize-3]);
        %         ylim([0 ceil(max(PETH_FR_smoothed.all))]);
        ylim([0 ceil(FR_max)]);
        set(gca, 'YTick',[0 ceil(FR_max)], 'YTickLabel',sprintfc('%i',[0 ceil(FR_max)]),'fontsize',8);
        ylabel('FR (Hz)','fontsize',12)
        
        
        clear PETH_FR* x
        
        
        %% Plot normalized SDF during the event period only
        
        subplot('position',[0.14 0.41 0.18 0.13]);
        
        clear SDF
        get_SDF_norm;
        
        
        
        subplot('position',[0.6 0.41 0.18 0.13]);
        
        SDF.Stimulus1_Incorr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Incorr,:), ts_spk, nb_win);
        SDF.Stimulus2_Incorr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Incorr,:), ts_spk, nb_win);
        SDF.Stimulus3_Incorr = Get_Normalized_SDF(ts_evt(select.Stimulus3_Incorr,:), ts_spk, nb_win);
        SDF.Stimulus4_Incorr = Get_Normalized_SDF(ts_evt(select.Stimulus4_Incorr,:), ts_spk, nb_win);
        
        
        SDF.Stimulus1_Incorr = conv(mean(SDF.Stimulus1_Incorr), gaussFilter,'same');
        SDF.Stimulus2_Incorr = conv(mean(SDF.Stimulus2_Incorr), gaussFilter,'same');
        SDF.Stimulus3_Incorr = conv(mean(SDF.Stimulus3_Incorr), gaussFilter,'same');
        SDF.Stimulus4_Incorr = conv(mean(SDF.Stimulus4_Incorr), gaussFilter,'same');
        
        
        plot(SDF.Stimulus1_Incorr,'color',Stimulus_color(1,:),'LineStyle','-','LineWidth',3); hold on;
        plot(SDF.Stimulus2_Incorr,'color',Stimulus_color(2,:),'LineStyle','-','LineWidth',3); hold on;
        plot(SDF.Stimulus3_Incorr,'color',Stimulus_color(3,:),'LineStyle','-','LineWidth',3); hold on;
        plot(SDF.Stimulus4_Incorr,'color',Stimulus_color(4,:),'LineStyle','-','LineWidth',3);
        
        
        
        box off;
        axis tight
        ylim([0 ceil(max(structfun(@(x)max(x(:)),SDF)))]);
        % set(gca,'xtick',[]);
        ylabel('FR (Hz)','fontsize',12);
        %         xlabel('Normalized time','fontsize',12);
        set(gca, 'YTick',[0 ceil(max(structfun(@(x)max(x(:)),SDF)))], 'YTickLabel',sprintfc('%i',[0 ceil(max(structfun(@(x)max(x(:)),SDF)))]),'fontsize',8);
        set(gca, 'XTick',[1 nb_win], 'XTickLabel',{'StimulusOnset' ;'Choice'},'fontsize',8);
        
        clear SDF
        
        
        
        
        %% Get the ROC curve per condition
        
        subplot('position',[0.14 0.24 0.18 0.13]);
        
        plot_AUC;
        
        
        
        %% Get the heatmap for stimulus selectivity
        
        %         subplot('position',[0.47 0.35 0.18 0.04]);
        subplot('position',[0.14 0.08 0.18 0.03]);
        
        
        
        plot_AUC_heatmap;        
        
        
        %% Get the ROC curve per condition (incorrect)
        
        subplot('position',[0.6 0.24 0.18 0.13]);
        
        




        SDF.Stimulus1_Incorr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Incorr,:), ts_spk, nb_win);
        SDF.Stimulus2_Incorr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Incorr,:), ts_spk, nb_win);
        SDF.Stimulus3_Incorr = Get_Normalized_SDF(ts_evt(select.Stimulus3_Incorr,:), ts_spk, nb_win);
        SDF.Stimulus4_Incorr = Get_Normalized_SDF(ts_evt(select.Stimulus4_Incorr,:), ts_spk, nb_win);
        
        
        
        
        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
        
        AUC.Familiar =  Get_AUC(SDF.Stimulus1_Incorr, SDF.Stimulus2_Incorr, nb_win);
        AUC.Novel =  Get_AUC(SDF.Stimulus3_Incorr, SDF.Stimulus4_Incorr, nb_win);
        
        AUC.Familiar_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus1_Incorr, SDF.Stimulus2_Incorr, nb_win, bootstrap_nb);
        AUC.Novel_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus3_Incorr, SDF.Stimulus4_Incorr, nb_win, bootstrap_nb);
        
        
        elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
        
        
        AUC.Scene =  Get_AUC(SDF.Stimulus1_Incorr, SDF.Stimulus2_Incorr, nb_win);
        AUC.OBJ =  Get_AUC(SDF.Stimulus3_Incorr, SDF.Stimulus4_Incorr, nb_win);
        
        
        AUC.Scene_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus1_Incorr, SDF.Stimulus2_Incorr, nb_win, bootstrap_nb);
        AUC.OBJ_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus3_Incorr, SDF.Stimulus4_Incorr, nb_win, bootstrap_nb);
        
        end
       

        
        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            
        plot(AUC.Familiar,'LineStyle','-','LineWidth',3); hold on;
        plot(AUC.Novel,'LineStyle','-','LineWidth',3); axis tight; box off; 
        
            
        plot(AUC.Familiar_bootstrapped,'LineStyle',':','LineWidth',2,'color',[0    0.4470    0.7410]); hold on;
        plot(AUC.Novel_bootstrapped,'LineStyle',':','LineWidth',2, 'color',[0.8500    0.3250    0.0980]); 
        
        
        elseif     strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            
            
        plot(AUC.Scene,'LineStyle','-','LineWidth',3); hold on;
        plot(AUC.OBJ,'LineStyle','-','LineWidth',3); axis tight; box off; 
        
            
        plot(AUC.Scene_bootstrapped,'LineStyle',':','LineWidth',2,'color',[0    0.4470    0.7410]); hold on;
        plot(AUC.OBJ_bootstrapped,'LineStyle',':','LineWidth',2, 'color',[0.8500    0.3250    0.0980]); 

        
        end
        
        
%         SDF.Pushing_Incorr = Get_Normalized_SDF(ts_evt(select.Pushing_Incorr,:), ts_spk, nb_win);
%         SDF.Digging_Incorr = Get_Normalized_SDF(ts_evt(select.Digging_Incorr,:), ts_spk, nb_win);

%         AUC.Resp =  Get_AUC(SDF.Pushing_Incorr, SDF.Digging_Incorr, nb_win);

%         plot(AUC.Resp,'LineStyle','-','LineWidth',3); 
        

        
        ylabel('ROC area','fontsize',12);
%         xlabel('Normalized time','fontsize',12);
        set(gca, 'XTick',[1 nb_win], 'XTickLabel',{'StimulusOnset' ;'Choice'},'fontsize',8);
        
        
%         if round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1  <= 0.9
%             
%         set(gca, 'YTick',[0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1], 'YTickLabel',sprintfc('%0.2f',[0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]),'fontsize',8);
%         ylim([0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1])
%         
%         else
            
        set(gca, 'YTick',[0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1], 'YTickLabel',sprintfc('%0.2f',[0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]),'fontsize',8);
        ylim([0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1])
                    
        delete SDF

        
        
        %% Get the heatmap for stimulus selectivity
        
        subplot('position',[0.6 0.08 0.18 0.03]);
        
        
        %% Get the heatmap for stimulus selectivity

        
        imagesc(AUC.OBJ);
        colormap(flipud(hot));
        caxis([0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]); box off;
        ylabel('OBJ');
        set(gca, 'XTick',[],'YTick',[]);
        set(gca, 'XTick',[1 nb_win], 'XTickLabel',{'StimulusOnset' ;'Choice'},'YTickLabel',[],'fontsize',8);
%         colorbar('Position', [.67 .28 .010 .11], 'YTick', [0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1], 'YTickLabel', sprintfc('%0.2f',[0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]));
        
        
        subplot('position',[0.6 0.13 0.18 0.03]);
        
        imagesc(AUC.Scene);title('Stimulus Selectivity');
        caxis([0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]); box off;
        ylabel('Scene');
        set(gca, 'XTickLabel',[],'YTickLabel',[]);
        set(gca, 'XTick',[],'YTick',[]);
        
        
        
        
        %% By AJR 2016/03/22
        %% Save root per session
        
        
        session_saveROOT=[saveROOT '\' summary(i_s).Task_name '\' summary(i_s).Region];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)
        
        
        %% Save figures
        filename=[prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        %         memory;
        
    end   % strcmp(summary(i_s).Rat, 'r389') && strcmp(summary(i_s).Task_name, 'OCRS(FourOBJ)')
    
end  % i_s= 1:c_s


end
