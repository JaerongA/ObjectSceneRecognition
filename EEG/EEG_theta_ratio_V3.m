%% Created by Jaerong 2017/09/06  for PER & POR ephys analysis


function [summary,summary_header]=EEG_theta_ratio_V3(summary, summary_header,dataROOT)



%% Load EEG Parms

EEG_parms;

nb_data_points= 514;



%% Fig parm

fig_pos = [300 300 1000 700];




%% Save folder

saveROOT= [dataROOT '\Analysis\EEG\Power\' date];

if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)



%% Output file

outputfile= 'EEG_Power.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key#, RatID, Session, Task_session, Task, Region, Subregion, Layer, Bregma, TT, Epoch_theta_Power, NormPower(Theta), NormPower(Beta), NormPower(LowGamma), NormPower(HighGamma), NormPower(Theta_Familiar), NormPower(Theta_Novel), NormPower(LowGamma_Familiar), NormPower(LowGamma_Novel), NormPower(HighGamma_Familiar), NormPower(HighGamma_Novel), Visual_Inspection\n';
fprintf(fod, txt_header);
fclose(fod);





[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if  strcmp(summary(i_s).Visual_Inspection, '1')
        
        
        
        
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
        
        
        
        %% Maxout trial removal (for EEG only)
        
        cd([Session_folder '\EEG\']);
        load([Prefix '_maxout.mat' ]);
        ts_evt(maxout_MAT==1,:)=[];

        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        
        
        
        %% Load EEG
        
        csc_ID= sprintf('CSC%s_RateReduced.ncs',summary(i_s).TT);
        %         csc_ID= sprintf('CSC%s.ncs',summary(i_s).TT);
        cd(Session_folder);
        
        
        
        
        
        %% Look up the ADBitVolts
        
        bit2micovolt = str2num(summary(i_s).ADBitmicrovolts); %read ADBitVolts
        
        
        
        
        
        %% Extract EEG during the event period
        
        
        EEG_MAT=[];
        EEG_baseline_MAT=[];
        
        
        ts_vector= [];
        power=[];
        power_norm=[];
        baseline_power=[];
        
        
        
        
        
        for trial_run= 1:size(ts_evt,1) % for each trial
            
            ts_vector = [];
            EEG = [];
            
            
            
            ts_vector = [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
            
            EEG.epoch = get_EEG(csc_ID, ts_vector, bit2micovolt);
            
            EEG_MAT{trial_run} = EEG.epoch;
            
            
            ts_vector = [ts_evt(trial_run,StimulusOnset)-1 ts_evt(trial_run,StimulusOnset)];
            
            
            
            EEG.baseline = get_EEG(csc_ID, ts_vector, bit2micovolt);
            
            EEG_baseline_MAT{trial_run} = EEG.baseline;
            
        end
        
        
        EEG.epoch = cell2mat(EEG_MAT);
        EEG.baseline = cell2mat(EEG_baseline_MAT);
        
        
        %% Reassemble the data block
        %% Number of data points (in blocks, the number in the power of 2)
        
        EEG_row= nb_data_points;
        EEG_col = floor(numel(EEG.epoch)/nb_data_points);
        
        EEG.epoch((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
        EEG.epoch= reshape(EEG.epoch, EEG_row, EEG_col);
        
        clear EEG_row EEG_col
        
        [S_epoch,F] =mtspectrumc(EEG.epoch,params);
        
        
        
        %% Reassemble the data block
        %% Number of data points (in blocks, the number in the power of 2)
        
        EEG_row= nb_data_points;
        EEG_col = floor(numel(EEG.baseline)/nb_data_points);
        
        EEG.baseline((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
        EEG.baseline= reshape(EEG.baseline, EEG_row, EEG_col);
        
        clear EEG_row EEG_col
        
        
        [S_baseline,F] =mtspectrumc(EEG.baseline,params);
        
        
        
        
        power.delta = bandpower(S_epoch,F,freq_range.delta,'psd')/1E3;
        power.theta = bandpower(S_epoch,F,freq_range.theta,'psd')/1E3;
        power.beta  = bandpower(S_epoch,F,freq_range.beta,'psd')/1E3;
        power.lowgamma  = bandpower(S_epoch,F,freq_range.lowgamma,'psd')/1E3;
        power.highgamma = bandpower(S_epoch,F,freq_range.highgamma,'psd')/1E3;
        
        
        baseline_power.delta = bandpower(S_baseline,F,freq_range.delta,'psd');
        baseline_power.theta = bandpower(S_baseline,F,freq_range.theta,'psd');
        baseline_power.beta  = bandpower(S_baseline,F,freq_range.beta,'psd');
        baseline_power.lowgamma  = bandpower(S_baseline,F,freq_range.lowgamma,'psd');
        baseline_power.highgamma = bandpower(S_baseline,F,freq_range.highgamma,'psd');
        
        
        
        power_norm.delta = power.delta /baseline_power.delta;
        power_norm.theta = power.theta /baseline_power.theta;
        power_norm.beta = power.beta /baseline_power.beta;
        power_norm.lowgamma = power.lowgamma /baseline_power.lowgamma;
        power_norm.highgamma = power.highgamma /baseline_power.highgamma;
        
        
        %% Check the power density function
        
        %             plot(mean(S_epoch)); hold on;
        %             plot(mean(S_baseline))
        
        %     S_epoch= mean(S_epoch);
        %     S_baseline= mean(S_baseline);
        S_norm=  S_epoch./S_baseline;
        %   plot(S_norm)
        
        
        
        % figure(); plot(F,10*log(S_baseline));
        % hold on;  plot(F,10*log(S_epoch));   legend('Baseline','Epoch');
        
        
        
        
        
        %% Create figures
        %% Print out cell ID
        
        
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        
        subplot('Position', [0.2 0.96 0.3 0.2]);
        text(0,0,Prefix,'fontsize',13);
        axis off;
        
        
        
        subplot('position',[0.1 0.15 0.65 0.7]);
        plot(F,S_norm,'linewidth',1.5);
        box off; hold on;
        xlabel('Frequency (Hz)','fontsize',15);
        ylabel('Norm. Power','fontsize',15);
        handle= hline(1);  set(handle,'linewidth',2);
        set(gca,'YTick', [0 max(get(gca,'ylim'))], 'YTickLabel', sprintfc('%0.2f',[0 max(get(gca,'ylim'))]));
        
        clear S_* F
        
        
        
        
        EEG_MAT=[];
        EEG_baseline_MAT=[];
        ts_evt_new= ts_evt(select.Familiar_Corr,:);
        
        for trial_run= 1:size(ts_evt_new,1) % for each trial
            
            ts_vector = [];
            EEG = [];
            
            
            
            ts_vector = [ts_evt_new(trial_run,StimulusOnset) ts_evt_new(trial_run,Choice)];
            
            EEG.epoch = get_EEG(csc_ID, ts_vector, bit2micovolt);
            
            EEG_MAT{trial_run} = EEG.epoch;
            
            
            ts_vector = [ts_evt_new(trial_run,StimulusOnset)-1 ts_evt_new(trial_run,StimulusOnset)];
            
            
            
            EEG.baseline = get_EEG(csc_ID, ts_vector, bit2micovolt);
            
            EEG_baseline_MAT{trial_run} = EEG.baseline;
            
        end
        
        EEG.epoch = cell2mat(EEG_MAT);
        EEG.baseline = cell2mat(EEG_baseline_MAT);
        
        
        %% Reassemble the data block
        %% Number of data points (in blocks, the number in the power of 2)
        
        EEG_row= nb_data_points;
        EEG_col = floor(numel(EEG.epoch)/nb_data_points);
        
        EEG.epoch((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
        EEG.epoch= reshape(EEG.epoch, EEG_row, EEG_col);
        
        clear EEG_row EEG_col
        
        [S_epoch,F] =mtspectrumc(EEG.epoch,params);
        
        
        
        %% Reassemble the data block
        %% Number of data points (in blocks, the number in the power of 2)
        
        EEG_row= nb_data_points;
        EEG_col = floor(numel(EEG.baseline)/nb_data_points);
        
        EEG.baseline((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
        EEG.baseline= reshape(EEG.baseline, EEG_row, EEG_col);
        
        clear EEG_row EEG_col
        
        
        [S_baseline,F] =mtspectrumc(EEG.baseline,params);
        
        
        
        
        
        
        power.theta_Familiar = bandpower(S_epoch,F,freq_range.theta,'psd');
        power.beta_Familiar  = bandpower(S_epoch,F,freq_range.beta,'psd');
        power.lowgamma_Familiar  = bandpower(S_epoch,F,freq_range.lowgamma,'psd');
        power.highgamma_Familiar = bandpower(S_epoch,F,freq_range.highgamma,'psd');
        
        
        baseline_power.theta_Familiar = bandpower(S_baseline,F,freq_range.theta,'psd');
        baseline_power.beta_Familiar  = bandpower(S_baseline,F,freq_range.beta,'psd');
        baseline_power.lowgamma_Familiar  = bandpower(S_baseline,F,freq_range.lowgamma,'psd');
        baseline_power.highgamma_Familiar = bandpower(S_baseline,F,freq_range.highgamma,'psd');
        
        
        
        power_norm.theta_Familiar = power.theta_Familiar /baseline_power.theta_Familiar;
        power_norm.beta_Familiar = power.beta_Familiar /baseline_power.beta_Familiar;
        power_norm.lowgamma_Familiar = power.lowgamma_Familiar /baseline_power.lowgamma_Familiar;
        power_norm.highgamma_Familiar = power.highgamma_Familiar /baseline_power.highgamma_Familiar;
        
        
        
        
        
        
        
        
        
        
        EEG_MAT=[];
        EEG_baseline_MAT=[];
        ts_evt_new= ts_evt(select.Novel_Corr,:);
        
        for trial_run= 1:size(ts_evt_new,1) % for each trial
            
            ts_vector = [];
            EEG = [];
            
            
            
            ts_vector = [ts_evt_new(trial_run,StimulusOnset) ts_evt_new(trial_run,Choice)];
            
            EEG.epoch = get_EEG(csc_ID, ts_vector, bit2micovolt);
            
            EEG_MAT{trial_run} = EEG.epoch;
            
            
            ts_vector = [ts_evt_new(trial_run,StimulusOnset)-1 ts_evt_new(trial_run,StimulusOnset)];
            
            
            
            EEG.baseline = get_EEG(csc_ID, ts_vector, bit2micovolt);
            
            EEG_baseline_MAT{trial_run} = EEG.baseline;
            
        end
        
        EEG.epoch = cell2mat(EEG_MAT);
        EEG.baseline = cell2mat(EEG_baseline_MAT);
        
        
        %% Reassemble the data block
        %% Number of data points (in blocks, the number in the power of 2)
        
        EEG_row= nb_data_points;
        EEG_col = floor(numel(EEG.epoch)/nb_data_points);
        
        EEG.epoch((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
        EEG.epoch= reshape(EEG.epoch, EEG_row, EEG_col);
        
        clear EEG_row EEG_col
        
        [S_epoch,F] =mtspectrumc(EEG.epoch,params);
        
        
        
        %% Reassemble the data block
        %% Number of data points (in blocks, the number in the power of 2)
        
        EEG_row= nb_data_points;
        EEG_col = floor(numel(EEG.baseline)/nb_data_points);
        
        EEG.baseline((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
        EEG.baseline= reshape(EEG.baseline, EEG_row, EEG_col);
        
        clear EEG_row EEG_col
        
        
        [S_baseline,F] =mtspectrumc(EEG.baseline,params);
        
        
        
        
        
        
        power.theta_Novel = bandpower(S_epoch,F,freq_range.theta,'psd');
        power.beta_Novel  = bandpower(S_epoch,F,freq_range.beta,'psd');
        power.lowgamma_Novel  = bandpower(S_epoch,F,freq_range.lowgamma,'psd');
        power.highgamma_Novel = bandpower(S_epoch,F,freq_range.highgamma,'psd');
        
        
        baseline_power.theta_Novel = bandpower(S_baseline,F,freq_range.theta,'psd');
        baseline_power.beta_Novel  = bandpower(S_baseline,F,freq_range.beta,'psd');
        baseline_power.lowgamma_Novel  = bandpower(S_baseline,F,freq_range.lowgamma,'psd');
        baseline_power.highgamma_Novel = bandpower(S_baseline,F,freq_range.highgamma,'psd');
        
        
        
        power_norm.theta_Novel = power.theta_Novel /baseline_power.theta_Novel;
        power_norm.beta_Novel = power.beta_Novel /baseline_power.beta_Novel;
        power_norm.lowgamma_Novel = power.lowgamma_Novel /baseline_power.lowgamma_Novel;
        power_norm.highgamma_Novel = power.highgamma_Novel /baseline_power.highgamma_Novel;
        
        
        
        
        
        
        
        
        msg= sprintf('Theta(Familiar) = %1.2f' , power_norm.theta_Familiar);
        text(1,1.1,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('Theta(Novel) = %1.2f' , power_norm.theta_Novel);
        text(1,1,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('LoGamma(Familiar) = %1.2f' , power_norm.lowgamma_Familiar);
        text(1,0.9,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('LoGamma(Novel) = %1.2f' , power_norm.lowgamma_Novel);
        text(1,0.8,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('HiGamma(Familiar) = %1.2f' , power_norm.highgamma_Familiar);
        text(1,0.7,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('HiGamma(Novel) = %1.2f' , power_norm.highgamma_Novel);
        text(1,0.6,msg,'units','normalized','fontsize',11);
        
        
        
        
        msg= sprintf('Raw Theta = %1.2f (mV^2)' , power.theta);
        text(1,0.5,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('Norm Theta = %1.2f', power_norm.theta);
        text(1,0.4,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('Norm Beta = %1.2f', power_norm.beta);
        text(1,0.3,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('Norm LowGamma = %1.2f', power_norm.lowgamma);
        text(1,0.2,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('Norm HighGamma = %1.2f', power_norm.highgamma);
        text(1,0.1,msg,'units','normalized','fontsize',11);
        
        
        
        
        %% Add to summary
        
        summary(i_s).Theta_Ratio= sprintf('%1.3f',power_norm.theta);
        summary(i_s).Power_Theta= sprintf('%1.3f',power.theta);
        summary(i_s).Power_Beta= sprintf('%1.3f',power.beta);
        summary(i_s).Power_LowGamma= sprintf('%1.3f',power.lowgamma);
        summary(i_s).Power_HighGamma= sprintf('%1.3f',power.highgamma);
        
        
        %% Save figure for verification
        
        cd(saveROOT)
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
        
        %% Output file generation
        
        fod=fopen(outputfile,'a');
        fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Region, Subregion, Layer, Bregma, TTID);
        fprintf(fod,',%1.2f, %1.2f, %1.2f, %1.2f, %1.2f',power.theta, power_norm.theta, power_norm.beta, power_norm.lowgamma, power_norm.highgamma);
        fprintf(fod,',%1.2f, %1.2f, %1.2f, %1.2f, %1.2f, %1.2f',power_norm.theta_Familiar, power_norm.theta_Novel, power_norm.lowgamma_Familiar, power_norm.lowgamma_Novel, power_norm.highgamma_Familiar, power_norm.highgamma_Novel);
        fprintf(fod,',%s',(summary(i_s).Visual_Inspection));
        fprintf(fod,'\n');
        fclose('all');
        
        
        
        clear power  power_norm
        
    end  %  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
    
    
end %   i_s= 1:c_s



end  % function
