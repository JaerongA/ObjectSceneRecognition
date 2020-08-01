



title(sprintf('Trial # %d', trial_run),'fontsize',12,'fontweight','bold');

trial_pos.x= x(logical(pos_Trial(:,trial_run)));
trial_pos.y= y(logical(pos_Trial(:,trial_run)));
trial_pos.t= t(logical(pos_Trial(:,trial_run)));
%     plot(x(logical(pos_Trial(:,trial_run))),y(logical(pos_Trial(:,trial_run))),'k*','markersize',2); alpha(.6);

%
%     figure();


%         x_maze = [345.3 380.2 380.2 423.1 423.1 302.1 302.1 345.3 345.3];
%         y_maze = [391.7 391.7 228.8 228.8 176.8 176.8 228.8 228.8 391.7];
%         plot(x_maze,y_maze);


xEdge = [325 395 395 475 475 245 245 325 325];
yEdge = [470 470 160 160 70 70 160 160 470];
plot(xEdge,yEdge);


ylim([50 650]);
xlim([150 500]);
set(gca,'YDir','reverse');
hold on;


axis off
 

fs=30;

for pos_run=1:length(trial_pos.x)
    
    pos= plot(trial_pos.x(pos_run),trial_pos.y(pos_run),'r*');
    
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
    
%     delete(pos);
    
    hold on;
    %     disp(pos_run);
end
