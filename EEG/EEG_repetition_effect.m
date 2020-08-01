%% Created by Jaerong 2017/09/01  for PER & POR ephys analysis


function [summary,summary_header]=EEG_repetition_effect(summary, summary_header,dataROOT)


%% Load EEG Parms

EEG_parms;


%% Fig parms

fig_pos = [100 150 1600 850];
bgcol=[1 0.6 0.6; 0.6 1 0.6];



%% Parms

alpha= 0.05;
xpos=0.8;
ypos=1.6;



%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\Repetition\' date ];

if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)



%% Output file

outputfile= 'EEG_repetition.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key#, RatID, Session, Task_session, Task, Region, Subregion, Layer, Bregma, TT,';
fprintf(fod, txt_header);
txt_header = 'Fitting_Category(Theta), CorrR(Theta), Slope(Theta), Polarity(Theta),';
fprintf(fod, txt_header);
txt_header = 'Fitting_Category(LoGamma), CorrR(LoGamma),  Slope(LoGamma), Polarity(LoGamma),';
fprintf(fod, txt_header);
txt_header = 'Fitting_Category(highGamma), CorrR(highGamma),  Slope(highGamma), Polarity(highGamma),';
fprintf(fod, txt_header);
fprintf(fod,'\n');
fclose(fod);




[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if  strcmp(summary(i_s).Visual_Inspection, '1')  &&  strcmp(summary(i_s).Power_criteria, '1')
        
        
        
        
        %% Set EEG info
        
        set_eeg_prefix;
        
        
        
        
        
        %% Loading trial ts info from ParsedEvents.mat
        
        
        % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        % 13. StimulusCat
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load_ts_evt;
        
                
        %% Select trial types
        
        select_trial_type;
 
        
        %% Performance
        
        Perf =[];
        
        for Stimulus_run = 1: 4
            
            eval(['Perf(Stimulus_run) = mean(ts_evt(select.Stimulus' num2str(Stimulus_run) '_All,Correctness));'])
            
        end
        
        
        
        
        
        
        %% Maxout trial removal (for EEG only)
        
        cd([Session_folder '\EEG\']);
        load([Prefix '_maxout.mat' ]);
        ts_evt(maxout_MAT==1,:)=[];
        
        
        
        
        
        
        
        %% Look up the ADBitVolts
        
        bit2milivolt = str2num(summary(i_s).ADBitmilivolts); %read ADBitVolts
        
        
       

        
        
        %% Extract EEG during the event period
        
        EEG_MAT=[];
        
        
        for trial_run= 1:size(ts_evt,1) % for each trial
            
            ts_vector = [];
            EEG = [];
            
            
            cd([Session_folder '\EEG\Noise_reduction']);
            csc_ID= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
            
            
            ts_vector = [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
            
            
            EEG = get_EEG(csc_ID, ts_vector, bit2milivolt);
            
            EEG_MAT{trial_run} = EEG;
            
            
        end
        
        clear EEG
        
        
        
        %% Calculate the frequency power
        
        Power_All=[];
        Power_Theta=[];
        Power_GammaLow=[];
        Power_GammaHigh=[];
        
        
        
        
        
        
        for trial_run= 1:size(EEG_MAT,2)
        
        Power_All(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)));
        Power_Theta(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.theta);
        Power_GammaLow(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.lowgamma);
        Power_GammaHigh(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.highgamma);
        
        end
        
        clear EEG* 

        
        
        
        %% Noisy trial elimination
        
        criteria = [];
        
        criteria = mean(Power_All) + std(Power_All)*2;
        
        
        nb_voided_trials= sum(Power_All > criteria);
        to_be_voided= (Power_All > criteria);
        msg= sprintf('nb trials voided = %d',sum(nb_voided_trials));
        disp(msg); clear msg;
        
        
        
        Power_All(to_be_voided) = [];
        Power_Theta(to_be_voided) = [];
        Power_GammaLow(to_be_voided) = [];
        Power_GammaHigh(to_be_voided) = [];
        ts_evt(find(to_be_voided == 1)',:) = [];
        
        
        %% Select trial types
        
        select_trial_type;        
        
        
        ts_evt= ts_evt(select.Corr,:);
        
        
        %% Min Max normalization 
               
        
        Power_All = mapminmax(Power_All, 0, 10)';
        Power_Theta = mapminmax(Power_Theta, 0, 10)';
        Power_GammaLow = mapminmax(Power_GammaLow, 0, 10)';
        Power_GammaHigh = mapminmax(Power_GammaHigh, 0, 10)';
        
        
        
        
        
        %% Create figures
        %% Print out cell ID
        
        
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        
        subplot('Position', [0.42 0.99 0.3 0.2]);
        text(0,0,Prefix,'fontsize',13);
        axis off;
        
        
        
        
        
        %% Output file generation
        
        cd(saveROOT)
        fod=fopen(outputfile,'a');
        fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Region, Subregion, Layer, Bregma, TTID);
        fclose('all');
        
        
        
        
        
        
        %% Theta
        
        
        
        target_Power=[];
        target_Power= Power_Theta;
        
        
        CorrR=[];
        Corr_Pval=[];
        Pval_sig=[];
        Polarity =cell(1,4);
        
        
        
        
        for Stimulus_run = 1:4
            
            
            if Stimulus_run ==1
                
                subplot('position',[0.08 0.7 0.15 0.15]);
            else
                
                subplot('position',[((Stimulus_run-1)/4)+0.02 0.7 0.15 0.15]);
                
            end
            
            
            get_repetition_fitting;
            
            
            if Stimulus_run ==1
                
                text(-0.45, 0.5,'Theta','units','normalized', 'fontsize', 15);
                
            end
            
            
        end   %%  Stimulus_run = 1:4
        
        
        
        
        %% Get repetition categorization
        
        
        Fitting_cat = get_category_repetition(Pval_sig);
        
        
        
        
        if sum(Pval_sig)==1
            
            CorrR= CorrR(logical(Pval_sig));
            Corr_Pval = Corr_Pval(logical(Pval_sig));
            Slope = Slope(logical(Pval_sig));
            Polarity = cell2mat(Polarity(logical(Pval_sig)));
            
        elseif  sum(Pval_sig)> 1
            
            ind= find(abs(CorrR) == max(abs(CorrR)));
            CorrR= CorrR(ind);
            Corr_Pval = Corr_Pval(ind);
            Slope = Slope(ind);
            Polarity =cell2mat(Polarity(ind));
            
        else
            
            CorrR= nan;
            Corr_Pval = nan;
            Slope = nan;
            Polarity = nan;
            
        end
        
        
        %% Output file generation
        
        
        
        
        fod=fopen(outputfile,'a');
        fprintf(fod,',%s, %1.2f, %1.2f, %s',Fitting_cat, CorrR, Slope, Polarity);
        fclose('all');
        
        
        
        
        
        
        %% Low gamma
        
        
        
        target_Power=[];
        target_Power= Power_GammaLow;
        
        CorrR=[];
        Corr_Pval=[];
        Pval_sig=[];
        Polarity =cell(1,4);
        
        
        for Stimulus_run = 1:4
            
            if Stimulus_run ==1
                
                subplot('position',[0.08 0.4 0.15 0.15]);
            else
                
                subplot('position',[((Stimulus_run-1)/4)+0.02 0.4 0.15 0.15]);
                
            end
            
            
            
            get_repetition_fitting;
            
            
            if Stimulus_run ==1
                
                
                text(-0.5, 0.5,'LowGamma','units','normalized', 'fontsize', 11);
                
            end
            
            
        end   %%  Stimulus_run = 1:4
        
        
        
        
        %% Get repetition categorization
        
        
        Fitting_cat = get_category_repetition(Pval_sig);
        
        
        
        
        if sum(Pval_sig)==1
            
            CorrR= CorrR(logical(Pval_sig));
            Corr_Pval = Corr_Pval(logical(Pval_sig));
            Slope = Slope(logical(Pval_sig));
            Polarity = cell2mat(Polarity(logical(Pval_sig)));
            
        elseif  sum(Pval_sig)> 1
            
            ind= find(abs(CorrR) == max(abs(CorrR)));
            CorrR= CorrR(ind);
            Corr_Pval = Corr_Pval(ind);
            Slope = Slope(ind);
            Polarity =cell2mat(Polarity(ind));
            
        else
            
            CorrR= nan;
            Corr_Pval = nan;
            Slope = nan;
            Polarity = nan;
            
        end
        
        
        %% Output file generation
        
        
        
        
        fod=fopen(outputfile,'a');
        fprintf(fod,',%s, %1.2f, %1.2f, %s',Fitting_cat, CorrR, Slope, Polarity);
        fclose('all');
        
        
        
        
        
        
        
        %% High gamma

        
        target_Power=[];
        target_Power= Power_GammaHigh;
        
        
        CorrR=[];
        Corr_Pval=[];
        Pval_sig=[];
        Polarity =cell(1,4);
        
        
        
        
        for Stimulus_run = 1:4
            
            
            
            if Stimulus_run ==1
                
                subplot('position',[0.08 0.1 0.15 0.15]);
            else
                
                subplot('position',[((Stimulus_run-1)/4)+0.02 0.1 0.15 0.15]);
                
            end
            
            
            
            get_repetition_fitting;
            
            
            if Stimulus_run ==1
                
                text(-0.5, 0.5,'HighGamma','units','normalized', 'fontsize', 11);
                
            end
            
        end   %%  Stimulus_run = 1:4
        
        
        
        
        
        
        %% Get repetition categorization
        
        
        Fitting_cat = get_category_repetition(Pval_sig);
        
        
        
        
        if sum(Pval_sig)==1
            
            CorrR= CorrR(logical(Pval_sig));
            Corr_Pval = Corr_Pval(logical(Pval_sig));
            Slope = Slope(logical(Pval_sig));
            Polarity = cell2mat(Polarity(logical(Pval_sig)));
            
        elseif  sum(Pval_sig)> 1
            
            ind= find(abs(CorrR) == max(abs(CorrR)));
            CorrR= CorrR(ind);
            Corr_Pval = Corr_Pval(ind);
            Slope = Slope(ind);
            Polarity =cell2mat(Polarity(ind));
            
        else
            
            CorrR= nan;
            Corr_Pval = nan;
            Slope = nan;
            Polarity = nan;
            
        end
        
        
        %% Output file generation
        
        
        
        
        fod=fopen(outputfile,'a');
        fprintf(fod,',%s, %1.2f, %1.2f, %s,',Fitting_cat, CorrR, Slope, Polarity);
        fprintf(fod, '\n');
        fclose('all');
        
        
        
        
        clear norm*
        
        
        %% Save figure for verification
        
        cd(saveROOT)
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
    end  %    strcmp(summary(i_s).Visual_Inspection, '1')
    
    
end %   i_s= 1:c_s



end  % function
