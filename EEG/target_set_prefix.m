%% Parameter setting
%% Modified for PRC & POR ephys by Jaerong 2017/02/26

Key2= summary(Target_run).Key;


switch length(Key2)
    case 1
        Key2= ['00' Key2];
    case 2
        Key2= ['0' Key2];
    otherwise
end

RatID2= summary(Target_run).Rat;
Session2 = summary(Target_run).Rec_session;
TT2= summary(Target_run).TT;

Task_session2 = summary(Target_run).Task_session;
Task2= summary(Target_run).Task_name;
Region2= summary(Target_run).Region;
Ref_Region2= summary(Target_run).Ref_Region;
SubRegion2= summary(Target_run).SubRegion;
Layer2= summary(Target_run).Layer;
Bregma2= summary(Target_run).Bregma;
TTID2= ['TT' summary(Target_run).TT '.ntt'];



Rat_folder=[dataROOT '\Ephys_data\' RatID2];
Session_folder=[Rat_folder '\' RatID2 '-' Session2 '-' Task_session2  '_' Task2];
TT_folder=[Session_folder '\TT' TT2];

Prefix2= [ Key2 '-' RatID2 '-' Session2 '-' Task_session2 '-' Task2 '-' Region2 '-' Layer2 '-( -' Bregma2 ' mm)' '-TT' TT2 ];
% disp(Prefix2);
