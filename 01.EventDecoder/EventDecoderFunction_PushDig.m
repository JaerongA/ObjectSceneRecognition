%% For PRC & POR ephys project
%% Made by Jaerong 2015/09/26


function EventDecoderFunction_PushDig(session_folder)


% session_folder= 'E:\Ephys_data\r394\r394-02-02_OCRS(TwoOBJ)';
% session_folder= 'E:\Ephys_data\r394\r394-02-02_OCRS(TwoOBJ))';
session_folder = 'H:\PRC_POR_ephys\Ephys_data\r558\r558-09-07_OCRS(FourOBJ)';

disp(['processing ...' session_folder(findstr(session_folder,'\')+1:end)]);



%% Session type (in order of appearance)

TwoOBJ_session=0;
FourOBJ_session=0;
Modality_session= 0;
SceneOBJ_session= 0;


%% Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};

Session_CAT = session_folder(findstr(session_folder,'(')+1:end-1);

if     strcmp(Session_CAT,'TwoOBJ')
    
    TwoOBJ_session=1;
    txtStimulus = {'Icecream' ; 'House'};
    
    
elseif    strcmp(Session_CAT,'FourOBJ')
    
    FourOBJ_session= 1;
    txtCategory= {'Familiar' ; 'Novel'};
    txtStimulus = {'Icecream' ; 'House';'Owl' ; 'Phone' };
    
    
elseif    strcmp(Session_CAT,'Modality')
    
    Modality_session= 1;
    txtCategory = {'VT' ; 'Visual'; 'Tactile' };
    txtStimulus = {'Owl' ; 'Phone'};
    PushStimulus= 1;
    DigStimulus= 2;
    
elseif strcmp(Session_CAT,'SceneOBJ')
    
    SceneOBJ_session= 1;
    txtCategory = {'Scene' ; 'OBJ'};
    txtStimulus = {'Zebra' ; 'Pebbles'; 'Owl' ; 'Phone'};
end

txtResponse = {'Push' ; 'Dig'};



% %% Parameters
%
% if Modality_session
%
% elseif FourOBJ_session
%
% elseif SceneOBJ_session
% end


endFlag=0;
directionFlag = 0; % 1 for go, 0 for return

Trial_number=0;
Trial_Start_number=0; Trial_End_number=0;
Void_trial_number=0;

OBJCAT=0;
Modality=0;



% error_correction=1; %% for B:\PRC_POR_ephys\Ephys_data\r344\r344-07-05_OCRS(FourOBJ) only

%% TTL communication with Cheetah  (103B-2 only)

% bit0 ::: communication mode
% bit1 ::: Correctness ::: 0 for incorrect and 1 for correct
% bit2 ::: Start of the Trial ::: 1 when you Start a new Trial
% bit3 ::: End of the Trial ::: 1 when you finished the previous one.
% bit4 ::: Void when the preceding Trial was not exploitable
% bit5 ::: Scene ::: 0 for Scene#1 and 1 for Scene#2
% bit6-7 :::: Free

% We need mask to deal easly with that byte fornat of information
% mask_Start =        [1 0 0 0 0 0 0 0];
% mask_end1 =         [0 1 0 0 0 0 0 0];
% mask_correct =      [0 0 0 1 0 0 0 0];
% mask_Void =         [0 0 0 0 1 0 0 0];
% mask_scene1 =       [0 0 0 0 0 1 0 0];  % 0 0 : Zebra, 0 1 : Pebble, 1 0 : Icecream, 1 1 : House
% mask_scene2 =       [0 0 0 0 0 0 1 0];
%
%
% mask_com1 =         [0 0 0 0 0 0 0 1];
% mask_commit =       [0 0 0 0 0 0 0 0];
% mask_LPT   =        [1 1 1 1 1 1 1 1];  %program Start and end signal. there is no meaning of name.


% mask_end2 =         [0 0 1 0 0 0 0 0];
%
% mask_vtmod =        [0 0 0 1 0 0 0 0]; %% Visuo tactile
% mask_vmod =         [0 0 0 0 1 0 0 0]; %% Visual
% mask_tmod =         [0 0 0 0 0 1 0 0]; %% Tactile



%% Atmega info

LED_control =  [1 1 0 0 0 0 0 0];
PusingSensor =  [0 1 0 0 0 0 0 0];
DiggingSensor =  [1 0 0 0 0 0 0 0];


%% Read the Events.csv file.

cd(session_folder);
fid = fopen('Events.csv','r');


%% TTL port


TTL_computer= 0;
TTL_sensor= 1;
TTL_ATmega= 3;


%% TTL port for 'r397-07-05_OCRS(FourOBJ)'
% TTL_computer= 2;
% TTL_sensor= 3;
% TTL_ATmega= 1;



%% Save root

saveROOT= [session_folder '\ExtractedEvents'];
if ~exist(saveROOT)
    mkdir(saveROOT);
end
cd(saveROOT);



%% Output .txt file
outputfile= 'SessionSummary.txt';
fod=fopen(outputfile,'w');

if Modality_session
    fprintf(fod,'Trial#  \tStimulus \tModality \tCorrectness \tChoiceLatency \tResponse \tVoid \tTrial_Start \tSensor4 \tSensor3 \tStimulusOnset \tChoice \tTrial_End');
elseif (FourOBJ_session || SceneOBJ_session)
    fprintf(fod,'Trial#  \tStimulus \tCategory \tCorrectness \tChoiceLatency \tResponse \tVoid \tTrial_Start \tSensor4 \tSensor3 \tStimulusOnset \tChoice \tTrial_End');
else
    fprintf(fod,'Trial#  \tStimulus \tCorrectness \tChoiceLatency \tResponse \tVoid \tTrial_Start \tSensor4 \tSensor3 \tStimulusOnset \tChoice \tTrial_End');
end
fprintf(fod,'\n');
fclose(fod);




%% variable initialization

Event_Variable_Initialization;


tline = fgetl(fid);


while ischar(tline)
    
    for col = 1:4
        [token, tline] = strtok(tline,',');
    end
    
    timestamp = str2double(token)/10^6;
    %         disp(sprintf('timestamp = %d', timestamp));
    
    
    for col = 5:18
        [token, tline] = strtok(tline,',');
    end
    
    
    
    if strfind(token,'TTL Input on AcqSystem1_0 board 0 port')
        port = token(41);
        a = token(54:55);
        p = dec2binvec( hex2dec(a), 8);
        p = fliplr(p);
        
        %% skip the machine Start time
        %         disp(p);
        
        
        if isequal(p,  mask_LPT)  && (Trial_number<2)
            continue;
            
            
            %         elseif (isequal(p,  mask_LPT)) && (Trial_number>2)
            %             disp('Session Ended');
            %             return;
        end
        
        
        
        
        % %                 disp(port);
        
        switch str2num(port)
            
            case TTL_sensor          %% Port 1 (for sensor signal)
                
                if directionFlag
                    
                    if p(4) == 0    %% Start box
                        Sensor4(end+1) = timestamp;
%                                                                         msg=sprintf('Sensor4 t=%1.2f ',timestamp); disp(msg);
                    end
                    if p(3)
                        Sensor3(end+1) = timestamp;
%                                                                         msg=sprintf('Sensor3 t=%1.2f ',timestamp); disp(msg);
                    end
                end
                
                
                
                
                
            case TTL_ATmega          %% Port 3 (for Atmega signal)
                
                
                
                if isequal(p,LED_control)    %% LED Onset/Offset
                    
                    StimulusOnset = timestamp;
                    msg=sprintf('StimulusOnset t=%1.2f ',timestamp); disp(msg);
                    %                                         Sensor2OnsetLatency= StimulusOnset - Sensor3(1);   %% approximately 1.7ms delay
                    
                elseif isequal(p,PusingSensor)    %% Start box
                    
                    Choice = timestamp;
                    directionFlag=0;
                    msg=sprintf('Pushing Choice t=%1.2f ',timestamp); disp(msg);
                    ChoiceLatency= Choice- StimulusOnset;
                    Response = 0;
                    msg = sprintf('Response = %s',cell2mat(txtResponse(Response+1))); disp(msg);
                    
                    msg=sprintf('Choice Latency= %1.2f s',ChoiceLatency); disp(msg);
                    
                    
                elseif isequal(p,DiggingSensor)    %% Start box
                    
                    Choice = timestamp;
                    directionFlag=0;
                    msg=sprintf('Digging Choice t=%1.2f ',timestamp); disp(msg);
                    Response = 1;
                    msg = sprintf('Response = %s',cell2mat(txtResponse(Response+1))); disp(msg);
                    
                    ChoiceLatency= Choice- StimulusOnset;
                    msg=sprintf('Choice Latency= %1.2f ',ChoiceLatency); disp(msg);
                   

                end
                
                                    

                
                
            case TTL_computer          %% Port 0 (for computer signal)
                
                
                %% Start signal detection (Start box sensor breakage)
                
                %                 disp(p)
                if isequal(p,  mask_Start)          % Start mask signal detected,
                    
                    
                    
                    %                     if Trial_Start_number ~= Trial_End_number  %% If the previous trial did not end properly
                    %                         disp('End signal missing');
                    %                         Trial_Start_number = Trial_Start_number;
                    %                         Trial_number = Trial_number;
                    %                     else
                    %                         Trial_number = Trial_number+1;
                    %                         Trial_Start_number = Trial_Start_number+1;
                    %                     end
                    %
                    
                    Trial_Start = timestamp;
                    
                    if ~isempty(Trial_Start) && (Trial_Start_number == Trial_End_number)
                        Trial_number = Trial_number+1;
                        Trial_Start_number = Trial_Start_number+1;
                    end
                    
                    
                    
                    msg = sprintf('\n\n---- Trial #%d Start t=%1.2f ----',Trial_Start_number,timestamp);disp(msg);
                    
                    
                    directionFlag = 1;
                end
                
                
                
                
                
                %% Trial end signal detection
                
                if (p(6) == 1) && (p(7) == 0 && p(5) == 0)
                    %                 if (p(6) == 1) && (p(7) == 1 && p(5) == 0)
                    Trial_End = timestamp;
                    
                    if ~Modality_session
                        if (Trial_Start_number > Trial_End_number) && ~isempty(Trial_Start) && ~isempty(ChoiceLatency)
                            Trial_End_number = Trial_End_number+1;
                        end
                    end
                    
                    
                    
                    %% Stimulus
                    if p(2) == 0 && p(1) == 0
                        Stimulus = 1;
                    elseif p(2) == 0 && p(1) == 1
                        Stimulus = 2;
                    elseif p(2) == 1 && p(1) == 0
                        Stimulus = 3;
                    elseif p(2) == 1 && p(1) == 1
                        Stimulus = 4;
                    end
                    
                    %                     %% Rat 344 only  (the stimulus identity in the two object session was coded as '3' or '4')
                    %                     if TwoOBJ_session
                    %                     Stimulus = Stimulus - 2;
                    %                     end
                    %
                    
                    %
                    %
                    %                     if Modality_session
                    %
                    %                         if Stimulus <=3
                    %                             Stimulus = PushStimulus;
                    %                         else
                    %                             Stimulus = DigStimulus;
                    %                         end
                    %                     end
                    %
                    
                    
                    disp(['Stimulus = ' cell2mat(txtStimulus(Stimulus))]);
                    
                    
                    
                    
                    
                    
                    
                    %% Stimulus Category
                    if  FourOBJ_session || SceneOBJ_session
                        if Stimulus <=2
                            OBJCAT = 1;
                        else
                            OBJCAT = 2;
                        end
                    end
                    
                    
                    
                    
                    
                    %% Correctness
                    if p(4)
                        Correctness = 0;
                    else
                        Correctness = 1;
                    end
                    msg = sprintf('Correctness = %d',Correctness); disp(msg);
                    
                    
                    
                    %                         txtStimulus = {'Icecream' ; 'House';'Owl' ; 'Phone' };
                    
                    
                    %                     %% Response
                    %                     if Modality_session
                    %                         if (Stimulus == 1)  && Correctness == 0
                    %                             Response = 1;
                    %                         elseif (Stimulus == 1) && Correctness == 1
                    %                             Response = 0;
                    %                         elseif (Stimulus == 2) && Correctness == 0
                    %                             Response = 0;
                    %                         elseif (Stimulus == 2) && Correctness == 1
                    %                             Response = 1;
                    %                         end
                    %
                    %                     elseif SceneOBJ_session
                    %
                    %                         if (Stimulus == 1 || Stimulus == 3) && Correctness == 0
                    %                             Response = 1;
                    %                         elseif (Stimulus == 1 || Stimulus == 3) && Correctness == 1
                    %                             Response = 0;
                    %                         elseif (Stimulus == 2 || Stimulus == 4) && Correctness == 0
                    %                             Response = 0;
                    %                         elseif (Stimulus == 2 || Stimulus == 4) && Correctness == 1
                    %                             Response = 1;
                    %                         end
                    %
                    %                     else
                    %
                    %                         if (Stimulus == 1 || Stimulus == 3) && Correctness == 0
                    %                             Response = 1;
                    %                         elseif (Stimulus == 1 || Stimulus == 3) && Correctness == 1
                    %                             Response = 0;
                    %                         elseif (Stimulus == 2 || Stimulus == 4) && Correctness == 0
                    %                             Response = 0;
                    %                         elseif (Stimulus == 2 || Stimulus == 4) && Correctness == 1
                    %                             Response = 1;
                    %                         end
                    %
                    %                     end  % ~Modality_session
                    
                    
                    
                    
                    
                    %% Void
                    if p(3) || (isempty(Sensor4) || isempty(Sensor3))   %% Revised on 2016/06/13 if either sensor 4 or 3 values are empty after choice, the trial should be voided.
%                     if p(3) ||  isempty(Sensor3) %% r396-08-06_OCRS(FourOBJ)
                        Void = 1;
                        msg = sprintf('Void');disp(msg);
                    else
                        Void = 0;
                    end
                    endFlag= 1;
                    
                    
                    
                    if ~Modality_session
                        msg = sprintf('---- Trial #%d End t=%1.2f ---- \n\n',Trial_End_number, timestamp); disp(msg);
                    end
                    
                end   %% Trial end signal detection
                
                
                %% Modality
                
                
                if (p(5) == 1) && (p(6) == 0 && p(7) == 0)   && endFlag
                    
                    if (Trial_Start_number > Trial_End_number)
                        Trial_End_number = Trial_End_number+1;
                    end
                    
                    if p(4)
                        Modality = 1;
                    elseif p(3)
                        Modality = 2;
                    elseif p(2)
                        Modality = 3;
                    end
                    
                    
                    msg = sprintf('Modality = %s',cell2mat(txtCategory(Modality)));  disp(msg);
                    msg = sprintf('---- Trial #%d End t=%1.2f ---- \n\n',Trial_End_number, timestamp); disp(msg);
                end
                
                
                
                if (Trial_Start_number == Trial_End_number) && ~isempty(Trial_Start) && ~isempty(Trial_End) && ~isempty(ChoiceLatency)  && endFlag
                    
                    
                    %                                         if strcmp(session_folder,'B:\PRC_POR_ephys\Ephys_data\r344\r344-07-05_OCRS(FourOBJ)') && (Trial_Start_number ==1)  %% There was a parsing error in this session
                    %                                             continue;
                    %                                         else
                    %                                             Trial_Start_number = Trial_Start_number -1;
                    %                                         end
                    
                    
                    %                     if strcmp(session_folder,'B:\PRC_POR_ephys\Ephys_data\r344\r344-07-05_OCRS(FourOBJ)')  && (Trial_Start_number ==2) && error_correction
                    %                         Trial_Start_number = Trial_Start_number -1;
                    %                         Trial_End_number = Trial_End_number -1;
                    %                         error_correction =0;
                    %                     end
                    
                    
                    
                    
                    nb_digit= numel(num2str(Trial_Start_number));
                    switch nb_digit
                        
                        case 1
                            f= sprintf('Trial00%s.mat',num2str(Trial_Start_number));
                        case 2
                            f= sprintf('Trial0%s.mat',num2str(Trial_Start_number));
                        case 3
                            f = sprintf('Trial%s.mat',num2str(Trial_Start_number));
                        otherwise
                    end
                    
                    
                    
                    if Modality_session
                        
                        save(f,'Sensor3','Sensor4','Trial_Start','ChoiceLatency','StimulusOnset','Stimulus','Modality','Response','Correctness','Choice','Void','Trial_End');
                    else
                        save(f,'Sensor3','Sensor4','Trial_Start','ChoiceLatency','StimulusOnset','Stimulus','Response','Correctness','Choice','Void','Trial_End');
                    end
                    
                    
                    
%                         Sensor4= nan; %% r396-08-06_OCRS(FourOBJ)
                    
                    
                    
                    %% Save Trial summary txt file
                    if Void
                        Correctness= nan;
                        ChoiceLatency= nan;
                        Sensor4= nan;
                        Sensor3= nan;
                        StimulusOnset= nan;
                        Choice= nan;
                        Trial_Start= nan;
                        Trial_End= nan;
                    end
                    
                    
                    fod= fopen(outputfile,'a');
                    
                    if Modality_session
                        
                        fprintf(fod,'%d \t%s \t%s \t%d \t%1.4f \t%s \t%d \t%1.4f \t%1.4f \t%1.4f \t%1.4f \t%1.4f \t%1.4f',...
                            Trial_Start_number, cell2mat(txtStimulus(Stimulus)),cell2mat(txtCategory(Modality)), Correctness, ChoiceLatency, cell2mat(txtResponse(Response+1)), Void, Trial_Start, Sensor4(1), Sensor3(1), StimulusOnset, Choice, Trial_End);
                        
                        
                    elseif (FourOBJ_session || SceneOBJ_session)
                        fprintf(fod,'%d \t%s \t%s \t%d \t%1.4f \t%s \t%d \t%1.4f \t%1.4f \t%1.4f \t%1.4f \t%1.4f \t%1.4f',...
                            Trial_Start_number, cell2mat(txtStimulus(Stimulus)), cell2mat(txtCategory(OBJCAT)), Correctness, ChoiceLatency, cell2mat(txtResponse(Response+1)), Void, Trial_Start, Sensor4(1), Sensor3(1), StimulusOnset, Choice, Trial_End);
                        
                    else
                        fprintf(fod,'%d \t%s \t%d \t%1.4f \t%s \t%d \t%1.4f \t%1.4f \t%1.4f \t%1.4f \t%1.4f \t%1.4f',...
                            Trial_Start_number, cell2mat(txtStimulus(Stimulus)), Correctness, ChoiceLatency, cell2mat(txtResponse(Response+1)), Void, Trial_Start, Sensor4(1), Sensor3(1), StimulusOnset, Choice, Trial_End);
                    end
                    
                    fprintf(fod,'\n');
                    fclose(fod);
                    endFlag= 0;
                    
                    
                    %% variable initialization
                    
                    Event_Variable_Initialization;
                    
                    
                    
                end  %  Trial_End_number && (Trial_Start_number == Trial_End_number)
                
        end
        
        
    end
    
    
    tline = fgetl(fid);
    
    
    
end



fclose('all');
clear all;