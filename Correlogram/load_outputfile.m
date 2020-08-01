%% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};

%% TwoOBJ  
    
    
outputfile.TwoOBJ= ['AUC_Analysis_Results_(TwoOBJ)_' date '.csv'];
% if ~exist(outputfile.TwoOBJ)
fod.TwoOBJ=fopen(outputfile.TwoOBJ,'w');

txt_header = 'Key#, RatID, Session, Task, Region, Bregma, ClusterID, nTrials,Epoch_FR, Performance_all,Performance_OBJ1,Performance_OBJ2, Latency, Latency_OBJ1, Latency_OBJ2,';
fprintf(fod.TwoOBJ, txt_header);
txt_header = 'AUC\n'; % classification performance
fprintf(fod.TwoOBJ, txt_header);
fclose(fod.TwoOBJ);
% end



%% FourOBJ  
    
    
outputfile.FourOBJ= ['AUC_Analysis_Results_(FourOBJ)_' date '.csv'];
% if ~exist(outputfile.FourOBJ)
fod.FourOBJ=fopen(outputfile.FourOBJ,'w');

txt_header = 'Key#, RatID, Session, Task, Region, Bregma, ClusterID, nTrials,Epoch_FR, Performance_all,Performance_fam,Performance_novel, Latency, Latency_fam, Latency_novel,';
fprintf(fod.FourOBJ, txt_header);
% txt_header = 'AUC_fam, AUC_novel,';
% fprintf(fod.FourOBJ, txt_header);
txt_header = 'Selectivit_lat_fam, Selectivit_lat_novel\n';
fprintf(fod.FourOBJ, txt_header);
fclose(fod.FourOBJ);
% end


%% Modality  
    
    
outputfile.Modality= ['AUC_Analysis_Results_(Modality)_' date '.csv'];
% if ~exist(outputfile.Modality)
fod.Modality=fopen(outputfile.Modality,'w');

txt_header = 'Key#, RatID, Session, Task, Region, Bregma, ClusterID, nTrials,Epoch_FR, Performance_all,Performance_VT,Performance_Vis,Performance_Tact, Latency_all, Latency_VT, Latency_Vis, Latency_Tact,';
fprintf(fod.Modality, txt_header);
txt_header = 'AUC_VT, AUC_Vis, AUC_Tact,';
fprintf(fod.Modality, txt_header);
txt_header = 'Selectivit_lat_VT, Selectivit_lat_Vis, Selectivit_lat_Tact\n';
fprintf(fod.Modality, txt_header);
fclose(fod.Modality);
% end



%% SceneOBJ
    
    
outputfile.SceneOBJ= ['AUC_Analysis_Results_(SceneOBJ)_' date '.csv'];
% if ~exist(outputfile.SceneOBJ)
fod.SceneOBJ=fopen(outputfile.SceneOBJ,'w');

txt_header = 'Key#, RatID, Session, Task, Region, Bregma, ClusterID, nTrials,Epoch_FR, Performance_all,Performance_OBJ,Performance_Scene, Latency, Latency_OBJ, Latency_Scene,';
fprintf(fod.SceneOBJ, txt_header);
% txt_header = 'AUC_Scene, AUC_OBJ';
% fprintf(fod.SceneOBJ, txt_header);
txt_header = 'Selectivit_lat_Scene, Selectivit_lat_OBJ,';
fprintf(fod.SceneOBJ, txt_header);
txt_header = 'Selectivit_ind_Scene, Selectivit_ind_OBJ\n';
fprintf(fod.SceneOBJ, txt_header);
fclose(fod.SceneOBJ);
% end

