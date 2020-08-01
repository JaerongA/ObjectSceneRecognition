%% Revised for PRC & POR study by AJR 2015/09/21 

function Summary_mat2txt(summary,summary_header,summary_newTXTname)

fod=fopen(summary_newTXTname,'w');
fprintf(fod,'%s\n',summary_header);

[r,c]=size(summary);

for i=1:c
    
    fprintf(fod,'%s',summary(i).Key); 
    fprintf(fod,'\t%s',summary(i).Rat);    
    fprintf(fod,'\t%s',summary(i).Rec_session);
    fprintf(fod,'\t%s',summary(i).Task_name);
    fprintf(fod,'\t%s',summary(i).Task_session);
    fprintf(fod,'\t%s', summary(i).TT);
    fprintf(fod,'\t%s', summary(i).Cluster);
    fprintf(fod,'\t%s', summary(i).Region);   
    fprintf(fod,'\t%s', summary(i).SubRegion);    
    fprintf(fod,'\t%s', summary(i).Layer); 
    fprintf(fod,'\t%s', summary(i).Bregma); 
    fprintf(fod,'\t%s', summary(i).Cell_Category);  %% Bursting, Regular, Nonclassified   (2017/07/03)
    fprintf(fod,'\t%s', summary(i).Isolation_Distance);
    fprintf(fod,'\t%s', summary(i).Lratio);
    fprintf(fod,'\t%s', summary(i).WithinRefPortion);
    fprintf(fod,'\t%s', summary(i).Epoch_FR);
    fprintf(fod,'\t%s', summary(i).Spike_Width);
    fprintf(fod,'\t%s', summary(i).Spike_Height);
    fprintf(fod,'\t%s', summary(i).Cell_type);
    fprintf(fod,'\t%s', summary(i).Zero_FR_Proportion);
    fprintf(fod,'\t%s', summary(i).Quality_ok);
    fprintf(fod,'\t%s', summary(i).Stability_ok);
    fprintf(fod,'\t%s', summary(i).Fitting_category);
    fprintf(fod,'\t%s', summary(i).Polarity);
    fprintf(fod,'\t%s', summary(i).BestFittingOBJ);
    fprintf(fod,'\t%s', summary(i).SigOBJ);  %% The objects showing significant fitting (e.g., 1111 means all objects were significantly fit with regression)
    fprintf(fod,'\t%s', summary(i).BestOBJ_CorrR);  
    fprintf(fod,'\t%s', summary(i).BestOBJ_Slope);  
    fprintf(fod,'\t%s', summary(i).Repetition_OK);  
    fprintf(fod,'\n');
    
end
fclose(fod);

end







