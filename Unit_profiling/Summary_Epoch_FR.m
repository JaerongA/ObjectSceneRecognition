function  [summary,summary_header]=  Summary_Epoch_FR(summary, summary_header, dataROOT)

%% Created by Jaerong 2016/11/04
%% This filter prints out the mean firing rate of the event period (stimulus onset to choice)

% fr_criteria = 0.5;  %% FR criteria

[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if  strcmp(summary(i_s).Rat,'r558') 
    
    %% Set cluster prefix
    
    set_cluster_prefix;
    
    
    %% Loading trial ts info from ParsedEvents.mat
    
    load_ts_evt;
    
    
    %% Loading clusters
    
    load_clusters;
    
    
    %% Get epoch firing rates  & significance test
    
    
    mean_fr=[];
    
    mean_fr= get_epoch_FR(ts_spk, ts_evt);
    
    
    summary(i_s).Epoch_FR= sprintf('%1.3f',mean_fr);
    
    disp(sprintf('Epoch FR = %s Hz', summary(i_s).Epoch_FR))
    
    
    end  % ~strcmp(summary(i_s).Region,'x') && ~strcmp(summary(i_s).Bregma,'?')
    
end

end




