%% For filtering out trials with long latencies (> 3 s.d)

dataROOT= 'I:\PRC_POR_ephys\Ephys_data';
saveROOT= 'I:\PRC_POR_ephys\Analysis\Behavior';

if ~exist(saveROOT);
    mkdir(saveROOT);
end

cd(saveROOT);

%% Output file generation

outputfile=['Behavior_FourOBJ.csv'];
fod=fopen(outputfile,'w');
txt_header = 'RatID, Session, Task_session, Task, Performance, Stimulus1, Stimulus2, Stimulus3, Stimulus4, Latency, \n';
fprintf(fod, txt_header);
fclose(fod);
% end


cd(dataROOT);
listing_rat=dir('r*');[r1,c1]=size(listing_rat);

for i1=1:r1
    target_rat = [dataROOT '\' listing_rat(i1).name];cd(target_rat)
    listing_session=dir('r*');[r2,c2]=size(listing_session);
    
    for i2=1:r2
        target_session = [target_rat '\' listing_session(i2).name]; disp(['accessing...' target_session]); cd(target_session);
        
        
        RatID= target_rat(end-3:end);
        
        str1= findstr(target_session,'-');
        str2= findstr(target_session,'_');
        
        Session = target_session(str1(1)+1:str1(2)-1);
        Task_session= target_session(str1(2)+1:str2(end)-1);
        
        
        %% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
        Task = target_session(findstr(target_session,'(')+1:end-1);
%         %
%                 if  strcmp(Task_session,'FourOBJ')
%                     cd(target_session);
%                 else
%                 continue;
%                 end
        
        
        
        cd([target_session '\Behavior'])
        load('Parsedevents.mat');
        
        Latency = nanmean(ts_evt(:,5));
        Performance_list = ts_evt(:,3);
        stimulus= ts_evt(:,2);
        
        Performance = nanmean(ts_evt(:,3))
        
        stimulus_1_list=find(stimulus == 1);
        Perf_1=mean(Performance_list(stimulus_1_list));
               
        stimulus_2_list=find(stimulus == 2);
        Perf_2=mean(Performance_list(stimulus_2_list));
        
        stimulus_3_list=find(stimulus == 3);
        Perf_3=mean(Performance_list(stimulus_3_list));
               
        stimulus_4_list=find(stimulus == 4);
        Perf_4=mean(Performance_list(stimulus_4_list));
        
        
        
        
        cd(saveROOT);
        fod=fopen(outputfile,'a');
        fprintf(fod,'%s ,%s ,%s ,%s, %1.3f, %1.3f, %1.3f, %1.3f, %1.3f, %1.3f, \n',  RatID, Session, Task_session, Task, Performance, Perf_1, Perf_2, Perf_3, Perf_4, Latency);
        fclose(fod);
        
        
        disp(Latency);
        
    end
end
disp('End')
