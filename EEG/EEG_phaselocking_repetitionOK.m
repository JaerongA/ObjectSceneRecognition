%% Created by Jaerong 2018/06/04 for PER & POR ephys analysis
%% Determine if a unit is suitable for use in the phaselocking analysis (# of spikes >= 30 in the smaller half of the session)
%% Only based on the correct trials


function [summary,summary_header] = EEG_phaselocking_repetitionOK(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT)



%% Load EEG Parms

EEG_parms;


%% Parms

Spk_criteria = 30;   % 2018/06/03 for CR revision
Repetition_OK = nan;  % (1 for units that are ok to use for repetition analysis (smaller half spike >= 30);
maxDEG = 360; intDEG = 20;

fig_ok= 0 ;
bgcol=[1 0.6 0.6; 0.6 1 0.6];

smoothing_parm= 0.4;


%% Shuffling parameter

replacement=1; bootstrap_nb=1000;   %% randomly sample 1000 times with replacement

%% Filtering

filter_order=2;
Wn=freq_range.theta;
ftype='bandpass';


[r_s,c_s]=size(summary);



for i_s=  1:c_s
    
    
    
       
        
    if  (str2num(summary(i_s).Quality_ok)== 1) && ~strcmp(summary(i_s).Region,'POR') && ~strcmp(summary(i_s).Fitting_category,'Nofitting') && ~strcmp(summary(i_s).Fitting_category,'NaN')
        

        
        %% Set cluster Prefix
        
        set_cluster_prefix;
        
        
        
        %% Loading clusters
        
        load_clusters;
        
        
        
        
        %% Select another TT from a different regions recorded in the same session
        
        
        nb_target=size(summary_eeg,2);
        
        
        for Target_run= 1:nb_target
            
            
            
            %% Set EEG info
            
            target_set_eeg_prefix;
            
            
            
            
            if  strcmp(summary_eeg(Target_run).Visual_Inspection, '1') &&  strcmp(summary_eeg(Target_run).Power_criteria, '1') ...
                    && strcmp(RatID, RatID2) && strcmp(Session, Session2) && strcmp(Task, Task2) && strcmp(Region, Region2)
                
                
                
                
                disp(['Cluster TT... ' Prefix]);
                disp(['EEG TT... : ' Prefix2]);
                
                
                
                
                
                %% Loading trial ts info from ParsedEvents.mat
                
                
                % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
                %
                % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
                % 13. StimulusCat
                %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                load_ts_evt;
                
                
                
                
                % Maxout trial removal (for EEG only)
                
                cd([Session_folder '\EEG\']);
                load([Prefix2 '_maxout.mat' ]);
                ts_evt(maxout_MAT==1,:)=[];
                
                
                
                
                BestFittingOBJ=[];
                BestFittingOBJ=summary(i_s).BestFittingOBJ;
                
                
                
                
                
                %% Select trial types
                
                select_trial_type;
                
                %% Correct Only
                
                switch find(strcmp(Stimulus_str, BestFittingOBJ))
                    case 1
                        ts_evt = ts_evt(select.Stimulus1_Corr,:);
                    case 2
                        ts_evt = ts_evt(select.Stimulus2_Corr,:);
                    case 3
                        ts_evt = ts_evt(select.Stimulus3_Corr,:);
                    case 4
                        ts_evt = ts_evt(select.Stimulus4_Corr,:);
                end
                
                
                
                
                select_trial_type;
                
                
                
                
                %% Look up the ADBitVolts
                
                bit2micovolt = str2num(summary_eeg(Target_run).ADBitmicrovolts);
                
                
                
                %% Extract EEG during the event period
                
                
                HistMAT = [];
                
                for trial_run= 1:size(ts_evt,1) % for each trial
                    
                    ts_vector = [];
                    thisEEG = [];
                    filteredEEG = [];
                    thisSPK = [];
                    
                    
                    
                    
                    
                    cd(Session_folder);
                    
                    ts_vector = [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
                    
                    cd([Session_folder '\EEG\Noise_reduction']);
                    csc_ID= sprintf('CSC%s_Noise_filtered.ncs',summary_eeg(Target_run).TT);
                    
                    [thisEEG,thisEEGTS] = get_EEG(csc_ID, ts_vector, bit2micovolt);
                    
                    thisEEGTS = thisEEGTS./1E6;
                    
                    %                     filteredEEG = eeg_filter(thisEEG, filter_order, freq_range.theta, sampling_freq, ftype);
                    %                     filteredEEG = eeg_filter(thisEEG, filter_order, freq_range.lowgamma, sampling_freq, ftype);
                    filteredEEG = eeg_filter(thisEEG, filter_order, Wn, sampling_freq, ftype);
                    
                    
                    thisSPK = ts_spk(ts_spk >= ts_vector(1) & ts_spk <= ts_vector(2));
                    
                    
                    
                    if numel(thisSPK)<=1
                        HistMAT{trial_run} = [];
                        continue;
                    end
                    
                    
                    
                    
                    phaseMat=[];
                    
                    [phaseMat] = GetPhase(filteredEEG);                                              %Based on Hibert transform, get phase
                    spkEEG = nan;
                    spike_ind=1;
                    for spkRUN = 1:numel(thisSPK)                                              %spk locked to EEG
                        
                        if isempty(max(thisEEGTS(thisEEGTS <= thisSPK(spkRUN))))
                            continue
                        else
                            spkEEG(spike_ind) = find(thisEEGTS == max(thisEEGTS(thisEEGTS <= thisSPK(spkRUN))));
                            spike_ind=spike_ind+1;
                        end
                    end
                    
                    
%                     phaseMat(spkEEG)
                    
                    
                    if ~isnan(spkEEG)                                                             %spk locked with EEG phase
                        HistMAT{trial_run} = phaseMat(spkEEG);
                    end
                    
                    clear phaseMat
                    
                    
                    thisPhase =HistMAT{trial_run};
                    
                    
                    
%                     if fig_ok
%                         
%                         
%                         
%                         
%                         
%                         %% Fig parms
%                         
%                         fig_pos = [400 400 1500 600];
%                         
%                         
%                         ind= findstr(Prefix,'-');
%                         
%                         switch length(sprintf('%d',ts_evt(trial_run,Trial)))
%                             
%                             case 1
%                                 fig_name= ['Trial# 00' sprintf('%d',ts_evt(trial_run,Trial)) ' -' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)  '.png'];
%                             case 2
%                                 fig_name= ['Trial# 0' sprintf('%d',ts_evt(trial_run,Trial)) ' -' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)  '.png'];
%                             case 3
%                                 fig_name= ['Trial# ' sprintf('%d',ts_evt(trial_run,Trial)) ' -' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)  '.png'];
%                         end
%                         
%                         
%                         
%                         
%                         
%                         %% Create figures
%                         %% Print out cell ID
%                         
%                         %                         set(0,'DefaultFigureVisible','off')
%                         fig=figure('name',fig_name(1:end-4),'Color',[1 1 1],'Position',fig_pos);
%                         
%                         subplot('Position', [0.25 0.98 0.3 0.2]);
%                         text(0,0,fig_name(1:end-4),'fontsize',11);
%                         axis off;
%                         
%                         
%                         
%                         %% Get phaselocking
%                         
%                         
%                         
%                         subplot('Position', [0.15 0.67 0.65 0.25]);
%                         
% %                         plot(((thisEEGTS-thisEEGTS(1))), thisEEG,'Color',[.3 .3 .3]); hold on;
%                         plot(((thisEEGTS-thisEEGTS(1))), filteredEEG,'b','linewidth',1.5); box off;  hold on;
%                         plot((thisEEGTS(spkEEG))-thisEEGTS(1), filteredEEG(spkEEG),'r*'); hold off;
%                         axis tight;
%                         ylabel('\muV','fontsize',15); xlabel('Time(s)');
%                         
%                         clear thisEEG*
%                         
%                         
%                         subplot('Position', [0.15 0.2 0.2 0.35]);
%                         
%                         
%                         hist([thisPhase thisPhase+360],0:20:720)
%                         thisHISTFREQ = histc([thisPhase thisPhase+360], 0:intDEG:maxDEG * 2);
%                         nb_spk= numel(thisSPK); trialFR(trial_run) = numel(thisSPK)/ ts_evt(trial_run, ChoiceLatency);
%                         thisHISTFREQ= thisHISTFREQ./ nb_spk; %% spike count normalized by the sum
%                         bar(thisHISTFREQ);
%                         set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
%                             'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
%                         xlabel('Degree'); ylabel('Norm. SPK #');
%                         title('Phase distribution'); box off;
%                         
%                         
%                         
%                         subplot('Position', [0.4 0.2 0.2 0.3]);
%                         
%                         
%                         %Statistical test, Rayleigh test
%                         thisPhase=thisPhase';
%                         [rayleigh_pval rayleigh_z] = circ_rtest(deg2rad(thisPhase));
%                         %             [thisRAOP thisRAOU] = circ_raotest(deg2rad(thisPhase));
%                         %             [thisRP thisRZ] = circ_rtest(deg2rad(cell2mat(HistMAT)));
%                         tempMU = rad2deg(circ_mean(deg2rad(thisPhase))); if tempMU < 0, phase_mean(trial_run) = 360 + tempMU; else phase_mean(trial_run) = tempMU; end
%                         thisKappa(trial_run) = circ_kurtosis(deg2rad(thisPhase));	%Pewsey's kappa
%                         phase_var(trial_run)= circ_var(deg2rad(thisPhase));
%                         
%                         rose(deg2rad(thisPhase),intDEG); hold on;
%                         [x,y] = pol2cart(deg2rad(phase_mean(trial_run)),max(get(gca,'Ytick')));
%                         c= compass(x,y);
%                         set(gca,'View',[-90 90],'YDir','reverse');
%                         set(c,'linestyle','-','linewidth',1.5,'color','r');
%                         
%                         hline = findobj(gca,'Type','line');
%                         set(hline,'LineWidth',1.5,'MarkerFaceColor',[.1 .1 .1]);
%                         
%                         
%                         
%                         subplot('Position', [0.7 0.2 0.2 0.3]);
%                         axis off;
%                         
%                         msg= sprintf('Latency = %1.3f', ts_evt(trial_run,ChoiceLatency));
%                         text(-.3,1.3, msg, 'Fontsize',12);
%                         
%                         msg= sprintf('FR = %.2f', trialFR(trial_run));
%                         text(-.3,1.1, msg, 'Fontsize',12);
%                         
%                         msg= sprintf('# of spk= %d', numel(thisSPK));
%                         text(-.3,.9, msg, 'Fontsize',12);
%                         
%                         msg= sprintf('Rayleigh test = %1.3f', rayleigh_z);
%                         text(-.3,.7, msg, 'Fontsize',12);
%                         
%                         msg= sprintf('Rayleigh P = %1.3f', rayleigh_pval);
%                         text(-.3,.5, msg, 'Fontsize',12);
%                         
%                         msg= sprintf('Mean deg = %1.3f', phase_mean(trial_run));
%                         text(-.3,.3, msg, 'Fontsize',12);
%                         
%                         msg= sprintf('Var deg  = %1.3f', phase_var(trial_run));
%                         text(-.3,.1, msg, 'Fontsize',12);
%                         
%                         msg= sprintf('Kappa = %1.3f', thisKappa(trial_run));
%                         text(-.3,-.1, msg, 'Fontsize',12);
%                         
%                         msg= sprintf('Stimulus = %s', Stimulus_str{ts_evt(trial_run,Stimulus)});
%                         text(0.4,0.9,msg,'units','normalized','fontsize',12);
%                         
%                         msg= sprintf('%s', Perf_str{ts_evt(trial_run,Correctness)+1});
%                         text(0.4,0.7,msg,'units','normalized','fontsize',15);
%                         
%                         
%                         %% Save figure for verification
%                         
%                         
%                         %                         fig_saveROOT= [ Prefix '-' Prefix2];
%                         fig_saveROOT= [saveROOT '\' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)];
%                         
%                         
%                         if ~exist(fig_saveROOT)
%                             mkdir(fig_saveROOT);
%                         end
%                         
%                         
%                         cd(fig_saveROOT)
%                         
%                         filename_ai=sprintf('Trial %d.eps', trial_run);
%                         print( gcf, '-painters', '-r300', filename_ai, '-depsc');
%                         
%                         filename= sprintf('Trial %d.png', trial_run);
%                         saveImage(fig,filename,fig_pos);
%                         
%                         
%                         
%                     end
                    
                    
                end
                
                %                 clear ts_spk
                
                
                %% Population Stats
                
                tempMU=[];
                thisPhase=[];
                rayleigh_pval=[];
                pval_sig=[];
                rayleigh_z=[];
                thisKappa=[];
                phase_var=[];
                phase_mean=[];
                RV=[];
                thisHISTFREQ=[];
                
                
                thisPhase.All= cell2mat(HistMAT);
                thisPhase.firsthalf= cell2mat(HistMAT(1:ceil(size(HistMAT,2)/2)));
                thisPhase.secondhalf= cell2mat(HistMAT(ceil(size(HistMAT,2)/2)+1:end));
                
                thisPhase.All= thisPhase.All';
                [rayleigh_pval.All rayleigh_z.All] = circ_rtest(deg2rad(thisPhase.All));
                if rayleigh_pval.All<0.05,  pval_sig.All =1;   else  pval_sig.All =0;    end
                
                tempMU.All = rad2deg(circ_mean(deg2rad(thisPhase.All))); if tempMU.All < 0, phase_mean.All = 360 + tempMU.All; else phase_mean.All = tempMU.All; end
                RV.All= circ_r(deg2rad(thisPhase.All));
                
                
                
                
%                 if isempty(thisPhase.firsthalf)
%                     continue;
%                 end
%                 thisPhase.firsthalf=thisPhase.firsthalf';
%                 [rayleigh_pval.firsthalf rayleigh_z.firsthalf] = circ_rtest(deg2rad(thisPhase.firsthalf));
%                 if rayleigh_pval.firsthalf<0.05,  pval_sig.firsthalf =1;   else  pval_sig.firsthalf =0;    end
%                 tempMU.firsthalf = rad2deg(circ_mean(deg2rad(thisPhase.firsthalf))); if tempMU.firsthalf < 0, phase_mean.firsthalf = 360 + tempMU.firsthalf; else phase_mean.firsthalf = tempMU.firsthalf; end
%                 thisKappa.firsthalf = circ_kurtosis(deg2rad(thisPhase.firsthalf));	%Pewsey's kappa
%                 phase_var.firsthalf= circ_var(deg2rad(thisPhase.firsthalf));
%                 
%                 
%                 
%                 if isempty(thisPhase.secondhalf)
%                     continue;
%                 end
%                 thisPhase.secondhalf=thisPhase.secondhalf';
%                 [rayleigh_pval.secondhalf rayleigh_z.secondhalf] = circ_rtest(deg2rad(thisPhase.secondhalf));
%                 if rayleigh_pval.secondhalf<0.05,  pval_sig.secondhalf =1;   else  pval_sig.secondhalf =0;    end
%                 tempMU.secondhalf = rad2deg(circ_mean(deg2rad(thisPhase.secondhalf))); if tempMU.secondhalf < 0, phase_mean.secondhalf = 360 + tempMU.secondhalf; else phase_mean.secondhalf = tempMU.secondhalf; end
%                 thisKappa.secondhalf = circ_kurtosis(deg2rad(thisPhase.secondhalf));	%Pewsey's kappa
%                 phase_var.secondhalf= circ_var(deg2rad(thisPhase.secondhalf));
%                 
%                 %% Testing whether the two samples differ significantly
%                 %                 [pval, k, K] = circ_kuipertest(deg2rad(thisPhase.firsthalf), deg2rad(thisPhase.secondhalf), res, vis_on)
%                 
%                 try
% %                 phase_mean_diff_pval = circ_kuipertest(deg2rad(thisPhase.firsthalf), deg2rad(thisPhase.secondhalf),intDEG);
%                 phase_mean_diff_pval = circ_wwtest(deg2rad(thisPhase.firsthalf), deg2rad(thisPhase.secondhalf));
%                 end
%                 if phase_mean_diff_pval < 0.05,  pval_sig.mean_diff =1;   else  pval_sig.mean_diff =0;    end
%                 
                
                %% Bootstrapping
                
                thisPhase.firsthalf=thisPhase.firsthalf';
                thisPhase.secondhalf=thisPhase.secondhalf';
                
                
                samplePhase=[]; sample_nb=[];
                
                
                nb_spk_small=  min(numel(thisPhase.firsthalf),numel(thisPhase.secondhalf));
                
                
                
                %% the spike in the smaller half should be >= 30
                
                
                if nb_spk_small < Spk_criteria
                    
                    Repetition_OK = 0;
                    summary(i_s).Repetition_OK= sprintf('%d',Repetition_OK);
                    
                else
                    Repetition_OK = 1;
                    summary(i_s).Repetition_OK= sprintf('%d',Repetition_OK);
                    
                end
                  
                
                
                %                 thisPhase.firsthalf= cell2mat(HistMAT(1:10));
                %                 thisPhase.secondhalf= cell2mat(HistMAT(20:end));
                
                %                 RV.firsthalf= circ_r(deg2rad(thisPhase.firsthalf'));
                %                 RV.secondhalf= circ_r(deg2rad(thisPhase.secondhalf'));
%                 
%                 RV.firsthalf= circ_r(deg2rad(thisPhase.firsthalf'));
%                 RV.secondhalf= circ_r(deg2rad(thisPhase.secondhalf'));
%                 
%                 
%                 if numel(thisPhase.firsthalf) > numel(thisPhase.secondhalf)
%                     first_high= 1;
%                     samplePhase= thisPhase.firsthalf;
%                     sample_nb= numel(thisPhase.secondhalf);
%                 else
%                     first_high= 0;
%                     samplePhase= thisPhase.secondhalf;
%                     sample_nb= numel(thisPhase.firsthalf);
%                 end
%                 
%                 
%                 
%                 PhaseMat =[];
%                 bootstrap_ok=1; bootstrap_ind=1;
%                 
%                 
%                 while bootstrap_ok
%                     
%                     bootstrapPhase =[];  Phaseind=[];
%                     
%                     Phaseind = randsample(numel(samplePhase),sample_nb);
%                     bootstrapPhase = samplePhase(Phaseind);
%                     
%                     
%                     PhaseMat(bootstrap_ind) = circ_r(deg2rad(bootstrapPhase'));
%                     
%                     bootstrap_ind= bootstrap_ind+1;
%                     
%                     if bootstrap_ind== bootstrap_nb+1;
%                         bootstrap_ok=0;
%                     end
%                     
%                 end % shuffle_ok
%                 
%                 
%                 if first_high
%                     RV.firsthalf = mean(PhaseMat);
%                     
%                 else
%                     RV.secondhalf = mean(PhaseMat);
%                 end
%                 
%                 
% %                 RV.diff= abs((RV.firsthalf - RV.secondhalf));
%                 RV.diff= RV.secondhalf - RV.firsthalf;
%                 
%                 clear PhaseMat
%                 
%                 
%                 
%                 
%                 
%                 
%                 
%                 
%                 ind= findstr(Prefix2,'-');
%                 fig_name = [Prefix ' vs.'  Key2 '-' Prefix2(ind(5)+1:end) '.png'];
%                 fig_pos= [200 200 1100 900];
%                 
%                 
%                 fig=figure('name',fig_name(1:end-4),'Color',[1 1 1],'Position',fig_pos);
%                 
%                 subplot('Position', [0.01 0.98 0.3 0.2]);
%                 text(0.5,0,fig_name(1:end-4),'fontsize',11); axis off;
%                 
%                 
%                 
%                 %% 1st half
%                 
%                 subplot('Position', [0.1 0.7 0.3 0.2]);
%                 %                 thisPhase.firsthalf=thisPhase.firsthalf';
%                 hist([thisPhase.firsthalf thisPhase.firsthalf+360],0:20:720)
%                 thisHISTFREQ.firsthalf = histc([thisPhase.firsthalf thisPhase.firsthalf+360], 0:intDEG:maxDEG * 2);
%                 nb_spk= numel(thisPhase.firsthalf);
%                 thisHISTFREQ.firsthalf= thisHISTFREQ.firsthalf./ nb_spk; %% spike count normalized by the sum
%                 bar(thisHISTFREQ.firsthalf,'k');
%                 set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
%                     'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
%                 xlabel('Deg'); ylabel('Norm. SPK #');
%                 title('Phase distribution(1st)'); box off;
%                 
%                 
%                 
%                 subplot('Position', [0.5 0.7 0.2 0.2]);
%                 
%                 %% Roseplot normalization
% %                 t = 0 : .01 : 15 * pi;
% %                 P = polar(t, 15 * ones(size(t)));
% %                 set(P, 'Visible', 'off'); hold on;
%                 
%                 
%                 a= rose(deg2rad(thisPhase.firsthalf),intDEG); a.Color='k'; hold on;
%                 [x,y] = pol2cart(deg2rad(phase_mean.firsthalf),max(get(gca,'Ytick'))*RV.firsthalf);
%                 
%                 
%                 %                 [x,y] = pol2cart(deg2rad(phase_mean.firsthalf),10);
%                 c= compass(x,y);
%                 set(gca,'View',[-90 90],'YDir','reverse');
%                 set(c,'linestyle','-','linewidth',1.5,'color','r');
%                 
%                 hline = findobj(gca,'Type','line');
%                 set(hline,'LineWidth',1.5,'MarkerFaceColor',[.1 .1 .1]);
%                 
%                 
%                 
%                 
%                 
%                 subplot('Position', [0.8 0.6 0.3 0.3]);
%                 axis off;
%                 
%                 
%                 
%                 msg= sprintf('Fitting Cat = %s', summary(i_s).Fitting_category);
%                 text(-.1,1.2,msg,'units','normalized','fontsize',11);
%                 
%                 msg= sprintf('Polarity = %s',  summary(i_s).Polarity);
%                 text(-.1,1.0,msg,'units','normalized','fontsize',11);
%                 
%                 msg= sprintf('Mean FR = %1.2f (Hz)', str2num(summary(i_s).Epoch_FR));
%                 text(-.1,.8, msg, 'Fontsize',11);
%                 
%                 msg= sprintf('BestFittingOBJ = %s',  BestFittingOBJ);
%                 text(-.1,.6,msg,'units','normalized','fontsize',12);
%                 
%                 
%                 msg= sprintf('Spk#(small)= %d',  nb_spk_small);
%                 text(-.1,.4,msg,'units','normalized','fontsize',12);
%                 
%                 
%                 
%                 msg= sprintf('Rayleigh test Z (1st) = %1.5f', rayleigh_z.firsthalf);
%                 text(-.1,.2, msg, 'Fontsize',11);
%                 
%                 msg= sprintf('Rayleigh P (1st) = %1.5f', rayleigh_pval.firsthalf);
%                 text(-.1,0, msg, 'Fontsize',11, 'backgroundcolor',bgcol(pval_sig.firsthalf+1,:));
%                 
%                 msg= sprintf('Mean deg (1st) = %1.2f', phase_mean.firsthalf);
%                 text(-.1,-.2, msg, 'Fontsize',11);
%                 
%                 
%                 
%                 
%                 
%                 
%                 %% 2nd half
%                 
%                 subplot('Position', [0.1 0.4 0.3 0.2]);
%                 %                 thisPhase.firsthalf=thisPhase.firsthalf';
%                 hist([thisPhase.secondhalf thisPhase.secondhalf+360],0:20:720)
%                 thisHISTFREQ.secondhalf = histc([thisPhase.secondhalf thisPhase.secondhalf+360], 0:intDEG:maxDEG * 2);
%                 nb_spk= numel(thisPhase.secondhalf);
%                 thisHISTFREQ.secondhalf= thisHISTFREQ.secondhalf./ nb_spk; %% spike count normalized by the sum
%                 bar(thisHISTFREQ.secondhalf);
%                 set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
%                     'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
%                 xlabel('Deg'); ylabel('Norm. SPK #');
%                 title('Phase distribution(2nd)'); box off;
%                 
%                 
%                 
%                 subplot('Position', [0.5 0.4 0.2 0.2]);
%                 rose(deg2rad(thisPhase.secondhalf),intDEG); hold on;
%                 [x,y] = pol2cart(deg2rad(phase_mean.secondhalf),max(get(gca,'Ytick'))*RV.secondhalf);
%                 c= compass(x,y);
%                 set(gca,'View',[-90 90],'YDir','reverse');
%                 set(c,'linestyle','-','linewidth',1.5,'color','r');
%                 
%                 hline = findobj(gca,'Type','line');
%                 set(hline,'LineWidth',1.5,'MarkerFaceColor',[.1 .1 .1]);
%                 
%                 
%                 
%                 
%                 
%                 subplot('Position', [0.8 0.1 0.3 0.3]);
%                 axis off;
%                 
%                 
%                 
%                 msg= sprintf('Rayleigh test Z (2nd) = %1.2f', rayleigh_z.secondhalf);
%                 text(-.1,1.2, msg, 'Fontsize',11);
%                 
%                 msg= sprintf('Rayleigh P (2nd) = %1.5f', rayleigh_pval.secondhalf);
%                 text(-.1,1, msg, 'Fontsize',11, 'backgroundcolor',bgcol(pval_sig.secondhalf+1,:));
%                 
%                 msg= sprintf('Mean deg (2nd) = %1.2f', phase_mean.secondhalf);
%                 text(-.1,0.8, msg, 'Fontsize',11);
%                 
%                 
%                 
%                 msg= sprintf('WW (mean diff) Pval = %1.5f',phase_mean_diff_pval);
%                 text(-.1,0.6, msg, 'Fontsize',11, 'backgroundcolor',bgcol(pval_sig.mean_diff+1,:));
%                 
%                 
%                 msg= sprintf('RV (1st) = %1.4f',  RV.firsthalf);
%                 text(-.1,.4,msg,'units','normalized','fontsize',13);
%                 
%                 msg= sprintf('RV (2nd) = %1.4f',  RV.secondhalf);
%                 text(-.1,.2,msg,'units','normalized','fontsize',13);
%                 
%                 msg= sprintf('cell type = %s', summary(i_s).Cell_type);   %% added 2018/05/28
%                 text(-.1,0,msg,'units','normalized','fontsize',13);
%                 
%                 
%                 
%                 
%                 %% Phase distribution overlaid
%                 
%                 first_bar= [thisHISTFREQ.firsthalf(1:end-1), thisHISTFREQ.firsthalf ];
%                 second_bar= [thisHISTFREQ.secondhalf(1:end-1), thisHISTFREQ.secondhalf ];
%                 
%                 
%                 subplot('Position', [0.35 0.05 0.4 0.25]);
%                 axis off;
%                 
%                 
%                 
%                 
%                 bar(first_bar,'k'); hold on;
%                 bar(second_bar,'b');                alpha(.3);
%                 lh= legend('1st','2nd','location','eastoutside');
%                 f = fit([1:numel(first_bar)]',first_bar','smoothingspline','SmoothingParam',smoothing_parm);
%                 h= plot(f,'k'); set(h,'linewidth',2);
%                 
%                 
%                 f = fit([1:numel(second_bar)]',second_bar','smoothingspline','SmoothingParam',smoothing_parm);
%                 h= plot(f,'b'); set(h,'linewidth',2);
%                 
%                 
%                 set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
%                     'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
%                 xlabel('Deg'); ylabel('Norm. SPK #');
%                 title('Phase distribution'); box off;
%                 
%                 
%                 clear first_bar second_bar 
%                 
%                 
%                 
%                 Regional_pair=[];
%                 Regional_pair= ['EEG-' Region2 ' vs. Cluster-' Region];
%                 
%                 %% Save figure for verification
%                 
%                 cd(saveROOT);
%                 
%                 
%                 %                 mat_name =[Prefix ' -' Prefix2 '.mat'];
%                 %                 save(mat_name,'HistMAT','thisPhase');
%                 
%                 filename_ai=[fig_name(1:end-4) '.eps'];
%                 print( gcf, '-painters', '-r300', filename_ai, '-depsc');
%                 
%                 filename=[fig_name  '.png'];
%                 saveImage(fig,fig_name,fig_pos);
%                 
%                 
%                 
% % outputfile= 'EEG_Phaselocking_OBJ.csv';
% % fod=fopen(outputfile,'w');
% % txt_header = 'Key#(Cluster), RatID, Session, Task_session, Task, Regional_pair, TT (EEG), ClusterID,';
% % fprintf(fod, txt_header);
% % txt_header = 'MeanFR, Rayleigh_sig(All), Rayleigh_sig(1st), Rayleigh_sig(2nd), Phase_mean(All), Phase_mean(1st), Phase_mean(2nd), RVL(All), RVL(1st), RVL(2nd), Phase_mean_diff_sig, Spk#(small_half),';
% % fprintf(fod, txt_header);
% % txt_header = 'FittingCAT, Polarity, BestFittingOBJ';
% % fprintf(fod, txt_header);
% % fprintf(fod,'\n');
% % fclose(fod);
%                 
% 
%                 
%                 %% Output file generation
%                 
%                 fod=fopen(outputfile,'a');
%                 fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Regional_pair, TTID2, ClusterID, summary(i_s).Cell_type);
%                 fprintf(fod,',%1.5f, %d, %d, %d, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %1.5f, %d, %d',str2num(summary(i_s).Epoch_FR), pval_sig.All, pval_sig.firsthalf, pval_sig.secondhalf, phase_mean.All, phase_mean.firsthalf, phase_mean.secondhalf, RV.All, RV.firsthalf, RV.secondhalf, RV.diff, pval_sig.mean_diff, nb_spk_small);
%                 fprintf(fod,',%s, %s, %s, %1.5f, %1.5f,',summary(i_s).Fitting_category, summary(i_s).Polarity, BestFittingOBJ, str2num(summary(i_s).BestOBJ_CorrR), str2num(summary(i_s).BestOBJ_Slope));
%                 fprintf(fod,'\n');
%                 fclose('all');
                
                clear thisPhase HistMAT thisKappa phase_var phase_mean
                
                
            end %   Target_run= 1:c_s
        end
        
    end
end


