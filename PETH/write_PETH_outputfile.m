%% By Jaerong 2016/03/22
%% Save root per session


session_saveROOT=[saveROOT '\' summary(i_s).Task_name];
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
    
    % outputfile.TwoOBJ= ['PETH_Analysis_Results_(TwoOBJ)' date '.csv'];
    % fod.TwoOBJ=fopen(outputfile.TwoOBJ,'w');
    %
    % txt_header = 'Key#, RatID, Session, Task, Region, ClusterID, nTrials,Performance_all,Performance_OBJ1,Performance_OBJ2 Latency, Latency_OBJ1, Latency_OBJ2,';
    % fprintf(fod.TwoOBJ, txt_header);
    % txt_header = 'anova_OBJ, anova_OBJ, anova_OBJ, RMI';
    % fprintf(fod.TwoOBJ, txt_header);
    % txt_header = 'CP\n'; % classifiCATion performance
    % fprintf(fod.TwoOBJ, txt_header);
    % fclose(fod.TwoOBJ);
    
    
    
    fod.TwoOBJ=fopen(outputfile.TwoOBJ,'a');
    fprintf(fod.TwoOBJ,'%s ,%s ,%s ,%s ,%s ,%s ,%s', Key, RatID, Session, Task, Region, Bregma, ClusterID);
    fprintf(fod.TwoOBJ,',%d ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f', nb_trial.all, nanmean(trial_perf), nanmean(trial_perf(select.Stimulus1_all,:)), nanmean(trial_perf(select.Stimulus2_all,:)), nanmean(trial_latency), nanmean(trial_latency(select.Stimulus1_all,:)), nanmean(trial_latency(select.Stimulus2_all,:)));
    fprintf(fod.TwoOBJ,',%d ,%d ,%d ,%1.2f', anova_sig(1), anova_sig(2), anova_sig(3), RMI);
    fprintf(fod.TwoOBJ,',%1.2f', CP);
    fprintf(fod.TwoOBJ, '\n');
    fclose('all');
    
    
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    
    
    % outputfile= ['PETH_Analysis_Results(' summary(i_s).Task_name date ')_txt'];
    % fod=fopen(outputfile,'w');
    %
    % txt_header = 'Key#, RatID, Session, Task, Region, ClusterID, nTrials,Performance_all,Performance_fam,Performance_novel Latency, Latency_fam, Latency_novel,';
    % fprintf(fod, txt_header);
    % txt_header = 'ttest_fam, ttest_novel, rs_fam, rs_novel, RMI_fam, RMI_novel, ttestOBJ, rsOBJ, RMI_OBJ';
    % fprintf(fod, txt_header);
    % txt_header = 'CP_fam, CP_novel,CP_OBJ\n'; % classifiCATion performance
    % fclose(fod);
    
    
    fod.FourOBJ=fopen(outputfile.FourOBJ,'a');
    fprintf(fod.FourOBJ,'%s ,%s ,%s ,%s ,%s ,%s ,%s', Key, RatID, Session, Task, Region, Bregma, ClusterID);
    fprintf(fod.FourOBJ,',%d ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f', nb_trial.all, nanmean(trial_perf), nanmean(trial_perf(select.Familiar,:)), nanmean(trial_perf(select.Novel,:)), nanmean(trial_latency), nanmean(trial_latency(select.Familiar,:)), nanmean(trial_latency(select.Novel,:)));
    fprintf(fod.FourOBJ,',%d ,%d ,%d ,%d ,%1.2f ,%1.2f ,%d ,%d ,%1.2f', ttest_sig.Familiar, ttest_sig.Novel, rs_sig.Familiar, rs_sig.Novel,...
        RMI.Familiar, RMI.Novel, ttest_sig.CAT, rs_sig.CAT, RMI.CAT);
    fprintf(fod.FourOBJ,' ,%d ,%d ,%d', anova_sig.Resp, anova_sig.CAT, anova_sig.Int);
    fprintf(fod.FourOBJ,' ,%1.2f ,%1.2f ,%1.2f', CP.Familiar, CP.Novel, CP.CAT);
    fprintf(fod.FourOBJ,' ,%1.2f ,%1.2f', AUC_overbaseline.Familiar, AUC_overbaseline.Novel);
    fprintf(fod.FourOBJ, '\n');
    fclose('all');
    
    
    
    
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(Modality)')
    
    
    
    
    %
    % outputfile= ['PETH_Analysis_Results_(Modality)' date '.csv'];
    % fod=fopen(outputfile,'w');
    %
    % txt_header = 'Key#, RatID, Session, Task, Region, ClusterID, nTrials,Performance_all,Performance_VT,Performance_Vis,Performance_Tact, Latency_all, Latency_VT, Latency_Vis, Latency_Tact,';
    % fprintf(fod, txt_header);
    % txt_header = 'ttest_VT, ttest_Vis, ttest_Tact, rs_VT, rs_Vis, rs_Tact, RMI_VT,RMI_Vis,RMI_Tact, anova_MOD,';
    % fprintf(fod, txt_header);
    % txt_header = 'CP_VT, CP_Vis,CP_Tact \n';
    % fprintf(fod, txt_header);
    % fclose(fod);
    %
    
    
    fod.Modality=fopen(outputfile.Modality,'a');
    fprintf(fod.Modality,'%s,%s ,%s ,%s ,%s ,%s ,%s', Key, RatID, Session, Task, Region, Bregma, ClusterID);
    fprintf(fod.Modality,',%d ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f',...
        nb_trial.all, nanmean(trial_perf), nanmean(trial_perf(select.VT,:)), nanmean(trial_perf(select.Visual,:)), nanmean(trial_perf(select.Tactile,:)), nanmean(trial_latency), nanmean(trial_latency(select.VT,:)),nanmean(trial_latency(select.Visual,:)), nanmean(trial_latency(select.Tactile,:)));
    fprintf(fod.Modality,',%d ,%d ,%d, %d ,%d ,%d ,%1.2f ,%1.2f ,%1.2f ,%d', ttest_sig.VT, ttest_sig.Visual, ttest_sig.Tactile, rs_sig.VT, rs_sig.Visual, rs_sig.Tactile,...
        RMI.VT, RMI.Visual, RMI.Tactile, anova_sig);
    fprintf(fod.Modality,' ,%1.2f ,%1.2f ,%1.2f', CP.VT, CP.Visual, CP.Tactile);
    fprintf(fod.Modality, '\n');
    fclose('all');
    
    
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    
    
    %
    %
    % %% SceneOBJ
    %
    %
    % outputfile= ['PETH_Analysis_Results_(SceneOBJ)' date '.txt'];
    % fod=fopen(outputfile,'w');
    %
    % txt_header = 'Key#, RatID, Session, Task, Region, ClusterID, nTrials,Performance_all,Performance_OBJ,Performance_Scene Latency, Latency_OBJ, Latency_Scene,';
    % fprintf(fod, txt_header);
    % txt_header = 'ttest_OBJ, ttest_Scene, rs_OBJ, rs_Scene, RMI_OBJ, RMI_Scene, ttestCAT, rsCAT, RMI_CAT';
    % fprintf(fod, txt_header);
    % txt_header = 'CP_OBJ, CP_Scene,CP_CAT\n';
    % fclose(fod);
    
    
    
    fod.SceneOBJ=fopen(outputfile.SceneOBJ,'a');
    fprintf(fod.SceneOBJ,'%s ,%s ,%s ,%s ,%s ,%s ,%s', Key, RatID, Session, Task, Region, Bregma, ClusterID);
    fprintf(fod.SceneOBJ,',%d ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f ,%1.2f', nb_trial.all, nanmean(trial_perf), nanmean(trial_perf(select.Scene,:)), nanmean(trial_perf(select.OBJ,:)), nanmean(trial_latency), nanmean(trial_latency(select.Scene,:)), nanmean(trial_latency(select.OBJ,:)));
    fprintf(fod.SceneOBJ,',%d ,%d ,%d ,%d ,%1.2f ,%1.2f ,%d ,%d ,%1.2f', ttest_sig.Scene, ttest_sig.OBJ, rs_sig.Scene, rs_sig.OBJ,...
        RMI.Scene, RMI.OBJ, ttest_sig.CAT, rs_sig.CAT, RMI.CAT);
    fprintf(fod.SceneOBJ,' ,%d ,%d ,%d', anova_sig.Resp, anova_sig.CAT, anova_sig.Int);
    fprintf(fod.SceneOBJ,' ,%1.2f ,%1.2f ,%1.2f', CP.Scene, CP.OBJ, CP.CAT);
    fprintf(fod.SceneOBJ,' ,%1.2f ,%1.2f', AUC_overbaseline.Scene, AUC_overbaseline.OBJ);
    fprintf(fod.SceneOBJ, '\n');
    fclose('all');
    
end

clear trial*

