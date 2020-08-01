%% Made by Jaerong 2017/09/19  revised for PER & POR ephys analysis
%% The program runs in conjunction with summary programs.
%% The program performs bandpass filtering between 3 to 300Hz using either butterworth or notchfilter.

function [summary,summary_header]=EEG_noise_filtering(summary, summary_header,dataROOT)




%% Load EEG Parms

EEG_parms;



%% Figure output folder
fig_saveROOT=[dataROOT '\Analysis\EEG\Filtering\' date ];
if ~exist(fig_saveROOT), mkdir(fig_saveROOT), end




%% Fig parms

fig_pos = [385 385 800 600];



[r_s,c_s]= size(summary);


for i_s= 1:c_s
    
    

    if   strcmp(summary(i_s).Rat,'r558')
    
    
    
    %% Set EEG info
    
    set_eeg_prefix;
    
    
    
    
    saveROOT= [Session_folder '\EEG\Noise_reduction'];
    if ~exist(saveROOT), mkdir(saveROOT); end
    
    
    csc_ID= sprintf('CSC%s_RateReduced.ncs',summary(i_s).TT);
    cd(Session_folder);
    
    
    
    ts=[];
    ChannelNumbers=[];
    sampling_freq=[];
    NumValSamples=[];
    EEG=[];
    header=[];
    
    
    
    %% Load the EEG file
    
    [ts, ChannelNumbers, sampling_freq, NumValSamples, EEG, header] = Nlx2MatCSC(csc_ID, [1 1 1 1 1], 1, 1,[]);
    
    
    if params.Fs ~= sampling_freq(1)
        error('Sampling Rate does not match!');
    end
    
    
    
    
    %% wideband filtering
    n=4;
    Wn=[3 300];
    Fn= sampling_freq(1)/2;  %% Nyquist frequency
    ftype='bandpass';
    [b,a]= butter(n, Wn/Fn, ftype);
    EEG_filtered = filtfilt(b, a, EEG);
    
    
    
    
    
    %% 60 Hz elimination (using butter function)
    
    n=3;
    Wn=[59 61];
    Fn= sampling_freq(1)/2;  %% Nyquist frequency
    ftype='stop';
    [b,a]= butter(n, Wn/Fn, ftype);
    EEG_filtered= filtfilt(b,a,EEG_filtered);
    
    
    
    
    %% Draw Raw & Filtered EEG data
    
%     set(0,'DefaultFigureVisible','off')    
    fig=figure('name',Prefix, 'Color',[1 1 1],'Position',fig_pos);
    %% Print out cell ID
    
    subplot('Position', [0.3 0.98 0.2 0.2]);
    text(0,0,Prefix,'fontsize',13);
    axis off;
    
    
    subplot('Position', [0.1 0.6 0.8 0.32]);
    plot(EEG(1:nb_data_points*10)); hold on; box off;
    plot(EEG_filtered(1:nb_data_points*10));    hold on;
    %     plot([0:nb_data_points-1]./nb_data_points, EEG_filtered2(1:nb_data_points));    hold on;
    legend('Raw','Filtered');
    xlabel('Time');
    
    
    
    %% Check the power density function
    subplot('Position', [0.1 0.1 0.45 0.4]);
    [S,f]=mtspectrumc(EEG(1:nb_data_points),params);
    plot(f,10*log10(S),'linewidth',2);   box off; hold on;
    [S,f]=mtspectrumc(EEG_filtered(1:nb_data_points),params);
    plot(f,10*log10(S),'linewidth',2);
    % %     [S,f]=mtspectrumc(EEG_filtered(1:nb_data_points),params);
    %     plot(f,10*log10(S),'linewidth',2);
    legend('raw','filtered(wideband)'); xlabel('Frequency (Hz)'); ylabel('Power (dB)');
    vline(60);
    
    
    
    %     %% Noise ratio calculation (ratio of the min & max values)
    %
    %     noise_ratio= (sum(sum(EEG==-32767 | EEG==32767)) / numel(EEG))*100;
    %
    %     subplot('Position', [0.65 0.2 0.2 0.3]);
    %
    %     axis off;
    %     msg= sprintf('Noise ratio  = %1.2f (percent)', noise_ratio);
    %     text(0,0.5,msg,'units','normalized','fontsize',15);
    
    
    
    %% Save 60Hz filtered .ncs file
    
    cd(saveROOT);
    
    [r(5) c(5)]=size(header);
    header(r(5)+1,c(5))={'-LeelabComment Noise filtered'}; %% filtering range from 59 to 61
    
    hyphen= findstr(csc_ID,'_');
    Mat2NlxCSC([csc_ID(1:hyphen(1)-1) '_Noise_filtered.ncs'], 0, 1, 1, [1 0 1 1 1 1], ts, sampling_freq, NumValSamples, EEG_filtered, header);
    
    
    
%     %% Remove old files (2017/09/20)
%     cd .. 
%     
%     if exist('60HZ_filtered','dir')
%     rmdir 60HZ_filtered s
%     end
%     
%     if exist('noise_reduction','dir')
%     rmdir noise_reduction s
%     end
    
    
    %% Save figure
    
    cd(fig_saveROOT)
    
    filename=[Prefix  '.png'];
    saveImage(fig,filename,fig_pos);
%     saveas(fig,filename);    
    
    
    
    end  %     strcmp(summary(i_s).Rat,'r558')
    
    
end

end


