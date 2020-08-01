%% By AJR 2016/11/06
%% Creates a population vector based on the time-normalized firing rates during the
%% event period (from stimulus onset to choice)
%% For population vector analysis

function [summary,summary_header]= Get_pop_vector(summary, summary_header, dataROOT)



%% Output folder

saveROOT= [dataROOT '\Analysis\Population_vector'];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% Parms

nb_win = 30;




[r_s,c_s]=size(summary);



for i_s=  1:c_s
    
    %     if  (strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')) && ~strcmp(summary(i_s).Bregma,'?') && ~strcmp(summary(i_s).Region,'x') && ~strcmp(summary(i_s).Region,'AC')
    %     if  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)') &&  strcmp(summary(i_s).Region,'PER')
    if  str2num(summary(i_s).Epoch_FR) >= 0.5  &&  ~strcmp(summary(i_s).Task_name,'OCRS(Modality)')
        
        
        
        %% Set cluster prefix
        
        set_cluster_prefix;
        
        
        %% Loading clusters
        
        load_clusters;
        
        
        
        %% Loading trial ts info from ParsedEvents.mat
        
        
        % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        % 13. StimulusCat
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load_ts_evt;
        
        
        %% Add stimulus category information
        
        if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            ts_evt= add_category_info(ts_evt,Task);
        end
        
        
        %% Eliminated void trials
        
        ts_evt= void_trial_elimination(ts_evt);
        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        
        %% Get the FR vector for normalized firing rates
        
        if     strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
            
            SDF.Stimulus1_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Corr,:), ts_spk, nb_win);
            SDF.Stimulus2_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Corr,:), ts_spk, nb_win);
            
            
        elseif    strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
            
            
            SDF.Stimulus1_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Corr,:), ts_spk, nb_win);
            SDF.Stimulus2_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Corr,:), ts_spk, nb_win);
            SDF.Stimulus3_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus3_Corr,:), ts_spk, nb_win);
            SDF.Stimulus4_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus4_Corr,:), ts_spk, nb_win);
            
            
        elseif    strcmp(summary(i_s).Task_name,'OCRS(Modality)')
            
            
            SDF.Stimulus1_VT_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus1_VT_Corr,:), ts_spk, nb_win);
            SDF.Stimulus1_Vis_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Vis_Corr,:), ts_spk, nb_win);
            SDF.Stimulus1_Tact_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Tact_Corr,:), ts_spk, nb_win);
            
            SDF.Stimulus2_VT_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus2_VT_Corr,:), ts_spk, nb_win);
            SDF.Stimulus2_Vis_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Vis_Corr,:), ts_spk, nb_win);
            SDF.Stimulus2_Tact_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Tact_Corr,:), ts_spk, nb_win);
            
            
        elseif strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
            
            
            SDF.Stimulus1_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus1_Corr,:), ts_spk, nb_win);
            SDF.Stimulus2_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus2_Corr,:), ts_spk, nb_win);
            SDF.Stimulus3_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus3_Corr,:), ts_spk, nb_win);
            SDF.Stimulus4_Corr = Get_Normalized_SDF(ts_evt(select.Stimulus4_Corr,:), ts_spk, nb_win);
            
        end
        
        
        %% Store the nomalized FR vectors into a .mat file
        
        
        session_saveROOT=[saveROOT '\' summary(i_s).Task_name];
        if ~exist(session_saveROOT), mkdir(session_saveROOT), end
        cd(session_saveROOT)
        
        
        save([prefix '.mat'],'SDF');
        cd(dataROOT);
        
        clear ts*  SDF  select*
        
    end
    
    
end


end