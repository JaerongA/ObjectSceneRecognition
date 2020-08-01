%% Modified for PRC & POR ephys by Jaerong 2017/02/26

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
SubRegion.ref= summary(Ref_run).SubRegion;
Layer.ref= summary(Ref_run).Layer;
Bregma.ref= summary(Ref_run).Bregma;
TTID.ref= ['TT' summary(Ref_run).TT '.ntt'];



Rat_folder=[dataROOT '\Ephys_data\' RatID.ref];
Session_folder=[Rat_folder '\' RatID.ref '-' Session.ref '-' Task_session.ref  '_' Task.ref];
TT_folder=[Session_folder '\TT' TT.ref];

Prefix.ref= [ Key.ref '-' RatID.ref '-' Session.ref '-' Task_session.ref '-' Task.ref '-' Region.ref '-' Layer.ref '-( -' Bregma.ref ' mm)' '-TT.ref' TT.ref ];
disp(Prefix.ref);
