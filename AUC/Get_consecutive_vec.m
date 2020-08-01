%% By Jaerong 2016/10/25
%% The function detects and returns the index of a continous block in a vector

function  [first_bin_ind, last_bin_ind]= Get_consecutive_vec(overbaseline_ind, consecutive_crit)


first_bin_ind =[];
last_bin_ind =[];


diff_ind = diff(overbaseline_ind);

if sum(diff_ind==1) >= consecutive_crit-1
    
    
    runs= contiguous(diff_ind,1);
    
    cont_block = runs{1,2};
    
        bin_ind= 1;
    
    
    for cont_run = 1: size(cont_block,1)
        
        
        cont_ind= cont_block(cont_run,:);
        
        if diff(cont_ind) >= consecutive_crit-2
            
            cont_ind(end)= cont_ind(end) +1;
            
            first_bin_ind(bin_ind,:)= cont_ind(1);
            last_bin_ind(bin_ind,:)= cont_ind(end);
            
            bin_ind= bin_ind +1;
        end
    end
    
end


end