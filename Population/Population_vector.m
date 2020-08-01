function Population_vector(dataROOT)

%% Created by AJR 2016/11/06 for PRC & POR analysis.
%% The program plots population vector matrices for different regions


%% Input folder

% dataROOT= 'G:\PRC_POR_ephys\Analysis\Population_vector\OCRS(TwoOBJ))';
% dataROOT= 'G:\PRC_POR_ephys\Analysis\Population_vector\OCRS(FourOBJ)';
dataROOT= 'G:\PRC_POR_ephys\Analysis\Population_vector\OCRS(SceneOBJ)';

cd(dataROOT);



%% Output folder

saveROOT= [dataROOT '\Analysis\Population_vector\Pop_matrices'];
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


cell_ind= 0;

for cell_run=  1:size(listing_IntHIPP,1)
    
    load(listing_IntHIPP(cell_run).name);
    disp(['Loading...  '     listing_IntHIPP(cell_run).name]);
    
    cell_ind= cell_ind + 1;
    
    Pop_mat.IntHIPP.Stimulus1_Corr(cell_run,:) = [SDF.Stimulus1_Corr];
    Pop_mat.IntHIPP.Stimulus2_Corr(cell_run,:) = [SDF.Stimulus2_Corr];
    Pop_mat.IntHIPP.Stimulus3_Corr(cell_run,:) = [SDF.Stimulus3_Corr];
    Pop_mat.IntHIPP.Stimulus4_Corr(cell_run,:) = [SDF.Stimulus4_Corr];
    
    %     Pop_mat.IntHIPP.Scene(cell_run,:) = mapminmax(SDF.Scene,0,1);
    %     Pop_mat.IntHIPP.OBJ(cell_run,:) =  mapminmax(SDF.OBJ,0,1);
    
end



cell_ind= 0;

for cell_run=  1:size(listing_PER,1)
    
    load(listing_PER(cell_run).name);
    disp(['Loading...  '     listing_PER(cell_run).name]);
    
    cell_ind= cell_ind + 1;
    
    
    Pop_mat.PER.Stimulus1_Corr(cell_run,:) = [SDF.Stimulus1_Corr];
    Pop_mat.PER.Stimulus2_Corr(cell_run,:) = [SDF.Stimulus2_Corr];
    Pop_mat.PER.Stimulus3_Corr(cell_run,:) = [SDF.Stimulus3_Corr];
    Pop_mat.PER.Stimulus4_Corr(cell_run,:) = [SDF.Stimulus4_Corr];
    
    
    %     Pop_mat.PER.Scene(cell_run,:) = mapminmax(SDF.Scene,0,1);
    %     Pop_mat.PER.OBJ(cell_run,:) =  mapminmax(SDF.OBJ,0,1);
    
    
end



cell_ind= 0;

for cell_run=  1:size(listing_POR,1)
    
    load(listing_POR(cell_run).name);
    disp(['Loading...  '     listing_POR(cell_run).name]);
    
    cell_ind= cell_ind + 1;
    
    Pop_mat.POR.Stimulus1_Corr(cell_run,:) = [SDF.Stimulus1_Corr];
    Pop_mat.POR.Stimulus2_Corr(cell_run,:) = [SDF.Stimulus2_Corr];
    Pop_mat.POR.Stimulus3_Corr(cell_run,:) = [SDF.Stimulus3_Corr];
    Pop_mat.POR.Stimulus4_Corr(cell_run,:) = [SDF.Stimulus4_Corr];
    
    
    %     Pop_mat.POR.Scene(cell_run,:) = mapminmax(SDF.Scene,0,1);
    %     Pop_mat.POR.OBJ(cell_run,:) =  mapminmax(SDF.OBJ,0,1);
    
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






% %% Plot population mean firing rates
%
% figure();
% subplot(1,3,1)
% plot(mean(Pop_mat.PER.Stimulus1_Corr),'linewidth',3); hold on;
% plot(mean(Pop_mat.PER.Stimulus2_Corr),'linewidth',3);
% plot(mean(Pop_mat.PER.Stimulus3_Corr),'linewidth',3);hold on;
% plot(mean(Pop_mat.PER.Stimulus4_Corr),'linewidth',3);
% title('PER')
% legend('Zebra','Pebble','Owl' , 'Phone');
%
%
% subplot(1,3,2)
% plot(mean(Pop_mat.POR.Stimulus1_Corr),'linewidth',3); hold on;
% plot(mean(Pop_mat.POR.Stimulus2_Corr),'linewidth',3);
% plot(mean(Pop_mat.POR.Stimulus3_Corr),'linewidth',3);hold on;
% plot(mean(Pop_mat.POR.Stimulus4_Corr),'linewidth',3);
% title('POR')
% legend('Zebra','Pebble','Owl' , 'Phone');
%
%
% subplot(1,3,3)
% plot(mean(Pop_mat.IntHIPP.Stimulus1_Corr),'linewidth',3); hold on;
% plot(mean(Pop_mat.IntHIPP.Stimulus2_Corr),'linewidth',3);
% plot(mean(Pop_mat.IntHIPP.Stimulus3_Corr),'linewidth',3);hold on;
% plot(mean(Pop_mat.IntHIPP.Stimulus4_Corr),'linewidth',3);
% title('IntHIPP')
% legend('Zebra','Pebble','Owl' , 'Phone');


%% IntHIPP
figure();

corrMAT=nan(nb_win);

for col_run= 1: nb_win
    
    for col_run2= 1:nb_win
        
        %         corrR= corrcoef(Pop_mat.IntHIPP.Stimulus1_Corr(:,col_run),Pop_mat.IntHIPP.Stimulus2_Corr(:,col_run2));
        %         corrR= corrcoef(Pop_mat.IntHIPP.Stimulus3_Corr(:,col_run),Pop_mat.IntHIPP.Stimulus4_Corr(:,col_run2));
        corrR= corrcoef(Pop_mat.POR.Stimulus1_Corr(:,col_run),Pop_mat.POR.Stimulus2_Corr(:,col_run2));
        
        
        
        corrMAT(col_run2,col_run)= corrR(1,2);
    end
end

corrMAT= flipud(corrMAT);

subplot('position',[0.15 0.75 0.2 0.2]);
title('IntHIPP(Scene)'); box off;
thisAlphaZ = corrMAT; thisAlphaZ(isnan(corrMAT)) = 0; thisAlphaZ(~isnan(corrMAT)) = 1;
imagesc(corrMAT); alpha(thisAlphaZ);
colorbar('Position', [.869 .717 .027 .204], 'YTick', [-.99 0 .99], 'YTickLabel', {'-1.0'; '0.5'; '1.0'});

colormap(jet)






corrMAT=nan(nb_win);

for col_run= 1: nb_win
    
    for col_run2= 1:nb_win
        
        %         corrR= corrcoef(Pop_mat.IntHIPP.Stimulus1_Corr(:,col_run),Pop_mat.IntHIPP.Stimulus2_Corr(:,col_run2));
        %         corrR= corrcoef(Pop_mat.IntHIPP.Stimulus3_Corr(:,col_run),Pop_mat.IntHIPP.Stimulus4_Corr(:,col_run2));
        corrR= corrcoef(Pop_mat.POR.Stimulus3_Corr(:,col_run),Pop_mat.POR.Stimulus4_Corr(:,col_run2));
        
        
        
        corrMAT(col_run2,col_run)= corrR(1,2);
    end
end

corrMAT= flipud(corrMAT);


subplot('position',[0.4 0.75 0.2 0.2]);
title('IntHIPP(Scene)'); box off;
thisAlphaZ = corrMAT; thisAlphaZ(isnan(corrMAT)) = 0; thisAlphaZ(~isnan(corrMAT)) = 1;
imagesc(corrMAT); alpha(thisAlphaZ);
colorbar('Position', [.869 .717 .027 .204], 'YTick', [-.99 0 .99], 'YTickLabel', {'-1.0'; '0.5'; '1.0'});








corrMAT=nan(nb_win);

for col_run= 1: nb_win
    
    for col_run2= 1:nb_win
        
        corrR= corrcoef(Pop_mat.PER.Stimulus1_Corr(:,col_run),Pop_mat.PER.Stimulus2_Corr(:,col_run2));
        
        
        corrMAT(col_run2,col_run)= corrR(1,2);
        
    end
end






corrMAT=nan(nb_win);

for col_run= 1: nb_win
    
    for col_run2= 1:nb_win
        
        corrR= corrcoef(Pop_mat.POR.Stimulus1_Corr(:,col_run),Pop_mat.POR.Stimulus2_Corr(:,col_run2));
        
        
        
        corrMAT(col_run2,col_run)= corrR(1,2);
        
    end
end


%% POR
subplot('position',[0.15 0.16 0.2 0.15]);
imagesc(corrMAT);
title('POR(Scene)'); box off;


colormap(jet)


caxis([0.8 1]);















%% Plot the results
picID = figure('color',[1 1 1],'pos', fig_pos);

colormap(flipud(hot))
% colormap(jet)
%% IntHIPP
subplot('position',[0.15 0.68 0.2 0.25]);
imagesc(Pop_mat.IntHIPP.Scene);title('IntHIPP(Scene)'); box off;
set(gca, 'YTick',[1 size(listing_IntHIPP,1)], 'YTickLabel',[1 size(listing_IntHIPP,1)],'fontsize',10);
set(gca, 'XTick',[1 size(Pop_mat.IntHIPP.Scene,2)], 'XTickLabel',{'Onset' ;'Choice'});
ylabel('Cell #');

subplot('position',[0.5 0.68 0.2 0.25]);
imagesc(Pop_mat.IntHIPP.OBJ);title('IntHIPP(OBJ)'); box off;
set(gca, 'YTick',[], 'YTickLabel',[]);
set(gca, 'XTick',[1 size(Pop_mat.IntHIPP.Scene,2)], 'XTickLabel',{'Onset' ;'Choice'},'YTickLabel',[],'fontsize',10);


%% PER
subplot('position',[0.15 0.4 0.2 0.22]);
imagesc(Pop_mat.PER.Scene);title('PER(Scene)'); box off;
set(gca, 'YTick',[1 size(listing_PER,1)], 'YTickLabel',[1 size(listing_PER,1)],'fontsize',10);
set(gca, 'XTick',[1 size(Pop_mat.PER.Scene,2)], 'XTickLabel',{'Onset' ;'Choice'});
ylabel('Cell #');

subplot('position',[0.5 0.4 0.2 0.22]);
imagesc(Pop_mat.PER.OBJ);title('PER(OBJ)'); box off;
set(gca, 'YTick',[], 'YTickLabel',[]);
set(gca, 'XTick',[1 size(Pop_mat.PER.OBJ,2)], 'XTickLabel',{'Onset' ;'Choice'},'YTickLabel',[],'fontsize',10);


%% POR
subplot('position',[0.15 0.16 0.2 0.15]);
imagesc(corrMAT);title('POR(Scene)'); box off;
set(gca, 'YTick',[1 size(listing_POR,1)], 'YTickLabel',[1 size(listing_POR,1)],'fontsize',10);
set(gca, 'XTick',[1 size(Pop_mat.POR.Scene,2)], 'XTickLabel',{'Onset' ;'Choice'});
ylabel('Cell #');

subplot('position',[0.5 0.16 0.2 0.15]);
imagesc(Pop_mat.POR.OBJ);title('POR(OBJ)'); box off;
set(gca, 'YTick',[], 'YTickLabel',[]);
set(gca, 'XTick',[1 size(Pop_mat.POR.OBJ,2)], 'XTickLabel',{'Onset' ;'Choice'},'YTickLabel',[],'fontsize',10);
















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



%% Plot histogram
%
%
% figure('color',[1 1 1]);
% subplot(1,2,1)
% title('Scene'); hold on;
% %
% %
% h= histogram(aligned_ind.IntHIPP.Scene,'Normalization','probability','BinWidth',4)
% % histogram(aligned_ind.POR.Scene,'Normalization','probability','BinWidth',4)
% % histogram(aligned_ind.PER.Scene,'Normalization','probability','BinWidth',4)
%
%
% h= hist(aligned_ind.IntHIPP.Scene,10);
% h= h./sum(h);
% plot(h); hold on;
%
% h= hist(aligned_ind.POR.Scene,10);
% h= h./sum(h);
% plot(h,'r'); hold on;
%
%
% h= hist(aligned_ind.PER.Scene,10);
% h= h./sum(h);
% plot(h,'k'); hold on;
%
%
%
%
%
% h= histfit(aligned_ind.IntHIPP.Scene,10,'kernel')
% h= histfit(aligned_ind.POR.Scene,10,'kernel')
% h= histfit(aligned_ind.PER.Scene,10,'kernel')
% histogram(aligned_ind.POR.Scene,'Normalization','probability','BinWidth',4)
% histogram(aligned_ind.PER.Scene,'Normalization','probability','BinWidth',4)
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
% plot(mean(Pop_mat.IntHIPP.OBJ),'linewidth',5);
% plot(mean(Pop_mat.PER.OBJ),'linewidth',5);
% plot(mean(Pop_mat.POR.OBJ),'linewidth',5); ylim([0.1 0.6]);
% legend('IntHIPP','PER','POR','location','southeast')
% set(gca, 'XTick',[0 size(Pop_mat.POR.OBJ,2)], 'XTickLabel',{'Onset' ;'Choice'});
%
%
%
%
%
%





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



