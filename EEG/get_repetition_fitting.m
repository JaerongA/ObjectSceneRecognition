%% By Jaerong 2017/09/07


%% Correct trials only
eval(['trial_nb= [1:length(select.Stimulus' num2str(Stimulus_run) '_Corr)];']);
eval(['norm_Power{Stimulus_run}= target_Power(select.Stimulus' num2str(Stimulus_run) '_Corr);']);



%% All trials
%             eval(['trial_nb= [1:length(norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All))];']);
%             eval(['norm_Power_All= norm_all_trial_fr(select.Stimulus' num2str(Stimulus_run) '_All);']);


%             trial_nb = 1:length(cell2mat(norm_Power_All(Stimulus_run))');

[r p]=corrcoef(trial_nb,cell2mat(norm_Power(Stimulus_run)));

CorrR(Stimulus_run)=r(1,2);
Corr_Pval(Stimulus_run)= p(1,2);  clear r p


Pval_sig(Stimulus_run) =  Corr_Pval(Stimulus_run) < alpha;

if Pval_sig(Stimulus_run)
    scatter(trial_nb, cell2mat(norm_Power(Stimulus_run)),'k','filled'); hold on;
else
    scatter(trial_nb, cell2mat(norm_Power(Stimulus_run)),'k'); hold on;
end


% pfit= polyfit(trial_nb,cell2mat(norm_Power(Stimulus_run)),1);
pfit= polyfit(trial_nb,cell2mat(norm_Power(Stimulus_run))',1);


Slope(Stimulus_run)=pfit(1);
trial_nb = 0: (ceil(max(trial_nb)/5)* 5);
yfit= pfit(1)*trial_nb + pfit(2);


if Pval_sig(Stimulus_run)
    plot(trial_nb,yfit,'r','linewidth',2);
else
    plot(trial_nb,yfit,'k');
end



set(gca, 'ylim',[0 10]);
set(gca, 'xlim',[0 ceil(max(trial_nb)/5)* 5]);
%             xlabel(['Trial #'],'fontsize',13,'fontweight','bold');
ylabel(['Norm. Power'],'fontsize',11,'fontweight','bold');


title(Stimulus_str{Stimulus_run},'fontsize',13);

msg= sprintf('CorrR = %1.2f',CorrR(Stimulus_run));
text(xpos,ypos,msg,'units','normalized')
msg= sprintf('Pval = %1.2f', Corr_Pval(Stimulus_run));
text(xpos,ypos-.2,msg,'units','normalized','backgroundcolor',bgcol(Pval_sig(Stimulus_run)+1,:));
msg= sprintf('Slope = %1.2f', Slope(Stimulus_run));
text(xpos,ypos-.4,msg,'units','normalized')
msg= sprintf('Perf = %1.2f', Perf(Stimulus_run));
text(xpos,ypos-.6,msg,'units','normalized')






%% Polarity for original

if CorrR(Stimulus_run)< 0
    Polarity{Stimulus_run}= 'negative';
else
    Polarity{Stimulus_run}= 'positive';
end


