%% Made by Jaerong 2016/06/14
%% The program detects and counts of sharp wave ripple (SWR) events.

clc; clear all; close all;


%% Sleep epoch timestamps

sleep_start = 3552176657621;
sleep_end = 3552978096019;
rec_end= 3553500384639;


%% Data folder
% dataROOT= 'H:\PRC_POR_ephys\Ephys_data\EEG_profile\2016-06-15_14-06-36';
dataROOT= 'H:\PRC_POR_ephys\Ephys_data\EEG_profile\2016-06-16_17-44-55';


%% Save folder
saveROOT= [dataROOT '\SWR'];

if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)


%% Output file generation
outputfile= ['SWR_analysis_' date '.csv'];
fod=fopen(outputfile,'w');

txt_header = 'TTID, Region, nb_SWR(sleep), nb_SWR(awake)';
fprintf(fod, txt_header);
txt_header = '\n';
fprintf(fod, txt_header);
fclose(fod);




%% SWR parameters

filter_range = [150 250];
nb_data_points= 2048;
sampling_freq= 2000;
threshold= 2;
time_thresh= 20;  %% 10ms



%% Figure

r_plot=2; c_plot=1;


cd(dataROOT)
%% Input table
T= readtable('EEG_summary.txt','Delimiter','\t');



listing_csc= dir('*.ncs'); nb_channel= size(listing_csc,1);

for channel_run =  1: nb_channel
    
cd(dataROOT)
    nb_SWR= [];
    eeg= [];
    eeg_SWR= [];
    
    
    csc_ID= sprintf(listing_csc(channel_run).name);
    
    disp(['processing... ' csc_ID ]);
    
    channel_number =  csc_ID(4:findstr(csc_ID, '_')-1);
    Region = cell2mat(T.Region(str2num(channel_number)));
    
    
    
    
    [ts, eeg.sleep, header] = Nlx2MatCSC(csc_ID, [1 0 0 0 1], 1, 4,[sleep_start sleep_end]); %load EEG files segmented by Big windows
    
    
    [ts, eeg.awake, header] = Nlx2MatCSC(csc_ID, [1 0 0 0 1], 1, 4,[sleep_end rec_end]); %load EEG files segmented by Big windows
    
    
    
    bit2volt = str2num(header{15}(1, 14:end)); %read ADBitVolts
    ADMaxValue = str2num(header{16}(1, 14:end)); %read ADMaxValue
    
    eeg.sleep= (eeg.sleep.* bit2volt).*10^6;  %% Convertino to microvolts
    eeg.awake= (eeg.awake.* bit2volt).*10^6;  %% Convertino to microvolts
    
    
    
    %% Reassemble the data block
    %% Number of data points (in blocks, the number in the power of 2)
    
    eeg_row= nb_data_points;
    
    eeg_col = floor(numel(eeg.sleep)/nb_data_points);
    eeg.sleep((eeg_row* eeg_col)+1:end) = [];  %% truncate the trailing values
    eeg.sleep= reshape(eeg.sleep, eeg_row, eeg_col);
    
    eeg_col = floor(numel(eeg.awake)/nb_data_points);
    eeg.awake((eeg_row* eeg_col)+1:end) = [];  %% truncate the trailing values
    eeg.awake= reshape(eeg.awake, eeg_row, eeg_col);
    
    
    
    %% 60 Hz elimination (using butter function)
    
    n=3;
    Wn=filter_range;
    Fn= sampling_freq/2;  %% Nyquist frequency
    ftype='bandpass';
    [b,a]= butter(n, Wn/Fn, ftype);
    
    
    eeg_SWR.sleep= filter(b,a,eeg.sleep);
    eeg_SWR.awake= filter(b,a,eeg.awake);
    
    
    
    
    %% Envelop detection
    envelope.sleep = abs(hilbert(eeg_SWR.sleep));
    envelope.awake = abs(hilbert(eeg_SWR.awake));
    
    
    
    envelope.sleep= reshape(envelope.sleep, 1, numel(envelope.sleep));
    envelope.awake= reshape(envelope.awake, 1, numel(envelope.awake));
    
    
    SWR_thresh.sleep= mean(envelope.sleep)+ (threshold*std(envelope.sleep));
    SWR_thresh.awake= mean(envelope.awake)+ (threshold*std(envelope.awake));
    
    
    
    envelope.sleep = reshape(envelope.sleep, nb_data_points, floor(numel(envelope.sleep)/nb_data_points));
    envelope.awake = reshape(envelope.awake, nb_data_points, floor(numel(envelope.awake)/nb_data_points));
    
    nb_above_thresh= [];
    nb_SWR= [];
    SWR_event= {};
    
    SWR_run = 0;
    
    
    for eeg_run = 1: size(eeg.sleep,2)
        
        
        overthresh = (envelope.sleep(:,eeg_run) > SWR_thresh.sleep)';
        
        diff_ind = find(diff(overthresh));
        
        
        for diff_run = 1: numel(diff_ind)
            
            if diff_run ==1
                
                if sum(overthresh(1:diff_ind(diff_run))) && ((sum(overthresh(1:diff_ind(diff_run))* (1/sampling_freq))*10^3) > time_thresh)
                    
                    SWR_run= SWR_run+1;
                    
                    SWR_event.sleep{SWR_run}= eeg.sleep(1:diff_ind(diff_run),eeg_run);
%                     figure();
%                     plot(eeg.sleep(:,eeg_run)); hold on; plot((1:diff_ind(diff_run)),eeg.sleep(1:diff_ind(diff_run),eeg_run),'r');  ylim([-2500 2500]);
                    
                end
                
            else
                try
                    if sum(overthresh(diff_ind(diff_run)+1:diff_ind(diff_run+1))) && ...
                            (((sum(overthresh(diff_ind(diff_run)+1:diff_ind(diff_run+1)))* (1/sampling_freq))*10^3) > time_thresh)
                        
                        SWR_run= SWR_run+1;
                        
                        SWR_event.sleep{SWR_run}= eeg.sleep(diff_ind(diff_run)+1:diff_ind(diff_run+1),eeg_run);
%                         figure();
%                         plot(eeg.sleep(:,eeg_run)); hold on; plot((diff_ind(diff_run)+1:diff_ind(diff_run+1)),eeg.sleep(diff_ind(diff_run)+1:diff_ind(diff_run+1),eeg_run),'r');  ylim([-2500 2500]);
                    end
                catch
                end
                
            end
            
        end
        
    end
    
    if ~isempty(SWR_event.sleep)
        nb_SWR.sleep = length(SWR_event.sleep);
    else
        nb_SWR.sleep =0;
    end
    
    
    
    SWR_run = 0;
    
    for eeg_run = 1: size(eeg.awake,2)
        
        
        overthresh = (envelope.awake(:,eeg_run) > SWR_thresh.awake)';
        
        diff_ind = find(diff(overthresh));
        
        
        for diff_run = 1: numel(diff_ind)
            
            if diff_run ==1
                
                if sum(overthresh(1:diff_ind(diff_run))) && ((sum(overthresh(1:diff_ind(diff_run))* (1/sampling_freq))*10^3) > time_thresh)
                    
                    SWR_run= SWR_run+1;
                    
                    SWR_event.awake{SWR_run}= eeg.awake(1:diff_ind(diff_run),eeg_run);
                    
%                     figure();
%                     plot(eeg.awake(:,eeg_run)); hold on; plot((1:diff_ind(diff_run)),eeg.awake(1:diff_ind(diff_run),eeg_run),'r'); ylim([-2500 2500]);
                end
                
            else
                try
                    if sum(overthresh(diff_ind(diff_run)+1:diff_ind(diff_run+1))) && ...
                            (((sum(overthresh(diff_ind(diff_run)+1:diff_ind(diff_run+1)))* (1/sampling_freq))*10^3) > time_thresh)
                        
                        SWR_run= SWR_run+1;
                        
                        SWR_event.awake{SWR_run}= eeg.awake(diff_ind(diff_run)+1:diff_ind(diff_run+1),eeg_run);
%                         figure();
%                         plot(eeg.awake(:,eeg_run)); hold on; plot((diff_ind(diff_run)+1:diff_ind(diff_run+1)),eeg.awake(diff_ind(diff_run)+1:diff_ind(diff_run+1),eeg_run),'r');  ylim([-2500 2500]);
                        
                    end
                catch
                end
                
            end
            
        end
        
    end
    
    if ~isempty(SWR_event.awake)
        nb_SWR.awake = length(SWR_event.awake);
    else
        nb_SWR.awake =0;
    end
    %
    %     %% Create figures
    %
    %
    %     fig_pos= [500,580,1300,600]; %lab computer
    %     fig=figure('name',['TT', channel_number '(' Region ').png'],'Color',[1 1 1],'Position',fig_pos);
    %
    %     subplot('Position', [0.45 0.98 0.4 0.2]);
    %     text(0,0,['TT', channel_number '(' Region ')'],'fontsize',15);
    %
    %     axis off;
    %
    %
    %
    %     subplot(r_plot,c_plot,1)
    %     plot(eeg(:,208),'linewidth',2)
    %     box off;
    %     %     title('Raw Trace','fontsize',15);
    %     text(-150,0,'Raw Trace','fontsize',15);
    %     axis off;
    %     %     xlabel(['Time (\muS)'])
    %     %     ylabel('Amplitude(\muV)');
    %     %         set(gca,'ylim',[-2000 2000]);
    %
    %
    %
    %     subplot(r_plot,c_plot,2)
    %
    %     plot(eeg_SWR(:,208),'k')
    %     box off;
    %     %     title('Ripple filtered','fontsize',15);
    %     text(-150,0,'Ripple filtered','fontsize',15);
    %     axis off;
    %     set(gca,'ylim',[-150  150]);
    %     %     xlabel(['Time (\muS)'])
    %     %     ylabel('Amplitude(\muV)');
    %     %     set(gca,'ylim',y_range);
    %     %     subplot(r_plot,c_plot,str2num(channel_number))
    %
    %     hold on;
    %     plot(envelope(:,208),'k'); axis off;
    %     plot(-envelope(:,208),'k');
    %     h = hline(SWR_thresh,'m:'); set(h,'linewidth',1.5);
    %     hold on;
    %
    %     eeg_sample= eeg_SWR(:,208);
    %     envelope_sample= envelope(:,208);
    %
    %     hold on;
    %     plot((find(envelope_sample > SWR_thresh)),'r')
    %
    %
    %
    %
    
    %% Save output files
    
    % txt_header = 'TTID, Region, nb_SWR(sleep), nb_SWR(awake), nb_SWR(sleep)';
    % fprintf(fod, txt_header);
    % txt_header = '\n';
    % fprintf(fod, txt_header);
    % fclose(fod);
    
    cd(saveROOT);
    fod=fopen(outputfile,'a');
    fprintf(fod,'%s ,%s ,%d ,%d', channel_number, Region, nb_SWR.sleep, nb_SWR.awake);
    fprintf(fod, '\n');
    fclose('all');
    
    
    
    nb_SWR = [];
    ts=[];
    NumValSamples=[];
    eeg_filtered_butter=[];
    header=[];
    %                 return
    
end




% 
% 
% %% Save figures
% filename=['SWR_analysis.png'];
% saveImage(fig,filename,fig_pos);
%