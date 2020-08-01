%% Revised by Jaerong 2018/10/17 for 2nd revision in CR
%% Calculates the power according to the familiar and novel objects.


function [summary,summary_header]= EEG_PSD_novelty(summary, summary_header,dataROOT)



%% Load EEG Parms

freq_range.all = [0 140];
freq_range.delta = [1 4]; freq_range.theta = [4 12]; freq_range.beta = [15 25]; freq_range.lowgamma = [30 50]; freq_range.highgamma = [70 120];
global sampling_freq
global period
sampling_freq= 2000;
period=(1/sampling_freq)*10^6;
% nb_data_points= 512;
nb_data_points= 2000;  % Number of data points increased to 2000 and zero padded (2018/10/02)



%% mtspecgramc parameter

% movingwin = [0.1 .05];           %moving window [windowSIZE windowSTEP]; 500ms window and moving by 10ms
movingwin = [0.3 .01];           %moving window [windowSIZE windowSTEP]; 300ms window and moving by 10ms
params.Fs = sampling_freq;               %frequency; here is EEG data frequency
params.tapers = [3 5];          %tapers [TimeBandWidth multipleTAPERS]; 5 is recommended for 500ms window (3 is recormended for 300ms window size)
params.fpass = freq_range.all;          %ROI freqency;
params.pad= 1;
params.trialave = 1;            %if trial to be averaged, set 1
params.err = [1 0.05] ;            % error bar on, p-value




% plt = 'l';


baseline_second= 0.5;  %% Duration of the baseline period

%% Fig parm

fig_pos = [200 300 900 700];



%% Save folder

saveROOT= [dataROOT '\Analysis\EEG\PSD\Novelty\' date];

if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)



%% Output file

outputfile= 'EEG_Novelty.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key#, RatID, Session, Task_session, Task, Region, Subregion, Layer, Bregma, TT,  RefRegion, Power(Theta), Power(HighGamma), Baseline_Power(Theta), Baseline_Power(HighGamma), Power_familiar(Theta), Power_familiar(HighGamma), Power_novel(Theta), Power_novel(HighGamma), MaxoutTrials, Power_criteria, 2nd_revision \n';
fprintf(fod, txt_header);
fclose(fod);





[r_s,c_s]=size(summary);


for i_s = 1:c_s
    
    
    if  strcmp(summary(i_s).Power_criteria, '1')
        
        
        
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
        
        
        
        %% Maxout trial removal
        
        cd([Session_folder '\EEG\']);
        load([Prefix '_maxout.mat' ]);
        ts_evt(maxout_MAT==1,:)=[];
        
        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
          
        
        
        
        %% Look up the ADBitVolts
        
        bit2micovolt = str2num(summary(i_s).ADBitmicrovolts); %read ADBitVolts
        
        
        
        
        
        %% Extract EEG during the event period
        
        
        EEG_MAT=[];
        EEG_baseline_MAT=[];
        
        power=[];
        power_norm=[];
        baseline_power=[];
        
        
        
        
        
        for trial_run= 1:size(ts_evt,1) % for each trial
            
            ts_vector = [];
            EEG = [];
            
            
            
            cd([Session_folder '\EEG\Noise_reduction']);
            csc_ID= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
            
            
            ts_vector = [ts_evt(trial_run,StimulusOnset), ts_evt(trial_run,Choice)];
            
            EEG.epoch = get_EEG(csc_ID, ts_vector, bit2micovolt);
            
            EEG_MAT{trial_run} = EEG.epoch;
            
            
            ts_vector = [ts_evt(trial_run,StimulusOnset)-baseline_second, ts_evt(trial_run,StimulusOnset)];
            
            
            
            EEG.baseline = get_EEG(csc_ID, ts_vector, bit2micovolt);
            
            EEG_baseline_MAT{trial_run} = EEG.baseline;
            
        end
        
        
        
        EEG=[];
               
        
        EEG.epoch = cell2mat(EEG_MAT);
        EEG.baseline = cell2mat(EEG_baseline_MAT);
        
        EEG.Novel = cell2mat(EEG_MAT(select.Novel_Corr));
        EEG.Familiar = cell2mat(EEG_MAT(select.Familiar_Corr));
        
        
        
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
        
        
        
        %% Reassemble the data block (Novel)
        %% Number of data points (in blocks, the number in the power of 2)
        
        EEG_row= nb_data_points;
        EEG_col = floor(numel(EEG.Novel)/nb_data_points);
        
        EEG.Novel((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
        EEG.Novel= reshape(EEG.Novel, EEG_row, EEG_col);
        
        clear EEG_row EEG_col
        
        
        [S_Novel,F] =mtspectrumc(EEG.Novel,params);
        
        
        
        %% Reassemble the data block (Familiar)
        %% Number of data points (in blocks, the number in the power of 2)
        
        EEG_row= nb_data_points;
        EEG_col = floor(numel(EEG.Familiar)/nb_data_points);
        
        EEG.Familiar((EEG_row* EEG_col)+1:end) = [];  %% truncate the trailing values
         EEG.Familiar= reshape(EEG.Familiar, EEG_row, EEG_col);
        
        clear EEG_row EEG_col
        
        
        [S_Familiar,F] =mtspectrumc(EEG.Familiar,params);
        
        
        
       
        
        
        
        %% Should be divided by 10E6 for converting uv2 to mv2,
        %%but divided by 10E3 instead for better visualization.
        %% Should be indicated in the y-axis (mv2 x 10^3)
        
        power.theta = bandpower(S_epoch,F,freq_range.theta,'psd')/10E3;
        power.highgamma = bandpower(S_epoch,F,freq_range.highgamma,'psd')/10E3;
        
        
        power_novel.theta = bandpower(S_Novel,F,freq_range.theta,'psd')/10E3;
        power_novel.highgamma = bandpower(S_Novel,F,freq_range.highgamma,'psd')/10E3;
        
        
        power_familiar.theta = bandpower(S_Familiar,F,freq_range.theta,'psd')/10E3;
        power_familiar.highgamma = bandpower(S_Familiar,F,freq_range.highgamma,'psd')/10E3;
        
        
        baseline_power.theta = bandpower(S_baseline,F,freq_range.theta,'psd')/10E3;
        baseline_power.highgamma = bandpower(S_baseline,F,freq_range.highgamma,'psd')/10E3;
        
      
        
        
        
        %% Create figures
        %% Print out cell ID
        
        Prefix = [Prefix ' - ' Ref_Region];
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        
        subplot('Position', [0.2 0.96 0.3 0.2]);
        text(0,0,Prefix,'fontsize',13);
        axis off;
        
        
        
        subplot('position',[0.1 0.15 0.55 0.7]);
        
        plot(F,10*log(S_baseline),'k'); hold on;        
        plot(F,10*log(S_Familiar),'b');
        plot(F,10*log(S_Novel),'r');   legend('Baseline','Familiar','Novel');
        box off; hold on;
        
        
        vline(4,'k:');vline(12,'k:');
        vline(70,'k:');vline(120,'k:');
    
        
        xlabel('Frequency (Hz)','fontsize',15); xlim([0 120]);
        ylabel('Power (dB)','fontsize',15);
        %         handle= hline(1);  set(handle,'linewidth',2);
        %         set(gca,'YTick', [0 max(get(gca,'ylim'))], 'YTickLabel', sprintfc('%0.2f',[0 max(get(gca,'ylim'))]));
        
        clear S_* F
        
        
        
        msg= sprintf('Theta = %1.3f (mV^2 x 10^3)' , power.theta);
        text(1,1.0,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('HighGamma = %1.3f (mV^2 x 10^3)' , power.highgamma);
        text(1,0.9,msg,'units','normalized','fontsize',11);
        
        
        
        msg= sprintf('Theta (baseline) = %1.3f (mV^2 x 10^3)' , baseline_power.theta);
        text(1,0.8,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('HighGamma (baseline) = %1.3f (mV^2 x 10^3)' , baseline_power.highgamma);
        text(1,0.7,msg,'units','normalized','fontsize',11);
        
        
        
        msg= sprintf('Theta (Novel) = %1.3f (mV^2 x 10^3)' , power_novel.theta);
        text(1,0.6,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('HighGamma (Novel) = %1.3f (mV^2 x 10^3)' , power_novel.highgamma);
        text(1,0.5,msg,'units','normalized','fontsize',11);
        
        
        
        msg= sprintf('Theta (Familiar) = %1.3f (mV^2 x 10^3)' , power_familiar.theta);
        text(1,0.4,msg,'units','normalized','fontsize',11);
        
        msg= sprintf('HighGamma (Familiar) = %1.3f (mV^2 x 10^3)' , power_familiar.highgamma);
        text(1,0.3,msg,'units','normalized','fontsize',11);
        
        
        
        msg= sprintf('Power Criterion = %d' , str2num(summary(i_s).Power_criteria));
        text(1.0,0.1,msg,'units','normalized','fontsize',11);
        
               
        
        
        %% Save figure for verification
        
        cd(saveROOT)
        
        filename_ai=[Prefix '.eps'];,   
        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
        % txt_header = 'Key#, RatID, Session, Task_session, Task, Region, Subregion, Layer, Bregma, TT, Power(Theta), Power(HighGamma), Baseline_Power(Theta), Baseline_Power(HighGamma), Norm_Power(Theta), Norm_Power(HighGamma), SignalLength(Epoch), SignalLength(Baseline) \n';
        

        
        %% Output file generation
        
        fod=fopen(outputfile,'a');
        fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Region, Subregion, Layer, Bregma, TTID, Ref_Region);
        fprintf(fod,',%1.6f, %1.6f, %1.6f, %1.6f',power.theta, power.highgamma, baseline_power.theta, baseline_power.highgamma);
        fprintf(fod,',%1.6f, %1.6f',power_novel.theta, power_novel.highgamma );
        fprintf(fod,',%1.6f, %1.6f',power_familiar.theta, power_familiar.highgamma );
        fprintf(fod,',%1.3f, %d, %d',str2num(summary(i_s).MaxoutTrials), str2num(summary(i_s).Power_criteria), str2num(summary(i_s).Second_revision));
        fprintf(fod,'\n');
        fclose('all');
        
        
        clear *power*
        
    end  %  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
    
    
% end %   i_s= 1:c_s



end  % function
