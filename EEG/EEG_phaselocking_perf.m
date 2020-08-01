%% Created by Jaerong 2017/10/08  for PER & POR ephys analysis
%% Get mean resultant vector from correct and incorrect trials

function EEG_phaselocking_perf(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT)



%% Load EEG Parms

EEG_parms;




%% Filtering

filter_order=2;
% Wn=freq_range.theta;
% Wn=freq_range.beta;
% Wn=freq_range.lowgamma;
Wn=freq_range.highgamma;
ftype='bandpass';



%% Phase param
maxDEG = 360; intDEG = 20;


fig_ok= 0 ;
bgcol=[1 0.6 0.6; 0.6 1 0.6];




%% Shuffling parameter

replacement=1; bootstrap_nb=1000;   %% randomly sample 1000 times with replacement



%% Save folder
% saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(Perf)\Theta' ];
% saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(Perf)\Beta' ];
% saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(Perf)\LowGamma' ];
saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(Perf)\HighGamma' ];

if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)






%% Output file

outputfile= 'EEG_Phaselocking_Perf.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key#(Cluster), RatID, Session, Task_session, Task, Regional_pair, TT (EEG), ClusterID,';
fprintf(fod, txt_header);
txt_header = 'MeanFR, RVL(Corr), RVL(Incorr),Spk#(small_half),';
fprintf(fod, txt_header);
txt_header = 'FittingCAT, Polarity';
fprintf(fod, txt_header);
fprintf(fod,'\n');
fclose(fod);




[r_s,c_s]=size(summary);



for i_s=  1:c_s
    
    
    
    if  (str2num(summary(i_s).Epoch_FR) >= 0.5)  && (str2num(summary(i_s).Zero_FR_Proportion) < 0.5) && ~strcmp(summary(i_s).Region,'POR') ...
            && (str2num(summary(i_s).Stability_ok)== 1) && ~strcmp(summary(i_s).Fitting_category,'Nofitting') && ~strcmp(summary(i_s).Fitting_category,'NaN')
        
        
        
        
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
                    && strcmp(RatID, RatID2) && strcmp(Session, Session2) && strcmp(Task, Task2)
                
                
                
                
                disp(['Cluster TT... ' Prefix]);
                disp(['EEG TT... : ' Prefix2]);
                
                Regional_pair=[];
                Regional_pair= ['EEG-' Region2 ' vs. Cluster-' Region];
                
                
                
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
                
                
                
                %% Select trial types
                
                select_trial_type;
                
                
                
                
                %% Look up the ADBitVolts
                
                bit2milivolt = str2num(summary_eeg(Target_run).ADBitmilivolts);
                
                
                
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
                    
                    [thisEEG,thisEEGTS] = get_EEG(csc_ID, ts_vector, bit2milivolt);
                    
                    thisEEGTS = thisEEGTS./1E6;
                    
                    filteredEEG = eeg_filter(thisEEG, filter_order, Wn, sampling_freq, ftype);
                    
                    
                    thisSPK = ts_spk(ts_spk >= ts_vector(1) & ts_spk <= ts_vector(2));
                    
                    
                    
                    if numel(thisSPK)<=1
                        HistMAT{trial_run} = [];
                        continue;
                    end
                    
                    
                    
                    
                    
                    
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
                    if ~isnan(spkEEG)                                                             %spk locked with EEG phase
                        HistMAT{trial_run} = phaseMat(spkEEG);
                    end
                    
                    
                    %                     size(ts_evt,1)
                end
                
                
                
                
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
                
                
                
                
                thisPhase.Corr = cell2mat(HistMAT(select.Corr));
                thisPhase.Corr=thisPhase.Corr';
                [rayleigh_pval.Corr rayleigh_z.Corr] = circ_rtest(deg2rad(thisPhase.Corr));
                if rayleigh_pval.Corr<0.05,  pval_sig.Corr =1;   else  pval_sig.Corr =0;    end
                tempMU.Corr = rad2deg(circ_mean(deg2rad(thisPhase.Corr))); if tempMU.Corr < 0, phase_mean.Corr = 360 + tempMU.Corr; else phase_mean.Corr = tempMU.Corr; end
                thisKappa.Corr = circ_kurtosis(deg2rad(thisPhase.Corr));	%Pewsey's kappa
                phase_var.Corr= circ_var(deg2rad(thisPhase.Corr));
                
                
                
                
                thisPhase.Incorr = cell2mat(HistMAT(select.Incorr));
                if isempty(thisPhase.Incorr)
                    continue;
                end
                thisPhase.Incorr=thisPhase.Incorr';
                [rayleigh_pval.Incorr rayleigh_z.Incorr] = circ_rtest(deg2rad(thisPhase.Incorr));
                if rayleigh_pval.Incorr<0.05,  pval_sig.Incorr =1;   else  pval_sig.Incorr =0;    end
                tempMU.Incorr = rad2deg(circ_mean(deg2rad(thisPhase.Incorr))); if tempMU.Incorr < 0, phase_mean.Incorr = 360 + tempMU.Incorr; else phase_mean.Incorr = tempMU.Incorr; end
                thisKappa.Incorr = circ_kurtosis(deg2rad(thisPhase.Incorr));	%Pewsey's kappa
                phase_var.Incorr= circ_var(deg2rad(thisPhase.Incorr));
                
                
                nb_spk_small=  min(numel(thisPhase.Corr),numel(thisPhase.Incorr));
                
                
                
                
                %% Bootstrapping  (Mean Resultant Length)
                
                
                
                samplePhase=[]; sample_nb=[];
                
                
                
                RV.Corr= circ_r(deg2rad(thisPhase.Corr));
                RV.Incorr= circ_r(deg2rad(thisPhase.Incorr));
                
                
                if numel(thisPhase.Corr) > numel(thisPhase.Incorr)
                    correct_high= 1;
                    samplePhase= thisPhase.Corr;
                    sample_nb= numel(thisPhase.Incorr);
                else
                    correct_high= 0;
                    samplePhase= thisPhase.Incorr;
                    sample_nb= numel(thisPhase.Corr);
                end
                
                
                
                PhaseMat =[];
                bootstrap_ok=1; bootstrap_ind=1;
                
                
                while bootstrap_ok
                    
                    bootstrapPhase =[];  Phaseind=[];
                    
                    Phaseind = randsample(numel(samplePhase),sample_nb);
                    bootstrapPhase = samplePhase(Phaseind);
                    
                    
                    PhaseMat(bootstrap_ind) = circ_r(deg2rad(bootstrapPhase));
                    
                    bootstrap_ind= bootstrap_ind+1;
                    
                    if bootstrap_ind== bootstrap_nb+1;
                        bootstrap_ok=0;
                    end
                    
                end % shuffle_ok
                
                
                if correct_high
                    RV.Corr = mean(PhaseMat);
                    
                else
                    RV.Incorr = mean(PhaseMat);
                end
                
                
                
                
                
                
                
                
                ind= findstr(Prefix2,'-');
                fig_name = [Prefix ' vs.'  Key2 '-' Prefix2(ind(5)+1:end) '.png'];
                fig_pos= [400 400 1100 700];
                
                
                fig=figure('name',fig_name(1:end-4),'Color',[1 1 1],'Position',fig_pos);
                
                subplot('Position', [0.01 0.98 0.3 0.2]);
                text(0.5,0,fig_name(1:end-4),'fontsize',11); axis off;
                
                
                %% Correct Only
                
                subplot('Position', [0.1 0.55 0.35 0.3]);
                thisPhase.Corr=thisPhase.Corr';
                hist([thisPhase.Corr thisPhase.Corr+360],0:20:720)
                thisHISTFREQ = histc([thisPhase.Corr thisPhase.Corr+360], 0:intDEG:maxDEG * 2);
                nb_spk.Corr= numel(thisPhase.Corr);
                thisHISTFREQ= thisHISTFREQ./ nb_spk.Corr; %% spike count normalized by the sum
                bar(thisHISTFREQ);
                set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
                    'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
                xlabel('Deg'); ylabel('Norm. SPK #');
                title('Phase distribution(Corr)'); box off;
                
                
                
                subplot('Position', [0.5 0.55 0.25 0.25]);
                rose(deg2rad(thisPhase.Corr),intDEG); hold on;
                [x,y] = pol2cart(deg2rad(phase_mean.Corr),max(get(gca,'Ytick'))*RV.Corr);
                c= compass(x,y);
                set(gca,'View',[-90 90],'YDir','reverse');
                set(c,'linestyle','-','linewidth',1.5,'color','r');
                
                hline = findobj(gca,'Type','line');
                set(hline,'LineWidth',1.5,'MarkerFaceColor',[.1 .1 .1]);
                
                
                
                
                
                
                subplot('Position', [0.8 0.55 0.3 0.3]);
                axis off;
                
                
                msg= sprintf('Fitting Cat = %s', summary(i_s).Fitting_category);
                text(-.1,1.2,msg,'units','normalized','fontsize',11);
                
                msg= sprintf('Polarity = %s',  summary(i_s).Polarity);
                text(-.1,1.0,msg,'units','normalized','fontsize',11);
                
                msg= sprintf('Mean FR = %1.2f (Hz)', str2num(summary(i_s).Epoch_FR));
                text(-.1,.8, msg, 'Fontsize',11);
                
                
                msg= sprintf('Spk#(small)= %d',  nb_spk_small);
                text(-.1,.6,msg,'units','normalized','fontsize',12);
                
                msg= sprintf('Rayleigh test Z (Corr) = %1.2f', rayleigh_z.Corr);
                text(-.1,.4, msg, 'Fontsize',11);
                
                msg= sprintf('Rayleigh P (Corr) = %1.2f', rayleigh_pval.Corr);
                text(-.1,.2, msg, 'Fontsize',11, 'backgroundcolor',bgcol(pval_sig.Corr+1,:));
                
                msg= sprintf('Mean deg (Corr) = %1.2f', phase_mean.Corr);
                text(-.1,.0, msg, 'Fontsize',11);
                
                
                
                
                
                
                
                
                %% Incorrect only
                
                
                subplot('Position', [0.1 0.1 0.35 0.3]);
                thisPhase.Incorr=thisPhase.Incorr';
                hist([thisPhase.Incorr thisPhase.Incorr+360],0:20:720)
                thisHISTFREQ = histc([thisPhase.Incorr thisPhase.Incorr+360], 0:intDEG:maxDEG * 2);
                nb_spk.Incorr= numel(thisPhase.Incorr);
                thisHISTFREQ= thisHISTFREQ./ nb_spk.Incorr; %% spike count normalized by the sum
                bar(thisHISTFREQ,'k');
                set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
                    'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
                xlabel('Deg'); ylabel('Norm. SPK #');
                title('Phase distribution(Incorr)'); box off;
                
                
                
                subplot('Position', [0.5 0.1 0.25 0.25]);
                rose(deg2rad(thisPhase.Incorr),intDEG); hold on;
                [x,y] = pol2cart(deg2rad(phase_mean.Incorr),max(get(gca,'Ytick'))*RV.Incorr);
                c= compass(x,y);
                set(gca,'View',[-90 90],'YDir','reverse');
                set(c,'linestyle','-','linewidth',1.5,'color','r');
                
                hline = findobj(gca,'Type','line');
                set(hline,'LineWidth',1.5,'MarkerFaceColor',[.1 .1 .1]);
                
                
                
                
                subplot('Position', [0.8 0.1 0.3 0.3]);
                axis off;
                
                
                
                msg= sprintf('Rayleigh test Z (Incorr) = %1.2f', rayleigh_z.Incorr);
                text(-.1,1.2, msg, 'Fontsize',11);
                
                msg= sprintf('Rayleigh P (Incorr) = %1.2f', rayleigh_pval.Incorr);
                text(-.1,1.0, msg, 'Fontsize',11, 'backgroundcolor',bgcol(pval_sig.Incorr+1,:));
                
                msg= sprintf('Mean deg (Incorr) = %1.2f', phase_mean.Incorr);
                text(-.1,0.8, msg, 'Fontsize',11);
                
                
                
                
                
                msg= sprintf('RV (Corr) = %1.4f',  RV.Corr);
                text(-.1,.4,msg,'units','normalized','fontsize',13);
                
                msg= sprintf('RV (Incorr) = %1.4f',  RV.Incorr);
                text(-.1,.2,msg,'units','normalized','fontsize',13);
                
                
                
                
                %% Save figure for verification
                cd(saveROOT);
                filename=[fig_name  '.png'];
                saveImage(fig,fig_name,fig_pos);
                
                
                
                
                
                % fod=fopen(outputfile,'w');
                % txt_header = 'Key#(Cluster), RatID, Session, Task_session, Task, Regional_pair, TT (EEG), ClusterID,';
                % fprintf(fod, txt_header);
                % txt_header = 'MeanFR, RVL(Corr), RVL(Incorr),Spk#(small_half),';
                % fprintf(fod, txt_header);
                % txt_header = 'FittingCAT, Polarity';
                % fprintf(fod, txt_header);
                % fprintf(fod,'\n');
                % fclose(fod);
                
                
                
                
                
                
                %% Output file generation
                
                fod=fopen(outputfile,'a');
                fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Regional_pair, TTID2, ClusterID);
                fprintf(fod,',%1.3f, %1.4f, %1.4f, %d',str2num(summary(i_s).Epoch_FR), RV.Corr, RV.Incorr, nb_spk_small);
                fprintf(fod,',%s, %s',summary(i_s).Fitting_category, summary(i_s).Polarity);
                fprintf(fod,'\n');
                fclose('all');
                
                
            end %   Target_run= 1:c_s
            
        end
        
        
    end
end


