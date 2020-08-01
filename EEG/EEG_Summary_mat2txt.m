%% Made by Jaerong 2013/05/14
%% Modified on 2017/02/24 for PER & POR ephys analysis
%% This function allow to read the summary_eeg table and create a list of good cluster for batch processing programs

function EEG_Summary_mat2txt(summary_eeg,summary_header,summary_newTXTname_eeg)

fod=fopen(summary_newTXTname_eeg,'w');
fprintf(fod,'%s\n',summary_header);

[r,c]=size(summary_eeg);

for i=1:c
    
    fprintf(fod,'%s',summary_eeg(i).Key); 
    fprintf(fod,'\t%s',summary_eeg(i).Rat);    
    fprintf(fod,'\t%s',summary_eeg(i).Rec_session);
    fprintf(fod,'\t%s',summary_eeg(i).Task_name);
    fprintf(fod,'\t%s',summary_eeg(i).Task_session);
    fprintf(fod,'\t%s', summary_eeg(i).TT);
    fprintf(fod,'\t%s', summary_eeg(i).Region);   
    fprintf(fod,'\t%s', summary_eeg(i).SubRegion);   
    fprintf(fod,'\t%s', summary_eeg(i).Layer);  
    fprintf(fod,'\t%s', summary_eeg(i).Bregma);  
    fprintf(fod,'\t%s', summary_eeg(i).ADBitmicrovolts);  
    fprintf(fod,'\t%s', summary_eeg(i).Reference);  
    fprintf(fod,'\t%s', summary_eeg(i).Ref_Region);  
    fprintf(fod,'\t%s', summary_eeg(i).Nb_Cell); 
    fprintf(fod,'\t%s', summary_eeg(i).Visual_Inspection); 
    fprintf(fod,'\t%s', summary_eeg(i).MaxoutTrials); 
    fprintf(fod,'\t%s', summary_eeg(i).Signal_Power);  %% added 2017/09/20  (integrate the normalized power in the frequency of interest)
    fprintf(fod,'\t%s', summary_eeg(i).Power_criteria);  
    fprintf(fod,'\t%s', summary_eeg(i).Second_revision);  %% added 2018/10/16  (criteria for 2nd revision in CR. probability of max-out trials < 50% and no significant noise. 
    %% Use of
    
    fprintf(fod,'\n');
end
fclose(fod);

end







