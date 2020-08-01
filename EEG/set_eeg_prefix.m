%% Modified for PRC & POR ephys by Jaerong 2017/02/26

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
Ref_Region= summary(i_s).Ref_Region;
Subregion= summary(i_s).SubRegion;
Layer= summary(i_s).Layer;
Bregma= summary(i_s).Bregma;
TTID= ['TT' summary(i_s).TT '.ntt'];



Rat_folder=[dataROOT '\Ephys_data\' RatID];
Session_folder=[Rat_folder '\' RatID '-' Session '-' Task_session '_' Task];
TT_folder=[Session_folder '\TT' TT];

Prefix= [ Key '-' RatID '-' Session '-' Task_session '-' Task '-' Region '-' Layer '-( -' Bregma ' mm)' '-TT' TT ];
% disp(Prefix);
