%% Created by Jaerong 2016/12/19 for PRC & POR analysis.
%% The program plots population hitmaps for different regions

clc; clear all;

%% Input folder


% dataROOT= 'F:\PRC_POR_ephys\Analysis\Population_PETH\OCRS(SceneOBJ)';
dataROOT= 'F:\PRC_POR_ephys\Analysis\Population_PETH\OCRS(SceneOBJ)\29-Oct-2017';
cd(dataROOT);


%% Output folder

saveROOT= [dataROOT];
if ~exist(saveROOT), mkdir(saveROOT); end



%% Parms


mat_range = [0 1];
fig_pos = [300,600,850,350];
r_plot=3;c_plot=2;

smoothingOK =1;
smoothing_factor =1;  %% 3 by 3 boxcar smoothing window
%         reshape([1:r_plot*c_plot],c_plot,r_plot)'


str= findstr(dataROOT,'(');
task_name= dataROOT(str+1:end-1);





%% Cell listing
listing_IntHIPP=dir('*IntHIPP*');
listing_PER=dir('*-PER-*');
listing_POR=dir('*POR*');


%% Make pop matrices

POP_mat = [];


cell_ind= 0;

for cell_run=  1:size(listing_IntHIPP,1)
    
    load(listing_IntHIPP(cell_run).name);
    disp(['Loading...  '     listing_IntHIPP(cell_run).name]);
    
    cell_ind= cell_ind + 1;
    
    POP_mat.IntHIPP(cell_run,:) = [SDF.All];
    
    
end



cell_ind= 0;

for cell_run=  1:size(listing_PER,1)
    
    load(listing_PER(cell_run).name);
    disp(['Loading...  '     listing_PER(cell_run).name]);
    
    cell_ind= cell_ind + 1;
    
    POP_mat.PER(cell_run,:) = [SDF.All];
    
    
end



cell_ind= 0;

for cell_run=  1:size(listing_POR,1)

    load(listing_POR(cell_run).name);
    disp(['Loading...  '     listing_POR(cell_run).name]);

    cell_ind= cell_ind + 1;

    POP_mat.POR(cell_run,:) = [SDF.All];

end



% [POP_mat.IntHIPP aligned_ind.IntHIPP]  = mat_align_max(POP_mat.IntHIPP,smoothingOK, smoothing_factor);


[POP_mat.PER aligned_ind.PER]  = mat_align_max(POP_mat.PER,smoothingOK, smoothing_factor);


[POP_mat.POR aligned_ind.POR]  = mat_align_max(POP_mat.POR,smoothingOK, smoothing_factor);




%% Plot the results
picID = figure('color',[1 1 1],'pos', fig_pos);
subplot('Position', [0.45 0.95 0.3 0.15]);
text(0,0,task_name,'fontsize',12);
axis off;



% colormap(flipud(hot))
colormap(jet)
%% IntHIPP
% subplot('position',[0.15 0.1 0.2 0.7]);
% imagesc(POP_mat.IntHIPP);title('IntHIPP'); box off;
% set(gca, 'YTick',[1 size(listing_IntHIPP,1)], 'YTickLabel',[1 size(listing_IntHIPP,1)],'fontsize',10);
% set(gca, 'XTick',[1 size(POP_mat.IntHIPP,2)], 'XTickLabel',{'Onset' ;'Choice'});
% ylabel('Cell #');


%% PER
subplot('position',[0.45 0.1 0.2 0.7]);
imagesc(POP_mat.PER);title('PER'); box off;
set(gca, 'YTick',[1 size(listing_PER,1)], 'YTickLabel',[1 size(listing_PER,1)],'fontsize',10);
set(gca, 'XTick',[1 size(POP_mat.PER,2)], 'XTickLabel',{'Onset' ;'Choice'});
ylabel('Cell #');



% POR
subplot('position',[0.75 0.1 0.2 0.7]);
imagesc(POP_mat.POR);title('POR'); box off;
set(gca, 'YTick',[1 size(listing_POR,1)], 'YTickLabel',[1 size(listing_POR,1)],'fontsize',10);
set(gca, 'XTick',[1 size(POP_mat.POR,2)], 'XTickLabel',{'Onset' ;'Choice'});
ylabel('Cell #');








cd(saveROOT);
filename_ai=['Population_PETH.eps'];
filename=['Population_PETH.png'];
print( gcf, '-painters', '-r300', filename_ai, '-depsc');
%  print('-dpsc2', '-noui', '-adobecset', '-painters', filename_ai)
% saveas(picID,filename_ai,'epsc')
saveImage(picID,filename,fig_pos);


% %% Plot average
%
% figure('color',[1 1 1]);
% subplot(2,3,1)
% title('Scene'); hold on;
% plot(mean(POP_mat.IntHIPP),'linewidth',5);
% plot(mean(POP_mat.PER),'linewidth',5);
% plot(mean(POP_mat.POR),'linewidth',5); ylim([0.5 0.7]);
% legend('IntHIPP','PER','POR','location','southeast')
% set(gca, 'XTick',[0 size(POP_mat.POR,2)], 'XTickLabel',{'Onset' ;'Choice'});
%
% subplot(2,3,2)
% title('OBJ'); hold on;
% plot(mean(POP_mat.IntHIPP),'linewidth',5);
% plot(mean(POP_mat.PER),'linewidth',5);
% plot(mean(POP_mat.POR),'linewidth',5); ylim([0.5 0.7]);
% legend('IntHIPP','PER','POR','location','southeast')
% set(gca, 'XTick',[0 size(POP_mat.POR,2)], 'XTickLabel',{'Onset' ;'Choice'});
%
% subplot(2,3,4)
% title('IntHIPP'); hold on;
% plot(mean(POP_mat.IntHIPP),'linewidth',5);
% plot(mean(POP_mat.IntHIPP),'linewidth',5); ylim([0.5 0.7]);
% legend('OBJ','Scene','location','southeast')
% set(gca, 'XTick',[0 size(POP_mat.POR,2)], 'XTickLabel',{'Onset' ;'Choice'});
%
% subplot(2,3,5)
% title('PER'); hold on;
% plot(mean(POP_mat.PER),'linewidth',5);
% plot(mean(POP_mat.PER),'linewidth',5); ylim([0.5 0.7]);
% legend('OBJ','Scene','location','southeast')
% set(gca, 'XTick',[0 size(POP_mat.POR,2)], 'XTickLabel',{'Onset' ;'Choice'});
%
% subplot(2,3,6)
% title('POR'); hold on;
% plot(mean(POP_mat.POR),'linewidth',5);
% plot(mean(POP_mat.POR),'linewidth',5); ylim([0.5 0.7]);
% legend('OBJ','Scene','location','southeast')
% set(gca, 'XTick',[0 size(POP_mat.POR,2)], 'XTickLabel',{'Onset' ;'Choice'});


%   centerOfMass(mean(POP_mat.IntHIPP))



%% Plot histogram
%
%
% figure('color',[1 1 1]);
% subplot(1,2,1)
% title('Scene'); hold on;
% %
% %
% h= histogram(aligned_ind.IntHIPP,'Normalization','probability','BinWidth',4)
% % histogram(aligned_ind.POR,'Normalization','probability','BinWidth',4)
% % histogram(aligned_ind.PER,'Normalization','probability','BinWidth',4)
%
%
% h= hist(aligned_ind.IntHIPP,10);
% h= h./sum(h);
% plot(h); hold on;
%
% h= hist(aligned_ind.POR,10);
% h= h./sum(h);
% plot(h,'r'); hold on;
%
%
% h= hist(aligned_ind.PER,10);
% h= h./sum(h);
% plot(h,'k'); hold on;
%
%
%
%
%
% h= histfit(aligned_ind.IntHIPP,10,'kernel')
% h= histfit(aligned_ind.POR,10,'kernel')
% h= histfit(aligned_ind.PER,10,'kernel')
% histogram(aligned_ind.POR,'Normalization','probability','BinWidth',4)
% histogram(aligned_ind.PER,'Normalization','probability','BinWidth',4)
%
%
%
%
% legend('IntHIPP','PER','POR','location','southeast')
%
%
%
% subplot(1,2,2)
% title('OBJ'); hold on;
% plot(mean(POP_mat.IntHIPP),'linewidth',5);
% plot(mean(POP_mat.PER),'linewidth',5);
% plot(mean(POP_mat.POR),'linewidth',5); ylim([0.1 0.6]);
% legend('IntHIPP','PER','POR','location','southeast')
% set(gca, 'XTick',[0 size(POP_mat.POR,2)], 'XTickLabel',{'Onset' ;'Choice'});
%
%
%
%
%
%







% caxis(mat_range)

% figure()
% dendrogram(aligned_ind.IntHIPP)
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



