%% By Jaerong (2015/09/30)
%% Check the sensor information

clc;

saveROOT = 'H:\PRC_POR_ephys\Analysis\EventPlot';

session_folder= 'H:\PRC_POR_ephys\Ephys_data\r469\r469-15-07_OCRS(SceneOBJ)';

cd([session_folder '\ExtractedEvents']);

listing_mat= dir('*.mat'); nb_trial= size(listing_mat,1);  %The # of Trials


marquer_size=4;

%% GLOBAL PETH
fig_name= [session_folder '.png'];



fig_pos=[500,100,1220,980];
picID=figure('name',fig_name,'Color',[1 1 1],'Position',fig_pos);

hold on


for trial_run=1:nb_trial
    
    
    nb_digit= numel(num2str(trial_run));
    
    switch nb_digit
        case 1
            filename= sprintf('Trial00%d.mat',trial_run);
        case 2
            filename= sprintf('Trial0%d.mat',trial_run);
        case 3
            filename = sprintf('Trial%d.mat',trial_run);
    end
    
    load (filename);
    
    %%  Select the event to align all the other events
    %     ref_event= Sensor4(1);
    ref_event= Trial_Start;
    
    if ~Void
        
        trialnum=trial_run;
        
        if(length(Sensor4)) h_sensor4= plot(Sensor4(1)-ref_event,ones(1,length(Sensor4))*trialnum,'bs','MarkerSize',marquer_size,'MarkerFaceColor','b'); end
        %         if(length(Sensor3)) plot(Sensor3-Trial_Start,ones(1,length(Sensor3))*trialnum,'rs','MarkerSize',marquer_size,'MarkerFaceColor','r'); end
        if(length(StimulusOnset)) h_StimulusOnest= plot(StimulusOnset-ref_event,trialnum,'o','MarkerSize',marquer_size*1.5,'MarkerEdgeColor',[1 0.5 0],'MarkerFaceColor',[1 0.5 0]); end
        if(length(Choice)) h_Choice= plot(Choice-ref_event,trialnum,'o','MarkerSize',marquer_size*1.5,'MarkerEdgeColor',[190 5 181]/255,'MarkerFaceColor',[190 5 181]/255); end
        if(length(Trial_Start)) h_Trial_Start= plot(Trial_Start-ref_event,trialnum,'k<','MarkerSize',marquer_size); end
        %         if(length(Trial_End)) plot(Trial_End-Trial_Start,trialnum,'k>','MarkerSize',marquer_size); end
        
    else
        
    end
    
    
end



hleg= legend([h_sensor4(1) h_StimulusOnest(1) h_Choice(1)],'Startbox','StimulusOnset','Choice');  %% edit legend, insert only the desired entries.
set(hleg,'box','off','Location','northeastoutside');
set(hleg,'Location','northeastoutside');



title(session_folder); xlabel('Time(s)'); ylabel('Trial #'); xlim([0 20])
hold off



str= findstr(fig_name,'\');
fig_name = fig_name(str(end)+1: end);

cd(saveROOT);
% saveImage(picID,fig_name,fig_pos);
saveas(picID,fig_name);

close all;
