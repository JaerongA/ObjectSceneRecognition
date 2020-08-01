%% By Jaerong
%% Get phase-locking (2018/01/18) compare novel and familiar objects

function EEG_phaselocking_novelty(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT)


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
% saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(Novelty)\Theta_' date ];
% saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(Novelty)\Beta_' date];
% saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(Novelty)\LowGamma_' date ];
saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(Novelty)\HighGamma_' date ];

if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)






%% Output file

outputfile= 'EEG_Phaselocking_Novelty.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key#(Cluster), RatID, Session, Task_session, Task, Regional_pair, TT (EEG), ClusterID,';
fprintf(fod, txt_header);
txt_header = 'MeanFR, RVL(Familiar_Corr), RVL(Novel_Corr),Spk#(small_half),';
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
                    && strcmp(RatID, RatID2) && strcmp(Session, Session2) && strcmp(Task, Task2) && strcmp(Region, Region2)
                
                
                
                
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
                
%     select.Familiar_Corr = find((ts_evt(:,Stimulus)==Icecream | ts_evt(:,Stimulus)==House) & ts_evt(:,Correctness)==1);
%     select.Novel_Corr = find((ts_evt(:,Stimulus)==Owl | ts_evt(:,Stimulus)==Phone)& ts_evt(:,Correctness)==1);
                
                
                %% Look up the ADBitVolts
                
%                 bit2milivolt = str2num(summary_eeg(Target_run).ADBitmilivolts);
                 bit2micovolt = str2num(summary_eeg(Target_run).ADBitmicrovolts); %read ADBitVolts
                
                
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
                
                
%     select.Familiar_Corr = find((ts_evt(:,Stimulus)==Icecream | ts_evt(:,Stimulus)==House) & ts_evt(:,Correctness)==1);
%     select.Novel_Corr = find((ts_evt(:,Stimulus)==Owl | ts_evt(:,Stimulus)==Phone)& ts_evt(:,Correctness)==1);
                
                
                thisPhase.Familiar_Corr = cell2mat(HistMAT(select.Familiar_Corr));
                thisPhase.Familiar_Corr=thisPhase.Familiar_Corr';
                [rayleigh_pval.Familiar_Corr rayleigh_z.Familiar_Corr] = circ_rtest(deg2rad(thisPhase.Familiar_Corr));
                if rayleigh_pval.Familiar_Corr<0.05,  pval_sig.Familiar_Corr =1;   else  pval_sig.Familiar_Corr =0;    end
                tempMU.Familiar_Corr = rad2deg(circ_mean(deg2rad(thisPhase.Familiar_Corr))); if tempMU.Familiar_Corr < 0, phase_mean.Familiar_Corr = 360 + tempMU.Familiar_Corr; else phase_mean.Familiar_Corr = tempMU.Familiar_Corr; end
                thisKappa.Familiar_Corr = circ_kurtosis(deg2rad(thisPhase.Familiar_Corr));	%Pewsey's kappa
                phase_var.Familiar_Corr= circ_var(deg2rad(thisPhase.Familiar_Corr));
                
                
                
                
                thisPhase.Novel_Corr = cell2mat(HistMAT(select.Novel_Corr));
                if isempty(thisPhase.Novel_Corr)
                    continue;
                end
                thisPhase.Novel_Corr=thisPhase.Novel_Corr';
                [rayleigh_pval.Novel_Corr rayleigh_z.Novel_Corr] = circ_rtest(deg2rad(thisPhase.Novel_Corr));
                if rayleigh_pval.Novel_Corr<0.05,  pval_sig.Novel_Corr =1;   else  pval_sig.Novel_Corr =0;    end
                tempMU.Novel_Corr = rad2deg(circ_mean(deg2rad(thisPhase.Novel_Corr))); if tempMU.Novel_Corr < 0, phase_mean.Novel_Corr = 360 + tempMU.Novel_Corr; else phase_mean.Novel_Corr = tempMU.Novel_Corr; end
                thisKappa.Novel_Corr = circ_kurtosis(deg2rad(thisPhase.Novel_Corr));	%Pewsey's kappa
                phase_var.Novel_Corr= circ_var(deg2rad(thisPhase.Novel_Corr));
                
                
                nb_spk_small=  min(numel(thisPhase.Familiar_Corr),numel(thisPhase.Novel_Corr));
                
                
                
                
                %% Bootstrapping  (Mean Resultant Length)
                
                
                
                samplePhase=[]; sample_nb=[];
                
                
                
                RV.Familiar_Corr= circ_r(deg2rad(thisPhase.Familiar_Corr));
                RV.Novel_Corr= circ_r(deg2rad(thisPhase.Novel_Corr));
                
                
                
%                 
%                 
%                 
%                 if numel(thisPhase.Familiar_Corr) > numel(thisPhase.Novel_Corr)
%                     familiar_high= 1;
%                     samplePhase= thisPhase.Familiar_Corr;
%                     sample_nb= numel(thisPhase.Novel_Corr);
%                 else
%                     familiar_high= 0;
%                     samplePhase= thisPhase.Novel_Corr;
%                     sample_nb= numel(thisPhase.Familiar_Corr);
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
%                     PhaseMat(bootstrap_ind) = circ_r(deg2rad(bootstrapPhase));
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
%                 if familiar_high
%                     RV.Familiar_Corr = mean(PhaseMat);
%                     
%                 else
%                     RV.Novel_Corr = mean(PhaseMat);
%                 end
%                 
%                 
                
                
                
                ind= findstr(Prefix2,'-');
                fig_name = [Prefix ' vs.'  Key2 '-' Prefix2(ind(5)+1:end) '.png'];
                fig_pos= [400 400 1100 700];
                
                
                fig=figure('name',fig_name(1:end-4),'Color',[1 1 1],'Position',fig_pos);
                
                subplot('Position', [0.01 0.98 0.3 0.2]);
                text(0.5,0,fig_name(1:end-4),'fontsize',11); axis off;
                
                
                %% Familiar Only
                
                subplot('Position', [0.1 0.55 0.35 0.3]);
                thisPhase.Familiar_Corr=thisPhase.Familiar_Corr';
                hist([thisPhase.Familiar_Corr thisPhase.Familiar_Corr+360],0:20:720)
                thisHISTFREQ = histc([thisPhase.Familiar_Corr thisPhase.Familiar_Corr+360], 0:intDEG:maxDEG * 2);
                nb_spk.Familiar_Corr= numel(thisPhase.Familiar_Corr);
                thisHISTFREQ= thisHISTFREQ./ nb_spk.Familiar_Corr; %% spike count normalized by the sum
                bar(thisHISTFREQ);
                set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
                    'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
                xlabel('Deg'); ylabel('Norm. SPK #');
                title('Phase distribution(Familiar)'); box off;
                
                
                
                subplot('Position', [0.5 0.55 0.25 0.25]);
                rose(deg2rad(thisPhase.Familiar_Corr),intDEG); hold on;
                [x,y] = pol2cart(deg2rad(phase_mean.Familiar_Corr),max(get(gca,'Ytick'))*RV.Familiar_Corr);
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
                
                msg= sprintf('Rayleigh test Z (Familiar) = %1.2f', rayleigh_z.Familiar_Corr);
                text(-.1,.4, msg, 'Fontsize',11);
                
                msg= sprintf('Rayleigh P (Familiar) = %1.2f', rayleigh_pval.Familiar_Corr);
                text(-.1,.2, msg, 'Fontsize',11, 'backgroundcolor',bgcol(pval_sig.Familiar_Corr+1,:));
                
                msg= sprintf('Mean deg (Familiar) = %1.2f', phase_mean.Familiar_Corr);
                text(-.1,.0, msg, 'Fontsize',11);
                
                
                
               %% Novel only
                subplot('Position', [0.1 0.1 0.35 0.3]);
                thisPhase.Novel_Corr=thisPhase.Novel_Corr';
                hist([thisPhase.Novel_Corr thisPhase.Novel_Corr+360],0:20:720)
                thisHISTFREQ = histc([thisPhase.Novel_Corr thisPhase.Novel_Corr+360], 0:intDEG:maxDEG * 2);
                nb_spk.Novel_Corr= numel(thisPhase.Novel_Corr);
                thisHISTFREQ= thisHISTFREQ./ nb_spk.Novel_Corr; %% spike count normalized by the sum
                bar(thisHISTFREQ,'k');
                set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
                    'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
                xlabel('Deg'); ylabel('Norm. SPK #');
                title('Phase distribution(Novel)'); box off;
                
                
                
                subplot('Position', [0.5 0.1 0.25 0.25]);
                rose(deg2rad(thisPhase.Novel_Corr),intDEG); hold on;
                [x,y] = pol2cart(deg2rad(phase_mean.Novel_Corr),max(get(gca,'Ytick'))*RV.Novel_Corr);
                c= compass(x,y);
                set(gca,'View',[-90 90],'YDir','reverse');
                set(c,'linestyle','-','linewidth',1.5,'color','r');
                
                hline = findobj(gca,'Type','line');
                set(hline,'LineWidth',1.5,'MarkerFaceColor',[.1 .1 .1]);
                
                
                
                
                subplot('Position', [0.8 0.1 0.3 0.3]);
                axis off;
                
                
                
                msg= sprintf('Rayleigh test Z (Novel) = %1.2f', rayleigh_z.Novel_Corr);
                text(-.1,1.2, msg, 'Fontsize',11);
                
                msg= sprintf('Rayleigh P (Novel) = %1.2f', rayleigh_pval.Novel_Corr);
                text(-.1,1.0, msg, 'Fontsize',11, 'backgroundcolor',bgcol(pval_sig.Novel_Corr+1,:));
                
                msg= sprintf('Mean deg (Novel) = %1.2f', phase_mean.Novel_Corr);
                text(-.1,0.8, msg, 'Fontsize',11);
                
                
                
                msg= sprintf('RV (Familiar) = %1.4f',  RV.Familiar_Corr);
                text(-.1,.4,msg,'units','normalized','fontsize',13);
                
                msg= sprintf('RV (Novel) = %1.4f',  RV.Novel_Corr);
                text(-.1,.2,msg,'units','normalized','fontsize',13);
                
                
                
                
               %% Save figure for verification
                cd(saveROOT);
                filename=[fig_name  '.png'];
                saveImage(fig,fig_name,fig_pos);
                
                
                
               %% Output file generation
                fod=fopen(outputfile,'a');
                fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Regional_pair, TTID2, ClusterID);
                fprintf(fod,',%1.3f, %1.4f, %1.4f, %d',str2num(summary(i_s).Epoch_FR), RV.Familiar_Corr, RV.Novel_Corr, nb_spk_small);
                fprintf(fod,',%s, %s',summary(i_s).Fitting_category, summary(i_s).Polarity);
                fprintf(fod,'\n');
                fclose('all');
                
                
            end %   Target_run= 1:c_s
            
        end
        
        
    end
end


