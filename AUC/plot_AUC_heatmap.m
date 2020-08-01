%% Get the heatmap for stimulus selectivity


if     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    
    
    imagesc(AUC.Familiar);
    colormap(flipud(hot));
    caxis([0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]); box off;
    ylabel('Fam');
    set(gca, 'XTick',[],'YTick',[]);
    set(gca, 'XTick',[1 nb_win], 'XTickLabel',{'StimulusOnset' ;'Choice'},'YTickLabel',[],'fontsize',8);
    %         colorbar('Position', [.67 .28 .010 .11], 'YTick', [0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1], 'YTickLabel', sprintfc('%0.2f',[0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]));
    
    
    subplot('position',[0.14 0.13 0.18 0.03]);
    
    imagesc(AUC.Novel);title('Stimulus Selectivity');
    %         colormap(flipud(cool));
    caxis([0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]); box off;
    ylabel('Novel');
    set(gca, 'XTickLabel',[],'YTickLabel',[]);
    set(gca, 'XTick',[],'YTick',[]);
    
    colorbar('Position', [.34 .08 .010 .08], 'YTick', [0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1], 'YTickLabel', sprintfc('%0.2f',[0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]));
    
    
    
elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    
    maph= imagesc(AUC.OBJ);
    colormap(flipud(hot));
    %     colormap(cool);
    caxis([0.5 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]); box off;
%     caxis([0.5 round(max(structfun(@(x)max(x(:)),AUC)),1)]); box off;
    ylabel('OBJ');
    set(gca, 'XTick',[],'YTick',[]);
    set(gca, 'XTick',[1 nb_win], 'XTickLabel',{'StimulusOnset' ;'Choice'},'YTickLabel',[],'fontsize',8);
    set(gca,'TickLength',[0 0]);
    
    if ~isempty(Sig_ind.OBJ)
        Sig_bin= [];
        for bin_run = 1: size(Sig_ind.OBJ,2)
            Sig_bin = cell2mat(Sig_ind.OBJ(bin_run));
    vhandle= vline(Sig_bin(1) -0.5, 'k'); set(vhandle,'linewidth',2);
    vhandle= vline(Sig_bin(end)+0.5, 'k');set(vhandle,'linewidth',2);
        end
    end
    
    subplot('position',[0.14 0.13 0.18 0.03]);
    
    maph = imagesc(AUC.Scene);title('Stimulus Selectivity');
    %         colormap(flipud(cool));
    caxis([0.5 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]); box off;
%     caxis([0.5 round(max(structfun(@(x)max(x(:)),AUC)),1)]); box off;
    ylabel('Scene');
    set(gca, 'XTickLabel',[],'YTickLabel',[]);
    set(gca, 'XTick',[],'YTick',[]);
    
    colorbar('Position', [.34 .08 .010 .08], 'YTick', [0.5 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1], 'YTickLabel', sprintfc('%0.2f',[0.5 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]));
    
    if ~isempty(Sig_ind.Scene)
        Sig_bin= [];
        for bin_run = 1: size(Sig_ind.Scene,2)
            Sig_bin = cell2mat(Sig_ind.Scene(bin_run));
    vhandle= vline(Sig_bin(1) -0.5, 'k'); set(vhandle,'linewidth',2);
    vhandle= vline(Sig_bin(end)+0.5, 'k');set(vhandle,'linewidth',2);
        end
    end
    
end


%% Added 2018/03/25
% 
% colormapfig= figure('pos',[350 480 550 250],'name',[Prefix '_heatmap']);
% subplot(2,1,1);
% maph= imagesc(AUC.OBJ); title(Prefix);
% colormap(flipud(hot));
% % colormap(jet);
% caxis([0.5 round(max(structfun(@(x)max(x(:)),AUC)),1)]); box off;
% ylabel('OBJ');
% set(gca, 'XTick',[],'YTick',[]);
% set(gca,'TickLength',[0 0]);
% 
%     if ~isempty(Sig_ind.OBJ)
%         Sig_bin= [];
%         for bin_run = 1: size(Sig_ind.OBJ,2)
%             Sig_bin = cell2mat(Sig_ind.OBJ(bin_run));
%     vhandle= vline(Sig_bin(1) -0.5, 'k'); set(vhandle,'linewidth',2);
%     vhandle= vline(Sig_bin(end)+0.5, 'k');set(vhandle,'linewidth',2);
%         end
%     end
% 
% subplot(2,1,2);
% 
% maph = imagesc(AUC.Scene);
% %         colormap(flipud(cool));
% caxis([0.5 round(max(structfun(@(x)max(x(:)),AUC)),1)]); box off;
% ylabel('Scene');
% set(gca, 'XTickLabel',[],'YTickLabel',[]);
% set(gca, 'XTick',[1 nb_win], 'XTickLabel',{'StimulusOnset' ;'Choice'},'YTickLabel',[],'fontsize',8);
% set(gca,'TickLength',[0 0]);
% 
%     if ~isempty(Sig_ind.Scene)
%         Sig_bin= [];
%         for bin_run = 1: size(Sig_ind.Scene,2)
%             Sig_bin = cell2mat(Sig_ind.Scene(bin_run));
%     vhandle= vline(Sig_bin(1) -0.5, 'k'); set(vhandle,'linewidth',2);
%     vhandle= vline(Sig_bin(end)+0.5, 'k');set(vhandle,'linewidth',2);
%         end
%     end
% 
% % colorbar('Position', [.34 .08 .010 .08], 'YTick', [0. round(max(structfun(@(x)max(x(:)),AUC)),1)], 'YTickLabel', sprintfc('%0.2f',[0.45 round(max(structfun(@(x)max(x(:)),AUC)),1)+0.1]));
% 
% 
% filename_ai=[Prefix '_heatmap.eps'];
% % print(gcf, '-painters', '-r300', filename_ai, '-depsc');
% print(gcf, '-depsc','-r700',filename_ai)
%  print2eps filename_ai
