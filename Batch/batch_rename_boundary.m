%% By Jaerong 2020/03/21
%% The program renames all boundary files (clbound etc.)




clear all; clc
project= 'I:\PRh-OCSD';
cd(project);
listing_rat=dir('r*');[r1,c1]=size(listing_rat);

for i1=1:r1
    target_rat = [project '\' listing_rat(i1).name];cd(target_rat)
    listing_session=dir('r*');[r2,c2]=size(listing_session);
    
    for i2=1:r2
        target_session = [target_rat '\' listing_session(i2).name];cd(target_session);
        listing_TT=dir('T*');[r3,c3]=size(listing_session);
        %% function using session informations as position data or behavioral data
        
        for i3=1:r3
            target_TT = [target_session '\' listing_TT(i3).name];cd(target_TT);
            %% function using cluster informations like spike timestamps
            listing_boundary= dir('clbound.txt'); [r4, c4]=size(listing_boundary);  
            if r4
            previousname = listing_boundary(1).name
            newname=[listing_TT(i3).name '_boundaries_behavior.txt']
            movefile(previousname,newname)                       
            end
        end
    end
end
