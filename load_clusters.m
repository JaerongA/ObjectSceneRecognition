%% Load Clusters

cd(TT_folder);
ts_spk = Nlx2MatSpike(ClusterID, [1 0 0 0 0], 0, 1, 0);
ts_spk=ts_spk/10^6;
ts_spk=ts_spk';


