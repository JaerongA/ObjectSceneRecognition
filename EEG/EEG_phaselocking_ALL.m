%% Created by Jaerong 2017/09/18  for PER & POR ephys analysis
%% Maxed out trials rejected


function EEG_phaselocking_ALL(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT)



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


fig_ok= 1 ;
bgcol=[1 0.6 0.6; 0.6 1 0.6];




%% Shuffling parameter

replacement=1; bootstrap_nb=1000;   %% randomly sample 1000 times with replacement



%% Save folder
% saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(ALL)\Theta'  date ];
% saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(ALL)\LowGamma\' date];
% saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(ALL)\Beta\' date ];
saveROOT= [dataROOT '\Analysis\EEG\Phaselocking(ALL)\HighGamma\' date];


if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)




%% Output file

outputfile= 'EEG_Phaselocking.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key#(Cluster), RatID, Session, Task_session, Task, Regional_pair, TT (EEG), ClusterID,';
fprintf(fod, txt_header);
txt_header = 'MeanFR, Rayleigh_Z, Rayleigh_sig, Phase_mean, Phase_var, kappa, RVL(ALL)';
fprintf(fod, txt_header);
txt_header = 'FittingCAT, Polarity';
fprintf(fod, txt_header);
fprintf(fod,'\n');
fclose(fod);




[r_s,c_s]=size(summary);



for i_s=  1:c_s
    
    
    
    %     if  (str2num(summary(i_s).Epoch_FR) >= 0.5)  && (str2num(summary(i_s).Zero_FR_Proportion) < 0.5) && ~strcmp(summary(i_s).Region,'POR') ...
    %             && (str2num(summary(i_s).Stability_ok)== 1) && ~strcmp(summary(i_s).Fitting_category,'Nofitting') && ~strcmp(summary(i_s).Fitting_category,'NaN')
    
    
    if  (strcmp(summary(i_s).Rat, 'r558')) && (strcmp(summary(i_s).Quality_ok, '1')) && ~strcmp(summary(i_s).Fitting_category,'Nofitting') && ~strcmp(summary(i_s).Fitting_category,'NaN')
        
        
        
        
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
                    
                    
                    if isempty(filteredEEG)
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
                    if ~isnan(spkEEG)                                                             %spk locked with EEG phase
                        HistMAT{trial_run} = phaseMat(spkEEG);
                    end
                    
                    
                    clear phaseMat
                    
                    disp(trial_run);
                    thisPhase =HistMAT{trial_run};
                    
                    
                    
                    if fig_ok
                        
                        
                        
                        
                        
                        %% Fig parms
                        
                        fig_pos = [400 400 1500 600];
                        
                        
                        ind= findstr(Prefix,'-');
                        
                        switch length(sprintf('%d',ts_evt(trial_run,Trial)))
                            
                            case 1
                                fig_name= ['Trial# 00' sprintf('%d',ts_evt(trial_run,Trial)) ' -' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)  '.png'];
                            case 2
                                fig_name= ['Trial# 0' sprintf('%d',ts_evt(trial_run,Trial)) ' -' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)  '.png'];
                            case 3
                                fig_name= ['Trial# ' sprintf('%d',ts_evt(trial_run,Trial)) ' -' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)  '.png'];
                        end
                        
                        
                        
                        
                        
                        %% Create figures
                        %% Print out cell ID
                        
                        %                         set(0,'DefaultFigureVisible','off')
                        fig=figure('name',fig_name(1:end-4),'Color',[1 1 1],'Position',fig_pos);
                        
                        subplot('Position', [0.25 0.98 0.3 0.2]);
                        text(0,0,fig_name(1:end-4),'fontsize',11);
                        axis off;
                        
                        
                        
                        %% Get phaselocking
                        
                        
                        
                        subplot('Position', [0.15 0.67 0.65 0.25]);
                        
                        plot(((thisEEGTS-thisEEGTS(1))), thisEEG,'Color',[.3 .3 .3]); hold on;
                        plot(((thisEEGTS-thisEEGTS(1))), filteredEEG,'b','linewidth',1.5); box off;
                        plot((thisEEGTS(spkEEG))-thisEEGTS(1), filteredEEG(spkEEG),'r*'); hold off;
                        axis tight;
                        ylabel('\muV','fontsize',15); xlabel('Time(s)');
                        
                        clear thisEEG*
                        
                        
                        subplot('Position', [0.15 0.2 0.2 0.35]);
                        
                        
                        hist([thisPhase thisPhase+360],0:20:720)
                        thisHISTFREQ = histc([thisPhase thisPhase+360], 0:intDEG:maxDEG * 2);
                        nb_spk= numel(thisSPK); trialFR(trial_run) = numel(thisSPK)/ ts_evt(trial_run, ChoiceLatency);
                        thisHISTFREQ= thisHISTFREQ./ nb_spk; %% spike count normalized by the sum
                        bar(thisHISTFREQ);
                        set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
                            'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
                        xlabel('Degree'); ylabel('Norm. SPK #');
                        title('Phase distribution'); box off;
                        
                        
                        
                        subplot('Position', [0.4 0.2 0.2 0.3]);
                        
                        
                        %Statistical test, Rayleigh test
                        thisPhase=thisPhase';
                        [rayleigh_pval rayleigh_z] = circ_rtest(deg2rad(thisPhase));
                        %             [thisRAOP thisRAOU] = circ_raotest(deg2rad(thisPhase));
                        %             [thisRP thisRZ] = circ_rtest(deg2rad(cell2mat(HistMAT)));
                        tempMU = rad2deg(circ_mean(deg2rad(thisPhase))); if tempMU < 0, phase_mean(trial_run) = 360 + tempMU; else phase_mean(trial_run) = tempMU; end
                        thisKappa(trial_run) = circ_kurtosis(deg2rad(thisPhase));	%Pewsey's kappa
                        phase_var(trial_run)= circ_var(deg2rad(thisPhase));
                        
                        rose(deg2rad(thisPhase),intDEG); hold on;
                        [x,y] = pol2cart(deg2rad(phase_mean(trial_run)),max(get(gca,'Ytick')));
                        c= compass(x,y);
                        set(gca,'View',[-90 90],'YDir','reverse');
                        set(c,'linestyle','-','linewidth',1.5,'color','r');
                        
                        hline = findobj(gca,'Type','line');
                        set(hline,'LineWidth',1.5,'MarkerFaceColor',[.1 .1 .1]);
                        
                        
                        
                        subplot('Position', [0.7 0.2 0.2 0.3]);
                        axis off;
                        
                        msg= sprintf('Latency = %1.3f', ts_evt(trial_run,ChoiceLatency));
                        text(-.3,1.3, msg, 'Fontsize',12);
                        
                        msg= sprintf('FR = %.2f', trialFR(trial_run));
                        text(-.3,1.1, msg, 'Fontsize',12);
                        
                        msg= sprintf('# of spk= %d', numel(thisSPK));
                        text(-.3,.9, msg, 'Fontsize',12);
                        
                        msg= sprintf('Rayleigh test = %1.3f', rayleigh_z);
                        text(-.3,.7, msg, 'Fontsize',12);
                        
                        msg= sprintf('Rayleigh P = %1.3f', rayleigh_pval);
                        text(-.3,.5, msg, 'Fontsize',12);
                        
                        msg= sprintf('Mean deg = %1.3f', phase_mean(trial_run));
                        text(-.3,.3, msg, 'Fontsize',12);
                        
                        msg= sprintf('Var deg  = %1.3f', phase_var(trial_run));
                        text(-.3,.1, msg, 'Fontsize',12);
                        
                        msg= sprintf('Kappa = %1.3f', thisKappa(trial_run));
                        text(-.3,-.1, msg, 'Fontsize',12);
                        
                        msg= sprintf('Stimulus = %s', Stimulus_str{ts_evt(trial_run,Stimulus)});
                        text(0.4,0.9,msg,'units','normalized','fontsize',12);
                        
                        msg= sprintf('%s', Perf_str{ts_evt(trial_run,Correctness)+1});
                        text(0.4,0.7,msg,'units','normalized','fontsize',15);
                        
                        
                        %% Save figure for verification
                        
                        
                        
                        
                        
                        %                         fig_saveROOT= [ Prefix '-' Prefix2];
                        fig_saveROOT= [saveROOT '\' Prefix ' & ' Key2 '-' Prefix2(ind(5)+1:end)];
                        
                        
                        if ~exist(fig_saveROOT)
                            mkdir(fig_saveROOT);
                        end
                        
                        
                        cd(fig_saveROOT)
                        
                        
                        filename_ai=sprintf('Trial %d.eps', trial_run);
                        print( gcf, '-painters', '-r300', filename_ai, '-depsc');
                        
                        
                        filename= sprintf('Trial %d.png', trial_run);
                        saveImage(fig,filename,fig_pos);
                        
                    end
                    
                    
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
                
                
                
                
                thisPhase = cell2mat(HistMAT);
                thisPhase=thisPhase';
                [rayleigh_pval rayleigh_z] = circ_rtest(deg2rad(thisPhase));
                if rayleigh_pval<0.05,  pval_sig=1;   else  pval_sig=0;    end
                
                %             [thisRAOP thisRAOU] = circ_raotest(deg2rad(thisPhase));
                %             [thisRP thisRZ] = circ_rtest(deg2rad(cell2mat(HistMAT)));
                tempMU = rad2deg(circ_mean(deg2rad(thisPhase))); if tempMU < 0, phase_mean = 360 + tempMU; else phase_mean = tempMU; end
                thisKappa = circ_kurtosis(deg2rad(thisPhase));	%Pewsey's kappa
                phase_var= circ_var(deg2rad(thisPhase));
                RV= circ_r(deg2rad(thisPhase));
                
                
                
                ind= findstr(Prefix2,'-');
                fig_name = [Prefix ' vs.'  Key2 '-' Prefix2(ind(5)+1:end) '.png'];
                fig_pos= [400 400 1000 700];
                
                
                fig=figure('name',fig_name(1:end-4),'Color',[1 1 1],'Position',fig_pos);
                
                subplot('Position', [0.01 0.98 0.3 0.2]);
                text(0.5,0,fig_name(1:end-4),'fontsize',11); axis off;
                
                
                
                
                subplot('Position', [0.1 0.55 0.35 0.3]);
                thisPhase=thisPhase';
                hist([thisPhase thisPhase+360],0:20:720)
                thisHISTFREQ = histc([thisPhase thisPhase+360], 0:intDEG:maxDEG * 2);
                nb_spk= numel(thisPhase);
                thisHISTFREQ= thisHISTFREQ./ nb_spk; %% spike count normalized by the sum
                bar(thisHISTFREQ);
                set(gca, 'XLim', [0 maxDEG * 2 / intDEG + 1],...
                    'XTick', 0:(maxDEG * 2 / intDEG + 1) / 8:(maxDEG * 2 / intDEG + 1), 'XTickLabel', {['0'], ['90'], ['180'], ['270'], ['360'], ['450'], ['540'], ['630'], ['720']});
                xlabel('Deg'); ylabel('Norm. SPK #');
                title('Phase distribution'); box off;
                
                
                
                subplot('Position', [0.5 0.55 0.25 0.25]);
                rose(deg2rad(thisPhase),intDEG); hold on;
                [x,y] = pol2cart(deg2rad(phase_mean),max(get(gca,'Ytick'))*RV);
                c= compass(x,y);
                set(gca,'View',[-90 90],'YDir','reverse');
                set(c,'linestyle','-','linewidth',1.5,'color','r');
                
                hline = findobj(gca,'Type','line');
                set(hline,'LineWidth',1.5,'MarkerFaceColor',[.1 .1 .1]);
                
                
                
                
                
                
                
                
                
                
                
                subplot('Position', [0.4 0.1 0.3 0.3]);
                axis off;
                
                msg= sprintf('Resultant Vector Length(All) = %1.3f ', RV);
                text(-.3,1, msg, 'Fontsize',12);
                
                msg= sprintf('Mean FR = %1.3f (Hz)', str2num(summary(i_s).Epoch_FR));
                text(-.3,.8, msg, 'Fontsize',12);
                
                msg= sprintf('Rayleigh test = %1.3f', rayleigh_z);
                text(-.3,.6, msg, 'Fontsize',12);
                
                msg= sprintf('Rayleigh P = %1.3f', rayleigh_pval);
                text(-.3,.4, msg, 'Fontsize',12, 'backgroundcolor',bgcol(pval_sig+1,:));
                
                msg= sprintf('Mean deg = %1.3f', phase_mean);
                text(-.3,.2, msg, 'Fontsize',12);
                
                msg= sprintf('Var deg  = %1.3f', phase_var);
                text(-.3, 0, msg, 'Fontsize',12);
                
                msg= sprintf('Kappa = %1.3f', thisKappa);
                text(-.3,-.2, msg, 'Fontsize',12);
                
                msg= sprintf('Fitting Cat = %s', summary(i_s).Fitting_category);
                text(0.5,.8,msg,'units','normalized','fontsize',12);
                
                msg= sprintf('Polarity = %s',  summary(i_s).Polarity);
                text(0.5,.6,msg,'units','normalized','fontsize',12);
                
                
                Regional_pair=[];
                Regional_pair= ['EEG-' Region2 ' vs. Cluster-' Region];
                
                %% Save figure for verification
                
                cd(saveROOT);
                
                
                %                 mat_name =[Prefix ' -' Prefix2 '.mat'];
                %                 save(mat_name,'HistMAT','thisPhase');
                
                
                clear thisPhase HistMAT
                
                filename_ai=[fig_name(1:end-4) '.eps'];
                print( gcf, '-painters', '-r300', filename_ai, '-depsc');
                
                
                filename=[fig_name  '.png'];
                saveImage(fig,fig_name,fig_pos);
                
                
                
                % outputfile= 'EEG_Phaselocking.csv';
                %
                % fod=fopen(outputfile,'w');
                % txt_header = 'Key#(Cluster), RatID, Session, Task_session, Task, Regional_pair, TT (EEG), ClusterID,';
                % fprintf(fod, txt_header);
                % txt_header = 'MeanFR, Rayleigh_Z, Rayleigh_sig, Phase_mean, Phase_var, kappa, RVL(ALL), RVL(1stHalf), RVL(2ndHalf), ';
                % fprintf(fod, txt_header);
                % txt_header = 'FittingCAT, Polarity';
                % fprintf(fod, txt_header);
                % fprintf(fod,'\n');
                % fclose(fod);
                
                
                
                
                fod=fopen(outputfile,'a');
                fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Regional_pair, TTID2, ClusterID);
                fprintf(fod,',%1.5f, %1.5f, %d, %1.5f, %1.5f, %1.5f, %1.5f',str2num(summary(i_s).Epoch_FR), rayleigh_z, pval_sig, phase_mean, phase_var, thisKappa, RV);
                fprintf(fod,',%s, %s',summary(i_s).Fitting_category, summary(i_s).Polarity);
                fprintf(fod,'\n');
                fclose('all');
                
                
            end %   Target_run= 1:c_s
        end
        
    end
end


