%% By Jaerong 2016/02/07
%% Get the learning curve per condition (based on state-space model)

% % Smith AC, Wirth A, Suzuki W, Brown EN. Bayesian analysis of interleaved learning and
% % response bias in behavioral experiments. Journal of Neurophysiology, 2007,
% % 97(3): 2516-2524.


clear all; clc; close all;


% dataROOT= 'G:\PRC_POR_ephys\Ephys_data';
% saveROOT= 'G:\PRC_POR_ephys\Analysis\Performance\LearningCurve';


dataROOT= 'F:\PRC_POR_ephys\Ephys_data';
saveROOT= 'F:\PRC_POR_ephys\Analysis\Performance\LearningCurve';
matbugROOT = 'F:\PRC-POR_ephys_toolbox\Learning_Analysis\IndividualAnalysisWinBUGS';


%% Output folder
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


%% Parms
Trial= 1; Stimulus=2; Correctness=3; Response=4;
ChoiceLatency= 5; StimulusOnset=6; Choice=7;
Trial_S3_1=8; Trial_S4_1=9; Trial_S3_end=10; Trial_S4_end=11; Trial_Void=12;
StimulusCAT=13;  %% novelty, modality, category


BackgroundProb=0.5;
MaxResponse=1;
SigE = 0.005; %default variance of learning state process is sqrt(0.005)
UpdaterFlag = 2;  %default allows bias
startP = 0.5;  %expected initial probability


fig_pos=[-800 480 2600 550]; %lab computer
%         fig_pos=[30 30 1200 1000]; % home computer

%% Category
Familiar= 1;
Novel =2;

SceneCAT= 1;
OBJCAT =2;


cd(dataROOT);


listing_rat=dir('r*'); r1=size(listing_rat,1);

for i1=2:r1
    target_rat = [dataROOT '\' listing_rat(i1).name];cd(target_rat)
    listing_session=dir('r*'); r2=size(listing_session,1);
    
    for i2=1:r2
        target_session = [target_rat '\' listing_session(i2).name];
        
        
        RatID= target_rat(end-3:end);
        
        str1= findstr(target_session,'-');
        str2= findstr(target_session,'_');
        str3= findstr(target_session,'\');
        
        
        
        Session = target_session(str1(1)+1:str1(2)-1);
        Task_session= target_session(str1(2)+1:str2(end)-1);
        
        
        %% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
        Task = target_session(findstr(target_session,'(')-4:end);
        
        Prefix= target_session(str3(end)+1:end); Prefix= strrep(Prefix,'_','-');
        
        clear str*
        
        if ~(strcmp(Task,'OCRS(FourOBJ)') || strcmp(Task,'OCRS(SceneOBJ)'))
            continue;
        else
            disp(['accessing...' target_session]); cd(target_session);
        end
        
        
        
       %% Column Header for ts_evt
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
        
        
        
        Corr_mat=[]; Learning_curve=[];
        
        Corr_mat.All=  ts_evt(:,Correctness)';
        Corr_mat.Pushing=  ts_evt(select.Pushing,Correctness)';
        Corr_mat.Digging=  ts_evt(select.Digging,Correctness)';
        
        Corr_mat.Stimulus1=  ts_evt(select.Stimulus1_all,Correctness)';
        Corr_mat.Stimulus2=  ts_evt(select.Stimulus2_all,Correctness)';
        Corr_mat.Stimulus3=  ts_evt(select.Stimulus3_all,Correctness)';
        Corr_mat.Stimulus4=  ts_evt(select.Stimulus4_all,Correctness)';
        
        
        
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            Corr_mat.Familiar =  ts_evt(select.Familiar,Correctness)';
            Corr_mat.Novel =  ts_evt(select.Novel,Correctness)';
            
        elseif strcmp(Task,'OCRS(SceneOBJ)')
            
            Corr_mat.Scene =  ts_evt(select.Scene,Correctness)';
            Corr_mat.OBJ =  ts_evt(select.OBJ,Correctness)';
            
        end
        
        
        
        
        
        %put matlab data in format for matbugs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        [Learning_curve.All Learning_curve_lowerCI.All Learning_curve_upperCI.All] = get_latent_learning(Corr_mat.All, startP, matbugROOT);
        
        [Learning_curve.Pushing Learning_curve_lowerCI.Pushing Learning_curve_upperCI.Pushing] = get_latent_learning(Corr_mat.Pushing, startP, matbugROOT);
        [Learning_curve.Digging Learning_curve_lowerCI.Digging Learning_curve_upperCI.Digging] = get_latent_learning(Corr_mat.Digging, startP, matbugROOT);
        
        if mean(Corr_mat.Stimulus1) <= 0.9
            [Learning_curve.Stimulus1 Learning_curve_lowerCI.Stimulus1 Learning_curve_upperCI.Stimulus1] = get_latent_learning(Corr_mat.Stimulus1, startP, matbugROOT);
        end
        
        if mean(Corr_mat.Stimulus2) <= 0.9
            [Learning_curve.Stimulus2 Learning_curve_lowerCI.Stimulus2 Learning_curve_upperCI.Stimulus2] = get_latent_learning(Corr_mat.Stimulus2, startP, matbugROOT);
        end
        
        if mean(Corr_mat.Stimulus3) <= 0.9
            [Learning_curve.Stimulus3 Learning_curve_lowerCI.Stimulus3 Learning_curve_upperCI.Stimulus3] = get_latent_learning(Corr_mat.Stimulus3, startP, matbugROOT);
        end
        
        if mean(Corr_mat.Stimulus4) <= 0.9
            [Learning_curve.Stimulus4 Learning_curve_lowerCI.Stimulus4 Learning_curve_upperCI.Stimulus4] = get_latent_learning(Corr_mat.Stimulus4, startP, matbugROOT);
        end
        
        
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            [Learning_curve.Familiar Learning_curve_lowerCI.Familiar Learning_curve_upperCI.Familiar] = get_latent_learning(Corr_mat.Familiar, startP, matbugROOT);
            [Learning_curve.Novel Learning_curve_lowerCI.Novel Learning_curve_upperCI.Novel] = get_latent_learning(Corr_mat.Novel, startP, matbugROOT);
            
        elseif strcmp(Task,'OCRS(SceneOBJ)')
            
            [Learning_curve.Scene Learning_curve_lowerCI.Scene Learning_curve_upperCI.Scene] = get_latent_learning(Corr_mat.Scene, startP, matbugROOT);
            [Learning_curve.OBJ Learning_curve_lowerCI.OBJ Learning_curve_upperCI.OBJ] = get_latent_learning(Corr_mat.OBJ, startP, matbugROOT);
            
        end
        
        
        
        %% Store the cumulative performance vectors into a .mat file
        
        cd(saveROOT);
        
        save([Prefix '.mat'],'Learning_curve');
        
        
        
        
        %% GLOBAL PETH
        
        
        fig=figure('name',Prefix, 'Color',[1 1 1],'Position',fig_pos);
        
        
        subplot('Position', [0.45 0.98 0.4 0.2]);
        text(0,0,Prefix,'fontsize',15);
        axis off;
        
        
        
        
        subplot('Position',[0.03 0.15 0.25 0.7]);
        
        
        
        plot(Learning_curve_lowerCI.All,'r:'); hold on; ylim([0 1]); box off;
        plot(Learning_curve.All,'k-','linewidth',2); hold on;
        plot(Learning_curve_upperCI.All,'r:');
        
        t=1:size(Learning_curve.All,1)-1;
        
        if(MaxResponse == 1)
            hold on; [y, x] = find(Corr_mat.All > 0);
            %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
            %             set(h, 'MarkerEdgeColor', 'k');
            scatter(x, y + 0.05, 10,'k','filled');
            hold on; [y, x] = find(Corr_mat.All == 0);
            %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
            %             set(h, 'MarkerEdgeColor', 'k');
            scatter(x, y + 0.05, 10,'k');
            axis([1 t(end)  0 1.05]);
        else
            hold on; plot(t, Corr_mat.All./MaxResponse,'ko');
            axis([1 t(end)  0 1]);
        end
        
        title('ALL','fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
        
        
        
        
        
        
        
        if mean(Corr_mat.Stimulus1) <= 0.9
            
        subplot('Position',[0.3 0.58 0.15 0.3]);
        
            plot(Learning_curve_lowerCI.Stimulus1,'r:'); hold on; ylim([0 1]); box off;
            plot(Learning_curve.Stimulus1,'k-','linewidth',2); hold on;
            plot(Learning_curve_upperCI.Stimulus1,'r:');
            
            t=1:size(Learning_curve.Stimulus1,1)-1;
            
            if(MaxResponse == 1)
                hold on; [y, x] = find(Corr_mat.Stimulus1 > 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k','filled');
                hold on; [y, x] = find(Corr_mat.Stimulus1 == 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k');
                axis([1 t(end)  0 1.05]);
            else
                hold on; plot(t, Corr_mat.Stimulus1./MaxResponse,'ko');
                axis([1 t(end)  0 1]);
            end
            
            title(Stimulus_str{1},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
            
            
        end
        
        
        
        
        if mean(Corr_mat.Stimulus2) <= 0.9
            
        subplot('Position',[0.48 0.58 0.15 0.3]);
            plot(Learning_curve_lowerCI.Stimulus2,'r:'); hold on; ylim([0 1]); box off;
            plot(Learning_curve.Stimulus2,'k-','linewidth',2); hold on;
            plot(Learning_curve_upperCI.Stimulus2,'r:');
            
            t=1:size(Learning_curve.Stimulus2,1)-1;
            
            if(MaxResponse == 1)
                hold on; [y, x] = find(Corr_mat.Stimulus2 > 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k','filled');
                hold on; [y, x] = find(Corr_mat.Stimulus2 == 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k');
                axis([1 t(end)  0 1.05]);
            else
                hold on; plot(t, Corr_mat.Stimulus2./MaxResponse,'ko');
                axis([1 t(end)  0 1]);
            end
            
            title(Stimulus_str{2},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
            
        end
        
        
        
        
        
        if mean(Corr_mat.Stimulus3) <= 0.9
            
        subplot('Position',[0.66 0.58 0.15 0.3]);
            plot(Learning_curve_lowerCI.Stimulus3,'r:'); hold on; ylim([0 1]); box off;
            plot(Learning_curve.Stimulus3,'k-','linewidth',2); hold on;
            plot(Learning_curve_upperCI.Stimulus3,'r:');
            
            t=1:size(Learning_curve.Stimulus3,1)-1;
            
            if(MaxResponse == 1)
                hold on; [y, x] = find(Corr_mat.Stimulus3 > 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k','filled');
                hold on; [y, x] = find(Corr_mat.Stimulus3 == 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k');
                axis([1 t(end)  0 1.05]);
            else
                hold on; plot(t, Corr_mat.Stimulus3./MaxResponse,'ko');
                axis([1 t(end)  0 1]);
            end
            
            title(Stimulus_str{3},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
            
        end
        
        
        
        
        
        
        if mean(Corr_mat.Stimulus4) <= 0.9
            
            
        subplot('Position',[0.84 0.58 0.15 0.3]);
            plot(Learning_curve_lowerCI.Stimulus4,'r:'); hold on; ylim([0 1]); box off;
            plot(Learning_curve.Stimulus4,'k-','linewidth',2); hold on;
            plot(Learning_curve_upperCI.Stimulus4,'r:');
            
            t=1:size(Learning_curve.Stimulus4,1)-1;
            
            if(MaxResponse == 1)
                hold on; [y, x] = find(Corr_mat.Stimulus4 > 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k','filled');
                hold on; [y, x] = find(Corr_mat.Stimulus4 == 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k');
                axis([1 t(end)  0 1.05]);
            else
                hold on; plot(t, Corr_mat.Stimulus4./MaxResponse,'ko');
                axis([1 t(end)  0 1]);
            end
            
            title(Stimulus_str{4},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
            
        end
        
        
        
        
        
        if strcmp(Task,'OCRS(FourOBJ)')
            
            
            subplot('Position',[0.3 0.15 0.15 0.3]);
            
            
            plot(Learning_curve_lowerCI.Familiar,'r:'); hold on; ylim([0 1]); box off;
            plot(Learning_curve.Familiar,'k-','linewidth',2); hold on;
            plot(Learning_curve_upperCI.Familiar,'r:');
            
            t=1:size(Learning_curve.Familiar,1)-1;
            
            if(MaxResponse == 1)
                hold on; [y, x] = find(Corr_mat.Familiar > 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k','filled');
                hold on; [y, x] = find(Corr_mat.Familiar == 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k');
                axis([1 t(end)  0 1.05]);
            else
                hold on; plot(t, Corr_mat.Familiar./MaxResponse,'ko');
                axis([1 t(end)  0 1]);
            end
            
            title(Category_str{1},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
            
            
            
            
            subplot('Position',[0.48 0.15 0.15 0.3]);
            
            
            plot(Learning_curve_lowerCI.Novel,'r:'); hold on; ylim([0 1]); box off;
            plot(Learning_curve.Novel,'k-','linewidth',2); hold on;
            plot(Learning_curve_upperCI.Novel,'r:');
            
            t=1:size(Learning_curve.Novel,1)-1;
            
            if(MaxResponse == 1)
                hold on; [y, x] = find(Corr_mat.Novel > 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k','filled');
                hold on; [y, x] = find(Corr_mat.Novel == 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k');
                axis([1 t(end)  0 1.05]);
            else
                hold on; plot(t, Corr_mat.Novel./MaxResponse,'ko');
                axis([1 t(end)  0 1]);
            end
            
            title(Category_str{2},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
            
            
            
            
        elseif strcmp(Task,'OCRS(SceneOBJ)')
            
            
            
            subplot('Position',[0.3 0.15 0.15 0.3]);
            
            
            plot(Learning_curve_lowerCI.Scene,'r:'); hold on; ylim([0 1]); box off;
            plot(Learning_curve.Scene,'k-','linewidth',2); hold on;
            plot(Learning_curve_upperCI.Scene,'r:');
            
            t=1:size(Learning_curve.Scene,1)-1;
            
            if(MaxResponse == 1)
                hold on; [y, x] = find(Corr_mat.Scene > 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k','filled');
                hold on; [y, x] = find(Corr_mat.Scene == 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k');
                axis([1 t(end)  0 1.05]);
            else
                hold on; plot(t, Corr_mat.Scene./MaxResponse,'ko');
                axis([1 t(end)  0 1]);
            end
            
            title(Category_str{1},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
            
            
            
            
            subplot('Position',[0.48 0.15 0.15 0.3]);
            
            
            plot(Learning_curve_lowerCI.OBJ,'r:'); hold on; ylim([0 1]); box off;
            plot(Learning_curve.OBJ,'k-','linewidth',2); hold on;
            plot(Learning_curve_upperCI.OBJ,'r:');
            
            t=1:size(Learning_curve.OBJ,1)-1;
            
            if(MaxResponse == 1)
                hold on; [y, x] = find(Corr_mat.OBJ > 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k','filled');
                hold on; [y, x] = find(Corr_mat.OBJ == 0);
                %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
                %             set(h, 'MarkerEdgeColor', 'k');
                scatter(x, y + 0.05, 20,'k');
                axis([1 t(end)  0 1.05]);
            else
                hold on; plot(t, Corr_mat.OBJ./MaxResponse,'ko');
                axis([1 t(end)  0 1]);
            end
            
            title(Category_str{2},'fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
            
            
        end
        
        
        
        
        
        subplot('Position',[0.66 0.15 0.15 0.3]);
        
        
        plot(Learning_curve_lowerCI.Pushing,'r:'); hold on; ylim([0 1]); box off;
        plot(Learning_curve.Pushing,'k-','linewidth',2); hold on;
        plot(Learning_curve_upperCI.Pushing,'r:');
        
        t=1:size(Learning_curve.Pushing,1)-1;
        
        if(MaxResponse == 1)
            hold on; [y, x] = find(Corr_mat.Pushing > 0);
            %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
            %             set(h, 'MarkerEdgeColor', 'k');
            scatter(x, y + 0.05, 20,'k','filled');
            hold on; [y, x] = find(Corr_mat.Pushing == 0);
            %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
            %             set(h, 'MarkerEdgeColor', 'k');
            scatter(x, y + 0.05, 20,'k');
            axis([1 t(end)  0 1.05]);
        else
            hold on; plot(t, Corr_mat.Pushing./MaxResponse,'ko');
            axis([1 t(end)  0 1]);
        end
        
        title('Pushing','fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
        
        
        
        
        subplot('Position',[0.84 0.15 0.15 0.3]);
        
        
        plot(Learning_curve_lowerCI.Digging,'r:'); hold on; ylim([0 1]); box off;
        plot(Learning_curve.Digging,'k-','linewidth',2); hold on;
        plot(Learning_curve_upperCI.Digging,'r:');
        
        t=1:size(Learning_curve.Digging,1)-1;
        
        if(MaxResponse == 1)
            hold on; [y, x] = find(Corr_mat.Digging > 0);
            %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
            %             set(h, 'MarkerEdgeColor', 'k');
            scatter(x, y + 0.05, 20,'k','filled');
            hold on; [y, x] = find(Corr_mat.Digging == 0);
            %             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
            %             set(h, 'MarkerEdgeColor', 'k');
            scatter(x, y + 0.05, 20,'k');
            axis([1 t(end)  0 1.05]);
        else
            hold on; plot(t, Corr_mat.Digging./MaxResponse,'ko');
            axis([1 t(end)  0 1]);
        end
        
        title('Digging','fontsize',12); xlabel('Trial#','fontsize',12); ylabel('Performance','fontsize',12);
        
        
        
        
        %% Save figures
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        filename_ai=[Prefix '.eps'];
        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        
    end
end