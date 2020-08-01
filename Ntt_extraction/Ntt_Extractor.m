function Ntt_Extractor(session_folder)


%% Created by Jaerong 2015/09/27 for PRC & POR analysis
%% This code extracts spikes from the behavioral epoch only while removing those from the start box


cd([session_folder '\Behavior']);
load Parsedevents.mat

% %% Column Header
% 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void


SB_exit=9;  %% rat exits the startbox
SB_entrance= 11; %% rat enters the startbox following chioce
% cd 'B:\PRC_POR_ephys\Ephys_data\r389\r389-06-04_OCRS(FourOBJ)';
cd(session_folder);

listing_TT= dir('T*'); nb_TT=size(listing_TT,1);


for TT_run= 1:nb_TT
    
    target_TT= [session_folder '\' listing_TT(TT_run).name]; cd(target_TT);
    
    %% If the target file already exists, go to the next file.
    
    if exist('*BEH.ntt');
    continue;
    end
    
    delete('*.parms');

    
    listing_NTT= dir('*.ntt');
    
    disp(['processing ...' listing_NTT(1).name]);
    
    
    Timestamps =[];
    ScNumbers =[];
    CellNumbers =[];
    Features =[];
    Samples =[];
    Header =[];
    
    
    Timestamps_new =[];
    ScNumbers_new =[];
    CellNumbers_new =[];
    Features_new =[];
    Samples_new =[];
    
    
    
    
    for trial_run = 1: size(ts_evt,1)
        
        StartTS= (ts_evt(trial_run, SB_exit))*10^6;
        EndTS= (ts_evt(trial_run, SB_entrance)+10)*10^6;
        Trial_duration= EndTS- StartTS;   %% To be eliminated
        
        if isnan(Trial_duration)
            continue;
        else
        
        disp(sprintf('Trial %d duration = %1.2f', trial_run, Trial_duration/10^6));
        
        [Timestamps, ScNumbers, CellNumbers, Features, Samples, Header] = Nlx2MatSpike(listing_NTT(1).name, [1 1 1 1 1], 1, 4, [StartTS EndTS]);
        
        Timestamps_new= [Timestamps_new Timestamps];
        ScNumbers_new= [ScNumbers_new ScNumbers];
        CellNumbers_new= [CellNumbers_new CellNumbers];
        Features_new= [Features_new Features];
        
        if trial_run == 1
            
            Samples_new= Samples;
        else
            
            Samples_new(:,:,end+1:end+ size(Samples,3))= Samples;
        end
        
        Timestamps= [];
        ScNumbers= [];
        CellNumbers= [];
        Features= [];
        Samples= [];
        
        
        end %% isnan(Trial_duration)
        
    end
    
    
    new_NTT_name = [listing_NTT(1).name(1:end-4) '_BEH.ntt'];
    
    Mat2NlxSpike(new_NTT_name, 0, 1, [], [1 1 1 1 1 1], Timestamps_new, ScNumbers_new, CellNumbers_new, Features_new, Samples_new, Header);
    
end

disp('END');
