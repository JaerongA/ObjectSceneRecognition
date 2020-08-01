function [aligned_mat aligned_ind] = mat_align_max(pop_mat,smoothingOK, smoothing_factor)

    %% Align by the max value  (By AJR 2016/11/03)
    
    
    
    max_ind= [];
    
    for     cell_run =1: size(pop_mat,1)
        
        [max_val ind]= max(pop_mat(cell_run,:));
        
        %     if max_val == nan
        %         pop_mat(cell_run,:)= [];
        %     else
        max_ind(cell_run) = ind;
        %     end
    end
    
    
    aligned_mat = [max_ind' pop_mat];
    
    aligned_mat= sortrows(aligned_mat,-1);
    
    
    aligned_ind= aligned_mat(:,1);  %% get the aligned index
    
    aligned_mat(:,1) = [];  %% remove the index
    
    aligned_mat = flipud(aligned_mat);  %% flip the matrix upside down
    
    
    if smoothingOK
    
    aligned_mat= smooth2a(aligned_mat,smoothing_factor,smoothing_factor); %% matrix smoothing
    
    end
    
end