        %% Plot baseline subtracted ROC curve area
        
        
        
        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
        
        plot(AUC.Familiar - AUC.Familiar_bootstrapped,'LineStyle','-','LineWidth',3,'color',[0 0.4470 0.7410]); hold on;
        plot(AUC.Novel - AUC.Novel_bootstrapped,'LineStyle','-','LineWidth',3,'color',[0.8500 0.3250 0.0980]);  axis tight; box off; 
        
        elseif   strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
        
        plot(AUC.Scene - AUC.Scene_bootstrapped,'LineStyle','-','LineWidth',3,'color',[0 0.4470 0.7410]); hold on;
        plot(AUC.OBJ - AUC.OBJ_bootstrapped,'LineStyle','-','LineWidth',3,'color',[0.8500 0.3250 0.0980]);  axis tight; box off; 
            
        end
        
        
        ylabel('ROC area - baseline','fontsize',10);
        xlabel('Normalized time','fontsize',12);
        set(gca, 'XTick',[1 nb_win], 'XTickLabel',{'StimulusOnset' ;'Choice'},'fontsize',8);
         Yaxis= get(gca,'Ylim');
        ylim([(floor(min(Yaxis)*10)/10)-.1, round(max(Yaxis)*10)/10+0.1])
        set(gca, 'YTick',[(floor(min(Yaxis)*10)/10)-.1, round(max(Yaxis)*10)/10+0.1])
        set(gca, 'YTickLabel',sprintfc('%1.2f',[(floor(min(Yaxis)*10)/10)-.1, round(max(Yaxis)*10)/10+0.1]),'fontsize',8);
        h= hline(0,'k:'); set(h,'linewidth',2)
        
        


        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            hleg = legend('Familiar','Novel','location','northeastoutside' );
%             hleg = legend('Familiar','Novel','Resp','location','northeastoutside' );
            
        elseif     strcmp(summary(i_s).Task_name,'OCRS(Modality)')
            
            hleg = legend('VT','Vis','Tact','location','northeastoutside' );
%             hleg = legend('VT','Vis','Tact','Resp','location','northeastoutside' );
            
        elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            hleg = legend('Scene','OBJ','location','northeastoutside' );
%             hleg = legend('Scene','OBJ','Resp','location','northeastoutside' );
        end
        
        
        set(hleg, 'pos',[0.39 0.15 0.005 0.03]);
        
        
        
        
        
        
        
        