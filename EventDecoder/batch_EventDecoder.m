clear all; clc;

dataROOT= 'B:\PRC_POR_ephys\Ephys_data';
cd(dataROOT);




listing_rat= dir('r*'); nb_rat= size(listing_rat,1);



for rat_run= 1:nb_rat
    
    
    rat_folder=[dataROOT '\' listing_rat(rat_run).name]; cd(rat_folder);
    
    listing_session= dir('r*');nb_session= size(listing_session,1);
    
    for session_run= 1:nb_session
        
        
        session_folder= [rat_folder '\' listing_session(session_run).name];
        
        cd(session_folder);
        
%         if exist('ExtractedEvents')
%             continue;
%         end
        
% session_folder= 'B:\PRC_POR_ephys\Ephys_data\r344\r344-07-05_OCRS(FourOBJ)';
        EventDecoderFunction_PushDig_All(session_folder)
        
    end
end

disp('End')


