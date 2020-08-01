        %% Get the ROC curve per condition
        
        
        
        SDF.Stimulus1_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Corr,:), ts_spk, nb_win);
        SDF.Stimulus2_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Corr,:), ts_spk, nb_win);
        SDF.Stimulus3_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus3_Corr,:), ts_spk, nb_win);
        SDF.Stimulus4_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus4_Corr,:), ts_spk, nb_win);
        
        
        
        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
        
        AUC.Familiar =  Get_AUC(SDF.Stimulus1_Corr, SDF.Stimulus2_Corr, nb_win);
        AUC.Novel =  Get_AUC(SDF.Stimulus3_Corr, SDF.Stimulus4_Corr, nb_win);
        
        AUC.Familiar_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus1_Corr, SDF.Stimulus2_Corr, nb_win, bootstrap_nb);
        AUC.Novel_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus3_Corr, SDF.Stimulus4_Corr, nb_win, bootstrap_nb);
        
        
        elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
        
        
        AUC.Scene =  Get_AUC(SDF.Stimulus1_Corr, SDF.Stimulus2_Corr, nb_win);
        AUC.OBJ =  Get_AUC(SDF.Stimulus3_Corr, SDF.Stimulus4_Corr, nb_win);
        
        AUC.Scene_bootstrapped=  Get_AUC_bootstrapped(SDF.Stimulus1_Corr, SDF.Stimulus2_Corr, nb_win, bootstrap_nb);
        AUC.OBJ_bootstrapped =  Get_AUC_bootstrapped(SDF.Stimulus3_Corr, SDF.Stimulus4_Corr, nb_win, bootstrap_nb);
        
        end
       

        
        if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            
        plot(AUC.Familiar,'LineStyle','-','LineWidth',3); hold on;
        plot(AUC.Novel,'LineStyle','-','LineWidth',3); axis tight; box off; 
        
            
        plot(AUC.Familiar_baseline,'LineStyle',':','LineWidth',2,'color',[0    0.4470    0.7410]); hold on;
        plot(AUC.Novel_baseline,'LineStyle',':','LineWidth',2, 'color',[0.8500    0.3250    0.0980]); 
        
        
        elseif     strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            
        plot(AUC.Scene,'LineStyle','-','LineWidth',3); hold on;
        plot(AUC.OBJ,'LineStyle','-','LineWidth',3); axis tight; box off; 
            
        
        
        plot(AUC.Scene_bootstrapped,'LineStyle',':','LineWidth',2,'color',[0    0.4470    0.7410]); hold on;
        plot(AUC.OBJ_bootstrapped,'LineStyle',':','LineWidth',2, 'color',[0.8500    0.3250    0.0980]); 
        

        
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
        
        
        %% Print out the legend

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
        
                        
        set(hleg, 'pos',[0.39 0.28 0.005 0.03]);

        delete SDF
        