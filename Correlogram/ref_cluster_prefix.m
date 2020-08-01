%% For PRC & POR ephys 
%% By AJR 2017/01/11

Key.ref= summary(Ref_run).Key;


switch length(Key.ref)
    case 1
        Key.ref= ['00' Key.ref];
    case 2
        Key.ref= ['0' Key.ref];
    otherwise
end

RatID.ref= summary(Ref_run).Rat;
Session.ref = summary(Ref_run).Rec_session;
TT.ref= summary(Ref_run).TT;
Task_session.ref = summary(Ref_run).Task_session;
Task.ref= summary(Ref_run).Task_name;
Region.ref= summary(Ref_run).Region;
Subregion.ref= summary(Ref_run).SubRegion;
Layer.ref= summary(Ref_run).Layer;
Bregma.ref= summary(Ref_run).Bregma;
Cluster_nb.ref= summary(Ref_run).Cluster;
TTID.ref= ['TT' summary(Ref_run).TT '_BEH.ntt'];

switch numel(summary(Ref_run).Cluster)
    
    case 1
        ClusterID.ref=['TT' summary(Ref_run).TT '_BEH_SS_0' summary(Ref_run).Cluster '.ntt'];

    case 2
        ClusterID.ref=['TT' summary(Ref_run).TT '_BEH_SS_' summary(Ref_run).Cluster '.ntt'];
end


Rat_folder.ref=[dataROOT '\Ephys_data\' RatID.ref];
Session_folder.ref=[Rat_folder.ref '\' RatID.ref '-' Session.ref '-0' Task_session.ref '_' Task.ref];
TT_folder.ref=[Session_folder.ref '\TT' TT.ref];

Prefix.ref= [ Key.ref '-' RatID.ref '-' Session.ref '-0' Task_session.ref '-' Task.ref '-' Region.ref '-' Layer.ref '-( -' Bregma.ref ' mm)-TT' TT.ref '.' Cluster_nb.ref ];
% disp(Prefix.ref);
