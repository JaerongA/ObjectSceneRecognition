%% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};

%% TwoOBJ  
    
    
outputfile.TwoOBJ= ['PETH_Analysis_Results_(TwoOBJ)_' date '.csv'];
% if ~exist(outputfile.TwoOBJ)
fod.TwoOBJ=fopen(outputfile.TwoOBJ,'w');

txt_header = 'Key#, RatID, Session, Task, Region, Bregma, ClusterID, nTrials,Performance_all,Performance_OBJ1,Performance_OBJ2, Latency, Latency_OBJ1, Latency_OBJ2,';
fprintf(fod.TwoOBJ, txt_header);
txt_header = 'anova_OBJ, anova_RESP, anova_INT, RMI,';
fprintf(fod.TwoOBJ, txt_header);
txt_header = 'CP\n'; % classification performance
fprintf(fod.TwoOBJ, txt_header);
fclose(fod.TwoOBJ);
% end


%% FourOBJ  
    
    
outputfile.FourOBJ= ['PETH_Analysis_Results_(FourOBJ)_' date '.csv'];
% if ~exist(outputfile.FourOBJ)
fod.FourOBJ=fopen(outputfile.FourOBJ,'w');

txt_header = 'Key#, RatID, Session, Task, Region, Bregma, ClusterID, nTrials,Performance_all,Performance_fam,Performance_novel, Latency, Latency_fam, Latency_novel,';
fprintf(fod.FourOBJ, txt_header);
txt_header = 'ttest_fam, ttest_novel, rs_fam, rs_novel, RMI_fam, RMI_novel, ttest_CAT, rs_CAT, RMI_CAT,';
fprintf(fod.FourOBJ, txt_header);
txt_header = 'anova_RESP, anova_CAT, anova_INT,';
fprintf(fod.FourOBJ, txt_header);
txt_header = 'CP_fam, CP_novel,CP_CAT,';
fprintf(fod.FourOBJ, txt_header);
txt_header = 'AUC_fam, AUC_novel\n';
fprintf(fod.FourOBJ, txt_header);
fclose(fod.FourOBJ);
% end


%% Modality  
    
    
outputfile.Modality= ['PETH_Analysis_Results_(Modality)_' date '.csv'];
% if ~exist(outputfile.Modality)
fod.Modality=fopen(outputfile.Modality,'w');

txt_header = 'Key#, RatID, Session, Task, Region, Bregma, ClusterID, nTrials,Performance_all,Performance_VT,Performance_Vis,Performance_Tact, Latency_all, Latency_VT, Latency_Vis, Latency_Tact,';
fprintf(fod.Modality, txt_header);
txt_header = 'ttest_VT, ttest_Vis, ttest_Tact, rs_VT, rs_Vis, rs_Tact, RMI_VT,RMI_Vis,RMI_Tact, anova_MOD,';
fprintf(fod.Modality, txt_header);
txt_header = 'CP_VT, CP_Vis,CP_Tact,';
fprintf(fod.Modality, txt_header);
txt_header = 'AUC_VT, AUC_Vis, AUC_Tact\n';
fprintf(fod.Modality, txt_header);
fclose(fod.Modality);
% end

%% SceneOBJ
    
    
outputfile.SceneOBJ= ['PETH_Analysis_Results_(SceneOBJ)_' date '.csv'];
% if ~exist(outputfile.SceneOBJ)
fod.SceneOBJ=fopen(outputfile.SceneOBJ,'w');

txt_header = 'Key#, RatID, Session, Task, Region, Bregma, ClusterID, nTrials,Performance_all,Performance_OBJ,Performance_Scene, Latency, Latency_OBJ, Latency_Scene,';
fprintf(fod.SceneOBJ, txt_header);
txt_header = 'ttest_Scene, ttest_OBJ, rs_Scene, rs_OBJ, RMI_Scene, RMI_OBJ, ttestCAT, rsCAT, RMI_CAT,';
fprintf(fod.SceneOBJ, txt_header);
txt_header = 'anova_RESP, anova_CAT, anova_INT,';
fprintf(fod.SceneOBJ, txt_header);
txt_header = 'CP_Scene, CP_OBJ, CP_CAT,';
fprintf(fod.SceneOBJ, txt_header);
txt_header = 'AUC_Scene, AUC_OBJ\n';
fprintf(fod.SceneOBJ, txt_header);
fclose(fod.SceneOBJ);
% end

