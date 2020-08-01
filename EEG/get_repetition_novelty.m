function [CorrR, Corr_Pval, Pval_sig, Slope, Polarity] = get_repetition_novelty(target_Power, select_trials)


        bgcol=[1 0.6 0.6; 0.6 1 0.6];

        global alpha
        global xpos
        global ypos
        
        
        target_Power= target_Power(select_trials);
        
        
        %% Outlier Removal
        
        criteria = mean(target_Power) + std(target_Power)*2;
        to_be_voided= (target_Power > criteria);
        target_Power(to_be_voided) = [];
        
        
        
        
        
        
        norm_Power = mapminmax(target_Power, 0, 10)';
        

        trial_nb= [1:length(target_Power)];
        
        
        [r p]=corrcoef(trial_nb,norm_Power);
        
        CorrR=r(1,2);
        Corr_Pval= p(1,2);  clear r p
        
        
        Pval_sig =  Corr_Pval < alpha;
        
        if Pval_sig
            scatter(trial_nb, norm_Power,'k','filled'); hold on;
        else
            scatter(trial_nb, norm_Power,'k'); hold on;
        end
        
        
        pfit= polyfit(trial_nb,norm_Power',1);
        
        
        Slope=pfit(1);
        trial_nb = 0: (ceil(max(trial_nb)/5)* 5);
        yfit= pfit(1)*trial_nb + pfit(2);
        
        
        if Pval_sig
            plot(trial_nb,yfit,'r','linewidth',2);
        else
            plot(trial_nb,yfit,'k');
        end
        
        
        
        set(gca, 'ylim',[0 10]);
        set(gca, 'xlim',[0 ceil(max(trial_nb)/5)* 5]);
        xlabel(['Trial #'],'fontsize',13,'fontweight','bold');
        ylabel(['Norm. Power'],'fontsize',11,'fontweight','bold');
        
        
        
        msg= sprintf('CorrR = %1.2f',CorrR);
        text(xpos,ypos,msg,'units','normalized')
        msg= sprintf('Pval = %1.2f', Corr_Pval);
        text(xpos,ypos-.2,msg,'units','normalized','backgroundcolor',bgcol(Pval_sig+1,:));
        msg= sprintf('Slope = %1.2f', Slope);
        text(xpos,ypos-.4,msg,'units','normalized')
        
        
        
        %% Polarity for original
        
        if CorrR< 0
            Polarity= 'negative';
        else
            Polarity= 'positive';
        end
        
end