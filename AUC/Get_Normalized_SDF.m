function SDF =  Get_Normalized_SDF(ts_evt, ts_spk, nb_win)
%% By Jaerong
%% ts_evt
ChoiceLatency= 5; StimulusOnset=6; Choice=7;

nb_trial=size(ts_evt,1);
nb_spk=size(ts_spk,1);
y_histo=zeros(nb_trial,nb_win);
bin_size =[];

for trial_run=1:nb_trial
    
    i_spk=1;
    
    trial_latency = ts_evt(trial_run, ChoiceLatency);
    bin_size = trial_latency/ nb_win;
    
    
    %% Define the event period
    PETHstart= ts_evt(trial_run, StimulusOnset);    % bin start
    PETHend= ts_evt(trial_run, Choice);    % bin end
    
    
    i_spk = find((ts_spk > PETHstart),1);
    if ~isempty(i_spk)
        
        while (ts_spk(i_spk)< PETHend) && (i_spk < nb_spk)
            Spk_start=ts_spk(i_spk)-PETHstart;
            i_histo=floor(Spk_start/bin_size)+1;
            y_histo(trial_run,i_histo)=y_histo(trial_run,i_histo)+1;
            i_spk=i_spk+1;
        end
    else
        continue
    end
    
    y_histo(trial_run,:) = y_histo(trial_run,:)./ bin_size;
    
end



% SDF = mean(y_histo);
SDF = y_histo;


end

