function nb_voided_trials(session_folder)


%% Written by AJR (2014/06/05)
%% The program requires a batch program (Batch_Create_response_latency.m)

saveROOT='I:\PRh-OCSD\Analysis\nb_voided_trials'; if ~exist(saveROOT); mkdir(saveROOT); end
cd(saveROOT);
filename=['nb_voided_trials_' date '.txt'];
if ~exist(filename)
    fid= fopen(filename,'w');
% fprintf(fid,'%s \t%s \t%s \t%d \t%d', rat, taskname, session, nb_trial, nb_incorr_trial, nb_empty_foodtray, post_choice_latency, post_choice_incorr_latency);
    fprintf(fid,'rat \ttask \tsession \tnb_trial \tnb_incorr_trial \tnb_empty_foodtray \tpost_choice_latency \tpost_choice_incorr_latency \n');
    fclose('all');
else
end
underscore= findstr(session_folder,'_');
finddash= findstr(session_folder,'-');
taskname= session_folder(underscore+1:end);
if ~((strcmp(taskname,'retrieval')) || (strcmp(taskname,'ambiguity')));
    return
else
end

rat= session_folder(finddash(2)-4:finddash(2)-1);
session= session_folder(finddash(2)+1:underscore-1);


% %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
%
% 1. trial# 2. object 3. correctness 4.side 5. obj_touch 6. disc_touch 7. sensor1_1, 8. sensor2_1, 9. sensor3_1, 10. sensor4_1, 11. sensor1_end
%
% 12. sensor2_end, 13. sensor3_end, 14. sensor4_end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disp(['processing...' session_folder]);

cd([session_folder '\Behavior']);
load('ParsedEvents.mat');



%% Eliminate voided trials

ts_incorr= ts_evt(ts_evt(:,3)==0,:); nb_incorr_trial= size(ts_incorr,1);
post_choice_incorr_latency = nanmedian(ts_incorr(:,7)-ts_incorr(:,6));
nb_empty_foodtray= sum(isnan(ts_incorr(:,7)));


nb_trial= size(ts_evt,1);

post_choice_latency= nanmedian(ts_evt(:,7)-ts_evt(:,6));

ts_incorr= ts_evt(ts_evt(:,3)==0,:); nb_incorr_trial= size(ts_incorr,1);



cd(saveROOT);

% fprintf(fid,'rat \ttask \tsession \tnb_trial \tnb_incorr_trial \tnb_empty_foodtray \tpost_choice_latency \tpost_choice_incorr_latency \n');
fid=fopen(filename,'a');
fprintf(fid,'%s \t%s \t%s \t%d \t%d \t%d \t%1.4f \t%1.4f', rat, taskname, session, nb_trial, nb_incorr_trial, nb_empty_foodtray, post_choice_latency, post_choice_incorr_latency);
fprintf(fid,'\n');
fclose('all');


end


