    
        %% Event
        
        
        % ChoiceLatency= 5; StimulusOnset=6; Choice=7;
        
        SDF.Stimulus1_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Corr,:), ts_spk, nb_win);
        SDF.Stimulus2_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Corr,:), ts_spk, nb_win);
        SDF.Stimulus3_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus3_Corr,:), ts_spk, nb_win);
        SDF.Stimulus4_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus4_Corr,:), ts_spk, nb_win);
        
        
        SDF.Stimulus1_Corr = conv(mean(SDF.Stimulus1_Corr), gaussFilter,'same');
        SDF.Stimulus2_Corr = conv(mean(SDF.Stimulus2_Corr), gaussFilter,'same');
        SDF.Stimulus3_Corr = conv(mean(SDF.Stimulus3_Corr), gaussFilter,'same');
        SDF.Stimulus4_Corr = conv(mean(SDF.Stimulus4_Corr), gaussFilter,'same');
        
        
        plot(SDF.Stimulus1_Corr,'color',Stimulus_color(1,:),'LineStyle','-','LineWidth',3); hold on;
        plot(SDF.Stimulus2_Corr,'color',Stimulus_color(2,:),'LineStyle','-','LineWidth',3); hold on;
        plot(SDF.Stimulus3_Corr,'color',Stimulus_color(3,:),'LineStyle','-','LineWidth',3); hold on;
        plot(SDF.Stimulus4_Corr,'color',Stimulus_color(4,:),'LineStyle','-','LineWidth',3);
        
        
        
        if     strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
            
            hleg = legend('Icecream','House','location','northeastoutside' );
            
        elseif     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            hleg = legend('Icecream','House','Owl' , 'Phone','location','northeastoutside' );
            
        elseif     strcmp(summary(i_s).Task_name,'OCRS(Modality)')
            
            hleg = legend('VT','Vis','Tact','location','northeastoutside' );
            
        elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            hleg = legend('Zebra','Pebble','Owl' , 'Phone','location','northeastoutside' );
        end
        
        
        
        set(hleg, 'pos',[0.42 0.48 0.005 0.03]);
        %         set(hleg,'box','off');
        hLegendPatch = findobj(hleg, 'type', 'patch');
        set(hLegendPatch, 'XData', [.2, .2, .2, .2])
        
        box off;
        axis tight
        ylim([0 ceil(max(structfun(@(x)max(x(:)),SDF)))]);
        % set(gca,'xtick',[]);
        ylabel('FR (Hz)','fontsize',12);
%         xlabel('Normalized time','fontsize',12);
        set(gca, 'YTick',[0 ceil(max(structfun(@(x)max(x(:)),SDF)))], 'YTickLabel',sprintfc('%i',[0 ceil(max(structfun(@(x)max(x(:)),SDF)))]),'fontsize',8);
        set(gca, 'XTick',[1 nb_win], 'XTickLabel',{'StimulusOnset' ;'Choice'},'fontsize',8);
        
        clear SDF