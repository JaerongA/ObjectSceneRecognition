%% By Jaerong 2017/02/13
%% Get the selectivity index from the AUC
%% Get the index based on the bootstrapped baseline

function [Selectivity_peakloc, Selectivity_duration, Selectivity_index, Selectivity_onset, Sig_ind] = get_AUC_SI_bootstrap(AUC, AUC_baseline, AUC_color)


Selectivity_peakloc = nan;
Selectivity_duration = nan;  %% total number of bins over baseline
Selectivity_index = 0;
Selectivity_onset = nan; %% The point of onset of the significance bins
AUC_overbaseline=[];
nb_overbaseline =[];
first_bin_ind=[];
last_bin_ind=[];
Overbaseline_ind=[];


nb_win= 30;
minmax_array = mapminmax([1:nb_win], 0, 1);  %% the number of

global consecutive_crit
global AUC_std_criteria


%% How to determine the range over the baseline

% Overbaseline_ind = find(AUC >= prctile(AUC,percentile));

Overbaseline_ind = find(AUC> (mean(AUC_baseline)+ AUC_std_criteria*std(AUC_baseline)));


% Overbaseline_ind = find(AUC>  AUC_baseline);  %% Bootstrapped baseline





%% T-test method
% sig_mat=[];
%
%
% for bin_run= 1: nb_win
%
%
%
% % sig_mat(bin_run) = ttest(AUC_baseline(:,bin_run),AUC(bin_run),'Alpha',0.01,'Tail','left');
%
% % [p, sig_mat(bin_run), stat] = signrank(AUC_baseline(:,bin_run),AUC(bin_run),'tail','left','alpha',0.01);
% end
%
%
% Overbaseline_ind = find(sig_mat==1);






[first_bin_ind, last_bin_ind]= Get_consecutive_vec(Overbaseline_ind, consecutive_crit);


%
% if ~isempty(first_bin_ind)
%
%     handle= vline(Overbaseline_ind(first_bin_ind(1)));  set(handle,'color',AUC_color,'LineWidth',1.5);
%     handle= vline(Overbaseline_ind(last_bin_ind(1)));  set(handle,'color',AUC_color,'LineWidth',1.5);
% end
%



% handle= hline(prctile(AUC,percentile));  set(handle,'color',AUC_color,'LineWidth',1.5);

Sig_ind = cell(1,size(first_bin_ind,1));

if ~isempty(first_bin_ind)
    
    Selectivity_onset = minmax_array(Overbaseline_ind(first_bin_ind(1)));
    
    
    for bin_run= 1: size(first_bin_ind,1)
        
        AUC_overbaseline = AUC(Overbaseline_ind(first_bin_ind(bin_run): last_bin_ind(bin_run)));
        nb_overbaseline(bin_run)= length(AUC_overbaseline);
        
        Sig_ind{bin_run} = Overbaseline_ind(first_bin_ind(bin_run):last_bin_ind(bin_run));  %% The bin index with a significant value

        
        %% find peak location
        
        max_val(bin_run)= max(AUC_overbaseline);
        
        
        
        %         Selectivity_index(bin_run) =  mean(AUC_overbaseline) * sqrt(nb_overbaseline(bin_run));
        Selectivity_index(bin_run) =  mean(AUC_overbaseline);
        
        
        handle = area(Overbaseline_ind(first_bin_ind(bin_run): last_bin_ind(bin_run)),AUC_overbaseline,'LineStyle',':','FaceColor',AUC_color);
        alpha(.2);
        
    end
    
    
    Selectivity_peakloc = min(minmax_array(find(AUC == max(max_val))));
    
    Selectivity_duration = sum(nb_overbaseline);
    
    
end


if Selectivity_index
    Selectivity_index =  mean(Selectivity_index) * sqrt(sum(Selectivity_duration));
end


% Overbaseline_ind= Overbaseline_ind(first_bin_ind:last_bin_ind);  %% The bin index with a significant value



end