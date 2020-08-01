%% For crosscorrelogram analysis

% %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
%
% 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
% 13. Stimulus Cat(OBJty, stimulus cat)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nb_trial=[];

nb_trial.all= size(ts_evt,1);


%% Pushing or digging response
select.Pushing = find(ts_evt(:,Response)==0);
select.Digging = find(ts_evt(:,Response)==1);

select.Pushing_Corr = find(ts_evt(:,Response)==0 & ts_evt(:,Correctness)==1);
select.Digging_Corr = find(ts_evt(:,Response)==1 & ts_evt(:,Correctness)==1);

select.Pushing_Incorr = find(ts_evt(:,Response)==0 & ts_evt(:,Correctness)==0);
select.Digging_Incorr = find(ts_evt(:,Response)==1 & ts_evt(:,Correctness)==0);


%% Correctness
select.Corr = find(ts_evt(:,Correctness)==1);
select.Incorr = find(ts_evt(:,Correctness)==0);



%% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};


if     strcmp(summary(Ref_run).Task_name,'OCRS(TwoOBJ)')
    
    %% Stimulus
    Icecream = 1;
    House = 2;
    
    nb_stimulus = 2;
    
    
    %% For 2 object sessions
    
    select.Stimulus1_All = find(ts_evt(:,Stimulus)==Icecream);
    select.Stimulus2_All = find(ts_evt(:,Stimulus)==House);
    
    
    select.Stimulus1_Corr = find(ts_evt(:,Stimulus)==Icecream & ts_evt(:,Correctness)==1);
    select.Stimulus2_Corr = find(ts_evt(:,Stimulus)==House & ts_evt(:,Correctness)==1);
    
    
    select.Stimulus1_Incorr = find(ts_evt(:,Stimulus)==Icecream & ts_evt(:,Correctness)==0);
    select.Stimulus2_Incorr = find(ts_evt(:,Stimulus)==House & ts_evt(:,Correctness)==0);
    
    
    %% # of trials
    nb_trial.Stimulus1_Corr= size(select.Stimulus1_Corr,1);
    nb_trial.Stimulus2_Corr= size(select.Stimulus2_Corr,1);
    
    
    
elseif    strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)')
    
    
    
    %% Stimulus
    Icecream = 1;
    House = 2;
    Owl = 3;
    Phone = 4;
    
    nb_stimulus = 4;
    
    
    
    %% For 4 object sessions
    
%     eval(['select.Stimulus' ,stimulus_run, ' = find(ts_evt(:,' ,stimulus_run, ')==' ,stimulus_run, ')'])
    
    
%     
%     nb_stimulus = 4; 
%     
%     for stimulus_run = 1: nb_stimulus
%      eval(['select.Stimulus' ,stimulus_run, '_All = find(ts_evt(:,' ,stimulus_run, ')==' ,stimulus_run, ')']) 
%     end
    
    
    select.Stimulus1_All = find(ts_evt(:,Stimulus)==Icecream);
    select.Stimulus2_All = find(ts_evt(:,Stimulus)==House);
    select.Stimulus3_All = find(ts_evt(:,Stimulus)==Owl);
    select.Stimulus4_All = find(ts_evt(:,Stimulus)==Phone);
    
    select.Stimulus1_Corr = find(ts_evt(:,Stimulus)==Icecream & ts_evt(:,Correctness)==1);
    select.Stimulus2_Corr = find(ts_evt(:,Stimulus)==House & ts_evt(:,Correctness)==1);
    select.Stimulus3_Corr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,Correctness)==1);
    select.Stimulus4_Corr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,Correctness)==1);
    
    
    select.Stimulus1_Incorr = find(ts_evt(:,Stimulus)==Icecream & ts_evt(:,Correctness)==0);
    select.Stimulus2_Incorr = find(ts_evt(:,Stimulus)==House & ts_evt(:,Correctness)==0);
    select.Stimulus3_Incorr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,Correctness)==0);
    select.Stimulus4_Incorr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,Correctness)==0);
    
    select.Familiar = find((ts_evt(:,Stimulus)==Icecream | ts_evt(:,Stimulus)==House));
    select.Novel = find((ts_evt(:,Stimulus)==Owl | ts_evt(:,Stimulus)==Phone));
    
    select.Familiar_Corr = find((ts_evt(:,Stimulus)==Icecream | ts_evt(:,Stimulus)==House) & ts_evt(:,Correctness)==1);
    select.Novel_Corr = find((ts_evt(:,Stimulus)==Owl | ts_evt(:,Stimulus)==Phone)& ts_evt(:,Correctness)==1);
    
    select.Familiar_Incorr = find((ts_evt(:,Stimulus)==Icecream | ts_evt(:,Stimulus)==House) & ts_evt(:,Correctness)==0);
    select.Novel_Incorr = find((ts_evt(:,Stimulus)==Owl | ts_evt(:,Stimulus)==Phone)& ts_evt(:,Correctness)==0);
    
    
    select.Stimulus1_Incorr = find(ts_evt(:,Stimulus)==Icecream & ts_evt(:,Correctness)==0);
    select.Stimulus2_Incorr = find(ts_evt(:,Stimulus)==House & ts_evt(:,Correctness)==0);
    select.Stimulus3_Incorr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,Correctness)==0);
    select.Stimulus4_Incorr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,Correctness)==0);
    
    
    %% # of trials
    nb_trial.Stimulus1_Corr= size(select.Stimulus1_Corr,1);
    nb_trial.Stimulus2_Corr= size(select.Stimulus2_Corr,1);
    nb_trial.Stimulus3_Corr= size(select.Stimulus3_Corr,1);
    nb_trial.Stimulus4_Corr= size(select.Stimulus4_Corr,1);
    
    
    
elseif    strcmp(summary(Ref_run).Task_name,'OCRS(Modality)')
    
    %     Modality_session= 1;
    %     txtCategory = {'VT' ; 'Visual'; 'Tactile' };
    %     txtStimulus = {'Owl' ; 'Phone'};
    %     PushStimulus= 1;
    %     DigStimulus= 2;
    
    
    %% Stimulus
    Owl = 1;
    Phone = 2;
    %% Modality
    VT = 1;
    Visual =2;
    Tactile =3;
    
    nb_stimulus = 2;
    
    
    %% For modality sessions
    
    select.VT = find(ts_evt(:,StimulusCAT)==VT);
    select.Visual= find(ts_evt(:,StimulusCAT)==Visual);
    select.Tactile= find(ts_evt(:,StimulusCAT)==Tactile);
    
    select.VT_Corr = find(ts_evt(:,StimulusCAT)==VT & ts_evt(:,Correctness)==1);
    select.Visual_Corr= find(ts_evt(:,StimulusCAT)==Visual & ts_evt(:,Correctness)==1);
    select.Tactile_Corr= find(ts_evt(:,StimulusCAT)==Tactile & ts_evt(:,Correctness)==1);
    
    select.VT_Incorr = find(ts_evt(:,StimulusCAT)==VT & ts_evt(:,Correctness)==0);
    select.Visual_Incorr= find(ts_evt(:,StimulusCAT)==Visual & ts_evt(:,Correctness)==0);
    select.Tactile_Incorr= find(ts_evt(:,StimulusCAT)==Tactile & ts_evt(:,Correctness)==0);
    
    
    select.Stimulus1_VT_Corr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,StimulusCAT)==VT  & ts_evt(:,Correctness)==1);
    select.Stimulus1_Vis_Corr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,StimulusCAT)==Visual  & ts_evt(:,Correctness)==1);
    select.Stimulus1_Tact_Corr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,StimulusCAT)==Tactile  & ts_evt(:,Correctness)==1);
    
    select.Stimulus2_VT_Corr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,StimulusCAT)==VT  & ts_evt(:,Correctness)==1);
    select.Stimulus2_Vis_Corr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,StimulusCAT)==Visual  & ts_evt(:,Correctness)==1);
    select.Stimulus2_Tact_Corr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,StimulusCAT)==Tactile  & ts_evt(:,Correctness)==1);


    select.Stimulus1_VT_Incorr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,StimulusCAT)==VT  & ts_evt(:,Correctness)==0);
    select.Stimulus1_Vis_Incorr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,StimulusCAT)==Visual  & ts_evt(:,Correctness)==0);
    select.Stimulus1_Tact_Incorr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,StimulusCAT)==Tactile  & ts_evt(:,Correctness)==0);
    
    
    select.Stimulus2_VT_Incorr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,StimulusCAT)==VT  & ts_evt(:,Correctness)==0);
    select.Stimulus2_Vis_Incorr  = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,StimulusCAT)==Visual  & ts_evt(:,Correctness)==0);
    select.Stimulus2_Tact_Incorr  = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,StimulusCAT)==Tactile  & ts_evt(:,Correctness)==0);
    
    
    
    
elseif strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
    

    %% Stimulus
    Zebra = 1;
    Pebbles = 2; 
    Owl = 3;
    Phone = 4;
    
    nb_stimulus = 4;
    
    %% Category
    SceneCAT= 1;
    OBJCAT =2;
    
    
    select.Stimulus1_All = find(ts_evt(:,Stimulus)==Zebra);
    select.Stimulus2_All = find(ts_evt(:,Stimulus)==Pebbles);
    select.Stimulus3_All = find(ts_evt(:,Stimulus)==Owl);
    select.Stimulus4_All = find(ts_evt(:,Stimulus)==Phone);
    
    
    select.Stimulus1_Corr = find(ts_evt(:,Stimulus)==Zebra & ts_evt(:,Correctness)==1);
    select.Stimulus2_Corr = find(ts_evt(:,Stimulus)==Pebbles & ts_evt(:,Correctness)==1);
    select.Stimulus3_Corr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,Correctness)==1);
    select.Stimulus4_Corr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,Correctness)==1);
    
    
    select.Stimulus1_Incorr = find(ts_evt(:,Stimulus)==Zebra & ts_evt(:,Correctness)==0);
    select.Stimulus2_Incorr = find(ts_evt(:,Stimulus)==Pebbles & ts_evt(:,Correctness)==0);
    select.Stimulus3_Incorr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,Correctness)==0);
    select.Stimulus4_Incorr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,Correctness)==0);
    
    
    select.Scene = find(ts_evt(:,StimulusCAT)==SceneCAT);
    select.OBJ= find(ts_evt(:,StimulusCAT)==OBJCAT);
    
    
    select.Scene_Corr = find(ts_evt(:,StimulusCAT)==SceneCAT & ts_evt(:,Correctness)==1);
    select.OBJ_Corr= find(ts_evt(:,StimulusCAT)==OBJCAT & ts_evt(:,Correctness)==1);

    
    select.Scene_Incorr = find(ts_evt(:,StimulusCAT)==SceneCAT & ts_evt(:,Correctness)==0);
    select.OBJ_Incorr= find(ts_evt(:,StimulusCAT)==OBJCAT & ts_evt(:,Correctness)==0);
      
    
    
end



