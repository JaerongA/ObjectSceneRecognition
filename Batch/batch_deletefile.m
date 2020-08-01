%% By Jaerong (2020/03/17)
%% This program removes unnecessary cluster files


clear all; clc; close all;

project='I:\PRh-OCSD\r073\';cd(project);
listing_session=dir('r*');[r1,c1]=size(listing_session);

for i1=1:r1
    target_session = [project '\' listing_session(i1).name];cd(target_session)
    listing_TT=dir('T*');[r2,c2]=size(listing_TT);

    for i2=1:r2
        target_TT = [target_session '\' listing_TT(i2).name];cd(target_TT);
        listing_filetoremove= dir('*_cluster.15'); [r3,c3]= size(listing_filetoremove); %%Put the file name you wish to erase
        
        if r3
            disp(listing_filetoremove.name); pause
            delete(listing_filetoremove.name)
            %% function using session informations as position data or behavioral data
        else
        end
        
        
    end
end

