%% By Jaerong
%% This function opens .ntt files and stores ADBitVolts values in the global summary sheet.


function [summary,summary_header]=Summary_GetADBitVolts(summary, summary_header,data_path)

[r_s,c_s]=size(summary);
cd('I:\PRh-OCSD\Analysis\Summary')
fod2=fopen('diff_ADBit_log.txt','w');

for i_s= 1:c_s
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    
    
    if strcmp(summary(i_s).ADBitVolts0,'?') || strcmp(summary(i_s).ADBitVolts1,'?') || strcmp(summary(i_s).ADBitVolts2,'?') || strcmp(summary(i_s).ADBitVolts3,'?')
        
        rat_folder=[data_path '\' summary(i_s).rat];
        session_folder=[rat_folder '\' summary(i_s).rat '-' summary(i_s).rec_session '_' summary(i_s).task_name];
        TT_folder=[session_folder '\' summary(i_s).TT];
        cd(TT_folder);
        disp([ 'Loading  ' summary(i_s).rat '-' summary(i_s).rec_session '-' summary(i_s).TT '.'  summary(i_s).cluster '...' ]);
        
        listing_tt=dir('TT*.ntt');
        ntt_file = [TT_folder '\' listing_tt(1).name];
        disp(['Loading ' listing_tt(1).name '...']);
        
        
        [Header] = Nlx2MatSpike(ntt_file, [0 0 0 0 0],1,1,[]);
        [r(4) c(4)]=size(Header);
        
        
        
        if strcmp(summary(i_s).rat, 'r073'); %% Dimension matching
            n=15;
        else
            n=16;
        end
        
        
        ADBitVolts_data=Header(n,c(4));
        
        
        string=char(ADBitVolts_data);
        space=strfind(string, ' ');
        
        ADBitVolts0=string(space(1)+1:space(2)-1);ADBitVolts0=str2num(ADBitVolts0);
        ADBitVolts1=string(space(2)+1:space(3)-1);ADBitVolts1=str2num(ADBitVolts1);
        ADBitVolts2=string(space(3)+1:space(4)-1);ADBitVolts2=str2num(ADBitVolts2);
        ADBitVolts3=string(space(4)+1:end);ADBitVolts3=str2num(ADBitVolts3);
        vec=[ADBitVolts0 ADBitVolts1 ADBitVolts2 ADBitVolts3];
        
        if(std(vec)~=0)
            msg=['ADBitVolts are different at this file : ' ntt_file];disp(msg);fprintf(fod2,'%s\n',msg);
        end
        
        summary(i_s).ADBitVolts0=sprintf('%1.4f',ADBitVolts0*10^6);
        summary(i_s).ADBitVolts1=sprintf('%1.4f',ADBitVolts1*10^6);
        summary(i_s).ADBitVolts2=sprintf('%1.4f',ADBitVolts2*10^6);
        summary(i_s).ADBitVolts3=sprintf('%1.4f',ADBitVolts3*10^6);
        
        
    else
        disp('ADBitVolts are already in the summary sheet');
    end
    
end
fclose(fod2);