%% Created by Jaerong 2017/10/07  for PER & POR ephys analysis


clear all; close all; clc;
%% Input folder

dataROOT= 'F:\PRC_POR_ephys\Analysis\EEG\Spectrogram(Repetition)\Stack';
cd(dataROOT)

%% Load EEG Parms

EEG_parms;


%% Fig parms

fig_pos = [200 600 1400 400];


nb_win =30;


%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\Spectrogram(Repetition)\Stack\'  date];
if ~exist(saveROOT)
    mkdir(saveROOT);
end



% %% Output file
%
% outputfile= ['EEG_POWER_' date '.txt'];
%
% fod=fopen(outputfile,'w');
% fprintf(fod,'Rat \tsession \tTT \ttask \tRegion \tlayer \ttheta_power(sampling) \tgamma_low_power(sampling) \tgamma_high_power(sampling) \ttheta_power(choice) \tgamma_low_power(choice) \tgamma_high_power(choice)');
% fprintf(fod,'\n');
% fclose(fod);


%% Cell listing
listing_IntHIPP=dir('*IntHIPP*');
listing_PER=dir('*PER*');


%% Make pop matrices

Pop_mat = [];


cell_ind= 0;

for cell_run=  1:size(listing_IntHIPP,1)
    
    load(listing_IntHIPP(cell_run).name);
    disp(['Loading...  '     listing_IntHIPP(cell_run).name]);
    
    cell_ind= cell_ind + 1;
    
    Pop_mat.IntHIPP.theta(cell_run,:) = norm_power.theta;
    Pop_mat.IntHIPP.lowgamma(cell_run,:) = norm_power.lowgamma;
    Pop_mat.IntHIPP.highgamma(cell_run,:) = norm_power.highgamma;
    
end




cell_ind= 0;

for cell_run=  1:size(listing_PER,1)
    
    load(listing_PER(cell_run).name);
    disp(['Loading...  '     listing_PER(cell_run).name]);
    
    cell_ind= cell_ind + 1;
    
    
    Pop_mat.PER.theta(cell_run,:) = norm_power.theta;
    Pop_mat.PER.lowgamma(cell_run,:) = norm_power.lowgamma;
    Pop_mat.PER.highgamma(cell_run,:) = norm_power.highgamma;
    
end



%% Create figures
%% Print out cell ID


fig=figure('Color',[1 1 1],'Position',fig_pos);

subplot('Position', [0.42 0.95 0.3 0.2]);
text(0,0,'Avg Power','fontsize',16);
axis off;


%% IntHIPP
subplot('position',[0.05 0.1 0.3 0.7]);
plot(mean(Pop_mat.IntHIPP.theta),'linewidth',5);   hold on;
plot(mean(Pop_mat.IntHIPP.lowgamma),'linewidth',5);
plot(mean(Pop_mat.IntHIPP.highgamma),'linewidth',5);hold off;
box off; 
% legend('\Theta','Low \gamma','High \gamma','location','EastOutside');
set(gca, 'XTick',[]);
xlabel('Norm. Time','Fontsize',12);
ylabel('Norm. Power','Fontsize',12);
ylim([0 1]);
title('IntHIPP');


%% PER

subplot('position',[0.45 0.1 0.3 0.7]);
plot(mean(Pop_mat.PER.theta),'linewidth',5);   hold on;
plot(mean(Pop_mat.PER.lowgamma),'linewidth',5);
plot(mean(Pop_mat.PER.highgamma),'linewidth',5);
box off; 
set(gca, 'XTick',[]);
xlabel('Norm. Time','Fontsize',12);
ylabel('Norm. Power','Fontsize',12);
ylim([0 1]);
title('PER');
lh= legend('\Theta','Low \gamma','High \gamma');


%% Save figure

cd(saveROOT)

save([Prefix '.mat'],'norm_power');
filename=[Prefix  '.png'];
saveImage(fig,filename,fig_pos);
