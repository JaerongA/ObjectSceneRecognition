%% EEG Parms

freq_range.all = [0 140];
freq_range.delta = [1 4]; freq_range.theta = [4 12]; freq_range.beta = [15 25]; freq_range.lowgamma = [30 50]; freq_range.highgamma = [70 120];
global sampling_freq
global period
sampling_freq= 2000;
period=(1/sampling_freq)*10^6;
removenoise = 0;
nb_data_points= 2000;



%% mtspecgramc parameter

% movingwin = [0.1 .05];           %moving window [windowSIZE windowSTEP]; 500ms window and moving by 10ms
movingwin = [0.3 .01];           %moving window [windowSIZE windowSTEP]; 300ms window and moving by 10ms
params.Fs = sampling_freq;               %frequency; here is EEG data frequency
params.tapers = [3 5];          %tapers [TimeBandWidth multipleTAPERS]; 5 is recommended for 500ms window (3 is recormended for 300ms window size)
params.fpass = freq_range.all;          %ROI freqency;
params.pad= 0;
params.trialave = 1;            %if trial to be averaged, set 1
params.err = [1 0.05] ;            % error bar on, p-value



%% Spectrogram Parms

% windowsize = 512;
% nfft = windowsize*2;
% noverlap = windowsize/2;
% % noverlap = 100;




plt = 'l';
