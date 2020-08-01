%% By Jaerong 2017/02/08
%% Get cumulative performance vector   
%% Enter binary performance vector as an input

function  cum_avg = get_cumulative_avg(performance_mat)

corr_mat= [];
cum_avg =[];


for trial_run= 2: size(performance_mat,1)
    
    corr_mat=[performance_mat(1:trial_run)];
    cum_avg(end+1)= mean(corr_mat);
    corr_mat=[];
    
end


end