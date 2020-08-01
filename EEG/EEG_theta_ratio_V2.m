%% Created by Jaerong 2017/09/06  for PER & POR ephys analysis


function [summary,summary_header]=EEG_theta_ratio_V2(summary, summary_header,dataROOT)


cd(dataROOT);
pre_folder=[];



%% Spectrogram Parms

freq_range.all = [0 150];
freq_range.delta = [1 4]; freq_range.theta = [4 12]; freq_range.beta = [15 25]; freq_range.lowgamma = [30 50]; freq_range.highgamma = [70 120];
global sampling_freq
sampling_freq= 2000;
nb_data_points= 1000;



%% mtspecgramc parameter

params.Fs = sampling_freq;               %frequency; here is EEG data frequency
params.tapers = [5 9];          %tapers [TimeBandWidth multipleTAPERS]; 5 is recommended for 500ms window (3 is recormended for 300ms window size)
params.fpass = freq_range.all;          %ROI freqency;
params.pad= 1;
params.trialave = 1;            %if trial to be averaged, set 1



%% Fig parm

fig_pos = [300 300 800 700];



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


for i_s= 503:c_s
    
    
    %     if   strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    
    
    
    set_eeg_prefix;
    
    
    
    
    if ~strcmp(pre_folder,Session_folder)
        
        
        load_ts_evt;
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        pre_folder= Session_folder;
    else
    end %(pre_folder== Session_folder)
    
    
    
    
    %% Load EEG
    
    csc_ID= sprintf('CSC%s_RateReduced.ncs',summary(i_s).TT);
    %         csc_ID= sprintf('CSC%s.ncs',summary(i_s).TT);
    cd(Session_folder);
    
    
    
    %% Look up the ADBitVolts
    
    [header] = Nlx2MatCSC(csc_ID, [0 0 0 0 0],1,1,[]); % look for ADBitVolts to convert eegs values from bits to volts
    bit2volt = str2num(header{15}(1, 14:end)); %read ADBitVolts
    clear header
    
    
    
    
    %% Extract EEG during the event period
    
    ts_vector= [];
    power=[];
    power_norm=[];
    baseline_power=[];
    
    
    
    
    
    for trial_run= 1:size(ts_evt,1) % for each trial
        
        ts_vector = [];
        EEG = [];
        
        
        
        ts_vector = [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
        
        EEG.epoch = get_EEG(csc_ID, ts_vector, bit2volt);
        
        
        
        
        
        
        %% Reassemble the data block
        %% Number of data points (in blocks, the number in the power of 2)
        
        EEG_row= nb_data_points;
        
        EEG_col = floor(numel(EEG.epoch)/nb_data_points);
        
        if EEG_col
            
            EEG.epoch((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
            EEG.epoch= reshape(EEG.epoch, EEG_row, EEG_col);
            
        else
        end
        
        clear EEG_row EEG_col
        
%         disp(trial_run);
        
        [S_epoch(trial_run,:),F] =mtspectrumc(EEG.epoch,params);
        
        
        
        
        ts_vector = [ts_evt(trial_run,StimulusOnset)-1 ts_evt(trial_run,StimulusOnset)];
        
        
        
        EEG.baseline = get_EEG(csc_ID, ts_vector, bit2volt);
        
        
        %% Get the baseline
        
        EEG_row= nb_data_points;
        
        EEG_col = floor(numel(EEG.baseline)/nb_data_points);
        
        if EEG_col
            
            EEG.baseline((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
            EEG.baseline= reshape(EEG.baseline, EEG_row, EEG_col);
            
        else
        end
        
        
        
        
        [S_baseline(trial_run,:),F] =mtspectrumc(EEG.baseline,params);
        
        
        %         plot(F,10*log(S_epoch(trial_run,:))); hold on;
        %         plot(F,10*log(S_baseline(trial_run,:)));
        
        
        %         S_norm(trial_run,:)= S_epoch(trial_run,:)./ S_baseline(trial_run,:);
        
        
%         S_norm(trial_run,:)= log(S_epoch(trial_run,:))./ log(S_baseline(trial_run,:));
        
        
        
        
        %% Calculate the frequency power
        
        
        power(trial_run).delta = bandpower(S_epoch(trial_run,:),F,freq_range.delta,'psd');
        power(trial_run).theta = bandpower(S_epoch(trial_run,:),F,freq_range.theta,'psd');
        power(trial_run).beta  = bandpower(S_epoch(trial_run,:),F,freq_range.beta,'psd');
        power(trial_run).lowgamma  = bandpower(S_epoch(trial_run,:),F,freq_range.lowgamma,'psd');
        power(trial_run).highgamma = bandpower(S_epoch(trial_run,:),F,freq_range.highgamma,'psd');
        
        
        baseline_power(trial_run).delta = bandpower(S_baseline(trial_run,:),F,freq_range.delta,'psd');
        baseline_power(trial_run).theta = bandpower(S_baseline(trial_run,:),F,freq_range.theta,'psd');
        baseline_power(trial_run).beta  = bandpower(S_baseline(trial_run,:),F,freq_range.beta,'psd');
        baseline_power(trial_run).lowgamma  = bandpower(S_baseline(trial_run,:),F,freq_range.lowgamma,'psd');
        baseline_power(trial_run).highgamma = bandpower(S_baseline(trial_run,:),F,freq_range.highgamma,'psd');
        
        
        
        power_norm(trial_run).delta = power(trial_run).delta /baseline_power(trial_run).delta;
        power_norm(trial_run).theta = power(trial_run).theta /baseline_power(trial_run).theta;
        power_norm(trial_run).beta = power(trial_run).beta /baseline_power(trial_run).beta;
        power_norm(trial_run).lowgamma = power(trial_run).lowgamma /baseline_power(trial_run).lowgamma;
        power_norm(trial_run).highgamma = power(trial_run).highgamma /baseline_power(trial_run).highgamma;
        
        
        

        
        
    end
    
    
    
    %% Raw power value (session avg) microvoltage conversion
    
    epoch_power =[];
    epoch_power_norm =[];
    
    
    epoch_power.delta =mean([power.delta])/1E3;
    epoch_power.theta =mean([power.theta])/1E3;
    epoch_power.beta =mean([power.beta])/1E3;
    epoch_power.lowgamma =mean([power.lowgamma])/1E3;
    epoch_power.highgamma =mean([power.highgamma])/1E3;
    
    
%     epoch_power_norm.delta =mean([power_norm.delta]);
    epoch_power_norm.theta =mean([power_norm.theta]);
    epoch_power_norm.beta =mean([power_norm.beta]);
    epoch_power_norm.lowgamma =mean([power_norm.lowgamma]);
    epoch_power_norm.highgamma =mean([power_norm.highgamma]);
    
    
    
    %% Conditional comparisons
    
    
    epoch_power_norm.theta_Familiar = mean([power_norm(select.Familiar_Corr).theta]);
    epoch_power_norm.theta_Novel =  mean([power_norm(select.Novel_Corr).theta]);
    
    epoch_power_norm.beta_Familiar = mean([power_norm(select.Familiar_Corr).beta]);
    epoch_power_norm.beta_Novel =  mean([power_norm(select.Novel_Corr).beta]);
    
    epoch_power_norm.lowgamma_Familiar =  mean([power_norm(select.Familiar_Corr).lowgamma]);
    epoch_power_norm.lowgamma_Novel =  mean([power_norm(select.Novel_Corr).lowgamma]);
    
    epoch_power_norm.highgamma_Familiar =  mean([power_norm(select.Familiar_Corr).highgamma]);
    epoch_power_norm.highgamma_Novel =  mean([power_norm(select.Novel_Corr).highgamma]);
    
    
  
    
    
    
    %% Check the power density function
    
    %             plot(mean(S_epoch)); hold on;
    %             plot(mean(S_baseline))
    
    S_epoch= mean(S_epoch);
    S_baseline= mean(S_baseline);
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
    
    
    
    
    msg= sprintf('Theta(Familiar) = %1.2f' , epoch_power_norm.theta_Familiar);
    text(1,1.1,msg,'units','normalized','fontsize',11);
    
    msg= sprintf('Theta(Novel) = %1.2f' , epoch_power_norm.theta_Novel);
    text(1,1,msg,'units','normalized','fontsize',11);
    
    msg= sprintf('LoGamma(Familiar) = %1.2f' , epoch_power_norm.lowgamma_Familiar);
    text(1,0.9,msg,'units','normalized','fontsize',11);
    
    msg= sprintf('LoGamma(Novel) = %1.2f' , epoch_power_norm.lowgamma_Novel);
    text(1,0.8,msg,'units','normalized','fontsize',11);
    
    msg= sprintf('HiGamma(Familiar) = %1.2f' , epoch_power_norm.highgamma_Familiar);
    text(1,0.7,msg,'units','normalized','fontsize',11);
    
    msg= sprintf('HiGamma(Novel) = %1.2f' , epoch_power_norm.highgamma_Novel);
    text(1,0.6,msg,'units','normalized','fontsize',11);
    
    
    
    
    msg= sprintf('Raw Theta = %1.2f (mV^2)' , epoch_power.theta);
    text(1,0.5,msg,'units','normalized','fontsize',11);
    
    msg= sprintf('Norm Theta = %1.2f', epoch_power_norm.theta);
    text(1,0.4,msg,'units','normalized','fontsize',11);
    
    msg= sprintf('Norm Beta = %1.2f', epoch_power_norm.beta);
    text(1,0.3,msg,'units','normalized','fontsize',11);
    
    msg= sprintf('Norm LowGamma = %1.2f', epoch_power_norm.lowgamma);
    text(1,0.2,msg,'units','normalized','fontsize',11);
    
    msg= sprintf('Norm HighGamma = %1.2f', epoch_power_norm.highgamma);
    text(1,0.1,msg,'units','normalized','fontsize',11);
    
    
    
    
    %% Add to summary
    
    summary(i_s).Theta_Ratio= sprintf('%1.3f',epoch_power_norm.theta);
    summary(i_s).Power_Theta= sprintf('%1.3f',epoch_power.theta);
    summary(i_s).Power_Beta= sprintf('%1.3f',epoch_power.beta);
    summary(i_s).Power_LowGamma= sprintf('%1.3f',epoch_power.lowgamma);
    summary(i_s).Power_HighGamma= sprintf('%1.3f',epoch_power.highgamma);
    
    
    clear power
    
    
    filename=[Prefix  '.png'];
    saveImage(fig,filename,fig_pos);
    
    
    %     clear eeg* nb_eeg nb_smp_eeg nb_smp_ts
    
    
    
    
    
    %% Save figure for verification
    
    cd(saveROOT)
    
    filename=[Prefix  '.png'];
    saveImage(fig,filename,fig_pos);
    
    
    
    
    %% Output file generation
    
    fod=fopen(outputfile,'a');
    fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Region, Subregion, Layer, Bregma, TTID);
    fprintf(fod,',%1.2f, %1.2f, %1.2f, %1.2f, %1.2f',epoch_power.theta, epoch_power_norm.theta, epoch_power_norm.beta, epoch_power_norm.lowgamma, epoch_power_norm.highgamma);
    fprintf(fod,',%1.2f, %1.2f, %1.2f, %1.2f, %1.2f, %1.2f',epoch_power_norm.theta_Familiar, epoch_power_norm.theta_Novel, epoch_power_norm.lowgamma_Familiar, epoch_power_norm.lowgamma_Novel, epoch_power_norm.highgamma_Familiar, epoch_power_norm.highgamma_Novel);
    fprintf(fod,',%s',(summary(i_s).Visual_Inspection));
    fprintf(fod,'\n');
    fclose('all');
    
    
    
    clear epoch_power  power_norm
    
    %     end  %  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
    
    
end %   i_s= 1:c_s



end  % function
