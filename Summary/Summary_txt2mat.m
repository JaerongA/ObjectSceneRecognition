%% Revised for PRC & POR ephys recording 2015/09/24

function [summary,summary_header]=Summary_txt2mat(summaryTXT_filename,summaryMAT_filename)


%% TO LOAD THE SUMMARY_TABLE

fsum=fopen(summaryTXT_filename,'r');

summary = struct('Key','?',...
    'Rat','?',...
    'Rec_session','?',...
    'Task_name','?',...
    'Task_session','?',...
    'TT','?',...
    'Cluster','?',...
    'Region','?',...
    'SubRegion','?',...
    'Layer','?',...
    'Bregma','?',...
    'Cell_Category','?',...
    'Isolation_Distance','?',...
    'Lratio','?',...
    'WithinRefPortion','?',...
    'Epoch_FR','?',...
    'Spike_Width','?',...   %% 2018/05/24
    'Spike_Height','?',...  %% 2018/05/24
    'Cell_type','?',...   %% 2018/05/24
    'Zero_FR_Proportion','?',...     %% Proportion of trials with no spikes (2017/06/30 for repetition anayses)
    'Quality_ok','?',...  %% 1 for units that passed the quality criteria (stability ok & zero spike trial proportion < 50%, firing rate >= 0.5 Hz)  2018/05/26
    'Stability_ok','?',... %% Stability of a neuron (waveform similarity 2014/07/21)
    'Fitting_category','?',...     %% 2017/09/28
    'Polarity','?',...     %% 2017/09/28
    'BestFittingOBJ','?',...     %% 2017/09/28
    'SigOBJ','?',...    %% 2017/10/13
    'BestOBJ_CorrR','?',...    %% 2018/01/06
    'BestOBJ_Slope','?',...    %% 2018/01/06
    'Repetition_OK','?');  %% added 2018/06/02  (Labeling of neurons that were used for the repetition analysis (Spikes in the smaller half >= 30)
   


i=0;
summary_header=fgetl(fsum);
remain=[];token=[];


remain=fgetl(fsum);
while ischar(remain)
    
    i=i+1;
    [summary(i).Key, remain] = strtok(remain,char(9));
    [summary(i).Rat, remain] = strtok(remain,char(9));
    [summary(i).Rec_session, remain] = strtok(remain,char(9));
    l=length(summary(i).Rec_session);
    if l==1, summary(i).Rec_session=['0' summary(i).Rec_session]; end
    [summary(i).Task_name, remain] = strtok(remain,char(9));
    [summary(i).Task_session, remain] = strtok(remain,char(9));
    [summary(i).TT, remain] = strtok(remain,char(9));
    [summary(i).Cluster, remain] = strtok(remain,char(9));
    [summary(i).Region, remain] = strtok(remain,char(9));
    [summary(i).SubRegion, remain] = strtok(remain,char(9));
    [summary(i).Layer, remain] = strtok(remain,char(9));
    [summary(i).Bregma, remain] = strtok(remain,char(9));
    [summary(i).Cell_Category, remain] = strtok(remain,char(9));  %% Bursting, Regular, Nonclassified   (2017/07/03)
    [summary(i).Isolation_Distance,remain] = strtok(remain,char(9));
    [summary(i).Lratio,remain] = strtok(remain,char(9));
    [summary(i).WithinRefPortion,remain] = strtok(remain,char(9));
    [summary(i).Epoch_FR,remain] = strtok(remain,char(9));
    [summary(i).Spike_Width,remain] = strtok(remain,char(9));
    [summary(i).Spike_Height,remain] = strtok(remain,char(9));
    [summary(i).Cell_type,remain] = strtok(remain,char(9));
    [summary(i).Zero_FR_Proportion,remain] = strtok(remain,char(9));
    [summary(i).Quality_ok,remain] = strtok(remain,char(9));
    [summary(i).Stability_ok,remain] = strtok(remain,char(9));
    [summary(i).Fitting_category,remain] = strtok(remain,char(9));
    [summary(i).Polarity,remain] = strtok(remain,char(9));
    [summary(i).BestFittingOBJ,remain] = strtok(remain,char(9));
    [summary(i).SigOBJ,remain] = strtok(remain,char(9));
    [summary(i).BestOBJ_CorrR,remain] = strtok(remain,char(9));
    [summary(i).BestOBJ_Slope,remain] = strtok(remain,char(9));
    [summary(i).Repetition_OK,remain] = strtok(remain,char(9));
    
    
    remain=fgetl(fsum);
end

fclose(fsum);

save(summaryMAT_filename,'summary','summary_header');
msg=sprintf('%d neurons were loaded',i);
disp(msg);

end