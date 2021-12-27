function  [summary,summary_header]=  get_cluster_plane(summary, summary_header, dataROOT)

    %% Created by Jaerong 2016/02/26
    saveROOT=[dataROOT '\Analysis\Unit_profiler'];
    if ~exist(saveROOT), mkdir(saveROOT), end
    cd(saveROOT);

    %% Parameter
    r_plot = 3; c_plot = 2;
    fig_pos = [600,150,800,700];
    plane_ind = 0;
    cluster_color= [255 164 138; 27 191 255; 255 167 10; 92 255 144; 255 146 239; 255 103 104];

    [r_s,c_s]=size(summary);

    for i_s= 1:c_s
        %% Set cluster prefix
        set_cluster_prefix;

        %% Loading clusters
        load_clusters;

        if ~exist(TTID)
            findunderscore = findstr(TTID, '_');
            TTID = [TTID(1:findunderscore(1)-1) '.ntt'];
        end

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

        %% Figure
        f1=figure('name',[  prefix '_' date],'Color',[1 1 1],'Position',fig_pos);

        %% Print out cell ID
        subplot('Position', [0.15 0.99 0.4 0.2]);
        text(0,0,prefix,'fontsize',15);
        axis off;

        %% Draw cluster plane
        TTAP = Nlx2MatSpike(TTID, [0 0 0 0 1], 0, 1, 0);
        nb_spk= size(TTAP,3);
        spk_ind= [1:nb_spk];
        spk_ind= randsample(spk_ind, round(nb_spk*0.6));
        spk_ind=  sort(spk_ind);
        TTAP = TTAP(:,:,spk_ind);  %% Plot only 60% of the original spike (downsampling)
        TTAP = TTAP.* (ADBitVolts *10^6);
        clear spk_ind  nb_spk

        plane_ind = 0;
        color_ind= 0;

        for Xplane =1:3
            for Yplane= Xplane:4
                if Xplane == Yplane
                    continue;
                else
                    plane_ind= plane_ind+1;
                    color_ind= color_ind +1;
                    if Xplane >6
                        continue;
                    else
    %                     if plane_ind == 12
    %                         plane_ind = plane_ind + 1;
    %                     end
    %                     subplot('position',[0.1 0.65 0.23 0.23]);
                        subplot(r_plot,c_plot,plane_ind);
                        scatter(max(TTAP(1:32,Xplane,:)),max(TTAP(1:32,Yplane,:)),1 ,[0.75 0.75 0.75],'filled'); hold on;
                        scatter(max(ClusterAP(1:32,Xplane,:)),max(ClusterAP(1:32,Yplane,:)),1 ,cluster_color(color_ind,:)./255,'filled');
                        xlabel(['Peak ' sprintf('%d',Xplane -1) '(\muV)']); ylabel(['Peak ' sprintf('%d',Yplane -1) '(\muV)'])
                        xaxis = get(gca,'xlim'); yaxis = get(gca,'ylim');
                        max_axis = max(max(xaxis, yaxis));
                        xlim([0 max_axis]);  ylim([0 max_axis]);
                        set(gca,'xtick',[0 max_axis])
                        set(gca,'ytick',[0 max_axis])
                        axis square;
                    end
                end
            end
        end

        clear TT* ClusterAP

        %% Save figure and mat file.
        cd(saveROOT);
        filename=[prefix '_cluster.png'];
        saveImage(f1,filename,fig_pos);
        close all;
    end
end