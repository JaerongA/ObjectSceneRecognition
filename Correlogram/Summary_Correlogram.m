%% Created by Jaerong 2017/01/09
%% The program generates cross-correlogram among HIPP & PER & POR

function Summary_Correlogram(summary, summary_header, dataROOT)



%% Output folder
saveROOT= [dataROOT '\Analysis\Correlogram\' date ];
if ~exist(saveROOT), mkdir(saveROOT); end
cd(saveROOT);



%% parameter setting


BarWidth= 3;

fig_pos=[200 150 1600 800]; %lab computer
%         fig_pos=[30 30 1200 1000]; % home computer
CAT_color = [0    0.4470    0.7410; 0.8500    0.3250    0.0980];



%% Time bin setting

% bin_size_sec= 0.001;
bin_size_sec= 0.001;
Xmin_sec= -0.2;
Xmax_sec= 0.2;

p_conf= 0.025;
bootstrap_nb =100;




outputfile= ['Correlogram_' date '.csv'];
fod = fopen(outputfile,'w');

txt_header = 'RatID, Session, Task, Ref_Cluster,  Target_Cluster, Region, PeakLoc, MonosypaticOK, LeadingRegion, BiasIND\n';
fprintf(fod, txt_header);
fclose(fod);






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


for Ref_run= 1:nb_ref
    
    
    
%     if  (strcmp(summary(Ref_run).Region,'PER') || strcmp(summary(Ref_run).Region,'POR')) &&  (str2num(summary(Ref_run).Epoch_FR) >= 0.5)  && (str2num(summary(Ref_run).Repetition_ok)) && (strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)') || strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)'))
    if  (strcmp(summary(Ref_run).Region,'PER') || strcmp(summary(Ref_run).Region,'POR')) &&  (str2num(summary(Ref_run).Epoch_FR) >= 0.5)  && (str2num(summary(Ref_run).Repetition_ok)) && (strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)') || strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)'))
        %     if  str2num(summary(Ref_run).Epoch_FR) >= 0.5  && str2num(summary(Ref_run).Repetition_ok) && ( strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)'))
        
        
        
        %% Set cluster prefix
        
        ref_cluster_prefix;
        
        %% Loading the reference cluster
        
        cd(TT_folder.ref);
        ts_spk.ref= Nlx2MatSpike(ClusterID.ref, [1 0 0 0 0], 0, 1, 0);
        
        
        %% Select another cluster from the same session
        
        nb_target =size(summary,2);
        
        
        
        for Target_run= Ref_run: nb_target
            
            
            %             if str2num(summary(Target_run).Epoch_FR) >= 0.5  && strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
            
            
            if  (str2num(summary(Target_run).Epoch_FR) >= 0.5) && (str2num(summary(Target_run).Repetition_ok)) &&  (strcmp(summary(Target_run).Task_name,'OCRS(FourOBJ)') || (strcmp(summary(Target_run).Task_name,'OCRS(SceneOBJ)')))
                
                
                target_cluster_prefix;
                
                
                
                if   (str2num(Key.ref)< str2num(Key.target)) && strcmp(RatID.ref, RatID.target) && strcmp(Session.ref, Session.target) && ~strcmp(Region.ref, Region.target)
                    
                    
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
                    
                    %                     [correlogram.ALL, X_range]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt);
                    
                    
                    [correlogram.ALL, correlogram.Jitter, X_range, peak_loc, trough_loc, upperLIM, lowerLIM, bias_ind]= ...
                        Draw_correlogram_jitter(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, bootstrap_nb, ts_evt);
                    
                    
                    if    strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)')
                        
                        [correlogram.Familiar]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.Familiar,:));
                        [correlogram.Novel]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.Novel,:));
                        
                    elseif    strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
                        
                        [correlogram.Scene]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.Scene,:));
                        [correlogram.OBJ]= Draw_correlogram(ts_spk.ref, ts_spk.target, bin_size_sec, Xmin_sec, Xmax_sec, p_conf, ts_evt(select.OBJ,:) );
                        
                    end
                    
                    
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
                    
                    
                    
                    %                     %% ms conversion
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
                    text(.7,1,sprintf('FR = %s (Hz)',summary(Ref_run).Epoch_FR),'Units','normalized');
                    
                    
                    subplot('position',[0.30 0.55 0.2 0.35]);
                    bar(X_range,autocorrelogram.target,BarWidth,'k'); hold on; box off;
                    set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); title(sprintf('Target (%s)',Region.target)); xlabel('Time (ms)'); ylabel('Count');
                    set(gca,'TickLength',[ 0 0 ]);
                    text(.7,1,sprintf('FR = %s (Hz)',summary(Target_run).Epoch_FR),'Units','normalized');
                    
                    
                    
                    %% Crosscorrelogram between the reference & target cluster
                    
                    
                    
                    subplot('position',[0.55 0.55 0.2 0.35]);
                    bar(X_range,correlogram.ALL,BarWidth,'k');  hold on; box off; alpha(.7);
                    %                         line([Xmin_ms Xmax_ms],[conf_int(2) conf_int(2)]);
                    %                         line([Xmin_ms Xmax_ms],[conf_int(2) conf_int(2)]);
                    set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); title('CrossCorr'); xlabel('Time (ms)'); ylabel('Count');
                    %                     hline(conf_int(1),'b:');
                    %                     hline(conf_int(2),'b:');
                    vhandle = vline(0,'b:');
                    
                    text(.1,1.1,sprintf('%s leads <--',Region.target),'Units','normalized');
                    text(.6,1.1,sprintf('--> %s leads',Region.ref),'Units','normalized');
                    
                    
                    plot(X_range,correlogram.Jitter,'r'); hold on;
                    plot(X_range,upperLIM,'r:',X_range,lowerLIM,'r:');
                    
                    if ~isnan(peak_loc*1000)
                        vhandle = vline(peak_loc*1000,'m:'); set(vhandle,'linewidth',1.5);
                    end
                    
                    
                    if (peak_loc*1000 > 1) && (peak_loc*1000 <=6)  %% From
                        
                        Monosynaptic = 'yes';
                    else
                        Monosynaptic = 'no';
                    end
                    
                    
                    if bias_ind < 0
                        LeadingRegion =  Region.ref;
                    else
                        LeadingRegion =  Region.target;
                    end
                    
                    
                    
                    %%Crosscorrelogram between the reference & target cluster
                    subplot('position',[0.79 0.55 0.2 0.35]);
                    axis off;
                    text(0,1,sprintf('Peak Location = %1.2f (ms)',peak_loc*1000),'Units','normalized','fontsize',15);
                    text(0,.8,sprintf('Monosypatic = %s',Monosynaptic),'Units','normalized','fontsize',15);
                    text(0,.6,sprintf('BiasIndex = %1.3f ',abs(bias_ind)),'Units','normalized','fontsize',15);
                    text(0,.4,sprintf('%s leading',LeadingRegion),'Units','normalized','fontsize',15);
                    
                    
                    subplot('position',[0.05 0.1 0.2 0.35]);
                    
                    
                    if    strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)')
                        
                        hbar = bar(X_range,correlogram.Familiar,BarWidth); set(hbar,'FaceColor',CAT_color(1,:)); box off;
                        set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); xlabel('time (ms)'); ylabel('Count');
                        set(gca,'TickLength',[ 0 0 ]); title('CrossCorr(Familiar)');
                        
                    elseif    strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
                        
                        hbar = bar(X_range,correlogram.Scene,BarWidth); set(hbar,'FaceColor',CAT_color(1,:)); box off;
                        set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); title(sprintf('Reference (%s)',Region.ref));
                        set(gca,'TickLength',[ 0 0 ]); title('CrossCorr(Scene)');
                        
                    end
                    
                    
                    subplot('position',[0.30 0.1 0.2 0.35]);
                    
                    
                    if    strcmp(summary(Ref_run).Task_name,'OCRS(FourOBJ)')
                        
                        hbar = bar(X_range,correlogram.Novel,BarWidth); set(hbar,'FaceColor',CAT_color(2,:)); box off;
                        set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); xlabel('time (ms)'); ylabel('Count');
                        set(gca,'TickLength',[ 0 0 ]); title('CrossCorr(Novel)');
                        
                    elseif    strcmp(summary(Ref_run).Task_name,'OCRS(SceneOBJ)')
                        
                        hbar = bar(X_range,correlogram.OBJ,BarWidth); set(hbar,'FaceColor',CAT_color(2,:)); box off;
                        set(gca,'xlim',[Xmin_ms - bin_size_ms Xmax_ms + bin_size_ms]); xlabel('time (ms)'); ylabel('Count');
                        set(gca,'TickLength',[ 0 0 ]); title('CrossCorr(OBJ)');
                        
                    end
                    
                    
                    session_saveROOT=[saveROOT '\' Task.ref ];
                    if ~exist(session_saveROOT), mkdir(session_saveROOT), end
                    cd(session_saveROOT)
                    
                    fig_name=[Prefix.ref '& ' Prefix.target '.png'];
                    saveImage(fig,fig_name,fig_pos);
                    
                    %                     fig_name_ai=[Prefix.ref '& ' Prefix.target '.eps'];
                    %                     print( gcf, '-painters', '-r300', fig_name_ai, '-depsc');
                    
                    
                    % txt_header = 'RatID, Session, Task, Ref_Cluster,  Target_Cluster, Region, PeakLoc, MonosypaticOK, LeadingRegion, BiasIND\n';
                    
                    %% Write to the output file
                    
                    cd(saveROOT);
                    
                    fod = fopen(outputfile,'a');
                    fprintf(fod,'%s ,%s ,%s ,%s ,%s , %s-%s,', RatID.ref, Task_session.ref, Task.ref, ClusterID.ref, ClusterID.target, Region.ref , Region.target);
                    fprintf(fod,'%1.2f ,%s ,%s ,%1.2f',...
                        peak_loc*1000, Monosynaptic, LeadingRegion, abs(bias_ind));
                    fprintf(fod,'\n');
                    fclose('all');
                    
                    
                    
                end % strcmp(session, Session.target) && ~strcmp(region, Region.target)
                
            end % strcmp(summary(Target_run).Quality_ok, '1')  && strcmp(summary(Target_run).fr_constraint_3epoch,'1') &&...
            
        end % Target_run=1: summary_size
    end % strcmp(summary(Ref_run).Quality_ok, '1')  && strcmp(summary(Ref_run).fr_constraint_3epoch,'1') &&...
    
    
end % Ref_run= 1:nb_ref
end



