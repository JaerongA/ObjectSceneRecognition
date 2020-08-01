%% Created by Jaerong 2014/10/07
%% The program generates autocorrelogram

function [summary,summary_header]=get_auto_correlogram(summary, summary_header, dataROOT)


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

saveROOT= [dataROOT '\Analysis\auto_correlogram'];
if ~exist(saveROOT), mkdir(saveROOT), end
cd(saveROOT);


outputfile= ['auto_correlogram.txt'];
fod = fopen(outputfile,'w');
fprintf(fod,'Rat \tsession \ttask \tref_TT \tref_cluster \tref_region \tref_layer');
fprintf(fod,'\n');
fclose(fod);



%% Event definition

start_box= 1; obj_onset=2; obj_touch=3; disc_touch=4; foodtray=5;


%% Select reference cluster

[r_s,c_s]=size(summary);


for i_s= 258
    %     1:c_s
    
    
    
    if   strcmp(summary(i_s).new_epoch_specificity,'1') &&  strcmp(summary(i_s).task_name,'ambiguity')  && strcmp(summary(i_s).Region2,'PER') && strcmp(summary(i_s).Quality_ok, '1') ...
            && strcmp(summary(i_s).fr_constraint_3epoch,'1')%                     && str2num(summary(i_s).MeanFR) <10;
        
        
        %% cluster prefix setting
        
        set_cluster_prefix  %% Function for setting the prefix 2013/07/23
        
        rat= summary(i_s).rat;
        rat_folder=[dataROOT '\' rat];
        session_folder=[rat_folder '\' rat '-' session '_' task];
        
        
        %% Loading the reference cluster
        
        TT_folder=[session_folder '\' TT];
        cd(TT_folder);
        ref_cl_name=[TT '_cluster.' cluster_nb];
        cluster= dlmread(ref_cl_name,',', 13,0);  ref_ts_spk=cluster(:,18); cluster=[];
        
        
        
        disp(['reference_cluster... ' prefix]);
        
        
        
        %% Loading trial ts info from ParsedEvents.mat
        
        cd([session_folder '\Behavior']);
        load('ParsedEvents.mat');
        
        
        
        %         % ts_event column header
        %         % 1. trial# 2. object 3. correctness 4.side 5. obj_touch 6. disc_touch 7. sensor1_1, 8. sensor2_1, 9. sensor3_1, 10. sensor4_1, 11. sensor1_end
        %         %
        %         % 12. sensor2_end, 13. sensor3_end, 14. sensor4_end 15.void
        %
        %         ts_evt= void_trial_elimination(ts_evt);
        %
        %
        %
        %         ts_evt_new=[ts_evt(:,10) ts_evt(:,8) ts_evt(:,5) ts_evt(:,6) ts_evt(:,7)];  % Make a new matrix of timestamps with key events of our interest.
        %         %                  start_box= 1; obj_onset=2; obj_touch=3; disc_touch=4; foodtray=5;
        
        
        
        [autocorrelogram,X_range,auto_conf_int, nb_ref_spk, nb_excluded_spk]= Draw_CrossCorrelogram(ref_ts_spk,ref_ts_spk,bin_size_sec,Xmin_sec, Xmax_sec,p_conf, []);
        
        
        %% eliminate the last bin
        autocorrelogram(end)=[];
        X_range(end)=[];
        
        
        [m max_ind]= max(autocorrelogram);
        autocorrelogram(max_ind)=0;
        
        %% GLOBAL PETH
        fig_pos=[150 350 1100 500]; %lab computer
        %         fig_pos=[30 30 1200 1000]; % home computer
        fig_h=figure('Color',[1 1 1],'Position',fig_pos);
        
        
        %% ms conversion
        X_range= X_range.*10^3;  %% ms conversion
        Xmin_sec= Xmin_sec.*10^3;  %% ms conversion
        Xmax_sec= Xmax_sec.*10^3;  %% ms conversion
        bin_lim_width= bin_lim_width.*10^3;  %% ms conversion
        
        
        
        
        %% autocorrelogram for the reference cluster
        
        subplot(1,2,1)
        % %                     normalized_crosscorr=normalized_crosscorr-1;
        %                     negative= find(normalized_crosscorr<0);
        %                     normalized_crosscorr(negative)=0;
        bar(X_range,autocorrelogram,'k'); hold on;
%         hline(auto_conf_int(1),'b:');  %mark the 95% confidence interval
%         hline(auto_conf_int(2),'b:');
        set(gca,'xlim',[Xmin_sec-bin_lim_width Xmax_sec+bin_lim_width]); xlabel('reference autocorr'); ylabel('count');
        prefix= strrep(prefix,'_','-');
        title(prefix);
        
        
        
        %
        %         subplot(1,2,2)
        %         bar(X_range,prob_crosscorr,'k')
        %         set(gca,'xlim',[Xmin_sec-bin_lim_width Xmax_sec+bin_lim_width]); xlabel('time (ms)'); ylabel('probability');
        %         %                     title('normalized');
        %
        %         fig_name=[prefix '& ' target_prefix '.bmp'];
        %         %                     filename_ai=[prefix '& ' target_prefix '.eps'];
        
        cd(saveROOT);
        
        fod = fopen(outputfile,'a');
        
        %         fprintf(fod,'Rat \tsession \ttask \tref_TT \tref_region \tref_layer');
        fprintf(fod,'%s \t%s \t%s \t%s \t%s \t%s',...
            rat, session, task, TT, cluster_nb, region, layer);
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
        
        
    end % strcmp(summary(summary_run).Quality_ok, '1')  && strcmp(summary(summary_run).fr_constraint_3epoch,'1') &&...
    
    
    
end % i_s= 1:c_s
end










