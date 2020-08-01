%% By Jaerong 2017/02/13
%% Get the selectivity index from the AUC

function [Selectivity_index, Selectivity_latency, Overbaseline_ind, nb_overbaseline] = get_AUC_SI(AUC, AUC_color)




Selectivity_index = 0;
Selectivity_latency = nan;
AUC_overbaseline=[];
nb_overbaseline =[];
first_bin_ind=[];
last_bin_ind=[];



nb_win= 30;
minmax_array = mapminmax([1:nb_win], 0, 1);  %% the number of

global consecutive_crit
global criteria_percentile



%% How to calculate the baseline

% Overbaseline_ind = find(AUC >= prctile(AUC,criteria_percentile));

Overbaseline_ind = find(AUC> mean(AUC)+ 2*std(AUC));


% Overbaseline_ind = find(AUC>  AUC_baseline);  %% Bootstrapped baseline




[first_bin_ind, last_bin_ind]= Get_consecutive_vec(Overbaseline_ind, consecutive_crit);


% 
% if ~isempty(first_bin_ind)
%     
%     handle= vline(Overbaseline_ind(first_bin_ind(1)));  set(handle,'color',AUC_color,'LineWidth',1.5);
%     handle= vline(Overbaseline_ind(last_bin_ind(1)));  set(handle,'color',AUC_color,'LineWidth',1.5);
% end
% 



% handle= hline(prctile(AUC,criteria_percentile));  set(handle,'color',AUC_color,'LineWidth',1.5);



if ~isempty(first_bin_ind)
    
    Selectivity_latency = minmax_array(Overbaseline_ind(first_bin_ind(1)));
    
    
    for bin_run= 1: size(first_bin_ind,1)
        
        AUC_overbaseline = AUC(Overbaseline_ind(first_bin_ind(bin_run): last_bin_ind(bin_run)));
        nb_overbaseline(bin_run)= length(AUC_overbaseline);
        Selectivity_index(bin_run) =  mean(AUC_overbaseline) * sqrt(nb_overbaseline(bin_run));
        Selectivity_index(bin_run) =  mean(AUC_overbaseline);
        
        
        handle = area(Overbaseline_ind(first_bin_ind(bin_run): last_bin_ind(bin_run)),AUC_overbaseline,'LineStyle',':','FaceColor',AUC_color);
        alpha(.2);
        
    end
    
end



if Selectivity_index
    Selectivity_index =  mean(Selectivity_index) * sqrt(sum(nb_overbaseline));
end


end