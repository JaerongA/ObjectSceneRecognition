%% By Jaerong

function AUC =  Get_AUC_bootstrapped(SDF1, SDF2, nb_win)


FRrate= 1; Stimulus =2;
sliding_win = 2;
bootstrap_ok=1; bootstrap_ind=1; bootstrap_nb=100;

AUC= nan(bootstrap_nb, nb_win);


for bin_run = 1: nb_win-1
    
    bootstrap_ok=1;
    bootstrap_ind=1;
    fr_epoch_mat = [];
    
    try
        fr_epoch_mat = [mean(SDF1(:,bin_run:bin_run+sliding_win),2) zeros(size(SDF1(:,bin_run:bin_run+sliding_win),1),1) ...
            ; mean(SDF2(:,bin_run:bin_run+sliding_win),2) ones(size(SDF2(:,bin_run:bin_run+sliding_win),1),1) ] ;
    catch
        fr_epoch_mat = [mean(SDF1(:,bin_run:bin_run+(sliding_win-1)),2) zeros(size(SDF1(:,bin_run:bin_run+(sliding_win-1)),1),1) ...
            ; mean(SDF2(:,bin_run:bin_run+(sliding_win-1)),2) ones(size(SDF2(:,bin_run:bin_run+(sliding_win-1)),1),1) ] ;
    end
    
    while bootstrap_ok
        
        fr_vec= fr_epoch_mat(:,FRrate);
        
        fr_vec= fr_vec(randperm(length(fr_vec)));
        
        fr_epoch_mat(:,FRrate) = fr_vec;
        
        
        glm= glmfit(fr_epoch_mat(:,FRrate), fr_epoch_mat(:,Stimulus));
        
        logistic = glmval(glm,fr_epoch_mat(:,1),'logit');
        
        [X,Y,T,AUC(bootstrap_ind,bin_run)] = perfcurve(fr_epoch_mat(:,Stimulus),logistic,1);
        
        
        if  AUC(bootstrap_ind,bin_run) < 0.5
            AUC(bootstrap_ind,bin_run) = 1 - AUC(bootstrap_ind,bin_run);
        end
        
        bootstrap_ind= bootstrap_ind+1;
        
        if bootstrap_ind== bootstrap_nb+1;
            bootstrap_ok=0;
        end
        
    end % bootstrap_ok
    
end



bin_run = bin_run + 1;

if bin_run == nb_win
    
    bootstrap_ok=1;
    bootstrap_ind=1;
    fr_epoch_mat = [];
    
    
    
    fr_epoch_mat = [SDF1(:,bin_run) zeros(size(SDF1(:,bin_run),1),1) ...
        ; SDF2(:,bin_run) ones(size(SDF2(:,bin_run),1),1) ] ;
    
    
    while bootstrap_ok
        
        fr_vec= fr_epoch_mat(:,FRrate);
        
        fr_vec= fr_vec(randperm(length(fr_vec)));
        
        fr_epoch_mat(:,FRrate) = fr_vec;
        
        
        glm= glmfit(fr_epoch_mat(:,FRrate), fr_epoch_mat(:,Stimulus));
        
        logistic = glmval(glm,fr_epoch_mat(:,1),'logit');
        
        [X,Y,T,AUC(bootstrap_ind,bin_run)] = perfcurve(fr_epoch_mat(:,Stimulus),logistic,1);
        
        
        if  AUC(bootstrap_ind,bin_run) < 0.5
            AUC(bootstrap_ind,bin_run) = 1 - AUC(bootstrap_ind,bin_run);
        end
        
        
        bootstrap_ind= bootstrap_ind+1;
        
        if bootstrap_ind== bootstrap_nb+1;
            bootstrap_ok=0;
        end
        
    end % bootstrap_ok
    
end


AUC = mean(AUC);


end
