%% Created by Jaerong 2013/07/23
%% The program generates cross-correlogram between PER and TE cells

function [summary,summary_header]=get_cross_correlogram(summary, summary_header, dataROOT)


%% parameter setting

cd(dataROOT);


%% time bin setting

bin_size_sec= 0.001;
bin_lim_width= bin_size_sec*10;
Xmin_sec= -0.1;
Xmax_sec= 0.1;
p_conf= 0.025;
draw_hist= 1;  %% 1 to generate the plot, if not 0.


%% save setting

saveROOT= [dataROOT '\Analysis\Cross_correlation\Cross_correlation_epoch'];
if ~exist(saveROOT), mkdir(saveROOT), end
cd(saveROOT);


outputfile= ['cross_correlation_OSP+MGCP.txt'];
fod = fopen(outputfile,'w');
fprintf(fod,'Rat \tsession \ttask \tref_TT \tref_cluster \tref_region \tref_layer \ttarget_TT \ttarget_cluster \ttarget_region \ttarget_layer \tpeak_location \tpeak_count \tupper_ci \tbias_index');
fprintf(fod,'\n');
fclose(fod);



%% Event definition

start_box= 1; obj_onset=2; obj_touch=3; disc_touch=4; foodtray=5;


%% Select reference cluster

[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    
    if strcmp(summary(i_s).Quality_ok, '1')  && strcmp(summary(i_s).fr_constraint_3epoch,'1') &&...
            strcmp(summary(i_s).Region3,'A36')   && (strcmp(summary(i_s).task_name,'retrieval') || (strcmp(summary(i_s).task_name,'ambiguity')))  ...
            && str2num(summary(i_s).MeanFR) <10;
        
        
        %% cluster prefix setting
        
        set_cluster_prefix  %% Function for setting the prefix 2013/07/23
        
        rat= summary(i_s).rat;
        rat_folder=[dataROOT '\' rat];
        session_folder=[rat_folder '\' rat '-' session '_' task];
        
        ref_prefix= prefix;
        
        %% Loading the reference cluster
        
        TT_folder=[session_folder '\' TT];
        cd(TT_folder);
        ref_cl_name=[TT '_cluster.' cluster_nb];
        cluster= dlmread(ref_cl_name,',', 13,0);  ref_ts_spk=cluster(:,18); cluster=[];
        
        
        %% Select another cluster from the same session
        
        [summary_r,summary_c]=size(summary);
        
        for summary_run=1: summary_c
            
            
            if strcmp(summary(summary_run).Quality_ok, '1')  && strcmp(summary(summary_run).fr_constraint_3epoch,'1') &&...
                    strcmp(summary(summary_run).Region2,'TE') && str2num(summary(summary_run).MeanFR) <10;
                
                key2= summary(summary_run).key;
                rat2= summary(summary_run).rat;
                session2= summary(summary_run).rec_session;
                region2= summary(summary_run).Region2;
%                 PER_sub_region2= summary(summary_run).Region3;
                TT2= summary(summary_run).TT;
                cluster_nb2= summary(summary_run).cluster;
                layer2= summary(summary_run).layer;
                
                if  strcmp(rat, rat2) && strcmp(session, session2) && ~strcmp(region, region2)
                    
                    
                    %% Loading the target cluster
                    
                    TT_folder2=[session_folder '\' TT2];
                    cd(TT_folder2);
                    cl_name=[TT2 '_cluster.' cluster_nb2];
                    cluster= dlmread(cl_name,',', 13,0);  ts_spk=cluster(:,18); cluster=[];
                    
                    target_prefix= [key2 '-' cl_name '-' region2 '-' layer2 ];
                    
                    disp(['reference_cluster... ' ref_prefix]);
                    disp(['target cluster... : ' target_prefix ]);
                    
                    
                    
                    %% Loading trial ts info from ParsedEvents.mat
                    
                    cd([session_folder '\Behavior']);
                    load('ParsedEvents.mat');
                    
                    
                    
                    % ts_event column header
                    % 1. trial# 2. object 3. correctness 4.side 5. obj_touch 6. disc_touch 7. sensor1_1, 8. sensor2_1, 9. sensor3_1, 10. sensor4_1, 11. sensor1_end
                    %
                    % 12. sensor2_end, 13. sensor3_end, 14. sensor4_end 15.void
                    
                    ts_evt= void_trial_elimination(ts_evt);
                    
                    
                    
                    ts_evt_new=[ts_evt(:,10) ts_evt(:,8) ts_evt(:,5) ts_evt(:,6) ts_evt(:,7)];  % Make a new matrix of timestamps with key events of our interest.
                    %                  start_box= 1; obj_onset=2; obj_touch=3; disc_touch=4; foodtray=5;
                    
                    
                    
                    [crosscorrelogram,X_range,conf_int, nb_ref_spk, nb_excluded_spk]= Draw_CrossCorrelogram(ref_ts_spk,ts_spk,bin_size_sec,Xmin_sec, Xmax_sec,p_conf, ts_evt_new);
                    
                    %% eliminate the last bin
                    crosscorrelogram(end)=[];
                    X_range(end)=[];
                    

                    [autocorrelogram,X_range,auto_conf_int, nb_ref_spk, nb_excluded_spk]= Draw_CrossCorrelogram(ref_ts_spk,ref_ts_spk,bin_size_sec,Xmin_sec, Xmax_sec,p_conf, ts_evt_new);
                    
                    %% eliminate the last bin
                    autocorrelogram(end)=[];
                    X_range(end)=[];
                    
                    
                    
                    %% GLOBAL PETH
                    fig_pos=[150 350 1100 500]; %lab computer
                    %         fig_pos=[30 30 1200 1000]; % home computer
                    fig_h=figure('Color',[1 1 1],'Position',fig_pos);
                    
                    
                    %% ms conversion
                    X_range= X_range.*10^3;  %% ms conversion
                    Xmin_sec= Xmin_sec.*10^3;  %% ms conversion
                    Xmax_sec= Xmax_sec.*10^3;  %% ms conversion
                    bin_lim_width= bin_lim_width.*10^3;  %% ms conversion
                    
                    
                    subplot(1,3,1)
                    bar(X_range,crosscorrelogram,'k');  hold on;
                    %                         line([Xmin_sec Xmax_sec],[conf_int(2) conf_int(2)]);
                    %                         line([Xmin_sec Xmax_sec],[conf_int(2) conf_int(2)]);
                    set(gca,'xlim',[Xmin_sec-bin_lim_width Xmax_sec+bin_lim_width]); xlabel('time (ms)'); ylabel('count');
                    ref_prefix= strrep(ref_prefix,'_','-'); target_prefix= strrep(target_prefix,'_','-');
                    hline(conf_int(1),'b:');
                    hline(conf_int(2),'b:');
                    
                    
                    %% Calculate the peak count and peak location
                    peak_count=max(crosscorrelogram);
                    peak_nb= sum(crosscorrelogram==max(crosscorrelogram));
                    if peak_nb >=2
                        peak_loc=nan; peak_count=nan;
                    else
                        peak_loc= ((X_range(crosscorrelogram==peak_count) +(X_range(crosscorrelogram==peak_count)+ bin_size_sec)))/2;
                        if peak_count> conf_int(2)
                        vline(peak_loc,'r:')
                        end
                    end
                    
                    trough_count=min(crosscorrelogram);
                    trough_nb= sum(crosscorrelogram==min(crosscorrelogram));
                    if trough_nb >=2
                        trough_loc=nan;
                    else
                        trough_loc= ((X_range(crosscorrelogram==trough_count) +(X_range(crosscorrelogram==trough_count)+ bin_size_sec)))/2;;
                        %                         vline(trough_loc,'r')
                    end
                    hold off;
                    
                    %% calculate the bias index
                    
                    
                    left_crosscorr= crosscorrelogram(1:length(crosscorrelogram)/2);
                    right_crosscorr= crosscorrelogram((length(crosscorrelogram)/2)+1:end);
                    bias_ind= (sum(left_crosscorr)-sum(right_crosscorr))/ (sum(left_crosscorr)+sum(right_crosscorr));
                    
                    % if the bias_ind is negative, it means that TE cells
                    % were more likely to be preceded by PER cells.
                    
                    
%                     %% Get the chance level for normalization
%                     chance_freq= sum(crosscorrelogram)/(length(X_range)); %% the spike frequency if the spikes in the histograms were evenly assigned to the time bin.
%                     normalized_crosscorr= crosscorrelogram./chance_freq;
%                     %                     normalized_crosscorr= crosscorrelogram-chance_freq;
%                     
%                     subplot(1,3,2)
%                     % %                     normalized_crosscorr=normalized_crosscorr-1;
%                     %                     negative= find(normalized_crosscorr<0);
%                     %                     normalized_crosscorr(negative)=0;
%                     bar(X_range,normalized_crosscorr,'k')
%                     set(gca,'xlim',[Xmin_sec-bin_lim_width Xmax_sec+bin_lim_width]); xlabel('time (ms)'); ylabel('# of normalized spk');
%                     ref_prefix= strrep(ref_prefix,'_','-'); target_prefix= strrep(target_prefix,'_','-');
%                     title([ref_prefix ' vs. ' target_prefix]);
                    
                    
                    %% autocorrelogram for the reference cluster
                    
                    subplot(1,3,2)
                    % %                     normalized_crosscorr=normalized_crosscorr-1;
                    %                     negative= find(normalized_crosscorr<0);
                    %                     normalized_crosscorr(negative)=0;
                    bar(X_range,autocorrelogram,'k'); hold on;
                    hline(auto_conf_int(1),'b:');  %mark the 95% confidence interval
                    hline(auto_conf_int(2),'b:');
                    set(gca,'xlim',[Xmin_sec-bin_lim_width Xmax_sec+bin_lim_width]); xlabel('reference autocorr'); ylabel('count');
                    ref_prefix= strrep(ref_prefix,'_','-'); target_prefix= strrep(target_prefix,'_','-');
                    title([ref_prefix ' vs. ' target_prefix]);
                    
                    
                    %% Spike probability
                    
                    
                    prob_crosscorr= crosscorrelogram./nb_ref_spk;   %% divided by the reference spk (PER), inspired by Maurer et al. JN 2006
                    
                    
                    subplot(1,3,3)
                    bar(X_range,prob_crosscorr,'k')
                    set(gca,'xlim',[Xmin_sec-bin_lim_width Xmax_sec+bin_lim_width]); xlabel('time (ms)'); ylabel('probability');
                    %                     title('normalized');
                    
                    fig_name=[ref_prefix '& ' target_prefix '.bmp'];
                    %                     filename_ai=[ref_prefix '& ' target_prefix '.eps'];
                    
                    cd(saveROOT);
                    
                    fod = fopen(outputfile,'a');
                    %                     fprintf(fod,'Rat \tsession \ttask \tref_TT \tref_region \tref_layer \wtarget_TT \ttarget_region \ttarget_layer \tpeak_location \tbias_index');
                    fprintf(fod,'%s \t%s \t%s \t%s \t%s \t%s \t%s \t%s \t%s \t%s \t%s \t%1.4f \t%1.4f \t%1.4f \t%1.4f',...
                        rat, session, task, TT, cluster_nb, region, layer, TT2, cluster_nb2, region2, layer2, peak_loc, peak_count, conf_int(2), bias_ind);
                    fprintf(fod,'\n');
                    fclose(fod);
                    
                    %                     saveas(fig_h, fig_name ,'bmp');
                    %                      print('-dpsc2', '-noui', '-adobecset', '-painters', filename_ai);
                    saveImage(fig_h,fig_name,fig_pos);
                    
                    %% time bin setting
                    
                    bin_size_sec= 0.001;
                    bin_lim_width= bin_size_sec*10;
                    Xmin_sec= -0.1;
                    Xmax_sec= 0.1;
                    
                end % strcmp(session, session2) && ~strcmp(region, region2)
                
            end % strcmp(summary(summary_run).Quality_ok, '1')  && strcmp(summary(summary_run).fr_constraint_3epoch,'1') &&...
            
        end % summary_run=1: summary_c
    end % strcmp(summary(i_s).Quality_ok, '1')  && strcmp(summary(i_s).fr_constraint_3epoch,'1') &&...
    
    
end % i_s= 1:c_s
end










