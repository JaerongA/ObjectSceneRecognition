%% By Jaerong 2016/11/14
%% Get the latency values from all conditions across the sessions

clear all; clc; 
dataROOT= 'H:\PRC_POR_ephys\Ephys_data';
saveROOT= 'H:\PRC_POR_ephys\Analysis\Performance';

%% Output folder
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% Output file generation

% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
outputfile.FourOBJ=['Latency(FourOBJ).csv'];
fod.FourOBJ=fopen(outputfile.FourOBJ,'w');
txt_header = 'RatID, Session, Task, Latency(All), Latency(Push), Latency(Dig), Latency(Familiar), Latency(Novel) \n';
fprintf(fod.FourOBJ, txt_header);
fclose(fod.FourOBJ);



outputfile.SceneOBJ=['Latency(SceneOBJ).csv'];
fod.SceneOBJ=fopen(outputfile.SceneOBJ,'w');
txt_header = 'RatID, Session, Task, Latency(All), Latency(Push), Latency(Dig), Latency(Scene), Latency(OBJ) \n';
fprintf(fod.SceneOBJ, txt_header);
fclose(fod.SceneOBJ);


cd(dataROOT);



%% Parms

Trial= 1; Stimulus=2; Correctness=3; Response=4;
ChoiceLatency= 5; StimulusOnset=6; Choice=7;
Trial_S3_1=8; Trial_S4_1=9; Trial_S3_end=10; Trial_S4_end=11; Trial_Void=12;
StimulusCAT=13;  %% novelty, modality, category


%% Category
Familiar= 1;
Novel =2;

SceneCAT= 1;
OBJCAT =2;



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
        
        
        
        if ~(strcmp(Task,'OCRS(FourOBJ)') || strcmp(Task,'OCRS(SceneOBJ)'))
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
        
        
        
        %% Pushing or digging response
        select.Pushing = find(ts_evt(:,Response)==0);
        select.Digging = find(ts_evt(:,Response)==1);
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            select.Familiar = find(ts_evt(:,StimulusCAT)==Familiar);
            select.Novel= find(ts_evt(:,StimulusCAT)==Novel);
            
        elseif  strcmp(Task,'OCRS(SceneOBJ)')
            
            select.Scene = find(ts_evt(:,StimulusCAT)==SceneCAT);
            select.OBJ= find(ts_evt(:,StimulusCAT)==OBJCAT);
            
        end
        
        
        Latency.All = median(ts_evt(:,ChoiceLatency));
        Latency.Pushing = median(ts_evt(select.Pushing,ChoiceLatency));
        Latency.Digging = median(ts_evt(select.Digging,ChoiceLatency));
        
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            Latency.Familiar = median(ts_evt(select.Familiar,ChoiceLatency));
            Latency.Novel = median(ts_evt(select.Novel,ChoiceLatency));
            
        elseif strcmp(Task,'OCRS(SceneOBJ)')
            
            Latency.Scene = median(ts_evt(select.Scene,ChoiceLatency));
            Latency.OBJ = median(ts_evt(select.OBJ,ChoiceLatency));
            
        end
        
        clear select*
        
        %% Output file generation
        
        
        % outputfile.FourOBJ=['Latency(FourOBJ).csv'];
        % fod=fopen(outputfile,'w');
        % txt_header = 'RatID, Session, Task, Latency(All), Latency(Push), Latency(Dig), Latency(Familiar), Latency(Novel) \n';
        % fprintf(fod.FourOBJ, txt_header);
        % fclose(fod.FourOBJ);
        
        
        
        
        cd(saveROOT);
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            fod.FourOBJ=fopen(outputfile.FourOBJ,'a');
            fprintf(fod.FourOBJ,'%s ,%s ,%s, %1.3f, %1.3f, %1.3f, %1.3f, %1.3f, \n',  RatID, Task_session, Task, Latency.All, Latency.Pushing, Latency.Digging, Latency.Familiar, Latency.Novel);
            fclose(fod.FourOBJ);
            
        elseif strcmp(Task,'OCRS(SceneOBJ)')
            
            fod.SceneOBJ=fopen(outputfile.SceneOBJ,'a');
            fprintf(fod.SceneOBJ,'%s ,%s ,%s, %1.3f, %1.3f, %1.3f, %1.3f, %1.3f, \n',  RatID, Task_session, Task, Latency.All, Latency.Pushing, Latency.Digging, Latency.Scene, Latency.OBJ);
            fclose(fod.SceneOBJ);
            
        end
        
        
    end
end


disp('End');


