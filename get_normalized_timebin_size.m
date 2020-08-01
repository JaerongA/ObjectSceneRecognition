%% By Jaerong 2016/11/05
%% Get the time bin size for the normalized SDF

clear all; clc;
dataROOT= 'H:\PRC_POR_ephys\Ephys_data';
saveROOT= 'H:\PRC_POR_ephys\Analysis\Normalized_Timebin_Size';

%% Output folder
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% Output file generation

% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
outputfile=['Normalized_Timebin_Size(20170122).csv'];
fod=fopen(outputfile,'w');
txt_header = 'RatID, Session, Task, Latency(All), Normalized_Timebin_Size \n';
fprintf(fod, txt_header);
fclose(fod);

cd(dataROOT);

%% Parms

Trial= 1; Stimulus=2; Correctness=3; Response=4;
ChoiceLatency= 5; StimulusOnset=6; Choice=7;
Trial_S3_1=8; Trial_S4_1=9; Trial_S3_end=10; Trial_S4_end=11; Trial_Void=12;
StimulusCAT=13;  %% novelty, modality, category

nb_win = 30;   %% Number of time bins for the normalized SDF


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
        
        disp(['accessing...' target_session]); cd(target_session);
        
        
        
        % %% Column Header for ts_evt
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        cd([target_session '\Behavior'])
        load('Parsedevents.mat');
        
        
        %% Eliminated void trials
        
        ts_evt= void_trial_elimination(ts_evt);
        
        
        nb_trial=size(ts_evt,1);
        bin_size =[];
        
        
        
        for trial_run=1:nb_trial
            
            
            trial_latency = ts_evt(trial_run, ChoiceLatency);
            bin_size(trial_run) = (trial_latency/ nb_win) * 10^3;  % ms conversion
            
            
        end
        
        
        Latency.All = median(ts_evt(:,ChoiceLatency));
        Normalized_Timebin_Size = mean(bin_size);
        
        
        %% Output file generation
        
        
        cd(saveROOT);
        
        
        fod=fopen(outputfile,'a');
        fprintf(fod,'%s ,%s ,%s, %1.3f, %1.3f, \n',  RatID, Task_session, Task, Latency.All, Normalized_Timebin_Size);
        fclose(fod);
        
        
    end
end


disp('End');
