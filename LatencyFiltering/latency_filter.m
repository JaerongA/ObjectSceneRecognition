function [voided_trials, nb_voided_trials, voidedtrialslatency, lat_mean] = Latency_filter(session_folder)

%% By Jaerong 
%% Eliminate voided trials based on choice latency
% session_folder = 'I:\PRC_POR_ephys\Ephys_data\r390\r390-01-01_OCRS(TwoOBJ)';
cd([session_folder]);

%loadfile
load Parsedevents.mat
latency = ts_evt(:,5);

%calculate the mean,sd and limits  
lat_mean = nanmean(latency);
lat_sd = nanstd(latency);
lat_maxlimit = lat_mean + (3*lat_sd);

%tiral number that exceeds the limits
voided_trials = find(latency > lat_maxlimit);
disp(voided_trials);
nb_voided_trials = length(voided_trials);
voidedtrialslatency=latency(voided_trials)

end