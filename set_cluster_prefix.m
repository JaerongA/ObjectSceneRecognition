%% For PRC & POR ephys 
%% by Jaerong 2015/09/24

Key= summary(i_s).Key;


switch length(Key)
    case 1
        Key= ['00' Key];
    case 2
        Key= ['0' Key];
    otherwise
end

RatID= summary(i_s).Rat;
Session = summary(i_s).Rec_session;
TT= summary(i_s).TT;

Task_session = summary(i_s).Task_session;
Task= summary(i_s).Task_name;
Region= summary(i_s).Region;
Subregion= summary(i_s).SubRegion;
Layer= summary(i_s).Layer;
Bregma= summary(i_s).Bregma;
Cluster_nb= summary(i_s).Cluster;


Rat_folder=[dataROOT '\Ephys_data\' RatID];
Session_folder=[Rat_folder '\' RatID '-' Session '-0' Task_session '_' Task];
TT_folder=[Session_folder '\TT' TT];
cd(TT_folder);



TTID= ['TT' summary(i_s).TT '_BEH.ntt'];

if exist(TTID)

switch numel(summary(i_s).Cluster)
    
    case 1
        ClusterID=['TT' summary(i_s).TT '_BEH_SS_0' summary(i_s).Cluster '.ntt'];

    case 2
        ClusterID=['TT' summary(i_s).TT '_BEH_SS_' summary(i_s).Cluster '.ntt'];
end


else
    
   switch numel(summary(i_s).Cluster)
    
    case 1
        ClusterID=['TT' summary(i_s).TT '_SS_0' summary(i_s).Cluster '.ntt'];

    case 2
        ClusterID=['TT' summary(i_s).TT '_SS_' summary(i_s).Cluster '.ntt'];
   end

end

%% For pre-post comparison
% TTID= ['TT' summary(i_s).TT '_whole.ntt'];
% 
% 
% 
% switch numel(summary(i_s).Cluster)
%     
%     case 1
%         ClusterID=['TT' summary(i_s).TT '_whole_SS_0' summary(i_s).Cluster '.ntt'];
% 
%     case 2
%         ClusterID=['TT' summary(i_s).TT '_whole_SS_' summary(i_s).Cluster '.ntt'];
% end



Prefix= [ Key '-' RatID '-' Session '-0' Task_session '-' Task '-' Region '-' Layer '-( -' Bregma ' mm)' '-TT' TT '.' Cluster_nb ];
disp(Prefix);
