        %% Get the ROC curve per condition
        
        
        
        SDF.Stimulus1_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Corr,:), ts_spk, nb_win);
        SDF.Stimulus2_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Corr,:), ts_spk, nb_win);
        SDF.Stimulus3_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus3_Corr,:), ts_spk, nb_win);
        SDF.Stimulus4_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus4_Corr,:), ts_spk, nb_win);
        
        
        
        
        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
        
        AUC.Familiar =  Get_AUC(SDF.Stimulus1_Corr, SDF.Stimulus2_Corr, nb_win);
        AUC.Novel =  Get_AUC(SDF.Stimulus3_Corr, SDF.Stimulus4_Corr, nb_win);
        
        
        AUC.Familiar_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus1_Corr, SDF.Stimulus2_Corr, nb_win);
        AUC.Novel_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus3_Corr, SDF.Stimulus4_Corr, nb_win);
        
        
        elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
        
        
        AUC.Scene =  Get_AUC(SDF.Stimulus1_Corr, SDF.Stimulus2_Corr, nb_win);
        AUC.OBJ =  Get_AUC(SDF.Stimulus3_Corr, SDF.Stimulus4_Corr, nb_win);
        
        
        AUC.Scene_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus1_Corr, SDF.Stimulus2_Corr, nb_win);
        AUC.OBJ_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus3_Corr, SDF.Stimulus4_Corr, nb_win);
        
        end
       

        
        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            
        plot(AUC.Familiar,'LineStyle','-','LineWidth',3); hold on;
        plot(AUC.Novel,'LineStyle','-','LineWidth',3); axis tight; box off; 
        
            
        plot(AUC.Familiar_bootstrapped,'LineStyle',':','LineWidth',3,'color',[0    0.4470    0.7410]); hold on;
        plot(AUC.Novel_bootstrapped,'LineStyle',':','LineWidth',3, 'color',[0.8500    0.3250    0.0980]); 
        
        
        elseif     strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            
            
        plot(AUC.Scene,'LineStyle','-','LineWidth',3); hold on;
        plot(AUC.OBJ,'LineStyle','-','LineWidth',3); axis tight; box off; 
        
            
        plot(AUC.Scene_bootstrapped,'LineStyle',':','LineWidth',3,'color',[0    0.4470    0.7410]); hold on;
        plot(AUC.OBJ_bootstrapped,'LineStyle',':','LineWidth',3, 'color',[0.8500    0.3250    0.0980]); 

        
        end
        
        
%         SDF.Pushing_Corr = Get_Normalized_SDF(ts_evt(select.Pushing_Corr,:), ts_spk, nb_win);
%         SDF.Digging_Corr = Get_Normalized_SDF(ts_evt(select.Digging_Corr,:), ts_spk, nb_win);

%         AUC.Resp =  Get_AUC(SDF.Pushing_Corr, SDF.Digging_Corr, nb_win);

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
            
%         end
        
        


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
        
                        
        set(hleg, 'pos',[0.42 0.33 0.005 0.03]);

        
        
        
        
        %% Plot baseline subtracted ROC curve area
        
        
        subplot('position',[0.17 0.1 0.20 0.13]);
        
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
        
        set(hleg, 'pos',[0.42 0.13 0.005 0.03]);
        
        
        %% Integrate over baseline subtracted ROC area
        
        
        
        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
%         AUC_overbaseline.Familiar= sum(AUC.Familiar - AUC.Familiar_bootstrapped);        
%         AUC_overbaseline.Novel= sum(AUC.Novel - AUC.Novel_bootstrapped);        
        
        %% Sum the positive values only (revised 2016/10/19)
        AUC_overbaseline.Familiar= AUC.Familiar - AUC.Familiar_bootstrapped;
        AUC_overbaseline.Novel= AUC.Novel - AUC.Novel_bootstrapped;
        
        AUC_overbaseline.Scene= sum(AUC_overbaseline.Scene(find(AUC_overbaseline.Scene> 0)));
        AUC_overbaseline.OBJ= sum(AUC_overbaseline.OBJ(find(AUC_overbaseline.OBJ> 0)));
        
        else
%         AUC_overbaseline.Scene= sum(AUC.Scene - AUC.Scene_bootstrapped);        
%         AUC_overbaseline.OBJ= sum(AUC.OBJ - AUC.OBJ_bootstrapped);  
        
        %% Sum the positive values only (revised 2016/10/19)
        AUC_overbaseline.Scene= AUC.Scene - AUC.Scene_bootstrapped;
        AUC_overbaseline.OBJ= AUC.OBJ - AUC.OBJ_bootstrapped;
        
        
        cd(saveROOT);
        save([prefix '.mat'],'AUC_overbaseline');
        cd(dataROOT);
       
        
        
        AUC_overbaseline.Scene= sum(AUC_overbaseline.Scene(find(AUC_overbaseline.Scene> 0)));
        AUC_overbaseline.OBJ= sum(AUC_overbaseline.OBJ(find(AUC_overbaseline.OBJ> 0)));
        
        end
        
        
        
        
        
        
        clear SDF  AUC
        