%% Revision by Jaerong 2015/09/20
%% The program draws a trial by trial position.
%% Head direction added

clear all; clc;


dataROOT='B:\PRC_POR_ephys\Ephys_data\2015-09-17_21-33-39(2nd pilot)\ParsedPosition';
evtROOT= 'B:\PRC_POR_ephys\Ephys_data\2015-09-17_21-33-39(2nd pilot)\ExtractedEvents';
cd(dataROOT)
load('ParsedPosition.mat')

r_plot=5;
c_plot=9;

fig_pos= [100,100,1600,900];
pic_pos= figure('color',[1 1 1],'Position',fig_pos);

trial_pos=[];
%% Printing out the prefix of the figure.
subplot('Position', [0.45 0.99 0.4 0.2]);
text(0,0,'Rat334(2nd pilot)','fontsize',15,'fontweight','bold');
axis off;

    cd(evtROOT);
    listing_mat= dir('*.mat'); 
    
for trial_run=1:nb_trial
    
    
    trial_info=listing_mat(trial_run).name;         
    load (trial_info);

    
    subplot(r_plot,c_plot,trial_run)
    hold on
    ylim([50 500]);
    xlim([150 500]);
    set(gca,'YDir','reverse');
    hold on;
    
    
    title(sprintf('Trial # %d', trial_run),'fontsize',12,'fontweight','bold');
    
    trial_pos.x= x(logical(pos_Trial(:,trial_run)));
    trial_pos.y= y(logical(pos_Trial(:,trial_run)));
    trial_pos.t= t(logical(pos_Trial(:,trial_run)));
%     trial_pos.t= trial_pos.t - trial_pos.t(1);
    
%     plot(x(logical(pos_Trial(:,trial_run))),y(logical(pos_Trial(:,trial_run))),'k*','markersize',2); alpha(.6);
    
%    
%     figure();


%         x_maze = [345.3 380.2 380.2 423.1 423.1 302.1 302.1 345.3 345.3];
%         y_maze = [391.7 391.7 228.8 228.8 176.8 176.8 228.8 228.8 391.7];
%         plot(x_maze,y_maze);
    

xEdge = [325 395 395 475 475 245 245 325 325];
yEdge = [480 480 160 160 70 70 160 160 480];
plot(xEdge,yEdge);
    axis off
    
    
    fs=1000000;
     
for pos_run=1:length(trial_pos.x)
    
    plot(trial_pos.x(pos_run),trial_pos.y(pos_run),'r.');
    
    if pos_run < 2
        
    h= text(235,520,num2str(trial_pos.t(pos_run)));
    pause(1/fs);
    
    
    elseif (pos_run >= 2) && (pos_run < length(trial_pos.x))
    h= text(235,570,num2str(trial_pos.t(pos_run)));
    pause(1/fs);
    delete(h);
    
    elseif pos_run == length(trial_pos.x)
        h= text(235,570,num2str(trial_pos.t(pos_run)));
        pause(1/fs);        
       
    end
        
    
    hold on;
    pause(1/fs);
%     disp(pos_run);
end



% %% Position interpolation
% 
% nb_missingX= sum(~logical(trial_pos.x));
% nb_missingY= sum(~logical(trial_pos.y));
% 
% 
% trial_pos.x(find(trial_pos.x== 0))= nan;
% trial_pos.y(find(trial_pos.y== 0))= nan;
% 
% ipos=1;
% while isnan(trial_pos.x(ipos)), ipos=ipos+1; end
% 
% 
% trial_pos.x= trial_pos.x(ipos:end);
% trial_pos.y= trial_pos.y(ipos:end);
% trial_pos.t= trial_pos.t(ipos:end);
% 
% 
% 
% 
% 
% 
% int_xpos= inpaint_nans(trial_pos.x, 0);
% int_ypos= inpaint_nans(trial_pos.y, 0);
% 
% figure();
% plot(trial_pos.t,int_xpos, 'linewidth',2)
% hold on;
% plot(trial_pos.t,trial_pos.x,'linewidth',2)
% 
% 
% plot(trial_pos.t,int_ypos,'linewidth',2)
% hold on;
% plot(trial_pos.t,trial_pos.y,'linewidth',2)
% 
% legend('x int','x','y int', 'y')
% 
% 
% 
% 
% for pos_run=1:length(int_xpos)
%     
%     plot(int_xpos(pos_run),int_ypos(pos_run),'b.');
%     
%     if pos_run < 2
%         
%     h= text(235,520,num2str(trial_pos.t(pos_run)));
%     pause(1/fs);
%     
%     
%     elseif (pos_run >= 2) && (pos_run < length(trial_pos.x))
%     h= text(235,570,num2str(trial_pos.t(pos_run)));
%     pause(1/fs);
%     delete(h);
%     
%     elseif pos_run == length(int_xpos)
%         h= text(235,570,num2str(trial_pos.t(pos_run)));
%         pause(1/fs);        
%        
%     end
%         
%     
%     hold on;
%     pause(1/fs);
% %     disp(pos_run);
% end
% 













% pause;

% 
% from_start_to_choice =find(t> sensor4(1) & t <= sensor3(1));
%     fs=10000;
% for pos_run=from_start_to_choice(1): from_start_to_choice(end)
%     
%     plot(x(pos_run),y(pos_run),'c.');
%     hold on;
%     pause(1/fs);
% %     disp(pos_run);
% end
% 

    
    

    
    
    trial_pos=[];
    
    hold off
    
end


filename='Rat334(2nd pilot).png';
saveImage(pic_pos,filename,fig_pos);
close all;




%% Plot head direction
intDEG=20;

fig_pos= [100,100,1600,900];
pic_hd= figure('color',[1 1 1],'Position',fig_pos);


%% Printing out the prefix of the figure.
subplot('Position', [0.45 0.99 0.4 0.2]);
text(0,0,'Rat334(2nd pilot)','fontsize',15,'fontweight','bold');
axis off;
trial_hd=[];

for trial_run=1:nb_trial
    subplot(r_plot,c_plot,trial_run)
    hold on; axis off;
    
    title(sprintf('trial # %d', trial_run),'fontsize',10,'fontweight','bold');
    
    trial_hd= a(logical(pos_Trial(:,trial_run)));
    trial_hd(find(trial_hd == -99))=[];
    hd= rose(deg2rad(trial_hd), intDEG); hold on;     set(hd,'color','k');
    set(gca,'View',[-270 270],'XDir','reverse');
    %     [x_hd,y_hd] = pol2cart(deg2rad(trial_hd), max(get(gca,'Ytick')));
    %     c_hd= compass(x_hd,y_hd);
    %     hline = findobj(gca,'Type','line');
    %     set(hline,'linecolor','k');
    %     hist([trial_hd trial_hd+360],0:20:720)
    hold off
    trial_hd=[];
end


filename='Rat334(2nd pilot).png';
saveImage(pic_hd,filename,fig_pos);
close all;



%% Conditional position trace

conditional_pos= figure('color',[1 1 1]);

subplot(1,2,1);
plot(x(logical(pos_corr(:,1))),y(logical(pos_corr(:,1))),'b*','markersize',1.5); hold on;
plot(x(logical(pos_corr(:,2))),y(logical(pos_corr(:,2))),'m*','markersize',1.5);
ylim([50 500]);
xlim([150 400]);
set(gca,'YDir','reverse');


subplot(1,2,2);
plot(x(logical(pos_context(:,1))),y(logical(pos_context(:,1))),'b*','markersize',2); hold on;
plot(x(logical(pos_context(:,2))),y(logical(pos_context(:,2))),'m*','markersize',2);
plot(x(logical(pos_context(:,3))),y(logical(pos_context(:,3))),'g*','markersize',2); hold on;
plot(x(logical(pos_context(:,4))),y(logical(pos_context(:,4))),'r*','markersize',2);
ylim([50 500]);
xlim([150 400]);
set(gca,'YDir','reverse');
legend('zebra','pebble','bamboo','mountain')








hleg= legend([h_choice_to_peak(1) h_peak_to_food(1)],'chioce2peak','peak2food');  %% edit legend, insert only the desired entries.
set(hleg,'box','off');
hLegendPatch = findobj(hleg, 'type', 'patch');
set(hLegendPatch, 'XData', [.2, .2, .3, .3]);



