        set(gca,'FontSize',5)
        draw_mode = 1;
        ref_evt = StimulusOnset;
        
        %% Draw PETH according to conditions
        
%         PETH.all= Draw_PETH_condition(ts_evt(select.Corr,:), ref_evt, ts_spk, nb_bins, bin_size, Stimulus_color, draw_mode); hold on;
%         handle= vline(0, 'k:', []); set(handle,'linewidth',1.5);
%         handle = hline(size(select.Stimulus1_Corr,1),'k-'); 
%         handle = hline(size(select.Stimulus1_Corr,1)+size(select.Stimulus2_Corr,1),'k-'); 
%         handle = hline(size(select.Stimulus1_Corr,1)+size(select.Stimulus2_Corr,1)+size(select.Stimulus3_Corr,1),'k-');
%         handle = hline(size(select.Stimulus1_Corr,1),'k-');
        

        %% Draw PETH in the order each stimulus apeears
        PETH.all= Draw_PETH_color(ts_evt(select.Corr,:), ref_evt, ts_spk, nb_bins, bin_size, Stimulus_color, draw_mode); hold on;
        
        
        set(gca,'ydir','reverse');
        ylim([0 size(ts_evt(select.Corr,:),1)]);
        set(gca, 'YTick',[0 size(ts_evt(select.Corr,:),1)], 'YTickLabel',sprintfc('%i',[0  size(ts_evt(select.Corr,:),1)]),'fontsize',8);
        set(gca,'yticklabel',flipud(get(gca,'yticklabel')));
%         set(gca,'xticklabel',[])
        ylabel('Trial #','fontsize',12);
        xlim([-1 4]);
        

