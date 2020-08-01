function [voided_trials, nb_voided_trials, voidedtrialslatency, lat_mean] = Latency_makevoid(session_folder)

% session_folder = 'I:\PRC_POR_ephys\Ephys_data\r390\r390-01-01_OCRS(TwoOBJ)';
cd(session_folder);

%loadfile
load Parsedevents.mat
latency = ts_evt(:,5);

%calculate the mean,sd and limits  
lat_mean = nanmean(latency);
lat_sd = nanstd(latency);
lat_maxlimit = lat_mean + (3*lat_sd);

%make trials that exceeded 3sd void
voided_trials = find(latency > lat_maxlimit);
ts_evt(voided_trials,12) = 1;
ts_evt(voided_trials,2:11) = NaN;

save('Parsedevents.mat','ts_evt','-append')
delete('ts_event.mat');
end