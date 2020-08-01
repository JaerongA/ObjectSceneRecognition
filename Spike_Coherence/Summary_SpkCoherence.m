%% Created by AJR 2017/02/20
%% The program generates cross-correlogram among HIPP & PER & POR

function Summary_SpkCoherence(summary, summary_header, dataROOT)




%% Output folder
saveROOT= [dataROOT '\Analysis\SpkCoherence\' date ];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);


% %% Parameters
%
% load_parms;
%
%
% %% Load output files
%
% load_outputfile;
%
%





%% parameter setting


BarWidth= 5;


fig_pos=[200 150 1600 800]; %lab computer
%         fig_pos=[30 30 1200 1000]; % home computer
CAT_color = [0    0.4470    0.7410; 0.8500    0.3250    0.0980];

cd(dataROOT);


%% time bin setting

% bin_size_sec= 0.001;
bin_size_sec= 0.001;
Xmin_sec= -0.2;
Xmax_sec= 0.2;


p_conf= 0.025;





outputfile= ['Correlogram_' date '.txt'];
fod = fopen(outputfile,'w');

txt_header = 'RatID, Session, Task, Ref_TT, Ref_Cluster, Ref_Region, Target_TT, Target_Cluster, Target_Region, Target_Layer, PeakLoc, PeakCount, UpperCI, BiasIND\n';
fprintf(fod, txt_header);
fclose(fod);












%% Spectrogram Parms

movingwin=[0.5 0.05]; % set the moving window dimensions
params.Fs=1000; % sampling frequency
params.fpass=[0 150]; % frequencies of interest
params.tapers=[5 9]; % tapers
params.trialave=1; % average over trials
params.err=0;










%% Trial Info
Trial= 1; Stimulus=2; Correctness=3; Response=4;

ChoiceLatency= 5;

global StimulusOnset
global Choice


StimulusOnset= 6;
Choice=7;


Trial_S3_1=8; Trial_S4_1=9; Trial_S3_end=10; Trial_S4_end=11; Trial_Void=12;

StimulusCAT=13;  %% novelty, modality, category


%% Reference Cluster Selection

nb_ref=size(summary,2);


for Ref_run= 128
%     1:nb_ref
    
    
    
    if str2num(summary(Ref_run).Epoch_FR) >= 0.5  && str2num(summary(Ref_run).Repetition_ok) && ( strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)'))
        
        
        
        %% Set cluster prefix
        
        ref_cluster_prefix;
        
        
        %% Loading the reference cluster
        
        cd(TT_folder.ref);
        ts_spk.ref= Nlx2MatSpike(ClusterID.ref, [1 0 0 0 0], 0, 1, 0);
        
        
        %% Select another cluster from the same session
        
        nb_target =size(summary,2);
        
        
        
        for Target_run=Ref_run: nb_target
            
            
            %             if str2num(summary(Target_run).Epoch_FR) >= 0.5  && strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
            
            if  str2num(summary(Target_run).Epoch_FR) >= 0.5 &&  str2num(summary(Ref_run).Repetition_ok) &&  (strcmp(summary(Target_run).Task_name,'OCRS(FourOBJ)'))
                
                
                target_cluster_prefix;
                
                
                
                if   (str2num(Key.ref)< str2num(Key.target)) && strcmp(RatID.ref, RatID.target) && strcmp(Session.ref, Session.target) && ~strcmp(Region.ref, Region.target) && ~strcmp(Region.ref, Region.target)
                    
                    
                    disp(['reference_cluster... ' Prefix.ref]);
                    disp(['target cluster... : ' Prefix.target]);
                    
                    
                    %% Loading the target cluster
                    
                    cd(TT_folder.target);
                    ts_spk.target= Nlx2MatSpike(ClusterID.target, [1 0 0 0 0], 0, 1, 0);
                    
                    
                    
                    %% Loading trial ts info from ParsedEvents.mat
                    
                    
                    % %% Column Header
                    % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
                    
                    
                    
                    cd([Session_folder.ref '\Behavior']);
                    load('ParsedEvents.mat');
                    
                    
                    
                    %% Add stimulus category information
                    
                    if strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)') || strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
                        ts_evt= add_category_info(ts_evt,Task.ref);
                    end
                    
                    %% Eliminated void trials
                    
                    ts_evt= void_trial_elimination(ts_evt);
                    
                    
                    %% Select trial types
                    
                    select_trial_type_correlogram;
                    
                    
                    
                    
                    
                    autocorrelogram=[];
                    correlogram=[];
                    
                    
                    
                    
                    %% Get autocorrelogram
                    
                    [autocorrelogram.ref]= Draw_correlogram(ts_spk.ref, ts_spk.ref, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt);
                    
                    
                    [m max_ind]= max(autocorrelogram.ref);
                    autocorrelogram.ref(max_ind)=0;  clear m
                    
                    
                    [autocorrelogram.target]= Draw_correlogram(ts_spk.target, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt);
                    
                    
                    [m max_ind]= max(autocorrelogram.target);
                    autocorrelogram.target(max_ind)=0;  clear m
                    
                    
                    
                    
                    
                    %% Get cross correlogram
                    
                    [correlogram.ALL, X_range]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt);
                    

                    [correlogram.Jitter]= Draw_correlogram_jitter(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt);
                    
                    
%                       [correlogram.ALL, X_range]= Draw_correlogram_bootstrap(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt);
                    
                    
                    
                    
                    if    strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)')
                        
                        [correlogram.Familiar]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.Familiar,:));
                        [correlogram.Novel]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.Novel,:));
                        
                    elseif    strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
                        
                        [correlogram.Scene]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.Scene,:));
                        [correlogram.OBJ]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.OBJ,:) );
                        
                    end
                    
                    
                    
                    %% Calculate the bias index
                    
                    
                    left_crosscorr= correlogram.ALL(1:length(correlogram.ALL)/2);  %% target
                    right_crosscorr= correlogram.ALL((length(correlogram.ALL)/2)+1:end);  %% ref
                    bias_ind= (sum(left_crosscorr)-sum(right_crosscorr))/ (sum(left_crosscorr)+sum(right_crosscorr));
                    
                    
                    pxx=[];
                    pxx.left = pwelch(left_crosscorr,[],[],512);   %% Target leads
                    pxx.right = pwelch(right_crosscorr,[],[],512);   %% Ref leads
                    
                    
                    
                    %% Calculate the peak count and peak location
                    peak_count=max(correlogram.ALL);
                    peak_nb= sum(correlogram.ALL==max(correlogram.ALL));
                    if peak_nb >=2
                        peak_loc=nan; peak_count=nan;
                    else
                        peak_loc= ((X_range(correlogram.ALL==peak_count) +(X_range(correlogram.ALL==peak_count)+ bin_size_sec)))/2;
                        %                         if peak_count> conf_int(2)
                        %                             vline(peak_loc,'r:')
                        %                         end
                    end
                    
                    trough_count=min(correlogram.ALL);
                    trough_nb= sum(correlogram.ALL==min(correlogram.ALL));
                    if trough_nb >=2
                        trough_loc=nan;
                    else
                        trough_loc= ((X_range(correlogram.ALL==trough_count) +(X_range(correlogram.ALL==trough_count)+ bin_size_sec)))/2;
                        %                         vline(trough_loc,'r')
                    end
                    %                     hold off;
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    % if the bias_ind is negative, it means that TE (target) cells
                    % were more likely to be preceded by PER (reference) cells.
                    
                    
                    %                     %% Get the chance level for normalization
                    %                     chance_freq= sum(correlogram)/(length(X_range)); %% the spike frequency if the spikes in the histograms were evenly assigned to the time bin.
                    %                     normalized_crosscorr= correlogram./chance_freq;
                    %                     %                     normalized_crosscorr= correlogram-chance_freq;
                    %
                    %                     subplot(1,3,2)
                    %                     % %                     normalized_crosscorr=normalized_crosscorr-1;
                    %                     %                     negative= find(normalized_crosscorr<0);
                    %                     %                     normalized_crosscorr(negative)=0;
                    %                     bar(X_range,normalized_crosscorr,'k')
                    %                     set(gca,'xlim',[Xmin_ms-bin_size_ms Xmax_ms+bin_size_ms]); xlabel('time (ms)'); ylabel('# of normalized spk');
                    %                     Prefix.ref= strrep(Prefix.ref,'_','-'); Prefix.target= strrep(Prefix.target,'_','-');
                    %                     title([Prefix.ref ' vs. ' Prefix.target]);
                    
                    
                    
                    %                     [correlogram.Scene, X_range, nb_spk]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.Scene,:));
                    %
                    %                     [correlogram.OBJ, X_range, nb_spk]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.OBJ,:));
                    
                    
                    
                    
                    
                    
                    
                    %% ms conversion
                    X_range= X_range.*10^3;  %% ms conversion
                    Xmin_ms= Xmin_sec.*10^3;  %% ms conversion
                    Xmax_ms= Xmax_sec.*10^3;  %% ms conversion
                    bin_size_ms= bin_size_sec.*10^3;  %% ms conversion
                    
                    
                    
                    
                    %% Figure
                    
                    fig=figure('Color',[1 1 1],'Position',fig_pos);
                    
                    
                    subplot('Position', [0.2 0.98 0.4 0.2]);
                    text(0,0,[Prefix.ref ' vs. ' Prefix.target],'fontsize',11);
                    axis off;
                    
                    
                    
                    
                    %% Autocorrelogram for the reference & target cluster
                    
                    subplot('position',[0.05 0.55 0.2 0.35]);
                    bar(X_range,autocorrelogram.ref,BarWidth,'k'); hold on; box off;
                    set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); title(sprintf('Reference (%s)',Region.ref)); xlabel('Time (ms)'); ylabel('Count');
                    set(gca,'TickLength',[ 0 0 ]);
                    text(.7,.9,sprintf('FR = %s (Hz)',summary(Ref_run).Epoch_FR),'Units','normalized');
                    
                    
                    subplot('position',[0.30 0.55 0.2 0.35]);
                    bar(X_range,autocorrelogram.target,BarWidth,'k'); hold on; box off;
                    set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); title(sprintf('Target (%s)',Region.target)); xlabel('Time (ms)'); ylabel('Count');
                    set(gca,'TickLength',[ 0 0 ]);
                    text(.7,.9,sprintf('FR = %s (Hz)',summary(Target_run).Epoch_FR),'Units','normalized');
                    
                    
                    
                    %% Crosscorrelogram between the reference & target cluster
                    
                    
                    
                    subplot('position',[0.55 0.55 0.2 0.35]);
                    bar(X_range,correlogram.ALL,BarWidth,'k');  hold on; box off;
                    %                         line([Xmin_ms Xmax_ms],[conf_int(2) conf_int(2)]);
                    %                         line([Xmin_ms Xmax_ms],[conf_int(2) conf_int(2)]);
                    set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); title('CrossCorr'); xlabel('Time (ms)'); ylabel('Count');
                    %                     hline(conf_int(1),'b:');
                    %                     hline(conf_int(2),'b:');
                    vhandle = vline(0,'r:'); set(vhandle,'linewidth',1.5);
                    
                    text(.1,1.1,sprintf('%s leads <--',Region.target),'Units','normalized');
                    text(.6,1.1,sprintf('--> %s leads',Region.ref),'Units','normalized');
                    
                    
                    
                    
                    %% Power spectrogram
                    subplot('position',[0.79 0.55 0.2 0.35]);
                    plot(10*log10(pxx.left),'b','linewidth',2);  hold  on;
                    plot(10*log10(pxx.right),'m','linewidth',2); box off;
                    
                    legend(sprintf('%s -> %s',Region.target ,Region.ref),sprintf('%s -> %s',Region.ref ,Region.target));
                    %                     legend('left','right');
                    xlim([1 140]);
                    xlabel(['Frequency (Hz)']); ylabel(['Power (dB)']);
                    
                    
                    
                    
                    
                    subplot('position',[0.05 0.1 0.2 0.35]);
                    
                    
                    if    strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)')
                        
                        hbar = bar(X_range,correlogram.Familiar,8); set(hbar,'FaceColor',CAT_color(1,:)); box off;
                        set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); xlabel('time (ms)'); ylabel('Count');
                        set(gca,'TickLength',[ 0 0 ]); title('CrossCorr(Familiar)');
                        
                    elseif    strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
                        
                        hbar = bar(X_range,correlogram.Scene,8); set(hbar,'FaceColor',CAT_color(1,:)); box off;
                        set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); title(sprintf('Reference (%s)',Region.ref));
                        set(gca,'TickLength',[ 0 0 ]); title('CrossCorr(Scene)');
                        
                    end
                    
                    
                    subplot('position',[0.30 0.1 0.2 0.35]);
                    
                    
                    if    strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)')
                        
                        hbar = bar(X_range,correlogram.Novel,10); set(hbar,'FaceColor',CAT_color(2,:)); box off;
                        set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); xlabel('time (ms)'); ylabel('Count');
                        set(gca,'TickLength',[ 0 0 ]); title('CrossCorr(Novel)');
                        
                    elseif    strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
                        
                        hbar = bar(X_range,correlogram.OBJ,10); set(hbar,'FaceColor',CAT_color(2,:)); box off;
                        set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); xlabel('time (ms)'); ylabel('Count');
                        set(gca,'TickLength',[ 0 0 ]); title('CrossCorr(OBJ)');
                        
                    end
                    
                    
                    
                    
                    
                    
                    
%                     %% Plot spectrogram & coherogram
%                     
%                     nb_trial= size(ts_evt,1);
%                     
%                     
%                     %% Spike extraction from the reference cluster
%                     
%                     
%                     
%                     for trial_run=1: nb_trial
%                         
%                         ts_evt_period= [ ts_evt(trial_run,StimulusOnset)  ts_evt(trial_run,Choice)];
%                         
%                         data.ref(trial_run) = extractdatapt(ts_spk.ref/10^6,ts_evt_period,1);
%                         data.target(trial_run) = extractdatapt(ts_spk.target/10^6,ts_evt_period,1);
%                         
%                     end
%                     
%                     
%                     
%                     [S,t,f,R]=mtspecgrampt(data.ref,movingwin,params); % compute spectrogram
%                     
%                     subplot('position',[0.55 0.35 0.24 0.10]);
%                     
%                     % plot spectrogram normalized by rate
%                     plot_matrix(S./repmat(R,[1 size(S,2)]),t,f); xlabel([]); set(gca,'xticklabel',[]);
%                     caxis([-5 6]);colorbar; colormap(jet);
%                     xlim([0.25 ceil(mean(ts_evt(:,ChoiceLatency)))]);
%                     title(sprintf('Reference (%s)',Region.ref)); ylabel('Frequency');
%                     
%                     
%                     
%                     
%                     
%                     [S,t,f,R]=mtspecgrampt(data.target,movingwin,params); % compute spectrogram
%                     
%                     subplot('position',[0.55 0.20 0.24 0.10]);
%                     
%                     % plot spectrogram normalized by rate
%                     plot_matrix(S./repmat(R,[1 size(S,2)]),t,f);xlabel([]); set(gca,'xticklabel',[]);
%                     caxis([-5 6]);colorbar; colormap(jet);
%                     xlim([0.25 ceil(mean(ts_evt(:,ChoiceLatency)))]);
%                     title(sprintf('Target (%s)',Region.target)); ylabel('Frequency');
                    
                    
                    
                    
                    
                    
                    
%                     fscorr= 1;
%                     params.err=[1 0.05];
%                     
% %                     [C,phi,S12,S1,S2,t,f]=cohgrampt(data.ref,data.target,movingwin,params,fscorr)
%                     [C]=cohgrampt(data.ref,data.target,movingwin,params,fscorr);
%                     
%                     
%                     subplot('position',[0.55 0.06 0.24 0.10]);
%                     
%                     % plot spectrogram normalized by rate
%                     plot_matrix(C,t,f);xlabel([]); caxis([-35 0]);
%                     xlim([0.25 ceil(mean(ts_evt(:,ChoiceLatency)))]); xlabel('Time (s)'); ylabel('Frequency');
%                     title('Coherogram'); 
%                     
                    
                    
                    
                    
                    fig_name=[Prefix.ref '& ' Prefix.target '.png'];
                    %                     filename_ai=[Prefix.ref '& ' Prefix.target '.eps'];
                    
                    cd(saveROOT);
                    
                    %                     fod = fopen(outputfile,'a');
                    %                     %                     fprintf(fod,'Rat \tsession \ttask \tRef_TT \tRef_region \tRef_layer \wtarget_TT \ttarget_region \ttarget_layer \tpeak_location \tbias_index');
                    %                     fprintf(fod,'%s \t%s \t%s \t%s \t%s \t%s \t%s \t%s \t%s \t%s \t%s \t%1.4f \t%1.4f \t%1.4f \t%1.4f',...
                    %                         RatID.ref, session, task, TT, cluster_nb, region, layer, TT.target, Cluster_nb.target, Region.target, Layer.target, peak_loc, peak_count, conf_int(2), bias_ind);
                    %                     fprintf(fod,'\n');
                    %                     fclose(fod);
                    
                    %                     saveas(fig, fig_name ,'bmp');
                    %                      print('-dpsc2', '-noui', '-adobecset', '-painters', filename_ai);
                    saveImage(fig,fig_name,fig_pos);
                    close all;
                    
                end % strcmp(session, Session.target) && ~strcmp(region, Region.target)
                
            end % strcmp(summary(Target_run).Quality_ok, '1')  && strcmp(summary(Target_run).fr_constraint_3epoch,'1') &&...
            
        end % Target_run=1: summary_size
    end % strcmp(summary(Ref_run).Quality_ok, '1')  && strcmp(summary(Ref_run).fr_constraint_3epoch,'1') &&...
    
    
end % Ref_run= 1:nb_ref
end



