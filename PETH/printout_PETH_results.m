
subplot(r_plot,c_plot,16);
axis off


msg= sprintf('# zero spike Trials = %d', sum(~logical(trial_fr)));
text(0,2.8,msg,'fontsize',txt_size);


msg= sprintf('FR epoch= %1.2f (Hz)', mean_fr.all);
text(0,2.4,msg,'fontsize',txt_size);

msg= sprintf('# of Trials= %d', nb_trial.all);
text(0,2.0,msg,'fontsize',txt_size);

msg= sprintf('Perf = %1.2f ', nanmean(trial_perf) * 100);
text(0,1.6,msg,'fontsize',txt_size);



if  strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
    
    
    msg= sprintf('Perf OBJ1 = %1.2f ', nanmean(trial_perf(select.Stimulus1_all,:)) * 100);
    text(0,1.2,msg,'fontsize',txt_size);
    
    msg= sprintf('Perf OBJ2 = %1.2f ', nanmean(trial_perf(select.Stimulus2_all,:)) * 100);
    text(0,0.8,msg,'fontsize',txt_size);
    
    
    msg= sprintf('Lat = %1.2f (s)', nanmean(ts_evt(:,ChoiceLatency)));
    text(0,0.4,msg,'fontsize',txt_size);
    
    
    msg= sprintf('Lat OBJ1 = %1.2f (s)', nanmean(ts_evt(select.Stimulus1_all,ChoiceLatency)));
    text(0,0,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat OBJ2 = %1.2f (s)', nanmean(ts_evt(select.Stimulus2_all,ChoiceLatency)));
    text(0,-0.6,msg,'fontsize',txt_size);
    
    
    
elseif strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    msg= sprintf('Perf Familiar = %1.2f ', nanmean(trial_perf(select.Familiar,:)) * 100);
    text(0,1.2,msg,'fontsize',txt_size);
    
    msg= sprintf('Perf Novel = %1.2f ', nanmean(trial_perf(select.Novel,:)) * 100);
    text(0,0.8,msg,'fontsize',txt_size);
    
    
    msg= sprintf('Lat = %1.2f (s)', nanmean(ts_evt(:,ChoiceLatency)));
    text(0,0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat Familiar = %1.2f (s)', nanmean(ts_evt(select.Familiar,ChoiceLatency)));
    text(0,0,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat Novel = %1.2f (s)', nanmean(ts_evt(select.Novel,ChoiceLatency)));
    text(0,-0.4,msg,'fontsize',txt_size);
    
    
    
elseif strcmp(summary(i_s).Task_name,'OCRS(Modality)')
    
    msg= sprintf('Perf VT = %1.2f ', nanmean(trial_perf(select.VT,:)) * 100);
    text(0,1.2,msg,'fontsize',txt_size);
    
    msg= sprintf('Perf Visual = %1.2f ', nanmean(trial_perf(select.Visual,:)) * 100);
    text(0,0.8,msg,'fontsize',txt_size);
    
    msg= sprintf('Perf Tactile = %1.2f ', nanmean(trial_perf(select.Tactile,:)) * 100);
    text(0,0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat = %1.2f (s)', nanmean(ts_evt(:,ChoiceLatency)));
    text(0,0,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat VT = %1.2f (s)', nanmean(ts_evt(select.VT,ChoiceLatency)));
    text(0,-0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat Visual = %1.2f (s)', nanmean(ts_evt(select.Visual,ChoiceLatency)));
    text(0,-0.8,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat Tactile = %1.2f (s)', nanmean(ts_evt(select.Tactile,ChoiceLatency)));
    text(0,-1.2,msg,'fontsize',txt_size);
    
    
    
elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    msg= sprintf('Perf Scene = %1.2f ', nanmean(trial_perf(select.Scene,:)) * 100);
    text(0,1.2,msg,'fontsize',txt_size);
    
    msg= sprintf('Perf OBJ = %1.2f ', nanmean(trial_perf(select.OBJ,:)) * 100);
    text(0,0.8,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat = %1.2f (s)', nanmean(ts_evt(:,ChoiceLatency)));
    text(0,0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat Scene = %1.2f (s)', nanmean(ts_evt(select.Scene,ChoiceLatency)));
    text(0,0,msg,'fontsize',txt_size);
    
    msg= sprintf('Lat OBJ = %1.2f (s)', nanmean(ts_evt(select.OBJ,ChoiceLatency)));
    text(0,-0.4,msg,'fontsize',txt_size);
    
    
end



%% Print out stat results

subplot(r_plot,c_plot,37);
axis off



if strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
    
    msg= sprintf('anova pval OBJ= %1.3f',anova_pval(1));
    text(0,2.4,msg,'fontsize',txt_size,'backgroundcolor',bgcol(anova_sig(1)+1,:));
    
    msg= sprintf('anova pval RESP= %1.3f',anova_pval(2));
    text(0,2,msg,'fontsize',txt_size,'backgroundcolor',bgcol(anova_sig(2)+1,:));
    
    msg= sprintf('anova pval Int= %1.3f',anova_pval(3));
    text(0,1.6,msg,'fontsize',txt_size,'backgroundcolor',bgcol(anova_sig(3)+1,:));
    
    msg= sprintf('RMI = %1.3f',RMI);
    text(0,1.2,msg,'fontsize',txt_size);
    
    msg= sprintf('CP = %1.3f',CP);
    text(0,0.8,msg,'fontsize',txt_size);
    
    
elseif strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    msg= sprintf('ttest pval Familiar= %1.3f',ttest_pval.Familiar);
    text(0,2.4,msg,'fontsize',txt_size,'backgroundcolor',bgcol(ttest_sig.Familiar+1,:));
    
    msg= sprintf('ttest pval Novel= %1.3f',ttest_pval.Novel);
    text(0,2,msg,'fontsize',txt_size,'backgroundcolor',bgcol(ttest_sig.Novel+1,:));
    
    msg= sprintf('rs pval Familiar= %1.3f',rs_pval.Familiar);
    text(0,1.6,msg,'fontsize',txt_size,'backgroundcolor',bgcol(rs_sig.Familiar+1,:));
    
    msg= sprintf('rs pval Novel= %1.3f',rs_pval.Novel);
    text(0,1.2,msg,'fontsize',txt_size,'backgroundcolor',bgcol(rs_sig.Novel+1,:));
    
    msg= sprintf('RMI Familiar= %1.3f',RMI.Familiar);
    text(0,0.8,msg,'fontsize',txt_size);
    
    msg= sprintf('RMI Novel= %1.3f',RMI.Novel);
    text(0,0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('CP Familiar= %1.3f',CP.Familiar);
    text(0,0,msg,'fontsize',txt_size);
    
    msg= sprintf('CP Novel= %1.3f',CP.Novel);
    text(0,-0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('CP CAT= %1.3f',CP.CAT);
    text(0,-0.8,msg,'fontsize',txt_size);
    
    
elseif strcmp(summary(i_s).Task_name,'OCRS(Modality)')
    
    msg= sprintf('ttest pval VT= %1.3f',ttest_pval.VT);
    text(0,2.4,msg,'fontsize',txt_size,'backgroundcolor',bgcol(ttest_sig.VT+1,:));
    
    msg= sprintf('ttest pval Visual= %1.3f',ttest_pval.Visual);
    text(0,2,msg,'fontsize',txt_size,'backgroundcolor',bgcol(ttest_sig.Visual+1,:));
    
    msg= sprintf('ttest pval Tactile= %1.3f',ttest_pval.Tactile);
    text(0,1.6,msg,'fontsize',txt_size,'backgroundcolor',bgcol(ttest_sig.Tactile+1,:));
    
    msg= sprintf('rs pval VT= %1.3f',rs_pval.VT);
    text(0,1.2,msg,'fontsize',txt_size,'backgroundcolor',bgcol(rs_sig.VT+1,:));
    
    msg= sprintf('rs pval Visual= %1.3f',rs_pval.Visual);
    text(0,0.8,msg,'fontsize',txt_size,'backgroundcolor',bgcol(rs_sig.Visual+1,:));
    
    msg= sprintf('rs pval Tactile= %1.3f',rs_pval.Tactile);
    text(0,0.4,msg,'fontsize',txt_size,'backgroundcolor',bgcol(rs_sig.Tactile+1,:));
    
    msg= sprintf('anova pval modality= %1.3f',anova_pval);
    text(0,0,msg,'fontsize',txt_size,'backgroundcolor',bgcol(anova_sig+1,:));
    
    msg= sprintf('RMI VT= %1.3f',RMI.VT);
    text(0,-0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('RMI Visual= %1.3f',RMI.Visual);
    text(0,-0.8,msg,'fontsize',txt_size);
    
    msg= sprintf('RMI Tactile= %1.3f',RMI.Tactile);
    text(0,-1.2,msg,'fontsize',txt_size);
    
    msg= sprintf('CP VT= %1.3f',CP.VT);
    text(0,-1.6,msg,'fontsize',txt_size);
    
    msg= sprintf('CP Visual= %1.3f',CP.Visual);
    text(0,-2,msg,'fontsize',txt_size);
    
    msg= sprintf('CP Tactile= %1.3f',CP.Tactile);
    text(0,-2.4,msg,'fontsize',txt_size);
    
    
elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    
    msg= sprintf('ttest pval Scene= %1.3f',ttest_pval.Scene);
    text(0,2.4,msg,'fontsize',txt_size,'backgroundcolor',bgcol(ttest_sig.Scene+1,:));
    
    msg= sprintf('ttest pval OBJ= %1.3f',ttest_pval.OBJ);
    text(0,2,msg,'fontsize',txt_size,'backgroundcolor',bgcol(ttest_sig.OBJ+1,:));
    
    msg= sprintf('rs pval Scene= %1.3f',rs_pval.Scene);
    text(0,1.6,msg,'fontsize',txt_size,'backgroundcolor',bgcol(rs_sig.Scene+1,:));
    
    msg= sprintf('rs pval OBJ= %1.3f',rs_pval.OBJ);
    text(0,1.2,msg,'fontsize',txt_size,'backgroundcolor',bgcol(rs_sig.OBJ+1,:));
    
    msg= sprintf('RMI Scene= %1.3f',RMI.Scene);
    text(0,0.8,msg,'fontsize',txt_size);
    
    msg= sprintf('RMI OBJ= %1.3f',RMI.OBJ);
    text(0,0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('CP Scene= %1.3f',CP.Scene);
    text(0,0,msg,'fontsize',txt_size);
    
    msg= sprintf('CP OBJ= %1.3f',CP.OBJ);
    text(0,-0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('CP CAT= %1.3f',CP.CAT);
    text(0,-0.8,msg,'fontsize',txt_size);
    
    
end


%% Print out stat results

if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    subplot(r_plot,c_plot,32);
    axis off
    
    
    msg= sprintf('anova pval RESP= %1.3f',anova_pval(1));
    text(0,0.8,msg,'fontsize',txt_size,'backgroundcolor',bgcol(anova_sig.Resp+1,:));
    
    msg= sprintf('anova pval CAT= %1.3f',anova_pval(2));
    text(0,0.4,msg,'fontsize',txt_size,'backgroundcolor',bgcol(anova_sig.CAT+1,:));
    
    msg= sprintf('anova pval Int= %1.3f',anova_pval(3));
    text(0,0,msg,'fontsize',txt_size,'backgroundcolor',bgcol(anova_sig.Int+1,:));
    
    
    msg= sprintf('ttest pval CAT= %1.3f',ttest_pval.CAT);
    text(0,-0.9,msg,'fontsize',txt_size,'backgroundcolor',bgcol(ttest_sig.CAT+1,:));
    
    msg= sprintf('rs pval CAT= %1.3f',rs_pval.CAT);
    text(0,-1.2,msg,'fontsize',txt_size,'backgroundcolor',bgcol(rs_sig.CAT+1,:));
    
    msg= sprintf('RMI CAT= %1.3f',RMI.CAT);
    text(0,-1.6,msg,'fontsize',txt_size);
    
end




%% Print out stat results

subplot(r_plot,c_plot,53);
axis off


if  strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')

    
    msg= sprintf('AUC - baseline (Familiar) = %1.3f',AUC_overbaseline.Familiar);
    text(0,0.0,msg,'fontsize',txt_size);
    
    msg= sprintf('AUC - baseline (Novel) = %1.3f',AUC_overbaseline.Novel);
    text(0,-0.4,msg,'fontsize',txt_size);
    
    
elseif strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')

    
    msg= sprintf('AUC - baseline (Scene) = %1.3f',AUC_overbaseline.Scene);
    text(0,0.0,msg,'fontsize',txt_size);
    
    msg= sprintf('AUC - baseline (OBJ) = %1.3f',AUC_overbaseline.OBJ);
    text(0,-0.4,msg,'fontsize',txt_size);
    
end

clear ts*


