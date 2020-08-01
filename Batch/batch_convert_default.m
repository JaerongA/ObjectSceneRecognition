function batch
project='I:\PRh-OCSD\ClusterCutting';cd(project);
listing_rat=dir('R*');[r1,c1]=size(listing_rat);

for i1=1:r1
    target_rat = [project '\' listing_rat(i1).name];cd(target_rat)
    listing_session=dir('S*');[r2,c2]=size(listing_session);
    
    for i2=1:r2
        target_session = [target_rat '\' listing_session(i2).name];cd(target_session);
        listing_TT=dir('T*');[r3,c3]=size(listing_session);
        %% function using session informations as position data or behavioral data
        listing= dir('Defaults'); [r4, c4]=size(listing);
        if r4
            Convert_Defaults(listing(1).name);
        end
        
        %         for i3=1:r3
        %             target_TT = [target_session '\' listing_TT(i3).name];cd(target_TT);
        %             %% function using cluster informations like spike timestamps
        %         end
        
    end
end
