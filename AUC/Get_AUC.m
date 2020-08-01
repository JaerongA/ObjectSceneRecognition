function AUC =  Get_AUC(SDF1, SDF2, nb_win)


FRrate= 1; Stimulus =2;
fr_epoch_mat = [];
global sliding_win
% sliding_win = 4;


for bin_run = 1: nb_win-1
    
    
    fr_epoch_mat = [];
    
    try
        fr_epoch_mat = [mean(SDF1(:,bin_run:bin_run+sliding_win),2) zeros(size(SDF1(:,bin_run:bin_run+sliding_win),1),1) ...
            ; mean(SDF2(:,bin_run:bin_run+sliding_win),2) ones(size(SDF2(:,bin_run:bin_run+sliding_win),1),1) ] ;
    catch
%         fr_epoch_mat = [mean(SDF1(:,bin_run:bin_run+(sliding_win-1)),2) zeros(size(SDF1(:,bin_run:bin_run+(sliding_win-1)),1),1) ...
%             ; mean(SDF2(:,bin_run:bin_run+(sliding_win-1)),2) ones(size(SDF2(:,bin_run:bin_run+(sliding_win-1)),1),1) ] ;
        
        
        fr_epoch_mat = [mean(SDF1(:,bin_run:nb_win),2) zeros(size(SDF1(:,bin_run:nb_win),1),1) ...
            ; mean(SDF2(:,bin_run:nb_win),2) ones(size(SDF2(:,bin_run:nb_win),1),1) ] ;
    end
    
    
    glm= glmfit(fr_epoch_mat(:,FRrate), fr_epoch_mat(:,Stimulus));
    
    logistic = glmval(glm,fr_epoch_mat(:,1),'logit');
    
    [X,Y,T,AUC(bin_run)] = perfcurve(fr_epoch_mat(:,Stimulus),logistic,1);
    
    if  AUC(bin_run) < 0.5
        AUC(bin_run) = 1 - AUC(bin_run);
    end
    
end

        bin_run = bin_run + 1;

if bin_run == nb_win
    
    fr_epoch_mat = [SDF1(:,bin_run) zeros(size(SDF1(:,bin_run),1),1) ...
        ; SDF2(:,bin_run) ones(size(SDF2(:,bin_run),1),1) ] ;
    
    
    glm= glmfit(fr_epoch_mat(:,FRrate), fr_epoch_mat(:,Stimulus));
    
    logistic = glmval(glm,fr_epoch_mat(:,1),'logit');
    
    [X,Y,T,AUC(bin_run)] = perfcurve(fr_epoch_mat(:,Stimulus),logistic,1);
    
    if  AUC(bin_run) < 0.5
        AUC(bin_run) = 1 - AUC(bin_run);
    end
    
end


end
