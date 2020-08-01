function  [summary,summary_header]=  Summary_QualityOK(summary, summary_header, dataROOT)

%% Created by AJR 2016/11/04
%% Tests whether a neuron is usable for analysis

% fr_criteria = 0.5;  %% FR criteria

[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if  strcmp(summary(i_s).Rat,'r558')
        
        %% Set cluster prefix
        
        set_cluster_prefix;
        
        
        
        if (str2num(summary(i_s).Epoch_FR) >= 0.5)  && (str2num(summary(i_s).Zero_FR_Proportion) < 0.5) && (str2num(summary(i_s).Stability_ok)== 1)
            summary(i_s).Quality_ok= sprintf('%d',1);
            
        else
            summary(i_s).Quality_ok= sprintf('%d',0);
        end
        
        
        
    end  % ~strcmp(summary(i_s).Region,'x') && ~strcmp(summary(i_s).Bregma,'?')
    
end

end




