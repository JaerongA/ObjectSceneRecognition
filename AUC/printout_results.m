
subplot(r_plot,c_plot,11);
axis off


msg= sprintf('# of Trials= %d', nb_trial.all);
text(0,2.8,msg,'fontsize',txt_size);

msg= sprintf('# zero spike Trials = %d', sum(~logical(trial_fr)));
text(0,2.4,msg,'fontsize',txt_size);


msg= sprintf('FR epoch= %1.2f (Hz)', mean_fr.all);
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


subplot(r_plot,c_plot,19);
axis off


if  strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    
%     msg= sprintf('AUC - baseline (Familiar) = %1.3f',AUC_overbaseline.Familiar);
%     text(-.5,0.0,msg,'fontsize',txt_size);
%     
%     msg= sprintf('AUC - baseline (Novel) = %1.3f',AUC_overbaseline.Novel);
%     text(-.5,-0.4,msg,'fontsize',txt_size);
%     

    msg= sprintf('Selectivity Ind (Familiar) = %1.2f',Selectivity_index.Familiar);
    text(-.5,0,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity Ind (Novel) = %1.2f',Selectivity_index.Novel);
    text(-.5,-0.4,msg,'fontsize',txt_size);
    
    
    
    msg= sprintf('Selectivity Latency (Familiar) = %1.2f',Selectivity_onset.Familiar);
    text(-.5,0.8,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity Latency (Novel) = %1.2f',Selectivity_onset.Novel);
    text(-.5,0.4,msg,'fontsize',txt_size);
    

    
elseif strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    
    %             msg= sprintf('AUC - baseline (Scene) = %1.3f',AUC_overbaseline.Scene);
    %             text(0,0.0,msg,'fontsize',txt_size);
    %
    %             msg= sprintf('AUC - baseline (OBJ) = %1.3f',AUC_overbaseline.OBJ);
    %             text(0,-0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity Ind (OBJ) = %1.2f',Selectivity_index.OBJ);
    text(-.5,-1.2,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity Ind (Scene) = %1.2f',Selectivity_index.Scene);
    text(-.5,-0.8,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity Duration (OBJ) = %1.2f',Selectivity_duration.OBJ);
    text(-.5,-0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity Duration (Scene) = %1.2f',Selectivity_duration.Scene);
    text(-.5,0,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity PeakLoc (OBJ) = %1.2f',Selectivity_peakloc.OBJ);
    text(-.5,0.4,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity PeakLoc (Scene) = %1.2f',Selectivity_peakloc.Scene);
    text(-.5,0.8,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity Onset (OBJ) = %1.2f',Selectivity_onset.OBJ);
    text(-.5,1.2,msg,'fontsize',txt_size);
    
    msg= sprintf('Selectivity Onset (Scene) = %1.2f',Selectivity_onset.Scene);
    text(-.5,1.6,msg,'fontsize',txt_size);
    
    
    
    
end



%     fprintf(fod.SceneOBJ,',%1.2f ,%1.2f', Selectivity_onset.Scene, Selectivity_onset.OBJ);
%     fprintf(fod.SceneOBJ,',%d ,%d', Selectivity_peakloc.Scene, Selectivity_peakloc.OBJ);
%     fprintf(fod.SceneOBJ,',%d ,%d', Selectivity_duration.Scene, Selectivity_duration.OBJ);
%     fprintf(fod.SceneOBJ,',%1.2f ,%1.2f', Selectivity_index.Scene, Selectivity_index.OBJ);



clear ts*
