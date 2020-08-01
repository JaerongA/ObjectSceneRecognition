%% Written by Jaerong 2017/01/09


%% Inputs :
% ts_microsec = timestamps of the cluster to be processed ( in mic  sec)
% ref_microsec = timestamps of the reference cluster  ( in mic sec)
% bin_size_sec = size of a bin (in sec)
% Xmin_sec = inferior limit of the histogram (mic sec)
% Xmax_sec  = superior limit of the histogram (mic sec)
% p_conf = probability of the confidence interval, use 0.005 for (99%)
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

%% How to use it
% ref=load('TT1cl2microsec.txt');
% ts=load('TT1cl3microsec.txt');
%[crosscorrelogram,bounds,conf,l_ref,excluded]=SD_CrossCorrelogram(ts,ref,0.002,-0.2,0.2,0.005,1);


function [crosscorrelogram,X_range, conf, nb_ref_spk, excluded]= Draw_crossCorrelogram_non_epoch(ts_microsec,ref_microsec,bin_size_sec,Xmin_sec,Xmax_sec,p_conf, ts_evt_new)


if ~isempty(ts_evt_new)
    
    %% Event definition
    
    start_box= 1; obj_onset=2; obj_touch=3; disc_touch=4; foodtray=5;
    
%                         %% ms conversion
%                     Xmin_sec= Xmin_sec.*10^3;  %% ms conversion
%                     Xmax_sec= Xmax_sec.*10^3;  %% ms conversion
%                     bin_size_sec= bin_size_sec.*10^3;  %% ms conversion
                    

    
    ref_ts_spk=ref_microsec./10^6;  %% Convert to seconds
    ts_spk=ts_microsec./10^6;
    
    %     ref_ts_spk=ref_microsec;  %% Convert to seconds
    %     ts_spk=ts_microsec;
    %
    nb_trial= size(ts_evt_new,1);
    
    
    %% Spike extraction from the reference cluster
    
    ref_ts_mat=cell(1,nb_trial);
    duration_ref_mat=cell(1,nb_trial);
    
    for trial_run=1: nb_trial
        
        if trial_run < 2 
        
            spk_ind= find(ref_ts_spk < ts_evt_new(trial_run,obj_onset));
        elseif trial_run== nb_trial
            spk_ind= find(ref_ts_spk > ts_evt_new(trial_run,disc_touch));
        else
            spk_ind= find((ref_ts_spk > ts_evt_new(trial_run-1,disc_touch)) & (ref_ts_spk < ts_evt_new(trial_run,obj_onset)));
        end
            
        ref_ts_mat{trial_run}= ref_ts_spk(spk_ind);
        if ~isempty(spk_ind)
            duration_ref_mat{trial_run}= ref_ts_mat{trial_run}(end)- ref_ts_mat{trial_run}(1);
        end
    end
    
    ref_ts_spk = cell2mat(ref_ts_mat');   %% Extracted only the spikes from the epoch
    ref_ts_spk=ref_ts_spk';
    nb_ref_spk=length(ref_ts_spk);
    duration_ref_spk= sum(cell2mat(duration_ref_mat'));
    fr_ref_spk=nb_ref_spk/duration_ref_spk;
    
    
    
    
    %% Spike extraction from the target cluster
    
    ts_mat=cell(1,nb_trial);
    duration_mat=cell(1,nb_trial);
    
    for trial_run=1: nb_trial
        
        if trial_run < 2 
        
            spk_ind= find(ts_spk < ts_evt_new(trial_run,obj_onset));
        elseif trial_run== nb_trial
            spk_ind= find(ts_spk > ts_evt_new(trial_run,disc_touch));
        else
            spk_ind= find(ts_spk > ts_evt_new(trial_run-1,disc_touch) & ts_spk < ts_evt_new(trial_run,obj_onset));
        end
        
      ts_mat{trial_run}= ts_spk(spk_ind);
        if ~isempty(spk_ind)
            duration_mat{trial_run}= ts_mat{trial_run}(end)- ts_mat{trial_run}(1);
        end
    end
    
    ts_spk = cell2mat(ts_mat');   %% Extracted only the spikes from the epoch
    ts_spk=ts_spk';
    nb_spk=length(ts_spk);
    duration_spk= sum(cell2mat(duration_mat'));
    fr_spk=nb_spk/duration_spk;
    
    
    
    
else
    
    
    
    
    nb_ref_spk=length(ref_ts_spk); duration_ref_spk =ref_ts_spk(end)-ref_ts_spk(1); fr_ref_spk=nb_ref_spk/duration_ref_spk;
    nb_spk=length(ts_spk);duration_spk =ts_spk(end)-ts_spk(1);fr_spk=nb_spk/duration_spk;
%     duration_total = max(ref_ts_spk(end),ts_spk(end)) - min(ts_spk(1),ref_ts_spk(1));
    
    
end  %~isempty(ts_evt_new)
    
    
    
    Xmin=Xmin_sec;Xmax=Xmax_sec;
    
    X_range=Xmin:bin_size_sec: Xmax;
    nb_range_int=length(X_range);
    h=zeros(1,nb_range_int);
    
    excluded=0;
    
    for ref_run=1:nb_ref_spk;
        for spk_run=1:nb_spk
            spk_int=ts_spk(spk_run)-ref_ts_spk(ref_run);
            if (spk_int>=Xmin) && (spk_int<Xmax)
                for int_run=1:nb_range_int-1
                    if (spk_int>=X_range(int_run)) && (spk_int<X_range(int_run+1))
                        h(int_run)=h(int_run)+1;
                    end
                end
            else
                excluded=excluded+1;
            end
        end
    end
    
    
    msg= sprintf('%d spikes were excluded', excluded);
    disp(msg);
    
    %% Abeles method
    f_ts=nb_spk/duration_spk;
    p_ts=f_ts*bin_size_sec;
    C=p_ts*nb_ref_spk;
    
    if (C<30)
        Prob=0;K=0;
        while Prob<p_conf
            Prob = (exp(-C) * (C^K)) / factorial(K);
            K=K+1;
        end
        LowConf =K-1;
        
        Prob=0;K=0;
        while Prob<(1-p_conf)
            Prob = Prob + (exp(-C) * (C^K)) / factorial(K);
            K=K+1;
        end
        HighConf=K-1;
        
    else
        LowConf = C - 1.96*sqrt(C);
        HighConf= C + 1.96*sqrt(C);
    end
    
    conf=[LowConf HighConf];
    
    crosscorrelogram=h;
    
end







%% How to build a cross correlogram from NeuroExplorer

% Algorithm
% Crosscorrelogram shows the conditional probability of a spike at time t0+t on the condition that there is a reference event at time t0.
%
% The time axis is divided into bins. The first bin is [XMin, XMin+Bin). The second bin is [XMin+Bin, XMin+Bin*2), etc. The left end is included in each bin, the right end is excluded from the bin.
%
% Let ref[i] be the array of timestamps of the reference event,
%
% ts[i] be the spike train (each ts is the timestamp).
%
% For each timestamp ref[k]:
%
% 1) calculate the distances from this event (or spike) to all the spikes in the spike train:
%
% d[i] = ts[i] - ref[k]
% 2) for each i:
%
% if d[i] is inside the first bin, increment the bin counter for the first bin:
%
% if d[i] >= XMin and d[i] < XMin + Bin
% then bincount[1] = bincount[1] +1
% if d[i] is inside the second bin, increment the bin counter for the second bin:
%
% if d[i] >= XMin+Bin and d[i] < XMin + Bin*2
% then bincount[2] = bincount[2] +1
% and so on... .
%
% If Normalization is Counts/Bin, no further calculations are performed.
%
% If Normalization is Probability, bin counts are divided by the number of reference events.
%
% Note that the Probability normalization makes sense only for small values of Bin. For Probability normalization to be valid (so that the values of probability are between 0 and 1), there should be no more than one spike in each bin. For example, if the Bin value is large and for each ref[k] above there are many d[i] values such that d[i] >= XMin and d[i] < XMin + Bin, the bin count for the first bin can exceed the number of reference events. Then, the probability value (bincount[1]/number_of_reference_events) could be larger than 1.
%
% If Normalization is Spikes/Sec, bin counts are divided by NumRefEvents*Bin, where NumRefEvents is the number of reference events.
%
% If Normalization is Z-score, bin_value = (bin_count - Confidence_mean)/sqrt(Confidence_mean), where Confidence_mean is the expected mean bin count calculated according to Conf. mean calculation parameter. Please note that bin counts have Poisson distribution and Normal approximation (used in Z-score) is valid only for large values (more than 10) of the Confidence_mean.
%
% If the option Count Bins In Filter is selected, 
% for normalization Spikes/Second, NeuroExplorer will divide bin count by NumTimesBinWasInFilter*Bin instead of NumRefEvents*Bin. 
% The problem is that when the interval filter is used, bins close to XMin and to XMax may often (when a reference event is close to the beginning or to the end of the interval in the interval filter) be positioned outside the filter and therefore will not be used for many reference events. Hence, the bins close to 0.0 will be used in analysis more often than the bins close to XMin and XMax. If the option Count Bins In Filter is selected, NeuroExplorer will count the number of times each bin was used in the calculation and use this count, NumTimesBinWasInFilter, (instead of the number of reference events) to normalize the histogram.
%
% Peak and Trough Statistics
% NeuroExplorer calculates histogram peak statistics the following way:
%
% Maximum of the histogram is found
% If the histogram contains several maxima with the same value, peak statistics are not calculated
% Otherwise, the center of the bin, where the histogram reaches maximum, is shown as Peak Position in the Summary of Numerical results
% The mean M and standard deviation S of the bin values of the histogram background are calculated:
% If Background parameter is set as Bins outside peak/trough, bins outside peak and trough (i.e., bins that are more than PeakWidth/2 away from the bin with the histogram maximum and the bin with the histogram minimum) are used to calculate M and S
% If Background parameter is set as Shoulders, bins that are to the left of Left Shoulder or to the right of Right Shoulder parameters are used to calculate M and S
% The value M (mean of the background bin values) is shown as Background Mean in the Summary of Numerical results
% The value S (standard deviation of the background bin values) is shown as Background Stdev in the Summary of Numerical results
% The value (HistogramMaximum ?M)/S is shown as Peak Z-score
% The value (HistogramMaximum + M)/2 is shown as Peak Half Height
% Histogram intersects a horizontal line drawn at Peak Half Height at time points TLeft and TRight. (TRight - TLeft) is shown as Peak Width
% Histogram trough statistics are calculated in a similar way. The only difference is that histogram minimum instead of histogram maximum is analyzed.

%% How to calcultate the confidence interval from NeuroExplorer

% If the total time interval (experimental session) is T (seconds) and we have N spikes in the interval, then the neuron frequency is:
%
% F = N/T
%
% Several options how to calculate neuron frequency F are available. See Options below.
%
% Then if the spike train is a Poisson train, the probability of the neuron to fire in the small bin of the size b (seconds) is
%
% P = F*b
%
% The expected bin count for the perievent histogram is then:
%
% C = P*NRef, where NRef is the number of the reference events.
%
% The value C is used for drawing the Mean Frequency in the Perievent Histograms and Cross- and Autocorrelograms.
%
% The confidence limits for C are calculated using the assumption that C has a Poisson distribution. Assume that a random variable S has a Poisson distribution with parameter C. Then the 99% confidence limits are calculated as follows:
%
% Low Conf. = x such that Prob(S < x) = 0.005
%
% High Conf. = y such that Prob(S > y) = 0.005
%
% If C < 30, NeuroExplorer uses the actual Poisson distribution
%
% Prob(S = K) = exp(-C) * (C^K) / K!, where C^K is C to the power of K,
%
% to calculate the confidence limits.
%
% If C>= 30., the Gaussian approximation is used. For example, for 99% confidence limits:
%
% Low Conf. = C - 2.58*sqrt(C);
%
% High Conf.= C + 2.58*sqrt(C);
%
% Reference
% Abeles M. Quantification, smoothing, and confidence limits for single-units histograms. Journal of Neuroscience Methods. 5(4):317-25, 1982





%% Brillinger method : is not working, wrong implementation ??
% new_h=sqrt(h/(bin_size_sec*l_ts));
% m=sqrt(l_ref/dt_ref);
%
% HighConf = m+ 1/sqrt(bin_size_sec/l_ts)
% LowConf = m -  1/sqrt(bin_size_sec/l_ts)
%
% hold on
% bar(Bounds,h)
% line([Xmin Xmax],[HighConf HighConf]);
% line([Xmin Xmax],[LowConf LowConf]);
% hold off

