function  [summary,summary_header]=  Get_zero_trial_proportion(summary, summary_header, dataROOT)

%% Created by Jaerong 2017/06/29
%% This filter prints out the proportion of trials which a given neuron fired no spikes

[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if       strcmp(summary(i_s).Rat,'r558') 
        
        
    %% Set cluster prefix
    
    set_cluster_prefix;
    
    
    
    %% Loading clusters
    
    load_clusters;
    
    
    
    %% Loading trial ts info from ParsedEvents.mat
    
    
    % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
    %
    % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
    % 13. StimulusCat
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    load_ts_evt;
    
    
    %% Eliminated void trials (trials with high latency (over 2 SD) and void signals)
    
    ts_evt= void_trial_elimination(ts_evt);
    
    [mean_fr sem_fr trial_fr trial_latency]= get_epoch_FR(ts_spk, ts_evt);
    
    trial_nb = length(trial_fr);
    zero_fr_trials= length(find(trial_fr == 0));
    zero_fr_proportion = zero_fr_trials/trial_nb;
    
    
    summary(i_s).Zero_FR_Proportion= sprintf('%1.3f',zero_fr_proportion);
    
    disp(sprintf('Zero_FR_Proportion = %1.3f %%', (zero_fr_proportion*100)));
    
    
    
    end  %     strcmp(summary(i_s).Rat,'r558') 
    
    
end

end




