


trial_stimulus= ts_evt(:,Stimulus);

training_data = [];
training_group = [];



%% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};


if     strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
    
    
    
    
    %% CP
    
    
    Class_mat = [];
    Class_mat= [trial_fr trial_stimulus];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP = correct_classification/size(Class_mat,1);
    
    
    
    
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    
    %% CP Familiar OBJect
    
    
    Class_mat = [];
    Class_mat= [trial_fr(select.Familiar_Corr,:) trial_stimulus(select.Familiar_Corr,:)];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP.Familiar = correct_classification/size(Class_mat,1);
    
    
    
    
    %% CP Novel OBJect
    
    
    
    Class_mat = [];
    Class_mat= [trial_fr(select.Novel_Corr,:) trial_stimulus(select.Novel_Corr,:)];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP.Novel = correct_classification/size(Class_mat,1);
    
    
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(Modality)')
    
    
    %% CP VT
    
    
    Class_mat = [];
    Class_mat= [trial_fr(select.VT_Corr,:) trial_stimulus(select.VT_Corr,:)];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP.VT = correct_classification/size(Class_mat,1);
    
    
    
    
    %% CP Visual
    
    
    
    Class_mat = [];
    Class_mat= [trial_fr(select.Visual_Corr,:) trial_stimulus(select.Visual_Corr,:)];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP.Visual = correct_classification/size(Class_mat,1);
        
    
    
    
    %% CP Tactile
    
    
    
    Class_mat = [];
    Class_mat= [trial_fr(select.Tactile_Corr,:) trial_stimulus(select.Tactile_Corr,:)];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP.Tactile = correct_classification/size(Class_mat,1);
    
    
    
    
    
elseif strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    
    
    %% CP Scene
    
    
    Class_mat = [];
    Class_mat= [trial_fr(select.Scene_Corr,:) trial_stimulus(select.Scene_Corr,:)];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP.Scene = correct_classification/size(Class_mat,1);
    
    
    
    
    %% CP OBJect
    
    
    
    Class_mat = [];
    Class_mat= [trial_fr(select.OBJ_Corr,:) trial_stimulus(select.OBJ_Corr,:)];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP.OBJ = correct_classification/size(Class_mat,1);
    
    
end







if     ~strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
    
    
    
    
    %%  Linear classification (leave one out method)
    
    
    training_data = [];
    training_group = [];
    
    
    
    %% CP Category
    
    Class_mat = [];
    Class_mat= [trial_fr(select.Pushing_Corr,:) trial_stimulus(select.Pushing_Corr,:)];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP.Pushing = correct_classification/size(Class_mat,1);
    
    
    
    
    Class_mat = [];
    Class_mat= [trial_fr(select.Digging_Corr,:) trial_stimulus(select.Digging_Corr,:)];
    
    correct_classification=0;
    
    for trial_run=1: size(Class_mat,1)
        training_data= Class_mat(~ismember(1:size(Class_mat,1),trial_run),1);
        training_group= Class_mat(~ismember(1:size(Class_mat,1),trial_run),2);
        test_FR= Class_mat(trial_run,1);
        
        %             disp(sprintf('trial FR = %1.2f', test_FR));
        test_answer= Class_mat(trial_run,2);
        classified_result=classify(test_FR, training_data,training_group);
        
        if classified_result == test_answer
            correct_classification=correct_classification+1;
            %                 disp(sprintf('trial %d = %s',trial_run, 'correct'));
        else
            %                 disp(sprintf('trial %d = %s',trial_run, 'wrong'));
        end
        
    end
    
    CP.Digging = correct_classification/size(Class_mat,1);
    
    CP.CAT = max(CP.Pushing, CP.Digging);
    
    
    clear trial_stimulus  
end