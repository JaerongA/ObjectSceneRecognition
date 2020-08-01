%% By Jaerong 2015/10/27
%% Convert .ntt files

dataROOT= 'B:\PRC_POR_ephys\Ephys_data';
cd(dataROOT);
listing_rat=dir('r*');[r1,c1]=size(listing_rat);

for i1=1:r1
    target_rat = [dataROOT '\' listing_rat(i1).name];cd(target_rat)
    listing_session=dir('r*');[r2,c2]=size(listing_session);
    
    for i2=1:r2
        target_session = [target_rat '\' listing_session(i2).name]; disp(target_session); cd(target_session);
        
%         %% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
%         Session_CAT = target_session(findstr(target_session,'(')+1:end-1);
%         
%         if  strcmp(Session_CAT,'TwoOBJ')
%             cd(target_session);
%         else
%         continue;
%         end
%         
        
        listing_TT=dir('T*');[r3,c3]=size(listing_TT);
        
        for i3=1:r3
            target_TT = [target_session '\' listing_TT(i3).name];cd(target_TT);
            listing_ntt= dir('*beh*'); [r4, c4]=size(listing_ntt);
            
            
            for i4= 1:r4
                nttID = listing_ntt(i4).name;  
                
%                 sep = findstr(nttID,'_');     
%                 if isempty(sep)
%                 new_nttID=[listing_ntt(i4).name(1:end-4) '_beh.ntt']; disp(new_nttID);
%                 else
%                 new_nttID=[listing_ntt(i4).name(1:sep(1)-1) '_beh_' listing_ntt(i4).name(sep(1)+1:end)]; disp(new_nttID);
%                 end                    
                new_nttID=  strrep(nttID,'beh','BEH');
                disp([nttID '->' new_nttID]);
                movefile(nttID,'abc');
                movefile('abc',new_nttID);
            end
            
        end
    end
end
disp('End')
