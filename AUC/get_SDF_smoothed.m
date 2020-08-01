draw_mode= 0;

PETH.Stimulus1_Corr= Draw_PETH(ts_evt(select.Stimulus1_Corr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
PETH.Stimulus2_Corr= Draw_PETH(ts_evt(select.Stimulus2_Corr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
PETH.Stimulus3_Corr= Draw_PETH(ts_evt(select.Stimulus3_Corr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);
PETH.Stimulus4_Corr= Draw_PETH(ts_evt(select.Stimulus4_Corr,:), ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode);


PETH_FR.all= nansum(PETH.all)/(size(PETH.all,1)*bin_size);
PETH_FR.Stimulus1_Corr= nansum(PETH.Stimulus1_Corr)/(size(PETH.Stimulus1_Corr,1)*bin_size);
PETH_FR.Stimulus2_Corr= nansum(PETH.Stimulus2_Corr)/(size(PETH.Stimulus2_Corr,1)*bin_size);
PETH_FR.Stimulus3_Corr= nansum(PETH.Stimulus3_Corr)/(size(PETH.Stimulus3_Corr,1)*bin_size);
PETH_FR.Stimulus4_Corr= nansum(PETH.Stimulus4_Corr)/(size(PETH.Stimulus4_Corr,1)*bin_size);



%% Gaussain convolution for smoothing

PETH_FR_smoothed.all = conv(PETH_FR.all, gaussFilter);
PETH_FR_smoothed.Stimulus1_Corr = conv(PETH_FR.Stimulus1_Corr, gaussFilter);
PETH_FR_smoothed.Stimulus2_Corr = conv(PETH_FR.Stimulus2_Corr, gaussFilter);
PETH_FR_smoothed.Stimulus3_Corr = conv(PETH_FR.Stimulus3_Corr, gaussFilter);
PETH_FR_smoothed.Stimulus4_Corr = conv(PETH_FR.Stimulus4_Corr, gaussFilter);


x= linspace(-half_PETH_size+(bin_size/2),half_PETH_size-(bin_size/2), length(PETH_FR_smoothed.all));
x_range= (x > -1 & x <4);


FR_max = [max(PETH_FR_smoothed.Stimulus1_Corr(x_range)) max(PETH_FR_smoothed.Stimulus2_Corr(x_range))...
    max(PETH_FR_smoothed.Stimulus3_Corr(x_range)) max(PETH_FR_smoothed.Stimulus4_Corr(x_range))];
FR_max = max(FR_max);
PETH_FR = [];

%% Plot smoothed SDF
hold on;
plot(x,PETH_FR_smoothed.Stimulus1_Corr,'color',Stimulus_color(1,:),'LineStyle','-','LineWidth',3);
plot(x,PETH_FR_smoothed.Stimulus2_Corr,'color',Stimulus_color(2,:),'LineStyle','-','LineWidth',3);
plot(x,PETH_FR_smoothed.Stimulus3_Corr,'color',Stimulus_color(3,:),'LineStyle','-','LineWidth',3);
plot(x,PETH_FR_smoothed.Stimulus4_Corr,'color',Stimulus_color(4,:),'LineStyle','-','LineWidth',3);

%         handle= vline(0, 'b:','Choice'); set(handle,'linewidth',2)
%         handle= vline(-nanmedian(trial_latency), 'r:', 'Onset'); set(handle,'linewidth',2)


handle= vline(0, 'k:','Onset'); set(handle,'linewidth',2)
handle= vline(nanmedian(trial_latency), 'b:', 'Choice'); set(handle,'linewidth',2,'color',[0.4 0.4 0.4])
xlim([-1 4]);
%         ylim([0 ceil(max(PETH_FR_smoothed.all))]);
ylim([0 ceil(FR_max)]);
set(gca, 'YTick',[0 ceil(FR_max)], 'YTickLabel',sprintfc('%i',[0 ceil(FR_max)]),'fontsize',8);
ylabel('FR (Hz)','fontsize',12)

clear PETH_FR* x