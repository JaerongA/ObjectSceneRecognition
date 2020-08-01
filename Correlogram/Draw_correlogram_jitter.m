%% Written by Jaerong 2017/01/09


%% Inputs :
% ts_microsec = timestamps of the cluster to be processed ( in mic  sec)
% ref_microsec = timestamps of the reference cluster  ( in mic sec)
% bin_size_sec = size of a bin (in sec)
% Xmin_sec_sec = inferior limit of the histogram (mic sec)
% Xmax_sec_sec  = superior limit of the histogram (mic sec)
% p_conf = probability of the confidence interval, use 0.005 for (99%) and 0.025 for 95%
% draw_hist = draw the crosscorrelogram and the confidence interval

%% Outputs
% crosscorrelogram :   value of each bin in cout/bin
%                               you can divided this vector by the number of reference (l_ref) events to obtain
%                               the probability of spiking
%                               you can divided this vector by ( l_ref*bin_size_sec ) to obtain Spikes/sec

% bounds : bins boundaries you can use do draw the crosscorrelogram using the function bar
% conf = [LowConf HighConf] : respectively the lower and upper Confidence Limits
% excluded : number of values excluded from ts to draw this crosscorrelogram
% the C value


% function [correlogram, X_range_sec, nb_spk, conf_int]= Draw_correlogram(RefSPK, TargetSPK, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt)



function [correlogram_org, correlogram_jitter, X_range_sec, peak_loc, trough_loc, upperLIM, lowerLIM, bias_ind] = ...
    Draw_correlogram_jitter(RefSPK, TargetSPK, bin_size_sec, Xmin_sec, Xmax_sec, bootstrap_nb, ts_evt)

global StimulusOnset
global Choice


% if isequal(ts_microsec, ref_microsec)   ==> autocorrelogram

ts_spk.ref= RefSPK./10^6;  %% Convert to seconds
ts_spk.target= TargetSPK./10^6;  %% Convert to seconds



% nb_spk.ref=length(ts_spk.ref);
% nb_spk.target=length(ts_spk.target);




if ~isempty(ts_evt)
    
    %% Event definition
    
    
    %                         %% ms conversion
    %                     Xmin_sec_sec= Xmin_sec_sec.*10^3;  %% ms conversion
    %                     Xmax_sec_sec= Xmax_sec_sec.*10^3;  %% ms conversion
    %                     bin_size_sec= bin_size_sec.*10^3;  %% ms conversion
    %     ts_spk.ref=ref_microsec;  %% Convert to seconds
    %     ts_spk=ts_microsec;
    
    
    nb_trial= size(ts_evt,1);
    
    
    %% Spike extraction from the reference cluster
    
    ts_mat.ref=cell(1,nb_trial);
    
    
    for trial_run=1: nb_trial
        
        spk_ind = find(ts_spk.ref > ts_evt(trial_run,StimulusOnset)& ts_spk.ref < ts_evt(trial_run,Choice));
        ts_mat.ref{trial_run}= ts_spk.ref(spk_ind);
    end
    
    ts_spk.ref = cell2mat(ts_mat.ref);   %% Extracted only the spikes from the epoch
    nb_spk.ref=length(ts_spk.ref);
    
    
    %
    %         for i_spk=1:length(ts_mat.ref{trial_run})
    %             lineh=  line([ts_mat.ref{trial_run}(i_spk) ts_mat.ref{trial_run}(i_spk)],[1 2]);
    %             set(lineh,'linewidth',1.5);
    %         end
    
    
    
    
    
    %% Spike extraction from the target cluster
    
    ts_mat.target=cell(1,nb_trial);
    
    for trial_run=1: nb_trial
        
        spk_ind = find(ts_spk.target > ts_evt(trial_run,StimulusOnset)& ts_spk.target < ts_evt(trial_run,Choice));
        ts_mat.target{trial_run}= ts_spk.target(spk_ind);
    end
    
    ts_spk.target = cell2mat(ts_mat.target);   %% Extracted only the spikes from the epoch
    nb_spk.target=length(ts_spk.target);
    
else
    
end  %~isempty(ts_evt)



%% Correlogram (Original)

X_range_sec = Xmin_sec: bin_size_sec: Xmax_sec;
nb_range_int = length(X_range_sec);
correlogram_org = zeros(1,nb_range_int);


excluded=0;

for ref_run=1:nb_spk.ref
    
    for target_run=1:nb_spk.target
        spk_int= ts_spk.target(target_run)-ts_spk.ref(ref_run);
        
        if (spk_int>= Xmin_sec) && (spk_int< Xmax_sec)
            for int_run=1:nb_range_int-1
                if (spk_int>=X_range_sec(int_run)) && (spk_int<X_range_sec(int_run+1))
                    correlogram_org(int_run)=correlogram_org(int_run)+1;
                end
            end
        else
            excluded=excluded+1;
        end
        
    end
    
end



correlogram_org(end)=[];







%% Correlogram (Jittered)


%% Random jitter by +- 5 ms



bootstrap_ind= 1;
bootstrap_ok =1;

correlogram_jitter = zeros(bootstrap_nb,nb_range_int);


while bootstrap_ok
    
    jitter=[];
    jitter = -5 + (5+5)*rand(nb_spk.ref,1);
    jitter = (jitter./10^3)';  %% to microseconds
    jitter_spk.ref = ts_spk.ref + jitter;
    
    
    jitter=[];
    jitter = -5 + (5+5)*rand(nb_spk.target,1);
    jitter = (jitter./10^3)';
    jitter_spk.target = ts_spk.target + jitter;
    
    
    % plot(ts_spk.ref(1:10));
    % hold on
    % plot(ts_spk.ref(1:10) + jitter(1:10),'r');
    
    
    
    
    
    excluded=0;
    
    for ref_run=1:nb_spk.ref
        
        for target_run=1:nb_spk.target
            spk_int= jitter_spk.target(target_run)-jitter_spk.ref(ref_run);
            
            if (spk_int>= Xmin_sec) && (spk_int< Xmax_sec)
                for int_run=1:nb_range_int-1
                    if (spk_int>=X_range_sec(int_run)) && (spk_int<X_range_sec(int_run+1))
                        correlogram_jitter(bootstrap_ind, int_run)=correlogram_jitter(bootstrap_ind, int_run)+1;
                    end
                end
            else
                excluded=excluded+1;
            end
            
        end
        
    end
    
    
    
    
    
    
    bootstrap_ind = bootstrap_ind +1;
    
    if bootstrap_ind > bootstrap_nb
        bootstrap_ok= 0;
    end
    
end


    %% Eliminate the last bin

correlogram_jitter(:,end)=[];
X_range_sec(end)=[];



upperLIM =[];
lowerLIM =[];


% upperCI=[];
% lowerCI=[];
%
%
% for bin_run = 1: size(correlogram,2)
%
% pd = fitdist(correlogram(:,bin_run),'Normal');
%
% ci = paramci(pd,'Alpha',.01);
%
% lowerCI(bin_run)= ci(1);
% upperCI(bin_run)= ci(2);
%
%
% end


upperLIM = mean(correlogram_jitter) + (2*std(correlogram_jitter,1));
lowerLIM = mean(correlogram_jitter) - (2*std(correlogram_jitter,1));

correlogram_jitter = mean(correlogram_jitter);





%% Calculate the bias index


peak_loc = nan;
trough_loc = nan;
bias_ind = nan;

left_crosscorr =[];
right_crosscorr =[];


left_crosscorr= correlogram_org(1:length(correlogram_org)/2);  %% target
right_crosscorr= correlogram_org((length(correlogram_org)/2)+1:end);  %% ref
bias_ind= (sum(left_crosscorr)-sum(right_crosscorr))/ (sum(left_crosscorr)+sum(right_crosscorr));




%% Calculate the peak count and peak location
[peak_count peak_ind]=max(correlogram_org);
peak_nb= sum(correlogram_org==max(correlogram_org));
if peak_nb <2 && (correlogram_org(peak_ind) > upperLIM(peak_ind))
    peak_loc= ((X_range_sec(correlogram_org==peak_count) +(X_range_sec(correlogram_org==peak_count)+ bin_size_sec)))/2;
end


[trough_count trough_ind]=min(correlogram_org);
trough_nb= sum(correlogram_org==min(correlogram_org));

if trough_nb <2 && (correlogram_org(trough_ind) < lowerLIM(trough_ind))
    trough_loc= ((X_range_sec(correlogram_org==trough_count) +(X_range_sec(correlogram_org==trough_count)+ bin_size_sec)))/2;
end





%% Abeles method
% f_ts=nb_spk.ref/duration_spk;
% p_ts=f_ts*bin_size_sec;
% C=p_ts*nb_spk.ref;

% if (C<30)
%     Prob=0;K=0;
%     while Prob<p_conf
%         Prob = (exp(-C) * (C^K)) / factorial(K);
%         K=K+1;
%     end
%     LowConf =K-1;
%
%     Prob=0;K=0;
%     while Prob<(1-p_conf)
%         Prob = Prob + (exp(-C) * (C^K)) / factorial(K);
%         K=K+1;
%     end
%     HighConf=K-1;
%
% else
%     LowConf = C - 1.96*sqrt(C);
%     HighConf= C + 1.96*sqrt(C);
% end
%
%
% conf=[LowConf HighConf];
% nb_spk= length(ts_spk.ref);


end
