function Repetition_Population_FR(dataROOT)

%% Created by AJR 2017/07/10 for PRC & POR analysis.


%% Input folder

dataROOT= 'F:\PRC_POR_ephys\Analysis\Repetition_Suppression\20-Jul-2017';

cd(dataROOT);



%% Output folder

saveROOT= [dataROOT '\Analysis\Repetition_Suppression\PopulationFR'];
if ~exist(saveROOT), mkdir(saveROOT); end





%% Parms

nb_win = 30;

mat_range = [0 1];
fig_pos = [70,100,550,900];
r_plot=5;c_plot=2;

smoothingOK =1;
smoothing_factor =1;  %% 3 by 3 boxcar smoothing window
%         reshape([1:r_plot*c_plot],c_plot,r_plot)'




%% Cell listing
listing_IntHIPP=dir('*IntHIPP*');
listing_PER=dir('*PER*');
listing_POR=dir('*POR*');



%% Make pop matrices

Pop_mat = [];


cell_ind.positive= 0;
cell_ind.negative= 0;

for cell_run=  1:size(listing_IntHIPP,1)
    
    load(listing_IntHIPP(cell_run).name);
    disp(['Loading...  '     listing_IntHIPP(cell_run).name]);
    
    
    if findstr(listing_IntHIPP(cell_run).name,'positive')
        
        cell_ind.positive= cell_ind.positive + 1;
        
        Pop_mat.IntHIPP.positive(cell_ind.positive,:) = mean_fr_block;
        
    else
        
        cell_ind.negative= cell_ind.negative + 1;
        
        Pop_mat.IntHIPP.negative(cell_ind.negative,:) = mean_fr_block;
        
    end
    
end




cell_ind.positive= 0;
cell_ind.negative= 0;

for cell_run=  1:size(listing_PER,1)
    
    load(listing_PER(cell_run).name);
    disp(['Loading...  '     listing_PER(cell_run).name]);
    
    
    if findstr(listing_PER(cell_run).name,'positive')
        
        cell_ind.positive= cell_ind.positive + 1;
        
        Pop_mat.PER.positive(cell_ind.positive,:) = mean_fr_block;
        
    else
        
        cell_ind.negative= cell_ind.negative + 1;
        
        Pop_mat.PER.negative(cell_ind.negative,:) = mean_fr_block;
        
    end
    
end



cell_ind.positive= 0;
cell_ind.negative= 0;

for cell_run=  1:size(listing_POR,1)
    
    load(listing_POR(cell_run).name);
    disp(['Loading...  '     listing_POR(cell_run).name]);
    
    
    if findstr(listing_POR(cell_run).name,'positive')
        
        cell_ind.positive= cell_ind.positive + 1;
        
        Pop_mat.POR.positive(cell_ind.positive,:) = mean_fr_block;
        
    else
        
        cell_ind.negative= cell_ind.negative + 1;
        
        Pop_mat.POR.negative(cell_ind.negative,:) = mean_fr_block;
        
    end
    
end





    
    
    % [Pop_mat.IntHIPP.Scene aligned_ind.IntHIPP.Scene]  = mat_align_max(Pop_mat.IntHIPP.Scene,smoothingOK, smoothing_factor);
    % [Pop_mat.IntHIPP.OBJ aligned_ind.IntHIPP.OBJ]  = mat_align_max(Pop_mat.IntHIPP.OBJ,smoothingOK, smoothing_factor);
    %
    %
    % [Pop_mat.PER.Scene aligned_ind.PER.Scene]  = mat_align_max(Pop_mat.PER.Scene,smoothingOK, smoothing_factor);
    % [Pop_mat.PER.OBJ aligned_ind.PER.OBJ]  = mat_align_max(Pop_mat.PER.OBJ,smoothingOK, smoothing_factor);
    %
    %
    % [Pop_mat.POR.Scene aligned_ind.POR.Scene]  = mat_align_max(Pop_mat.POR.Scene,smoothingOK, smoothing_factor);
    % [Pop_mat.POR.OBJ aligned_ind.POR.OBJ]  = mat_align_max(Pop_mat.POR.OBJ,smoothingOK, smoothing_factor);
    
    
    
    
    
    
    %% Plot the results
    picID = figure('color',[1 1 1],'pos', fig_pos);
    
%     colormap(flipud(hot))
    colormap(jet)
    %% IntHIPP
    subplot('position',[0.15 0.68 0.2 0.25]);
    imagesc(Pop_mat.IntHIPP.positive);title('IntHIPP(Positive)'); box off;
    set(gca, 'YTick',[1 size(Pop_mat.IntHIPP.positive,1)], 'YTickLabel',[1 size(Pop_mat.IntHIPP.positive,1)],'fontsize',10);
    set(gca, 'XTick',[1 size(Pop_mat.IntHIPP.positive,2)])
%     xlabel('Trial Block');     ylabel('Cell #');
    
    subplot('position',[0.5 0.68 0.2 0.25]);
    imagesc(Pop_mat.IntHIPP.negative);title('IntHIPP(Negative)'); box off;
    set(gca, 'YTick',[1 size(Pop_mat.IntHIPP.negative,1)], 'YTickLabel',[1 size(Pop_mat.IntHIPP.negative,1)],'fontsize',10);
    set(gca, 'XTick',[1 size(Pop_mat.IntHIPP.negative,2)]);
%     xlabel('Trial Block');     ylabel('Cell #');
    
    
    
    
    %% PER
    subplot('position',[0.15 0.4 0.2 0.22]);
    imagesc(Pop_mat.PER.positive);title('PER(positive)'); box off;
    set(gca, 'YTick',[1 size(Pop_mat.PER.positive,1)], 'YTickLabel',[1 size(Pop_mat.PER.positive,1)],'fontsize',10);
    set(gca, 'XTick',[1 size(Pop_mat.PER.positive,2)]);
%     xlabel('Trial Block');     ylabel('Cell #');
    
    subplot('position',[0.5 0.4 0.2 0.22]);
    imagesc(Pop_mat.PER.negative);title('PER(negative)'); box off;
    set(gca, 'YTick',[1 size(Pop_mat.PER.negative,1)], 'YTickLabel',[1 size(Pop_mat.PER.negative,1)],'fontsize',10);
    set(gca, 'XTick',[1 size(Pop_mat.PER.negative,2)]);
    xlabel('Trial Block');     ylabel('Cell #');

    
    
    
    %% POR
    subplot('position',[0.15 0.16 0.2 0.15]);
    imagesc(Pop_mat.POR.positive);title('POR(positive)'); box off;
    set(gca, 'YTick',[1 size(listing_POR,1)], 'YTickLabel',[1 size(listing_POR,1)],'fontsize',10);
    set(gca, 'XTick',[1 size(Pop_mat.POR.Scene,2)], 'XTickLabel',{'Onset' ;'Choice'});
    ylabel('Cell #');
    xlabel('Trial Block');     ylabel('Cell #');
    
    
    subplot('position',[0.5 0.16 0.2 0.15]);
    imagesc(Pop_mat.POR.OBJ);title('POR(OBJ)'); box off;
    set(gca, 'YTick',[], 'YTickLabel',[]);
    set(gca, 'XTick',[1 size(Pop_mat.POR.OBJ,2)], 'XTickLabel',{'Onset' ;'Choice'},'YTickLabel',[],'fontsize',10);
    xlabel('Trial Block');     ylabel('Cell #');
    
    
    
    %% Plot average
    
    figure('color',[1 1 1]);
    subplot(2,3,1)
    title('Scene'); hold on;
    plot(mean(Pop_mat.IntHIPP.Scene),'linewidth',5);
    plot(mean(Pop_mat.PER.Scene),'linewidth',5);
    plot(mean(Pop_mat.POR.Scene),'linewidth',5); ylim([0.5 0.7]);
    legend('IntHIPP','PER','POR','location','southeast')
    set(gca, 'XTick',[0 size(Pop_mat.POR.OBJ,2)], 'XTickLabel',{'Onset' ;'Choice'});
    
    subplot(2,3,2)
    title('OBJ'); hold on;
    plot(mean(Pop_mat.IntHIPP.OBJ),'linewidth',5);
    plot(mean(Pop_mat.PER.OBJ),'linewidth',5);
    plot(mean(Pop_mat.POR.OBJ),'linewidth',5); ylim([0.5 0.7]);
    legend('IntHIPP','PER','POR','location','southeast')
    set(gca, 'XTick',[0 size(Pop_mat.POR.OBJ,2)], 'XTickLabel',{'Onset' ;'Choice'});
    
    subplot(2,3,4)
    title('IntHIPP'); hold on;
    plot(mean(Pop_mat.IntHIPP.OBJ),'linewidth',5);
    plot(mean(Pop_mat.IntHIPP.Scene),'linewidth',5); ylim([0.5 0.7]);
    legend('OBJ','Scene','location','southeast')
    set(gca, 'XTick',[0 size(Pop_mat.POR.OBJ,2)], 'XTickLabel',{'Onset' ;'Choice'});
    
    subplot(2,3,5)
    title('PER'); hold on;
    plot(mean(Pop_mat.PER.OBJ),'linewidth',5);
    plot(mean(Pop_mat.PER.Scene),'linewidth',5); ylim([0.5 0.7]);
    legend('OBJ','Scene','location','southeast')
    set(gca, 'XTick',[0 size(Pop_mat.POR.OBJ,2)], 'XTickLabel',{'Onset' ;'Choice'});
    
    subplot(2,3,6)
    title('POR'); hold on;
    plot(mean(Pop_mat.POR.OBJ),'linewidth',5);
    plot(mean(Pop_mat.POR.Scene),'linewidth',5); ylim([0.5 0.7]);
    legend('OBJ','Scene','location','southeast')
    set(gca, 'XTick',[0 size(Pop_mat.POR.OBJ,2)], 'XTickLabel',{'Onset' ;'Choice'});
    
    
    centerOfMass(mean(Pop_mat.IntHIPP.Scene))
    
    
    
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



