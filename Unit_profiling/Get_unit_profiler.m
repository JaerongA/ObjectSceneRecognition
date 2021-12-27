function  [summary,summary_header]=  get_unit_profiler(summary, summary_header, dataROOT)

    %% Created by Jaerong 2016/02/26
    %% This version prints out aligned version of the waveform and the autocorrelogram of the cell
    %% Output folder
    saveROOT=[dataROOT '\Analysis\Unit_profiler(FourOBJ)\' date];
    if ~exist(saveROOT), mkdir(saveROOT), end
    cd(saveROOT);

    %% Parameter
    txt_fontsize= 11;
    bin_size_sec= 0.001;
    bin_lim_width= bin_size_sec*10;
    Xmin_sec= -0.5;
    Xmax_sec= 0.5;
    p_conf= 0.025;
    Cluster_color= [255 164 138; 27 191 255; 255 167 10; 92 255 144; 255 146 239; 255 103 104];
    isiWINDOW = 7; isiSCALE = 100; histEDGE = -1:1 / isiSCALE:isiWINDOW;  %% ISI plot
    samplig_rate= (1/32)*1000;  %% Sampling rate (ms)

    %% Criteria for int vs pyr categorization
    criteria.FR = 10;
    criteria.Width = 250;

    %% Output file generation
    outputfile='Unit_profiler(FourOBJ).csv';
    fod=fopen(outputfile,'w');

    % txt_header = 'Key#, RatID, Session, Task_session, Task, Region, Subregion, Layer, Bregma, ClusterID, Spike_Width(ms), Spike_Height(uv), MeanFR(hz), Mode_latency(ms), Cell_CAT, IsolationDistance, L-ratio, withinREFRACPortion, LogISIPEAKTIME(ms)\n';
    txt_header = 'Key#, RatID, Session, Task_session, Task, Region, Subregion, Layer, Bregma, ClusterID, Spike_Width(us), Spike_Height(uv), MeanFR(hz), Mode_latency(ms), Cell_CAT, Cell_type, withinREFRACPortion, LogISIPEAKTIME(ms)\n';
    fprintf(fod, txt_header);
    fclose(fod);

    [r_s ,c_s]=size(summary);

    for i_s = 1:c_s
        if       strcmp(summary(i_s).Rat,'r558')

            %% Set cluster Prefix
            set_cluster_prefix;
            tic;

            %% Loading trial ts info from ParsedEvents.mat
            load_ts_evt;

            %% Loading clusters
            load_clusters;

            %% Make a new matrix of timestamps with key events of our interest.
            ts_evt_new=[ts_evt(:,StimulusOnset) ts_evt(:,Choice) ];

            %% Get epoch firing rates  & significance test
            get_FR_significance;
            clear ts_evt_new  ts_spk

            if ~exist(TTID)
                findunderscore = findstr(TTID, '_');
                TTID = [TTID(1:findunderscore(1)-1) '.ntt'];
            end

            TTTS = Nlx2MatSpike(TTID, [1 0 0 0 0], 0, 1, 0);

            [ClusterTS, ClusterAP, ClusterHeader] = Nlx2MatSpike(ClusterID, [1 0 0 0 1], 1, 1, 0);

            for ADBit_ind=  10: 20
                findspace = findstr(ClusterHeader{ADBit_ind},' ');
                if numel(findspace)

                    if ~strcmp(cellstr(ClusterHeader{ADBit_ind}(2:findspace(1))),'ADBitVolts')
                        ADBit_ind = ADBit_ind +1;
                    else
                        ADBitVolts= str2double(ClusterHeader{ADBit_ind}(findspace(1)+1:findspace(2)));
                    end
                end
            end
            %     TTAP = TTAP.* (ADBitVolts *10^6);
            ClusterAP = ClusterAP.* (ADBitVolts *10^6);

            %% GET the cluster spike index
            ClusterIndex = [];
            for spike_run = 1:size(ClusterTS, 2)
                ClusterIndex(spike_run) = min(find(ClusterTS(spike_run) == TTTS));
            end

            clear TTTS

    %         %% Isolation distance & L-Ratio
    %         ChannelValidity = logical(sum(sum(ClusterAP(:,:,1:20)),3));
    %         channel_nb=sum(ChannelValidity);
    %
    %         clear FeatureData;
    %
    %         Write_fd_file(TT_folder, TTID, {'Energy', 'WavePC1'}, ChannelValidity, 10000, 0, 0);
    %         load([TTID(1:end-4) '_Energy.fd'], '-mat');
    %         [fszROW fszCOL] = size(FeatureData);
    %         inputFEATUREDATA = zeros(fszROW, channel_nb*2);
    %         inputFEATUREDATA(:, 1:channel_nb) = FeatureData(:, 1:channel_nb);
    %         clear FeatureData fszROW;
    %         load([TTID(1:end-4) '_WavePC1.fd'], '-mat');
    %         inputFEATUREDATA(:, channel_nb+1:channel_nb*2) = FeatureData(:, 1:channel_nb);
    %         delete *.fd;
    %
    %         ISODIST = IsolationDistance(inputFEATUREDATA, ClusterIndex);
    %         [L LRATIO] = L_Ratio(inputFEATUREDATA, ClusterIndex);
    %
    %         clear Feature* inputFEATUREDATA

            %% Autocorrelogram figure
            r_plot=2;c_plot=4;
            fig_pos=[70,250,1250,550];
            fig=figure('name',[  Prefix '_' date],'Color',[1 1 1],'Position',fig_pos);

            %% Print out cell ID
            subplot('Position', [0.3 0.98 0.4 0.2]);
            text(0,0,Prefix,'fontsize',12);
            axis off;

            %% Spike alignment
            this_wave=[]; thisWidth=[];
            raw_wave_mat = [];
            aligned_wave_mat = [];

            for TT_run = 1:4
                [TT_max_amp(TT_run) TT_max_ind(TT_run)]= max(mean(squeeze(ClusterAP(:,TT_run,:)),2));
                %            for wave_run= 1: 50
                for wave_run= 1: size(ClusterAP,3)
                    new_wave= nan(32,1);
                    this_wave= ClusterAP(:, TT_run, wave_run);
                    [max_amp max_ind] = max(this_wave);

                    if max_ind ~= TT_max_ind(TT_run)
                        max_diff= max_ind- TT_max_ind(TT_run);
                        if max_diff > 0
                            new_wave(1:end-max_diff)= this_wave(1+max_diff:end);
                            this_wave= new_wave;
                        else
                            new_wave(1-max_diff:end)= this_wave(1: end +max_diff);
                            this_wave= new_wave;
                        end
                    end
                    aligned_wave_mat(:,wave_run)= this_wave;
                end

                thisMEANAP(:,TT_run) = nanmean(aligned_wave_mat,2);
                thisMEANMAXLOC = min(find(thisMEANAP(:,TT_run) == max(thisMEANAP(:,TT_run)))); thisMEANMINLOC = max(find(thisMEANAP(:,TT_run) == min(thisMEANAP(:,TT_run))));

                if thisMEANMINLOC > thisMEANMAXLOC
                thisPEAKTOVALLEY = thisMEANMINLOC - thisMEANMAXLOC + 1;
                else
                thisPEAKTOVALLEY = thisMEANMAXLOC - thisMEANMINLOC + 1;
                end

                thisWidth(TT_run)= thisPEAKTOVALLEY * samplig_rate;
                thisHeight(TT_run)=  abs(max(thisMEANAP(:,TT_run)) - min(thisMEANAP(:,TT_run)));
            end %  TT_run = 1:4

            Max_amp = max(thisMEANAP(:));
            Min_amp = min(thisMEANAP(:));

            for TT_run = 1:4
                subplot(r_plot,c_plot,TT_run);
                plot([0:size(aligned_wave_mat,1)-1].*32,thisMEANAP(:,TT_run), 'k', 'linewidth',2); hold on; box off;
                title(sprintf('CH %d',TT_run-1)); xlabel('time(ms)'); ylabel('amplitude(\muV)');
                ylim([(round((Min_amp)/10)-5)*10   ceil((Max_amp/10)+5)*10])
                box off;
                hold on;
            end  % TT_run = 1:4

            max_amp=[];
            max_ind=[];
            aligned_wave_mat=[];

            %% Draw the autocorrelogram (All spikes including those fired during non-event periods)
            [autocorrelogram,X_range,auto_conf_int]= Draw_correlogram(ClusterTS,ClusterTS,bin_size_sec,Xmin_sec, Xmax_sec,p_conf, []);

            %% Eliminate the last bin
            autocorrelogram(end)=[];
            X_range(end)=[];
            [m max_ind]= max(autocorrelogram);
            autocorrelogram(max_ind)=0;

            %% Bursting neuron identification based on the autocorrelogram
            cell_cat= 'unclassified';
            bursting_criteria= max(autocorrelogram([(max_ind- 50): (max_ind+ 50)]))/2;
            regular_criteria= 35;
            bin_value=[];
            bin_value= [autocorrelogram([(max_ind- 5): (max_ind-3)]) autocorrelogram([(max_ind+3): (max_ind+5)])] ;

            peak_max= max(bin_value);

            if peak_max > bursting_criteria
                cell_cat= 'bursting';
            end

            autocorr_hist_mode = find(autocorrelogram == max(autocorrelogram));
            mode_latency= min(abs(autocorr_hist_mode - max_ind));

            if mode_latency > regular_criteria
                cell_cat= 'regular';
            end

            %% Spike height & spike width
            [Spk.Height max_height_ind] = max(thisHeight);
            Spk.Width = thisWidth(max_height_ind);

            %% Cell type determination based on the mean firing rate & spike width (2018/05/28)
            if (mean_fr.all > criteria.FR) || (Spk.Width  < criteria.Width)
                cell_type = 'Int';
            else
                cell_type = 'Pyr';
            end

            %% ms conversion
            X_range= X_range.*10^3;  %% ms conversion
            Xmin_sec= Xmin_sec.*10^3;  %% ms conversion
            Xmax_sec= Xmax_sec.*10^3;  %% ms conversion
            bin_lim_width= bin_lim_width.*10^3;  %% ms conversion

            subplot(r_plot,c_plot,5)
            bar(X_range,autocorrelogram,'k'); hold on; box off;
            %     hline(auto_conf_int(1),'b:');  %mark the 95% confidence interval
            %     hline(auto_conf_int(2),'b:');
            set(gca,'xlim',[Xmin_sec-bin_lim_width Xmax_sec+bin_lim_width]);
            yaxis = get(gca,'ylim'); set(gca,'ytick',[0 yaxis(2)])
            xlabel('time(ms)'); ylabel('count');
            set(gca,'xtick',[-500 0 500])

            subplot(r_plot,c_plot,6)
            axis off

            msg= sprintf('Spk height Peak2Valley = %1.2f ', Spk.Height);  %% Aligned waveform with the highest amplitude
            text(-.2,0,[msg '(\muV)'], 'Fontsize',txt_fontsize);

            msg= sprintf('Spk width Peak2Valley = %1.2f  ', Spk.Width);  %% Aligned waveform with the highest amplitude
            text(-.2,0.2,[msg '(\muS)'], 'Fontsize',txt_fontsize);

            msg= sprintf('mean FR (Epoch) = %1.2f (hz)', mean_fr.all);  %% Mean FR from the event period
            text(-.2,0.4,msg,'Fontsize',txt_fontsize);

            msg= sprintf('mode latency = %1.2f (ms)', mode_latency);  %% Onmaze spike only
            text(-.2,0.6,msg,'Fontsize',txt_fontsize);

            msg= sprintf('cell cat = %s', cell_cat);
            text(-.2,0.8,msg,'Fontsize',txt_fontsize);

            msg= sprintf('cell type = %s', cell_type);   %% added 2018/05/28
            text(-.2,1.0,msg,'Fontsize',txt_fontsize);

            %% Inter-spike interval (ISI) plot
            isiHIST = histc(log10(diff(ClusterTS)), histEDGE);
            withinREFRACPortion = (sum(diff(ClusterTS) < (1*10^3)) / length(ClusterTS)) * 100;
            LogISIPEAKTIME = (10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000;
            clear ClusterTS  ClusterIndex

            subplot(r_plot,c_plot,7);
            hold on;
            bar(isiHIST,'k');
            vline(400,'r');
            LogISIPEAKTIME = (10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000;
            text(min(find(isiHIST == min(max(isiHIST)))), min(max(isiHIST)), sprintf('%1.2f ms', LogISIPEAKTIME));
            text(400,max(isiHIST),'1ms');
            hold off;
            title(['log ISI']); xlabel(['time (ms)']); ylabel(['count']);
            axis tight;
            set(gca, 'FontSize', 8, 'XLim', [350 size(histEDGE, 2)], 'XTick', 350:((size(histEDGE, 2) - 350) / 2):size(histEDGE, 2), 'XTickLabel', {['.31'], ['55'], ['10000']});

            clear isiHIST

            subplot(r_plot,c_plot,8)
            axis off
            msg= sprintf('Within ref spk proportion = %0.2f% % ', withinREFRACPortion);
            text(0,0,msg, 'Fontsize',txt_fontsize);
            msg= sprintf('ISI peak time = %1.2f (ms)', LogISIPEAKTIME);  %% Aligned waveform with the highest amplitude
            text(0,0.2,msg, 'Fontsize',txt_fontsize);

    %         %% Print out ID and L-ratio
    %         msg= sprintf('Isolation Distance = %1.2f ', ISODIST);  %% Aligned waveform with the highest amplitude
    %         text(0,0.4,msg, 'Fontsize',txt_fontsize);
    %         msg= sprintf('L - ratio = %1.2f ', LRATIO);  %% Aligned waveform with the highest amplitude
    %         text(0,0.6,msg, 'Fontsize',txt_fontsize);
    %         summary(i_s).Isolation_Distance= sprintf('%1.2f',ISODIST);
    %         summary(i_s).Lratio= sprintf('%1.2f',LRATIO);

            %     %% Draw cluster plane
            %
            %     TTAP = Nlx2MatSpike(TTID, [0 0 0 0 1], 0, 1, 0);
            %     nb_spk= size(TTAP,3);
            %     spk_ind= [1:nb_spk];
            %     spk_ind= randsample(spk_ind, round(nb_spk*0.6));
            %     spk_ind=  sort(spk_ind);
            %     TTAP = TTAP(:,:,spk_ind);  %% Plot only 60% of the original spike (downsampling)
            %     TTAP = TTAP.* (ADBitVolts *10^6);
            %     clear spk_ind  nb_spk
            %
            %     plane_ind = 8;
            %     color_ind= 0;
            %
            %     for Xplane =1:3
            %         for Yplane= Xplane:4
            %             if Xplane == Yplane
            %                 continue;
            %             else
            %
            %                 plane_ind= plane_ind+1;
            %                 color_ind= color_ind +1;
            %
            %                 if Xplane >6
            %                     continue;
            %                 else
            %                     if plane_ind == 12
            %                         plane_ind = plane_ind + 1;
            %                     end
            %                     subplot(r_plot,c_plot,plane_ind);
            %                     scatter(max(TTAP(1:32,Xplane,:)),max(TTAP(1:32,Yplane,:)),1 ,[0.75 0.75 0.75],'filled'); hold on;
            %                     scatter(max(ClusterAP(1:32,Xplane,:)),max(ClusterAP(1:32,Yplane,:)),1 ,Cluster_color(color_ind,:)./255,'filled');
            %                     xlabel(['Peak ' sprintf('%d',Xplane -1) '(\muV)']); ylabel(['Peak ' sprintf('%d',Yplane -1) '(\muV)'])
            %                     xaxis = get(gca,'xlim'); yaxis = get(gca,'ylim');
            %                     xlim([0 xaxis(2)]);  ylim([0 yaxis(2)]);
            %                     set(gca,'xtick',[0 xaxis(2)])
            %                     set(gca,'ytick',[0 yaxis(2)])
            %                 end
            %             end
            %         end
            %     end
            %     clear TT* ClusterAP

            summary(i_s).Cell_Category= sprintf('%s',cell_cat);
            summary(i_s).WithinRefPortion= sprintf('%0.2f',withinREFRACPortion);
            summary(i_s).Spike_Width= sprintf('%1.3f',Spk.Width);
            summary(i_s).Spike_Height= sprintf('%1.3f', Spk.Height);
            summary(i_s).Cell_type= sprintf('%s', cell_type);

            %% Output file generation
            cd(saveROOT);
            fod= fopen(outputfile,'a');
            fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Region, Subregion, Layer, Bregma, ClusterID);
            fprintf(fod,',%1.3f, %1.3f, %1.3f, %1.3f, %s, %s',Spk.Width, Spk.Height, mean_fr.all, mode_latency, cell_cat, cell_type);
    %         fprintf(fod,',%1.3f, %1.3f',ISODIST, LRATIO);
            fprintf(fod,',%0.3f, %1.3f',withinREFRACPortion, LogISIPEAKTIME);
            fprintf(fod,'\n');
            fclose('all');

            % Save figures
            filename_ai=[Prefix '.eps'];
            print( gcf, '-painters', '-r300', filename_ai, '-depsc');
            filename=[Prefix '.png'];
            saveImage(fig,filename,fig_pos);
            close all;

            %% Reset the timebin
            bin_size_sec= 0.001;
            bin_lim_width= bin_size_sec*10;
            Xmin_sec= -0.5;
            Xmax_sec= 0.5;

            clear aligned_wave_mat cluster

        end

    end

end

