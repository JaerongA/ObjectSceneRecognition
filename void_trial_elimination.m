%% By Jaerong
% %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
%
% 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
% 13. Modality
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [ts_evt_out nb_voided_trial]= void_trial_elimination(ts_evt)


nb_trial= size(ts_evt,1);


StimulusOnset= 6;
Choice= 7;
Trial_Void=12;


%% Mean latency 
% 
% mean_latency= nanmean(ts_evt(:,Choice)-ts_evt(:,StimulusOnset)); std_latency= nanstd(ts_evt(:,Choice)-ts_evt(:,StimulusOnset));
% latency_criteria= mean_latency + (std_latency*3);
% 
% 
% %% Void the trials if one of the latencies exceeds 3 std over the session mean
% 
% trial_latency = [];
% for trial_run=1: nb_trial
%     
%     trial_latency = ts_evt(trial_run,Choice)-ts_evt(trial_run,StimulusOnset);
%     if trial_latency > latency_criteria,
%         ts_evt(trial_run,Trial_Void)=1; else end
% end


%% Remove all the void trials.

voided_mat= ts_evt(find(ts_evt(:,Trial_Void)==1),:);
ts_evt(logical(ts_evt(:,Trial_Void)),:)=[];


void_latency=nanmean(voided_mat(:,Choice)-voided_mat(:,StimulusOnset));
nb_latency_voided = size(voided_mat,1);
ts_evt_out=ts_evt;

end