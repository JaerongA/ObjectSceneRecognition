%% By Jaerong 2016/03/22
%% Save root per session


session_saveROOT=[saveROOT '\' summary(i_s).Task_name '\' summary(i_s).Region];
if ~exist(session_saveROOT), mkdir(session_saveROOT), end
cd(session_saveROOT)


%% Save figures
filename=[prefix  '.png'];
saveImage(fig,filename,fig_pos);

filename_ai=[prefix '.eps'];
print( gcf, '-painters', '-r300', filename_ai, '-depsc');


%% Save output files



%% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};

cd(saveROOT);

if strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
    
    
    
    fod.TwoOBJ=fopen(outputfile.TwoOBJ,'a');
    fprintf(fod.TwoOBJ,'%s ,%s ,%s ,%s ,%s ,%s ,%s', Key, RatID, Task_session, Task, Region, Bregma, ClusterID);
    fprintf(fod.TwoOBJ,',%d ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f', nb_trial.all, mean_fr.all, nanmean(trial_perf), nanmean(trial_perf(select.Stimulus1_all,:)), nanmean(trial_perf(select.Stimulus2_all,:)), nanmean(trial_latency), nanmean(trial_latency(select.Stimulus1_all,:)), nanmean(trial_latency(select.Stimulus2_all,:)));
    fprintf(fod.TwoOBJ, '\n');
    fclose('all');
    
    
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    
    
    fod.FourOBJ=fopen(outputfile.FourOBJ,'a');
    fprintf(fod.FourOBJ,'%s ,%s ,%s ,%s ,%s ,%s ,%s', Key, RatID, Task_session, Task, Region, Bregma, ClusterID);
    fprintf(fod.FourOBJ,',%d ,%1.2f,%1.2f,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f', nb_trial.all, mean_fr.all, nanmean(trial_perf), nanmean(trial_perf(select.Familiar,:)), nanmean(trial_perf(select.Novel,:)), nanmean(trial_latency), nanmean(trial_latency(select.Familiar,:)), nanmean(trial_latency(select.Novel,:)));
    fprintf(fod.FourOBJ,' ,%1.2f ,%1.2f', Selectivity_index.Familiar, Selectivity_index.Novel);
    fprintf(fod.FourOBJ,' ,%1.2f ,%1.2f', Selectivity_latency.Familiar, Selectivity_latency.Novel);
    fprintf(fod.FourOBJ, '\n');
    fclose('all');
    
    
    
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(Modality)')
    
    
    
    fod.Modality=fopen(outputfile.Modality,'a');
    fprintf(fod.Modality,'%s,%s ,%s ,%s ,%s ,%s ,%s', Key, RatID, Task_session, Task, Region, Bregma, ClusterID);
    fprintf(fod.Modality,',%d ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f',...
        nb_trial.all, nanmean(trial_perf), nanmean(trial_perf(select.VT,:)), nanmean(trial_perf(select.Visual,:)), nanmean(trial_perf(select.Tactile,:)), nanmean(trial_latency), nanmean(trial_latency(select.VT,:)),nanmean(trial_latency(select.Visual,:)), nanmean(trial_latency(select.Tactile,:)));
    fprintf(fod.Modality, '\n');
    fclose('all');
    
    
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    
    
    fod.SceneOBJ=fopen(outputfile.SceneOBJ,'a');
    fprintf(fod.SceneOBJ,'%s ,%s ,%s ,%s ,%s ,%s ,%s', Key, RatID, Task_session, Task, Region, Bregma, ClusterID);
    fprintf(fod.SceneOBJ,',%d ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f', nb_trial.all, mean_fr.all, nanmean(trial_perf), nanmean(trial_perf(select.Scene,:)), nanmean(trial_perf(select.OBJ,:)), nanmean(trial_latency), nanmean(trial_latency(select.Scene,:)), nanmean(trial_latency(select.OBJ,:)));
    fprintf(fod.FourOBJ,',%1.2f ,%1.2f', Selectivity_latency.Scene, Selectivity_latency.OBJ);
    fprintf(fod.SceneOBJ,',%1.2f ,%1.2f', Selectivity_index.Scene, Selectivity_index.OBJ);
    fprintf(fod.SceneOBJ, '\n');
    fclose('all');
    
end

clear trial*


