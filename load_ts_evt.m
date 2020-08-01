
%% Made by Jaerong 2015/09/24
%% Loading trial ts info from ParsedEvents.mat

% %% Column Header
% 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void


% ts_evt(1,:)=Trial_nb; ts_evt(2,:)=Trial_Stimulus; ts_evt(3,:)=Trial_Correctness; ts_evt(4,:)=Trial_Response;
% ts_evt(5,:)=Trial_ChoiceLatency; ts_evt(6,:)=Trial_StimulusOnset; ts_evt(7,:)=Trial_Choice;
% ts_evt(8,:)=Trial_S3_1; ts_evt(9,:)=Trial_S4_1; ts_evt(10,:)=Trial_S3_end; ts_evt(11,:)=Trial_S4_end; ts_evt(12,:)=Trial_Void;
% ts_evt= ts_evt';

Trial= 1; Stimulus=2; Correctness=3; Response=4;

global ChoiceLatency
global StimulusOnset
global Choice

ChoiceLatency= 5; StimulusOnset=6; Choice=7;

Trial_S3_1=8; Trial_S4_1=9; Trial_S3_end=10; Trial_S4_end=11; Trial_Void=12;

StimulusCAT=13;  %% novelty, modality, category

folder = [Session_folder '\Behavior'];
if ~exist(folder)
    return ;
else
    
    cd([Session_folder '\Behavior']);
    load('ParsedEvents.mat');
    clear folder
    
end



%% Add stimulus category information

if strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
% if strcmp(summary_eeg(i_s).Task_name,'OCRS(FourOBJ)') || strcmp(summary_eeg(i_s).Task_name,'OCRS(SceneOBJ)')
    ts_evt= add_category_info(ts_evt,Task);
end


%% Eliminated void trials

ts_evt= void_trial_elimination(ts_evt);