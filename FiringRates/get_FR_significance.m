%% By Jaerong
%% Get epoch firing rates  & significance test

fr_criteria = 0.5;  %% FR criteria

mean_fr=[];
sem_fr=[];
fr_sig= 0;

[mean_fr.all sem_fr.all trial_fr trial_latency]= get_epoch_FR(ts_spk, ts_evt);


if mean_fr.all >= fr_criteria   %% set at 0.5Hz for now
    fr_sig= 1;
else
end

%% Skip the cell if the FR is below the criteria
% 
% if ~fr_sig
%     disp('skipped');
%     continue;
% end
