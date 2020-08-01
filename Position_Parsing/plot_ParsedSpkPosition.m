data_root='I:\PRh-OCSD\r073\r073-01\ParsedSpk';
cd(data_root)
load('ParsedSpk.mat')

r_plot=5;
c_plot=5;

figure('color',[1 1 1])



for i=1:total_trial_number
    col=i/total_trial_number;
    subplot(r_plot,c_plot,i)
    hold on
%     xlim([0 720]);
%     ylim([0 480]);
     xlim([275 625]);
     ylim([150 450]);
    set(gca,'YDir','reverse')   %% Start box at the bottom of the plot
    
    plot(x(logical(trial(:,i))),y(logical(trial(:,i))),'color',[col 0 1-col]);
    
    axis off
    hold off
    

end
