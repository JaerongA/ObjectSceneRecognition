%% By Jaerong 2016/02/07
%% Get the cumulative performance per condition

clear all; clc; close all;

% dataROOT= 'G:\PRC_POR_ephys\Ephys_data';
% saveROOT= 'G:\PRC_POR_ephys\Analysis\Performance\Cumulative_Perf';


dataROOT= 'F:\PRC_POR_ephys\Ephys_data';
saveROOT= 'F:\PRC_POR_ephys\Analysis\Performance\Cumulative_Perf';

%% Output folder
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);



%% Parms

Trial= 1; Stimulus=2; Correctness=3; Response=4;
ChoiceLatency= 5; StimulusOnset=6; Choice=7;
Trial_S3_1=8; Trial_S4_1=9; Trial_S3_end=10; Trial_S4_end=11; Trial_Void=12;
StimulusCAT=13;  %% novelty, modality, category
fig_pos=[30 480 1700 550]; %lab computer
%         fig_pos=[30 30 1200 1000]; % home computer

%% Category
Familiar= 1;
Novel =2;

SceneCAT= 1;
OBJCAT =2;


cd(dataROOT);


listing_rat=dir('r*'); r1=size(listing_rat,1);

for i1=1:r1
    target_rat = [dataROOT '\' listing_rat(i1).name];cd(target_rat)
    listing_session=dir('r*'); r2=size(listing_session,1);
    
    for i2=1:r2
        target_session = [target_rat '\' listing_session(i2).name];
        
        
        RatID= target_rat(end-3:end);
        
        str1= findstr(target_session,'-');
        str2= findstr(target_session,'_');
        
        Session = target_session(str1(1)+1:str1(2)-1);
        Task_session= target_session(str1(2)+1:str2(end)-1);
        
        
        %% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
        Task = target_session(findstr(target_session,'(')-4:end);
        
        str3= findstr(target_session,'\');
        Prefix= target_session(str3(end)+1:end); Prefix= strrep(Prefix,'_','-');
        
        clear str*
        
        if ~(strcmp(Task,'OCRS(FourOBJ)') || strcmp(Task,'OCRS(SceneOBJ)'))
            continue;
        else
            disp(['accessing...' target_session]); cd(target_session);
        end
        
        
        
        % %% Column Header for ts_evt
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        cd([target_session '\Behavior'])
        load('Parsedevents.mat');
        
        
        
        %% Add stimulus category information
        
        if strcmp(Task,'OCRS(FourOBJ)') || strcmp(Task,'OCRS(SceneOBJ)')
            ts_evt= add_category_info(ts_evt,Task);
        end
        
        
        %% Eliminated void trials
        
        ts_evt= void_trial_elimination(ts_evt);
        
        
        
        
        %% Select trial types
        
        
        
        %% Pushing or digging response
        select.Pushing = find(ts_evt(:,Response)==0);
        select.Digging = find(ts_evt(:,Response)==1);
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            
            
            %% Stimulus
            Icecream = 1;
            House = 2;
            Owl = 3;
            Phone = 4;
            
            Stimulus_str= {'Icecream','House','Owl','Phone'};
            Category_str= {'Familiar','Novel'};
            
            select.Stimulus1_all = find(ts_evt(:,Stimulus)==Icecream);
            select.Stimulus2_all = find(ts_evt(:,Stimulus)==House);
            select.Stimulus3_all = find(ts_evt(:,Stimulus)==Owl);
            select.Stimulus4_all = find(ts_evt(:,Stimulus)==Phone);
            
            select.Familiar = find(ts_evt(:,StimulusCAT)==Familiar);
            select.Novel= find(ts_evt(:,StimulusCAT)==Novel);
            
        elseif  strcmp(Task,'OCRS(SceneOBJ)')
            
            
            %% Stimulus
            Zebra = 1;
            Pebbles = 2;
            Owl = 3;
            Phone = 4;
            
            Stimulus_str= {'Zebra','Pebbles','Owl','Phone'};
            Category_str= {'Scene','Object'};
            
            
            select.Stimulus1_all = find(ts_evt(:,Stimulus)==Zebra);
            select.Stimulus2_all = find(ts_evt(:,Stimulus)==Pebbles);
            select.Stimulus3_all = find(ts_evt(:,Stimulus)==Owl);
            select.Stimulus4_all = find(ts_evt(:,Stimulus)==Phone);
            
            
            
            select.Scene = find(ts_evt(:,StimulusCAT)==SceneCAT);
            select.OBJ= find(ts_evt(:,StimulusCAT)==OBJCAT);
            
        end
        
        
        Performance.All = mean(ts_evt(:,Correctness));
        Performance.Pushing = mean(ts_evt(select.Pushing,Correctness));
        Performance.Digging = mean(ts_evt(select.Digging,Correctness));
        
        Performance.Stimulus1 = mean(ts_evt(select.Stimulus1_all,Correctness));
        Performance.Stimulus2 = mean(ts_evt(select.Stimulus2_all,Correctness));
        Performance.Stimulus3 = mean(ts_evt(select.Stimulus3_all,Correctness));
        Performance.Stimulus4 = mean(ts_evt(select.Stimulus4_all,Correctness));
        
        
        
        
        
        
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            Performance.Familiar = mean(ts_evt(select.Familiar,Correctness));
            Performance.Novel = mean(ts_evt(select.Novel,Correctness));
            
        elseif strcmp(Task,'OCRS(SceneOBJ)')
            
            Performance.Scene = mean(ts_evt(select.Scene,Correctness));
            Performance.OBJ = mean(ts_evt(select.OBJ,Correctness));
            
        end
        
        
        Cumulative_Perf.Stimulus1 = get_cumulative_avg(ts_evt(select.Stimulus1_all,Correctness));
        Cumulative_Perf.Stimulus2 = get_cumulative_avg(ts_evt(select.Stimulus2_all,Correctness));
        Cumulative_Perf.Stimulus3 = get_cumulative_avg(ts_evt(select.Stimulus3_all,Correctness));
        Cumulative_Perf.Stimulus4 = get_cumulative_avg(ts_evt(select.Stimulus4_all,Correctness));
        
        
        Cumulative_Perf.All = get_cumulative_avg(ts_evt(:,Correctness));
        Cumulative_Perf.Pushing = get_cumulative_avg(ts_evt(select.Pushing,Correctness));
        Cumulative_Perf.Digging = get_cumulative_avg(ts_evt(select.Digging,Correctness));
        
        
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            Cumulative_Perf.Familiar = get_cumulative_avg(ts_evt(select.Familiar,Correctness));
            Cumulative_Perf.Novel = get_cumulative_avg(ts_evt(select.Novel,Correctness));
            
        elseif strcmp(Task,'OCRS(SceneOBJ)')
            
            Cumulative_Perf.Scene = get_cumulative_avg(ts_evt(select.Scene,Correctness));
            Cumulative_Perf.OBJ = get_cumulative_avg(ts_evt(select.OBJ,Correctness));
            
        end
        
        
        
        
        %% Store the cumulative performance vectors into a .mat file
        
        cd(saveROOT);
        
        save([Prefix '.mat'],'Cumulative_Perf','Performance');
        
        
        
        
        %% GLOBAL PETH
        fig=figure('name',Prefix, 'Color',[1 1 1],'Position',fig_pos);
        
        
        subplot('Position', [0.45 0.98 0.4 0.2]);
        text(0,0,Prefix,'fontsize',15);
        axis off;
        
        
        subplot('Position',[0.04 0.15 0.2 0.7]);
        
        plot(Cumulative_Perf.All,'k', 'linewidth', 2);
        title('ALL','fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        
        subplot('Position',[0.3 0.58 0.15 0.3]);
        
        plot(Cumulative_Perf.Stimulus1, 'linewidth', 2);
        title(Stimulus_str{1},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        
        subplot('Position',[0.48 0.58 0.15 0.3]);
        
        plot(Cumulative_Perf.Stimulus2, 'linewidth', 2);
        title(Stimulus_str{2},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        
        subplot('Position',[0.66 0.58 0.15 0.3]);
        
        plot(Cumulative_Perf.Stimulus3, 'linewidth', 2);
        title(Stimulus_str{3},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        
        subplot('Position',[0.84 0.58 0.15 0.3]);
        
        plot(Cumulative_Perf.Stimulus4, 'linewidth', 2);
        title(Stimulus_str{4},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
        
        subplot('Position',[0.3 0.15 0.15 0.3]);
        
        plot(Cumulative_Perf.Familiar, 'linewidth', 2);
        title(Category_str{1},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        
        
        subplot('Position',[0.48 0.15 0.15 0.3]);
        
        plot(Cumulative_Perf.Novel, 'linewidth', 2);
        title(Category_str{2},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        
        
            
        elseif strcmp(Task,'OCRS(SceneOBJ)')
        
        subplot('Position',[0.3 0.15 0.15 0.3]);
        
        plot(Cumulative_Perf.Scene, 'linewidth', 2);
        title(Category_str{1},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        
        
        subplot('Position',[0.48 0.15 0.15 0.3]);
        
        plot(Cumulative_Perf.OBJ, 'linewidth', 2);
        title(Category_str{2},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        end
        
        
        
        
        
        subplot('Position',[0.66 0.15 0.15 0.3]);
        
        plot(Cumulative_Perf.Pushing, 'linewidth', 2);
        title('Pushing','fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off; 
        
        
        subplot('Position',[0.84 0.15 0.15 0.3]);
        
        plot(Cumulative_Perf.Digging, 'linewidth', 2);
        title('Digging','fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Cumulative Perf','fontsize',12); 
        ylim([0 1]); box off;         
        
        
        
        
        %% Save figures
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        filename_ai=[Prefix '.eps'];
        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        
    end
end