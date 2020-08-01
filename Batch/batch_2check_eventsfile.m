%% By Jaerong
%% This program prints out which folder doesn't contain 'Events.cvs' file.

clear all; clc;



project='I:\PRh-OCSD' ;cd(project);
listing_rat=dir('r*');[r1,c1]=size(listing_rat);

for i1=1:r1
    target_rat = [project '\' listing_rat(i1).name];cd(target_rat)
    listing_session=dir('r*');[r2,c2]=size(listing_session);
    
    for i2=1:r2
        target_session = [target_rat '\' listing_session(i2).name];cd(target_session);
        listing_events= dir('Events.csv'); [r3, c3]= size(listing_events);
        
        if ~r3
            sprintf('%s', target_session);
         
        end
    end
end

disp('END')