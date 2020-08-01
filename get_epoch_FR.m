function [mean_fr sem_fr trial_fr trial_latency]=  get_epoch_FR(ts_spk, ts_evt)

%% Revised by Jaerong 2016/03/18

nb_epoch=1;  
nb_trial= size(ts_evt,1);
trial_latency= nan(nb_trial,nb_epoch);
nb_spk= nan(nb_trial,nb_epoch);
trial_fr= nan(nb_trial,nb_epoch);
mean_fr = nan;
sem_fr = nan;


%% Event Definition in OCRS

StimulusOnset= 6;
Choice= 7;


for trial_run= 1:nb_trial
    
    trial_ts= ts_evt(trial_run,:);
    
    %% Choice latency for each trial
    
    trial_latency(trial_run,nb_epoch)= trial_ts(Choice) -trial_ts(StimulusOnset);
    
    %% The number of spikes for each trial
    
    nb_spk(trial_run,nb_epoch)= size(find(ts_spk > trial_ts(StimulusOnset)& ts_spk < trial_ts(Choice)),1);
    
    %% Firing rates during the choice period per trial
    
    trial_fr(trial_run,nb_epoch)= nb_spk(trial_run,nb_epoch)/trial_latency(trial_run,nb_epoch);
    
end


%  trial_fr(~logical(trial_fr))= nan;


mean_fr = nanmean(trial_fr,1);
sem_fr= sem(trial_fr,1); 



end