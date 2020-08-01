%% for PRC & POR ephys project
%% by Jaerong 2015/09/18

clear all; clc;


session_folder= 'B:\PRC_POR_ephys\Ephys_data\2015-09-17_21-33-39(2nd pilot)';
targetROOT= [session_folder '\ExtractedEvents'];

% function Create_ParsedPosition(session_folder,counterbalanced)

cd(session_folder);   %session folder


%% save setting
saveROOT= [session_folder '\ParsedPosition'];
if ~exist(saveROOT)
    mkdir(saveROOT);
end


pos= dlmread('Pos.p.ascii',',',24,0);
nb_pos=size(pos,1); t=pos(:,1)./10^6; x=pos(:,2); y=pos(:,3); a=pos(:,4); pos=[]; ipos=1;


% % If both x and y are zeros(non visited coordinates) we remove them.
% i1=~logical(x);i2=~logical(y); x(i1&i2)=[];y(i1&i2)=[];a(i1&i2)=[];t(i1|i2)=[];
% %% This emtyies all zeros in the matrix
% t(or(find(x<=0),find(y<=0)))=[];
% a(or(find(x<=0),find(y<=0)))=[];
% x(find(x<=0))=[];
% y(find(y<=0))=[];
% nb_pos= length(t);



cd(targetROOT);
listing_mat= dir('*.mat'); nb_trial= size(listing_mat,1);  %The # of trials



%% variable initialization

pos_Stimulus= zeros(nb_pos,4); pos_Correctness=zeros(nb_pos,2); pos_Response= zeros(nb_pos,2); pos_Trial= zeros(nb_pos, nb_trial);  

trial_Correctness=nan(nb_trial,1);trial_Void=nan(nb_trial,1);trial_Response=nan(nb_trial,1);trial_Stimulus=nan(nb_trial,1);



%% First we tag each position data with trial info such as Trial#, 
%% Stimulus, Correctness, Response value;

for trial_run=1:nb_trial
    
    trial_info=listing_mat(trial_run).name;         
    load (trial_info);
    disp(['loading... ' trial_info]);
    if ~Void
        
        %% This part is very similar to the part used to parse the position data in Create_ParsedSpikes(session_folder,session,valid_clusters,task_code)
        
        if (~isempty(Sensor4(1))) && (~isempty(Choice))  %% Designate sensor4 breakage as the start signal
            

            while ((t(ipos)<Sensor4(1)) && (ipos<(nb_pos-1))) ipos=ipos+1; end
            
            trial_Stimulus(trial_run)=Stimulus; 
            trial_Correctness(trial_run)=Correctness; 
            trial_Response(trial_run)=Response; 
            trial_Void(trial_run)=0; 
            
            %% Create conditional position info
            while ((t(ipos)<=Choice(1)) && ipos<(nb_pos-1))
                
                pos_Stimulus(ipos,Stimulus)=1;      
                pos_Correctness(ipos,Correctness+1)=1;             % if correct corr=[0 1]; incorrect= [1 0];
                pos_Response(ipos,Response+1)=1;         
                pos_Trial(ipos,trial_run)=1;              
                ipos=ipos+1;
            end
            
            
        end % (~isempty(Start)) && (~isempty(Choice)) 
    else
        trial_Void(trial_run)=1;
    end
end



disp('....Parsing of position Data Done');

cd(saveROOT);
save('ParsedPosition.mat','t','x','y','a','pos_Stimulus','pos_Correctness','pos_Response','pos_Trial',...
    'trial_Stimulus','trial_Correctness','trial_Response', 'trial_Void', 'nb_trial');


clear all; clc;