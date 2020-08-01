
Key.target= summary(Target_run).Key;

switch length(Key.target)
    case 1
        Key.target= ['00' Key.target];
    case 2
        Key.target= ['0' Key.target];
    otherwise
end

RatID.target= summary(Target_run).Rat;
Session.target= summary(Target_run).Rec_session;
TT.target= summary(Target_run).TT;
Task_session.target = summary(Target_run).Task_session;
Task.target= summary(Target_run).Task_name;
Region.target= summary(Target_run).Region;
Layer.target= summary(Target_run).Layer;
Bregma.target= summary(Target_run).Bregma;
Cluster_nb.target= summary(Target_run).Cluster;
TTID.target= ['TT' summary(Target_run).TT '_BEH.ntt'];

switch numel(summary(Target_run).Cluster)
    
    case 1
        ClusterID.target=['TT' summary(Target_run).TT '_BEH_SS_0' summary(Target_run).Cluster '.ntt'];
        
    case 2
        ClusterID.target=['TT' summary(Target_run).TT '_BEH_SS_' summary(Target_run).Cluster '.ntt'];
end


Rat_folder.target=[dataROOT '\Ephys_data\' RatID.target];
Session_folder.target=[Rat_folder.target '\' RatID.target '-' Session.target '-0' Task_session.target '_' Task.target];
TT_folder.target=[Session_folder.target '\TT' TT.target];

Prefix.target= [ Key.target '-' RatID.target '-' Session.target '-0' Task_session.target '-' Task.target '-' Region.target '-' Layer.target '-( -' Bregma.target ' mm)-TT' TT.target '.' Cluster_nb.target];
%                 disp(Prefix.target);



