%% By Jaerong 2016/12/17
%% Get the performance values from all conditions across the sessions

clear all; clc;
dataROOT= 'F:\PRC_POR_ephys\Ephys_data';
saveROOT= 'F:\PRC_POR_ephys\Analysis\Performance';

%% Output folder
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% Output file generation

% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
outputfile.FourOBJ=['TrialNB(FourOBJ).csv'];
fod.FourOBJ=fopen(outputfile.FourOBJ,'w');
txt_header = 'RatID, Session, Task, CorrectTrial#(ALL), CorrectTrial#(Icecream), CorrectTrial#(House), CorrectTrial#(Owl), CorrectTrial#(Phone) \n';
fprintf(fod.FourOBJ, txt_header);
fclose(fod.FourOBJ);


cd(dataROOT);


%% Parms

Trial= 1; Stimulus=2; Correctness=3; Response=4;
ChoiceLatency= 5; StimulusOnset=6; Choice=7;
Trial_S3_1=8; Trial_S4_1=9; Trial_S3_end=10; Trial_S4_end=11; Trial_Void=12;
StimulusCAT=13;  %% novelty, modality, category




%% Stimulus
Icecream = 1;
House = 2;
Owl = 3;
Phone = 4;

nb_stimulus = 4;


Stimulus_str= {'Icecream','House','Owl','Phone'};
Category_str= {'Familiar','Novel'};






%% Category
Familiar= 1;
Novel =2;




listing_rat=dir('r*');[r1,c1]=size(listing_rat);

for i1=1:r1
    target_rat = [dataROOT '\' listing_rat(i1).name];cd(target_rat)
    listing_session=dir('r*');[r2,c2]=size(listing_session);
    
    for i2=1:r2
        target_session = [target_rat '\' listing_session(i2).name];
        
        
        RatID= target_rat(end-3:end);
        
        str1= findstr(target_session,'-');
        str2= findstr(target_session,'_');
        
        Session = target_session(str1(1)+1:str1(2)-1);
        Task_session= target_session(str1(2)+1:str2(end)-1);
        
        
        %% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
        Task = target_session(findstr(target_session,'(')-4:end);
        
        
        
        if ~(strcmp(Task,'OCRS(FourOBJ)'))
            continue;
        else
            disp(['accessing...' target_session]); cd(target_session);
        end
        
        
        
        % %% Column Header for ts_evt
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        cd([target_session '\Behavior'])
        load('Parsedevents.mat');
        
        
        
        %% Add stimulus category information
        
        if strcmp(Task,'OCRS(FourOBJ)') || strcmp(Task,'OCRS(SceneOBJ)')
            ts_evt= add_category_info(ts_evt,Task);
        end
        
        
        %% Eliminated void trials
        
        ts_evt= void_trial_elimination(ts_evt);
        
        
        
        %% Select trial types
        
        
        
        select.Pushing = find(ts_evt(:,Response)==0);
        select.Digging = find(ts_evt(:,Response)==1);
        
        select.Corr = find(ts_evt(:,Correctness)==1);
        select.Stimulus1_Corr = find(ts_evt(:,Stimulus)==Icecream & ts_evt(:,Correctness)==1);
        select.Stimulus2_Corr = find(ts_evt(:,Stimulus)==House & ts_evt(:,Correctness)==1);
        select.Stimulus3_Corr = find(ts_evt(:,Stimulus)==Owl & ts_evt(:,Correctness)==1);
        select.Stimulus4_Corr = find(ts_evt(:,Stimulus)==Phone & ts_evt(:,Correctness)==1);
        
        
        
        %% # of trials
        
        nb_trial.Corr= size(select.Corr,1);
        nb_trial.Stimulus1_Corr= size(select.Stimulus1_Corr,1);
        nb_trial.Stimulus2_Corr= size(select.Stimulus2_Corr,1);
        nb_trial.Stimulus3_Corr= size(select.Stimulus3_Corr,1);
        nb_trial.Stimulus4_Corr= size(select.Stimulus4_Corr,1);
        
        
        
        %
        %         if strcmp(Task,'OCRS(FourOBJ)')
        %
        %             select.Familiar = find(ts_evt(:,StimulusCAT)==Familiar);
        %             select.Novel= find(ts_evt(:,StimulusCAT)==Novel);
        %
        %         elseif  strcmp(Task,'OCRS(SceneOBJ)')
        %
        %             select.Scene = find(ts_evt(:,StimulusCAT)==SceneCAT);
        %             select.OBJ= find(ts_evt(:,StimulusCAT)==OBJCAT);
        %
        %         end
        %
        %
        %         Performance.All = mean(ts_evt(:,Correctness));
        %         Performance.Pushing = mean(ts_evt(select.Pushing,Correctness));
        %         Performance.Digging = mean(ts_evt(select.Digging,Correctness));
        %
        %
        %         if strcmp(Task,'OCRS(FourOBJ)')
        %
        %             Performance.Familiar = mean(ts_evt(select.Familiar,Correctness));
        %             Performance.Novel = mean(ts_evt(select.Novel,Correctness));
        %
        %         elseif strcmp(Task,'OCRS(SceneOBJ)')
        %
        %             Performance.Scene = mean(ts_evt(select.Scene,Correctness));
        %             Performance.OBJ = mean(ts_evt(select.OBJ,Correctness));
        %
        %         end
        
        clear select*
        
        %% Output file generation
        
        
        
        
        % outputfile.FourOBJ=['TrialNB(FourOBJ).csv'];
        % fod.FourOBJ=fopen(outputfile.FourOBJ,'w');
        % txt_header = 'RatID, Session, Task, CorrectTrial#(ALL), CorrectTrial#(Icecream), CorrectTrial#(House), CorrectTrial#(Owl), CorrectTrial#(Phone) \n';
        % fprintf(fod.FourOBJ, txt_header);
        % fclose(fod.FourOBJ);
        
        
        
        
        
        
        cd(saveROOT);
        
            
            fod.FourOBJ=fopen(outputfile.FourOBJ,'a');
            fprintf(fod.FourOBJ,'%s ,%s ,%s, %d, %d, %d, %d, %d, \n',  RatID, Task_session, Task, nb_trial.Corr, nb_trial.Stimulus1_Corr, nb_trial.Stimulus2_Corr, nb_trial.Stimulus3_Corr, nb_trial.Stimulus4_Corr);
            fclose(fod.FourOBJ);
            
        
        
    end
end


disp('End');


