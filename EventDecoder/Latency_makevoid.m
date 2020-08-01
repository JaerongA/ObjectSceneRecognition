function [voided_trials, nb_voided_trials, void_latency, lat_mean] = Latency_makevoid(session_folder)

%%�� ������ parsedevents���� latency������ �ҷ����� mean latecny �� ���� 3 s.d.�� �Ѿ ���� ����
%%trials���� void ó���Ѵ�

session_folder = 'H:\PRC_POR_ephys\Ephys_data\r558\r558-03-01_OCRS(FourOBJ)';
dataROOT= [session_folder '\Behavior'];
cd(dataROOT);

%loadfile
load Parsedevents.mat
latency = ts_evt(:,5);

%calculate the mean,sd and limits  
lat_mean = nanmean(latency);
lat_sd = nanstd(latency);
lat_maxlimit = lat_mean + (3*lat_sd);

%make trials that exceeded 3sd void
voided_trials = find(latency > lat_maxlimit)


void_latency= nanmean(ts_evt(voided_trials,5))

nb_voided_trials = length(voided_trials)


ts_evt(voided_trials,12) = 1;
ts_evt(voided_trials,2:11) = NaN;

%% Remove all the void trials.



save('Parsedevents.mat','ts_evt','-append')


end