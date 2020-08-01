clc;clear all;

dataROOT='I:\PRC_POR_ephys';
summary_path=[dataROOT '\Analysis\Summary'];
cd(summary_path)
behaviorinfosheet = 'behavior_info2.txt';
behaviorinfonew = 'behavior_info_final.txt';

fbeh=fopen(behaviorinfosheet,'r');

i=0;
beh_header=fgetl(fbeh);
remain=[];token=[];
remain=fgetl(fbeh);


summary = struct('Key','?',...
    'Rat','?',...
    'Rec_session','?',...
    'Task_name','?',...
    'Task_session','?'); 

while ischar(remain)
i=i+1;
    [summary(i).Key, remain] = strtok(remain,char(9));%1 %A
    [summary(i).Rat, remain] = strtok(remain,char(9));%2 %B
    [summary(i).Rec_session, remain] = strtok(remain,char(9));%4 %D
    l=length(summary(i).Rec_session);
    if l==1, summary(i).Rec_session=['0' summary(i).Rec_session]; end
    [summary(i).Task_name, remain] = strtok(remain,char(9));%5 %E
    [summary(i).Task_session, remain] = strtok(remain,char(9));%5 %E
   
   
    remain=fgetl(fbeh);
end
fclose(fbeh);

msg=sprintf('%d sessions were loaded',i);
disp(msg);

mean_latency = []
for k = 1: length(summary) 
    
thisR = summary(k).Rat;
thisS = summary(k).Rec_session;
thisTn = summary(k).Task_name;
thisTs = summary(k).Task_session;
    
session_folder = ([dataROOT '\Ephys_data' '\r' thisR '\r' thisR '-' thisS '-0' thisTs '_' thisTn '\Behavior']);
[voided_trials, nb_voided_trials, voidedtrialslatency, lat_mean] = Latency_filter(session_folder)

mean_latency(k,1) =lat_mean
end

