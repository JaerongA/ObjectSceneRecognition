%% By Jaerong 2017/08/11
%% Print out all EEG channels from each channel for the event period.

close all; clear all; clc;
dataROOT= 'F:\PRC_POR_ephys\Ephys_data';
saveROOT= 'F:\PRC_POR_ephys\Analysis\EEG\Visual_Inspection';


% dataROOT= 'H:\PRC_POR_ephys\Ephys_data';
% saveROOT= 'H:\PRC_POR_ephys\Analysis\EEG\Visual_Inspection';

%% Output folder
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


% %% Output file generation
%
% % Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
% outputfile.FourOBJ=['Performance(FourOBJ).csv'];
% fod.FourOBJ=fopen(outputfile.FourOBJ,'w');
% txt_header = 'RatID, Session, Task, Performance(All), Performance(Push), Performance(Dig), Performance(Familiar), Performance(Novel) \n';
% fprintf(fod.FourOBJ, txt_header);
% fclose(fod.FourOBJ);
%
%
%
% outputfile.SceneOBJ=['Performance(SceneOBJ).csv'];
% fod.SceneOBJ=fopen(outputfile.SceneOBJ,'w');
% txt_header = 'RatID, Session, Task, Performance(All), Performance(Push), Performance(Dig), Performance(Scene), Performance(OBJ) \n';
% fprintf(fod.SceneOBJ, txt_header);
% fclose(fod.SceneOBJ);


cd(dataROOT);



%% Parameters

Trial= 1; Stimulus=2; Correctness=3; Response=4;
ChoiceLatency= 5; StimulusOnset=6; Choice=7;
Trial_S3_1=8; Trial_S4_1=9; Trial_S3_end=10; Trial_S4_end=11; Trial_Void=12;
StimulusCAT=13;  %% novelty, modality, category

fig_pos = [80 100 1200 950];
xpos=0.15;
ypos=0.85;





listing_rat=dir('r*');[r1,c1]=size(listing_rat);

for i1=8:r1
    target_rat = [dataROOT '\' listing_rat(i1).name];cd(target_rat)
    listing_session=dir('r*');[r2,c2]=size(listing_session);
    
    for i2= 3
%         1:r2
        target_session = [target_rat '\' listing_session(i2).name];
        
        
        RatID= target_rat(end-3:end);
        
        str1= findstr(target_session,'-');
        str2= findstr(target_session,'_');
        
        Session = target_session(str1(1)+1:str1(2)-1);
        Task_session= target_session(str1(2)+1:str2(end)-1);
        
        
        
        
        clear str1 str2
        
        
        %% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
        Task = target_session(findstr(target_session,'(')-4:end);
        
        
        
%         if ~(strcmp(Task,'OCRS(FourOBJ)') || strcmp(Task,'OCRS(SceneOBJ)'))
        if ~strcmp(Task,'OCRS(FourOBJ)') 
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
        
        
        cd(target_session)
        
        
        
        listing_TT=dir('CSC*');nb_TT=size(listing_TT,1);
        
        
        for trial_run=1:size(ts_evt,1) % for each trial
            
            str= findstr(target_session,'\');
            
            
            ts.StimulusOnset = (ts_evt(trial_run,StimulusOnset)*1E6);
            ts.Choice = (ts_evt(trial_run,Choice)*1E6);
            
            
            
            fig_name= [target_session(str(end)+1:end) '-' sprintf('Trial %d', trial_run)]; fig_name= strrep(fig_name,'_','-');
            
            
            fig=figure('name',fig_name,'Color',[1 1 1],'Position',fig_pos);
            
            subplot('Position', [0.4 0.98 0.45 0.2]);
            text(0,0,fig_name,'fontsize',13);
            axis off;
            
            for TT_run  = 1: nb_TT
                
                cd(target_session)
                
                EEG = [];
                
                csc_ID= listing_TT(TT_run).name;
                
                header = Nlx2MatCSC(csc_ID, [0 0 0 0 0],1,1,[]); % look for ADBitVolts to convert eegs values from bits to volts
%                 bit2volt = str2num(header{15}(1, 14:end)); %read ADBitVolts
                bit2volt = str2num(header{17}(1, 14:end)); %read ADBitVolts
                clear header
                
                
                
                EEG = Nlx2MatCSC(csc_ID, [0 0 0 0 1], 0, 4, [ts.StimulusOnset ts.Choice ]);
                
                
                EEG= EEG.*bit2volt;
                
                nb_smp_eeg=size(EEG,2);
                EEG=reshape(EEG,1,512*nb_smp_eeg);
                
                
                
                %                 subplot('Position', [xpos ypos 0.9 0.1]);
                subplot(nb_TT, 10, (1+ (10*(TT_run-1))) :TT_run*10);
                %                 subplot('Position', [xpos ypos-0.05 0.9 0.1]);
                % %                 subplot('Position', [xpos ypos 0.9 0.1]);
                % %                 subplot('Position', [xpos ypos 0.9 0.1]);
                %
                plot(EEG,'Color',[.5 .5 .5]);  axis  off;
%                 text(-0.05,0.5,csc_ID(1:findstr(csc_ID,'_')-1),'Fontsize',9,'units','normalized'); hold on;
                text(-0.05,0.5,csc_ID(1:end-4),'Fontsize',9,'units','normalized'); hold on;
                
                clear EEG
                
            end
            
            
            str= findstr(fig_name,'-');
            
            fig_saveROOT=[saveROOT '\' fig_name(1:str(end)-1) ];
            if ~exist(fig_saveROOT), mkdir(fig_saveROOT), end
            cd(fig_saveROOT);
            
            
            filename=[fig_name '.png'];
            saveImage(fig,filename,fig_pos);
            
            
            
        end
       
        
        close all;
                
        
    end
end


disp('End');


