%% Created by Jaerong 2015/09/27 
%% This code splits .ntt spike files into epochs (e.g.,pre/post sleep or behavioral sessions)

% delete('*.parms');
% 
session_folder = 'F:\PRC_POR_ephys\Ephys_data\r469\r469-03-01_OCRS(FourOBJ)';
StartTS= 764848053635;
EndTS= 770406530510;
EpochSelection =2;


EpochSTR= {'PRESLEEP','BEH','POSTSLEEP'};

cd(session_folder);


listing_TT= dir('T*'); nb_TT=size(listing_TT,1);


for TT_run= 1:nb_TT
    
    target_TT= [session_folder '\' listing_TT(TT_run).name]; cd(target_TT);
    
    if exist('*BEH.ntt')
    continue;
    end
    
    listing_NTT= dir('*.ntt');
     
    disp(['processing ...' listing_NTT(1).name]);
    
    [Timestamps, ScNumbers, CellNumbers, Features, Samples, Header] = Nlx2MatSpike(listing_NTT(1).name, [1 1 1 1 1], 1, 4, [StartTS EndTS]);
%     [Timestamps, ScNumbers, CellNumbers, Features, Samples, Header] = Nlx2MatSpike(listing_NTT(1).name, [1 1 1 1 1], 1, 1, [StartTS EndTS]);
    
    new_NTT_name = [listing_NTT(1).name(1:end-4) '_' cell2mat(EpochSTR(EpochSelection)) '.ntt'];
        
    Mat2NlxSpike(new_NTT_name, 0, 1, [], [1 1 1 1 1 1], Timestamps, ScNumbers, CellNumbers, Features, Samples, Header);
    
    Timestamps= [];
    ScNumbers= [];
    CellNumbers= [];
    Features= [];
    Samples= [];
    Header= [];
    
    cd(session_folder);
    
    
  end
    
disp('END');
