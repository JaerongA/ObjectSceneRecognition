%% Made by Jaerong 2013/05/14
%% Modified on 2017/02/24 for PER & POR ephys analysis
%% This function allow to read the summary_eeg table and create a list of good cluster for batch processing programs

function [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat(summary_newTXTname_eeg,summary_MATname_eeg)


%% TO LOAD THE summary_eeg_TABLE

fsum=fopen(summary_newTXTname_eeg,'r');

summary_eeg = struct('Key','?',...
    'Rat','?',...
    'Rec_session','?',...
    'Task_name','?',...
    'Task_session','?',...
    'TT','?',...
    'Region','?',...
    'SubRegion','?',...
    'Layer','?',...
    'Bregma','?',...
    'ADBitmicrovolts','?',...  %% added 2017/09/19
    'Reference','?',...
    'Ref_Region','?',...
    'Nb_Cell','?',...
    'Visual_Inspection','?',...  %% added 2017/09/01
    'MaxoutTrials','?',...  %% added 2017/09/17
    'Signal_Power','?',...   %% added 2017/09/20  (integrate the normalized power in the frequency of interest)
    'Power_criteria','?',...  %% added 2017/09/20  (integrate the normalized power in the frequency of interest) initial criteria
    'Second_revision','?');  %% added 2018/10/16  


i=0;
summary_header_eeg=fgetl(fsum);
remain=[];token=[];

remain=fgetl(fsum);

while ischar(remain)
    
    i=i+1;
    [summary_eeg(i).Key, remain] = strtok(remain,char(9));
    [summary_eeg(i).Rat, remain] = strtok(remain,char(9));
    [summary_eeg(i).Rec_session, remain] = strtok(remain,char(9));
    l=length(summary_eeg(i).Rec_session);
    if l==1, summary_eeg(i).Rec_session=['0' summary_eeg(i).Rec_session]; end
    [summary_eeg(i).Task_name, remain] = strtok(remain,char(9));
    [summary_eeg(i).Task_session, remain] = strtok(remain,char(9));
    l=length(summary_eeg(i).Task_session);
    if l==1, summary_eeg(i).Task_session=['0' summary_eeg(i).Task_session]; end
    [summary_eeg(i).TT, remain] = strtok(remain,char(9));
    [summary_eeg(i).Region, remain] = strtok(remain,char(9));
    [summary_eeg(i).SubRegion, remain] = strtok(remain,char(9));
    [summary_eeg(i).Layer, remain] = strtok(remain,char(9));
    [summary_eeg(i).Bregma, remain] = strtok(remain,char(9));
    [summary_eeg(i).ADBitmicrovolts, remain] = strtok(remain,char(9));
    [summary_eeg(i).Reference, remain] = strtok(remain,char(9));
    [summary_eeg(i).Ref_Region, remain] = strtok(remain,char(9));
    [summary_eeg(i).Nb_Cell, remain] = strtok(remain,char(9));
    [summary_eeg(i).Visual_Inspection, remain] = strtok(remain,char(9));
    [summary_eeg(i).MaxoutTrials, remain] = strtok(remain,char(9));
    [summary_eeg(i).Signal_Power, remain] = strtok(remain,char(9));
    [summary_eeg(i).Power_criteria, remain] = strtok(remain,char(9));
    [summary_eeg(i).Second_revision, remain] = strtok(remain,char(9));
    
    remain=fgetl(fsum);
end


fclose(fsum);

save(summary_MATname_eeg,'summary_eeg','summary_header_eeg');
msg=sprintf('%d csc file were loaded',i);
disp(msg);

end