function Create_ParsedEvents(session_folder)

%% The function stores timestamp values for every event in each sesssion.
%% Revised for PRC & POR ephys Jaerong (2015/09/23)

session_folder = 'H:\PRC_POR_ephys\Ephys_data\r558\r558-03-01_OCRS(FourOBJ)';


cd(session_folder);   %session folder

if exist('Behavior','dir')
    mkdir('Behavior');
end


cd([session_folder '\ExtractedEvents']);

listing_mat= dir('*Trial*.mat'); nb_trial= size(listing_mat,1);  %The # of Trials


Trial_Stimulus=[]; Trial_Response=[]; Trial_Correctness=[]; Trial_Modality=[];
Trial_S3_1=[];Trial_S4_1=[]; Trial_Choice=[]; Trial_StimulusOnset=[]; Trial_ChoiceLatency=[];
Trial_S3_end=[];Trial_S4_end=[];
Trial_Void=[];
Trial_nb=[];
ts_evt=[];


for trial_run=1:nb_trial
    
    nb_digit= numel(num2str(trial_run));
    switch nb_digit
        case 1
            filename= sprintf('Trial00%d.mat',trial_run);
        case 2
            filename= sprintf('Trial0%d.mat',trial_run);
        case 3
            filename = sprintf('Trial%d.mat',trial_run);
    end
    load (filename);
    
    
%     if isempty(Sensor3)||isempty(Sensor4)||Void
    if isempty(Sensor3)||Void
        Trial_nb(trial_run)=trial_run;
        Trial_Stimulus(trial_run)=NaN;
        Trial_Correctness(trial_run)=NaN;
        Trial_Response(trial_run)= NaN;
        Trial_ChoiceLatency(trial_run)= NaN;
        Trial_StimulusOnset(trial_run)= NaN;
        Trial_Choice(trial_run)= NaN;
        Trial_S3_1(trial_run)=NaN;
        Trial_S4_1(trial_run)=NaN;
        Trial_S3_end(trial_run)=NaN;
        Trial_S4_end(trial_run)=NaN;
        Trial_Modality(trial_run)=NaN;
        Trial_Void(trial_run)=1;
    else
        Trial_nb(trial_run)=trial_run;
        Trial_Stimulus(trial_run)=Stimulus;
        Trial_Correctness(trial_run)=Correctness;
        Trial_Response(trial_run)= Response;
        Trial_ChoiceLatency(trial_run)= ChoiceLatency;
        Trial_StimulusOnset(trial_run)= StimulusOnset;
        Trial_Choice(trial_run)= Choice;
        Trial_S3_1(trial_run)=Sensor3(1);
        Trial_S4_1(trial_run)=Sensor4(1); 
%         Trial_S4_1(trial_run)=NaN;
        Trial_S3_end(trial_run)=Sensor3(end);
        Trial_S4_end(trial_run)=Sensor4(end);
%         Trial_S4_end(trial_run)=NaN;
        Trial_Void(trial_run)=0;
        
%         if ~isempty(Modality)
%         Trial_Modality(trial_run)=Modality;
%         end
        
    end
    
end

% %% Column Header
% 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void

% if  isempty(Modality)

ts_evt(1,:)=Trial_nb; ts_evt(2,:)=Trial_Stimulus; ts_evt(3,:)=Trial_Correctness; ts_evt(4,:)=Trial_Response;
ts_evt(5,:)=Trial_ChoiceLatency; ts_evt(6,:)=Trial_StimulusOnset; ts_evt(7,:)=Trial_Choice;
ts_evt(8,:)=Trial_S3_1; ts_evt(9,:)=Trial_S4_1; ts_evt(10,:)=Trial_S3_end; ts_evt(11,:)=Trial_S4_end; ts_evt(12,:)=Trial_Void;
    
% else
%     
% ts_evt(1,:)=Trial_nb; ts_evt(2,:)=Trial_Stimulus; ts_evt(3,:)=Trial_Correctness; ts_evt(4,:)=Trial_Response;
% ts_evt(5,:)=Trial_ChoiceLatency; ts_evt(6,:)=Trial_StimulusOnset; ts_evt(7,:)=Trial_Choice;
% ts_evt(8,:)=Trial_S3_1; ts_evt(9,:)=Trial_S4_1; ts_evt(10,:)=Trial_S3_end; ts_evt(11,:)=Trial_S4_end; ts_evt(12,:)=Trial_Void; ts_evt(13,:)=Trial_Modality; 
    

% end
   

    ts_evt= ts_evt';


disp('....Parsing of Event Data Done');
cd([session_folder '\Behavior'])
save('Parsedevents.mat','ts_evt');


end


