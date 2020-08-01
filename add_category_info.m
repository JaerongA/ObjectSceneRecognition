function ts_evt= add_category_info(ts_evt, Task)

%% Novelty, and stimulus category information missing in four object and scene sessions.
%% This function adds stimululs category information to the 13th column of the ts_evt.mat file.
%% By Jaerong 2016/03/22 


% %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
%
% 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
% 13. StimulusCat
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


nb_trial= size(ts_evt,1);
Stimulus= 2;
StimulusCat = 13;


if strcmp(Task,'OCRS(FourOBJ)')
    
    %% Stimulus
    Icecream = 1;
    House = 2;
    Owl = 3;
    Phone = 4;
    %% Category
    Familiar= 1;
    Novel =2;
    
    for trial_run=1: nb_trial
        
        if (ts_evt(trial_run,Stimulus)  == Icecream) |  (ts_evt(trial_run,Stimulus)  == House)
            ts_evt(trial_run,StimulusCat) = Familiar;
        else
            ts_evt(trial_run,StimulusCat) = Novel;
        end
    end
    
    
    
elseif strcmp(Task,'OCRS(SceneOBJ)')
    
    
    %% Stimulus
    Zebra = 1;
    Pebbles = 2;
    Owl = 3;
    Phone = 4;
    
    %% Category
    SceneCAT= 1;
    OBJCAT =2;
    
    
    for trial_run=1: nb_trial
        
        if (ts_evt(trial_run,Stimulus)  == Zebra) |  (ts_evt(trial_run,Stimulus)  == Pebbles)
            ts_evt(trial_run,StimulusCat) = SceneCAT;
        else
            ts_evt(trial_run,StimulusCat) = OBJCAT;
        end
    end
    
    
    
    
    
end



