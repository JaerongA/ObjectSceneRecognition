
subplot('Position',[0.50 0.79 0.20 0.12]);
if     strcmp(summary(i_s).Task_name,'OCRS(Modality)')
    h = barwitherr([sem_fr.Owl; sem_fr.Phone], [mean_fr.Owl; mean_fr.Phone]);
    set(gca,'XTickLabel',{'Owl','Phone'}); box off;
    ylabel('FR(hz)')
    set(h(1),'FaceColor','k');
    set(h(2),'FaceColor',[0.6 0.6 0.6]);
    set(h,'barwidth',1)
    
else
    h = barwitherr([sem_fr.Corr; sem_fr.Incorr], [mean_fr.Corr; mean_fr.Incorr]);
    set(gca,'XTickLabel',{'Correct','Error'}); box off;
    ylabel('FR (Hz)')
    set(h(1),'FaceColor','k');
    set(h(2),'FaceColor',[0.6 0.6 0.6]);
    set(h,'barwidth',1)
end



if     strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
    
    ax = legend('Icecream','House','location','northeastoutside' );
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    ax = legend('Icecream','House','Owl' , 'Phone','location','northeastoutside' );
    
elseif     strcmp(summary(i_s).Task_name,'OCRS(Modality)')
    
    ax = legend('VT','Vis','Tact','location','northeastoutside' );
    
elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    ax = legend('Zebra','Pebble','Owl' , 'Phone','location','northeastoutside' );
end



set(ax, 'pos',[0.75 0.83  0.01 0.05])


%% Bar graphs according to response (correct only)

if     ~strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
    
%     ax = subplot(r_plot,c_plot,[13:15]);
    subplot('Position',[0.50 0.6 0.20 0.12]);
    
    h = barwitherr([sem_fr.Pushing ; sem_fr.Digging], [mean_fr.Pushing; mean_fr.Digging]);
    set(gca,'XTickLabel',{'Pushing','Digging'}); box off;
    ylabel('FR (Hz)')
    set(h(1),'FaceColor','c');
    set(h(2),'FaceColor','m');
    set(h,'barwidth',1)
    
end




