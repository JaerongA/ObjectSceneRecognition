%% Event_Variable_Initialization for PRC & POR ephys study (by Jaerong) 2015/09/16


Trial_Start=[];

Sensor3 =[];Sensor4=[]; StimulusOnset= []; Choice=[]; ChoiceLatency=[];

Stimulus=[]; Modality=[]; Response=[]; Correctness=[]; Void=nan; 

Trial_End=[];
% 
% Trial_Start=nan;
% 
% Sensor3 =nan;Sensor4=nan; StimulusOnset=nan; Choice=nan; Choice_Latency=nan;
% 
% Stimulus=nan; Modality=nan; Response=nan; Correctness=nan; Void=0; 
% 
% Trial_End=nan;



LED_control =  [1 1 0 0 0 0 0 0];
PusingSensor =  [0 1 0 0 0 0 0 0];
DiggingSensor =  [1 0 0 0 0 0 0 0];


mask_LPT   =        [1 1 1 1 1 1 1 1];

% mask_Start   =      [0 0 0 0 0 0 1 1]; %% Rm103B-1
mask_Start   =      [0 0 0 0 0 0 1 0]; %% Rm103B-2


endFlag=0;