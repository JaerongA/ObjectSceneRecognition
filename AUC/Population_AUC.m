%% Created by Jaerong 2017/01/09 for PRC & POR analysis.
%% The program plots population AUC
%% The ROC will run based on the population vector for individual objects (obtained from Get_pop_vector.m).
%% The AUC of the ROC per bin (sliding window of 3) calculated

clc; clear all; close all;
dataROOT= 'F:\PRC_POR_ephys';

%% Parms
mat_range = [0 1];
fig_pos = [20,380,1300,650];
r_plot=5;c_plot=2;
smoothingOK =1;
smoothing_factor =1;  %% 3 by 3 boxcar smoothing window
%         reshape([1:r_plot*c_plot],c_plot,r_plot)'

%% Bin size & number

nb_bins=80;bin_size=0.10; % sec

%% Number of time bins for normalized SDF (2016/10/09)

nb_win=30;

saveOK= 0;


%% Output folder
saveROOT= [dataROOT '\Analysis\AUC\Population_AUC_' date];
if ~exist(saveROOT), mkdir(saveROOT); end


%% Input folder
inputROOT= [dataROOT '\Analysis\Population_vector']; cd(inputROOT);


listing_Task=dir('*OCRS*');

for task_run = 1: size(listing_Task,1)
    
    target_Task= [inputROOT '\' listing_Task(task_run).name]; cd(target_Task);
    
    
    Task_name = target_Task(findstr(target_Task,'OCRS'):end);
    
    % if strcmp(Task_name, 'OCRS(TwoOBJ)')
    
    
    
    % if     strcmp(Task_name,'OCRS(FourOBJ)')
    %
    %
    %     %% Stimulus
    %     Icecream = 1;
    %     House = 2;
    %     Owl = 3;
    %     Phone = 4;
    %
    % elseif    strcmp(Task_name,'OCRS(SceneOBJ)')
    %
    %
    %     %% Stimulus
    %     Zebra = 1;
    %     Pebbles = 2;
    %     Owl = 3;
    %     Phone = 4;
    %
    %
    % end
    
    
    
    
    %% Cell listing
    listing_IntHIPP=dir('*IntHIPP*');
    listing_PER=dir('*PER*');
    listing_POR=dir('*POR*');
    
    
    
    %% Make pop matrices
    AUC_mat = [];
    IntHIPP_mat = [];
    PER_mat = [];
    POR_mat = [];
    
    
    cell_ind= 0;
    
    if     strcmp(Task_name,'OCRS(TwoOBJ)')
        
        
        
        for cell_run=  1:size(listing_IntHIPP,1)
            
            load(listing_IntHIPP(cell_run).name);
            disp(['Loading...  '     listing_IntHIPP(cell_run).name]);
            
            cell_ind= cell_ind + 1;
            
            
            IntHIPP_mat.Stimulus1(cell_run,:) = SDF.Stimulus1_Corr;
            IntHIPP_mat.Stimulus2(cell_run,:) = SDF.Stimulus2_Corr;
            
        end
        
        
        
        cell_ind= 0;
        
        for cell_run=  1:size(listing_PER,1)
            
            load(listing_PER(cell_run).name);
            disp(['Loading...  '     listing_PER(cell_run).name]);
            
            cell_ind= cell_ind + 1;
            
            PER_mat.Stimulus1(cell_run,:) = SDF.Stimulus1_Corr;
            PER_mat.Stimulus2(cell_run,:) = SDF.Stimulus2_Corr;
            
            
        end
        
        
        
        cell_ind= 0;
        
        for cell_run=  1:size(listing_POR,1)
            
            load(listing_POR(cell_run).name);
            disp(['Loading...  '     listing_POR(cell_run).name]);
            
            cell_ind= cell_ind + 1;
            
            POR_mat.Stimulus1(cell_run,:) = SDF.Stimulus1_Corr;
            POR_mat.Stimulus2(cell_run,:) = SDF.Stimulus2_Corr;
            
        end
        
        
    else
        
        for cell_run=  1:size(listing_IntHIPP,1)
            
            load(listing_IntHIPP(cell_run).name);
            disp(['Loading...  '     listing_IntHIPP(cell_run).name]);
            
            cell_ind= cell_ind + 1;
            
            
            IntHIPP_mat.Stimulus1(cell_run,:) = SDF.Stimulus1_Corr;
            IntHIPP_mat.Stimulus2(cell_run,:) = SDF.Stimulus2_Corr;
            IntHIPP_mat.Stimulus3(cell_run,:) = SDF.Stimulus3_Corr;
            IntHIPP_mat.Stimulus4(cell_run,:) = SDF.Stimulus4_Corr;
            
        end
        
        
        
        cell_ind= 0;
        
        for cell_run=  1:size(listing_PER,1)
            
            load(listing_PER(cell_run).name);
            disp(['Loading...  '     listing_PER(cell_run).name]);
            
            cell_ind= cell_ind + 1;
            
            PER_mat.Stimulus1(cell_run,:) = SDF.Stimulus1_Corr;
            PER_mat.Stimulus2(cell_run,:) = SDF.Stimulus2_Corr;
            PER_mat.Stimulus3(cell_run,:) = SDF.Stimulus3_Corr;
            PER_mat.Stimulus4(cell_run,:) = SDF.Stimulus4_Corr;
            
            
        end
        
        
        
        
        cell_ind= 0;
        
        for cell_run=  1:size(listing_POR,1)
            
            load(listing_POR(cell_run).name);
            disp(['Loading...  '     listing_POR(cell_run).name]);
            
            cell_ind= cell_ind + 1;
            
            POR_mat.Stimulus1(cell_run,:) = SDF.Stimulus1_Corr;
            POR_mat.Stimulus2(cell_run,:) = SDF.Stimulus2_Corr;
            POR_mat.Stimulus3(cell_run,:) = SDF.Stimulus3_Corr;
            POR_mat.Stimulus4(cell_run,:) = SDF.Stimulus4_Corr;
            
        end
        
        
        
    end
    
    
    
    
    
    
    if     strcmp(Task_name,'OCRS(FourOBJ)')
        
        AUC.IntHIPP.Familiar =  Get_AUC(IntHIPP_mat.Stimulus1, IntHIPP_mat.Stimulus2, nb_win);
        AUC.IntHIPP.Novel =  Get_AUC(IntHIPP_mat.Stimulus3, IntHIPP_mat.Stimulus4, nb_win);
        
        
        AUC.PER.Familiar =  Get_AUC(PER_mat.Stimulus1, PER_mat.Stimulus2, nb_win);
        AUC.PER.Novel =  Get_AUC(PER_mat.Stimulus3, PER_mat.Stimulus4, nb_win);
        
        
        AUC.POR.Familiar =  Get_AUC(POR_mat.Stimulus1, POR_mat.Stimulus2, nb_win);
        AUC.POR.Novel =  Get_AUC(POR_mat.Stimulus3, POR_mat.Stimulus4, nb_win);
        
        
        
    elseif    strcmp(Task_name,'OCRS(SceneOBJ)')
        
        
        AUC.IntHIPP.Scene =  Get_AUC(IntHIPP_mat.Stimulus1, IntHIPP_mat.Stimulus2, nb_win);
        AUC.IntHIPP.OBJ =  Get_AUC(IntHIPP_mat.Stimulus3, IntHIPP_mat.Stimulus4, nb_win);
        
        
        AUC.PER.Scene =  Get_AUC(PER_mat.Stimulus1, PER_mat.Stimulus2, nb_win);
        AUC.PER.OBJ =  Get_AUC(PER_mat.Stimulus3, PER_mat.Stimulus4, nb_win);
        
        
        AUC.POR.Scene =  Get_AUC(POR_mat.Stimulus1, POR_mat.Stimulus2, nb_win);
        AUC.POR.OBJ =  Get_AUC(POR_mat.Stimulus3, POR_mat.Stimulus4, nb_win);
        
        
        
    elseif    strcmp(Task_name,'OCRS(TwoOBJ)')
        
        
        AUC.IntHIPP =  Get_AUC(IntHIPP_mat.Stimulus1, IntHIPP_mat.Stimulus2, nb_win);
        
        AUC.PER =  Get_AUC(PER_mat.Stimulus1, PER_mat.Stimulus2, nb_win);
        
        AUC.POR =  Get_AUC(POR_mat.Stimulus1, POR_mat.Stimulus2, nb_win);
        
        
    end
    
    
    
    %
    % AUC_sum.IntHIPP.Scene= sum(AUC.IntHIPP.Scene)
    % AUC_sum.IntHIPP.OBJ= sum(AUC.IntHIPP.OBJ)
    %
    % AUC_sum.PER.Scene= sum(AUC.PER.Scene)
    % AUC_sum.PER.OBJ= sum(AUC.PER.OBJ)
    %
    % AUC_sum.POR.Scene= sum(AUC.POR.Scene)
    % AUC_sum.POR.OBJ= sum(AUC.POR.OBJ)
    %
    
    
    
    % AUC_mean.IntHIPP.Scene= mean(AUC.IntHIPP.Scene)
    % AUC_mean.IntHIPP.OBJ= mean(AUC.IntHIPP.OBJ)
    %
    % AUC_mean.PER.Scene= mean(AUC.PER.Scene)
    % AUC_mean.PER.OBJ= mean(AUC.PER.OBJ)
    %
    % AUC_mean.POR.Scene= mean(AUC.POR.Scene)
    % AUC_mean.POR.OBJ= mean(AUC.POR.OBJ)
    
    
    
    
    %% Plot average
    
    %% Plot the results
    picID = figure('color',[1 1 1],'pos', fig_pos);
    subplot('Position', [0.4 0.99 0.4 0.2]);
    text(0,0,Task_name);
    axis off;
    
    
    
    
    if     strcmp(Task_name,'OCRS(FourOBJ)')
        
        
        subplot(2,3,1)
        title(['IntHIPP(n=' sprintf('%d',size(listing_IntHIPP,1)) ')']); hold on;
        plot([0:nb_win-1],(AUC.IntHIPP.Familiar),'linewidth',4);
        plot([0:nb_win-1],(AUC.IntHIPP.Novel),'linewidth',4); ylim([0.5 0.7]);
        legend('Familiar','Novel','location','northwest');
        ylabel('Population AUC');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        subplot(2,3,2)
        title(['PER(n=' sprintf('%d',size(listing_PER,1)) ')']); hold on;
        plot([0:nb_win-1],(AUC.PER.Familiar),'linewidth',4);
        plot([0:nb_win-1],(AUC.PER.Novel),'linewidth',4); ylim([0.5 0.7]);
        legend('Familiar','Novel','location','northwest');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        subplot(2,3,3)
        title(['POR(n=' sprintf('%d',size(listing_POR,1)) ')']); hold on;
        plot([0:nb_win-1],(AUC.POR.Familiar),'linewidth',4);
        plot([0:nb_win-1],(AUC.POR.Novel),'linewidth',4); ylim([0.5 0.7]);
        legend('Familiar','Novel','location','northwest');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        
        subplot(2,3,4)
        title('Familiar'); hold on;
        plot([0:nb_win-1],(AUC.IntHIPP.Familiar),'m','linewidth',4);
        plot([0:nb_win-1],(AUC.PER.Familiar),'g','linewidth',4);
        plot([0:nb_win-1],(AUC.POR.Familiar),'k','linewidth',4); ylim([0.5 0.7]);
        legend('IntHIPP','PER','POR','location','northwest');
        ylabel('Population AUC');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        
        subplot(2,3,5)
        title('Novel'); hold on;
        plot([0:nb_win-1],(AUC.IntHIPP.Novel),'m','linewidth',4);
        plot([0:nb_win-1],(AUC.PER.Novel),'g','linewidth',4);
        plot([0:nb_win-1],(AUC.POR.Novel),'k','linewidth',4); ylim([0.5 0.7]);
        legend('IntHIPP','PER','POR','location','northwest');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        
        
        
    elseif    strcmp(Task_name,'OCRS(SceneOBJ)')
        
        
        subplot(2,3,1)
        title(['IntHIPP(n=' sprintf('%d',size(listing_IntHIPP,1)) ')']); hold on;
        plot([0:nb_win-1],(AUC.IntHIPP.Scene),'linewidth',5);
        plot([0:nb_win-1],(AUC.IntHIPP.OBJ),'linewidth',5); ylim([0.5 0.8]);
        legend('Scene','OBJ','location','northwest');
        ylabel('Population AUC');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        subplot(2,3,2)
        title(['PER(n=' sprintf('%d',size(listing_PER,1)) ')']); hold on;
        plot([0:nb_win-1],(AUC.PER.Scene),'linewidth',5);
        plot([0:nb_win-1],(AUC.PER.OBJ),'linewidth',5); ylim([0.5 0.8]);
        legend('Scene','OBJ','location','northwest');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        subplot(2,3,3)
        title(['POR(n=' sprintf('%d',size(listing_POR,1)) ')']); hold on;
        plot([0:nb_win-1],(AUC.POR.Scene),'linewidth',5);
        plot([0:nb_win-1],(AUC.POR.OBJ),'linewidth',5); ylim([0.5 0.8]);
        legend('Scene','OBJ','location','northwest');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        
        subplot(2,3,4)
        title('Scene'); hold on;
        plot([0:nb_win-1],(AUC.IntHIPP.Scene),'m','linewidth',4);
        plot([0:nb_win-1],(AUC.PER.Scene),'g','linewidth',4);
        plot([0:nb_win-1],(AUC.POR.Scene),'k','linewidth',4); ylim([0.5 0.8]);
        legend('IntHIPP','PER','POR','location','northwest');
        ylabel('Population AUC');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        
        subplot(2,3,5)
        title('OBJ'); hold on;
        plot([0:nb_win-1],(AUC.IntHIPP.OBJ),'m','linewidth',4);
        plot([0:nb_win-1],(AUC.PER.OBJ),'g','linewidth',4);
        plot([0:nb_win-1],(AUC.POR.OBJ),'k','linewidth',4); ylim([0.5 0.8]);
        legend('IntHIPP','PER','POR','location','northwest');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        
        
    elseif    strcmp(Task_name,'OCRS(TwoOBJ)')
        
        
        
        subplot(2,3,1)
        title(['IntHIPP(n=' sprintf('%d',size(listing_IntHIPP,1)) ')']); hold on;
        plot([0:nb_win-1],(AUC.IntHIPP),'linewidth',5); ylim([0.5 0.7]);
        ylabel('Population AUC');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        subplot(2,3,2)
        title(['PER(n=' sprintf('%d',size(listing_PER,1)) ')']); hold on;
        plot([0:nb_win-1],(AUC.PER),'linewidth',5); ylim([0.5 0.7]);
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        subplot(2,3,3)
        title(['POR(n=' sprintf('%d',size(listing_POR,1)) ')']); hold on;
        plot([0:nb_win-1],(AUC.POR),'linewidth',5); ylim([0.5 0.7]);
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        
        subplot(2,3,4)
        plot([0:nb_win-1],(AUC.IntHIPP),'m','linewidth',4); hold
        plot([0:nb_win-1],(AUC.PER),'g','linewidth',4);
        plot([0:nb_win-1],(AUC.POR),'k','linewidth',4); ylim([0.5 0.7]);
        legend('IntHIPP','PER','POR','location','northwest');
        ylabel('Population AUC');
        xlim([0 nb_win-1]);
        set(gca, 'XTick',[0 nb_win-1], 'XTickLabel',{'Onset' ;'Choice'});
        
        
    end
    
    
    
    if saveOK
        
        
        cd(saveROOT);
        filename= [Task_name '.bmp'];
        filename_ai= [Task_name '.eps'];
        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        saveas(picID,filename);
        close all;
        
    else
        
        close all;
    end
    
    
    
    
end

% caxis(mat_range)

% figure()
% dendrogram(aligned_ind.IntHIPP.Scene)
%

%
% %% Align by the max value
%
% max_ind= [];
%
% for     cell_run =1: size(pop_mat,1)
%
%     [max_val ind]= max(pop_mat(cell_run,:));
%
%     %     if max_val == nan
%     %         pop_mat(cell_run,:)= [];
%     %     else
%     max_ind(cell_run) = ind;
%     %     end
% end
%
%
% pop_mat_align = [max_ind' pop_mat];
%
% pop_mat_align= sortrows(pop_mat_align,-1);
%
% pop_mat_align(:,1) = [];
%
%
%
%
%
% thisAlphaZ = corrMAT; thisAlphaZ(isnan(corrMAT)) = 0; thisAlphaZ(~isnan(corrMAT)) = 1;
% imagesc(corrMAT); alpha(thisAlphaZ); caxis(mat_range); colorbar('Position', [.869 .717 .027 .204], 'YTick', [-.99 0 .99], 'YTickLabel', {'-1.0'; '0.5'; '1.0'});
% axis image;
% xlabel(['barney'],'fontsize',13,'fontweight','bold'); ylabel(['egg'],'fontsize',13,'fontweight','bold');
% session_name= strrep(session_name,'_','-');
% title(session_name,'fontsize',13);
% evt_ts=[];
% evt_ts= ts_evt_med./0.2;
% set(gca,'xtick',evt_ts,'xticklabel',[0 1 2 3],'ytick',evt_ts,'yticklabel',[0 1 2 3],'ydir','normal','ticklength',[0 0]);
%
% filename= [session_name '_corrMAT.bmp'];
% filename_ai= [session_name '_corrMAT.eps'];
% saveas(picID,filename); print('-dpsc2', '-noui', '-adobecset', '-painters', filename_ai)
% close all;
%
%



