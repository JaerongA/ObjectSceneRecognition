
%% Inputs :
% ts_microsec = timestamps of the cluster to be processed ( in micro sec)
% ref_microsec = timestamps of the reference cluster  ( in micro sec)
% bin_size_sec = size of a bin (in sec)
% Xmin_sec = inferior limit of the histogram (sec)
% Xmax_sec  = superior limit of the histogram (sec)
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
% [conf,l_ref]=SD_ConfidenceInterval(ts,ref,0.002,0.005)

function [conf,l_ref]=SD_ConfidenceInterval(ts_microsec,ref_microsec,bin_size_sec,p_conf)

ref=ref_microsec/1000000;
ts=ts_microsec/1000000;

l_ref=length(ref);dt_ref =ref(end)-ref(1);f_ref=l_ref/dt_ref;
l_ts=length(ts);dt_ts =ts(end)-ts(1);f_ts=l_ts/dt_ts;

%% Abeles method
f_ts=l_ts/dt_ts;
p_ts=f_ts*bin_size_sec;
C=p_ts*l_ref;

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
    LowConf = C - 2.58*sqrt(C);
    HighConf= C + 2.58*sqrt(C);
end

conf=[LowConf HighConf];

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
