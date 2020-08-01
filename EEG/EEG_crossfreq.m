%% Created by Jaerong 2017/09/08  for PER & POR ephys analysis
%% Examines the crossfrequency coupling between theta and gamma

function [summary,summary_header]=EEG_crossfreq(summary, summary_header,dataROOT)

%% Load EEG Parms

EEG_parms;



%% Fig parms

fig_pos = [255 200 1250 850];



%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\CFC\' date];

if ~exist(saveROOT)
    mkdir(saveROOT);
end
cd(saveROOT)


%% Output file

% outputfile= 'EEG_CFC.csv';
%
% fod=fopen(outputfile,'w');
% txt_header = 'Key#, RatID, Session, Task_session, Task, Region, Subregion, Layer, Bregma, TT,';
% fprintf(fod, txt_header);
% % txt_header = 'Fitting_Category(Theta), CorrR(Theta), Slope(Theta), Polarity(Theta),';
% % fprintf(fod, txt_header);
% fprintf(fod,'\n');
% fclose(fod);


[r_s,c_s]=size(summary);


for i_s=   16:c_s
    
    
    if  strcmp(summary(i_s).Visual_Inspection, '1')
        
        
        %% Set EEG info
        
        set_eeg_prefix;
        
        
        
        
        %% Loading trial ts info from ParsedEvents.mat
        
        
        % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        % 13. StimulusCat
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        load_ts_evt;
        
        
        
        %% Maxout trial removal (for EEG only)
        
        cd([Session_folder '\EEG\']);
        load([Prefix '_maxout.mat' ]);
        ts_evt(maxout_MAT==1,:)=[];
        
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        
        
        %% Look up the ADBitVolts
        
        
        bit2milivolt = str2num(summary(i_s).ADBitmicrovolts); 
        
        
        
        
        %% Extract EEG during the event period
        
        CFC_mat=[];
        
        
        for trial_run= 1 :size(ts_evt,1) % for each trial
            
            
            
            ts_vector = [];
            EEG = [];
            
            ts_vector = [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
            
            
            
            cd([Session_folder '\EEG\Noise_reduction']);
            csc_ID= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
            
            
            [EEG,EEGTS] = get_EEG(csc_ID, ts_vector, bit2milivolt);
            
            
            EEGTS = EEGTS./1E6;
            

            
            fig_name= sprintf('Trial = #%d  %s',ts_evt(trial_run,Trial), Prefix);
            
%             set(0,'DefaultFigureVisible','off')    
            fig=figure('name',fig_name,'Color',[1 1 1],'Position',fig_pos);
            
            subplot('Position', [0.3 0.98 0.3 0.15]);
            text(0,0,fig_name,'fontsize',12);
            axis off;
            
            
            
            
            subplot('Position', [0.15 0.4 0.65 0.2]);
            
            
            %% Chronux

            
            
            
            %% Minmax normalization
            [S,T,F] = mtspecgramc(EEG,movingwin, params);
            %             T= T-1;
            freq_range_ind= find(F<=freq_range.all(end) & F>=freq_range.all(1));
            F= F(freq_range_ind); S= S(:,freq_range_ind);
            
            
            S_norm= mapminmax(S',0,1);
            imagesc(T,F,S_norm); cb= colorbar; ylabel(cb, 'Norm. Power');
%             plot_matrix(S,T,F);
            %             imagesc(T-1,F,10*log(S'));
            set(gca,'YDir','Normal');  colormap jet; box off;
            ylabel('Frequency(Hz)','fontsize',12)
            xlabel('Time(s)','fontsize',12)
            delete colorbar
            T_range= get(gca,'XLim');
            cb= colorbar('Position', [.83 .4 .02 .2]);
%             ylabel(cb, 'Power(dB)');
            
            
            
            %% Built-in spectrogram
            
            %             [S F T] =spectrogram(EEG,windowsize,noverlap,516,sampling_freq,'yaxis');
            %             freq_range_ind= find(F<=freq_range.all(end) & F>=freq_range.all(1));
            %             F= F(freq_range_ind,:); S= S(freq_range_ind,:);
            %             imagesc(T,F,10*log(abs(S)));
            %             set(gca,'YDir','Normal');  colormap jet; box off; delete colorbar
            %             T_range= get(gca,'XLim');
            %
            
            
            clear S F T 
            
            
            
            
            %             vhandle = vline(ts_evt(trial_run,StimulusOnset) - EEGTS(1),'k:',''); set(vhandle,'linewidth',3);
            %             vhandle = vline(ts_evt(trial_run,Choice) - EEGTS(1),'k:',''); set(vhandle,'linewidth',3);
            ylabel('Frequency (Hz)'); xlabel('Time(s)');
            
            
            
            
            subplot('Position', [0.15 0.67 0.65 0.25]);
            
            plot(((EEGTS-EEGTS(1))), EEG,'Color',[.5 .5 .5]); box off;
            ylabel('\muV','fontsize',15); xlabel('Time(s)');
            
            text(-.21 ,0.5,'Raw Trace','units','normalized','fontsize',15,'color',[.5 .5 .5]);
            %             xlim([-1 (EEGTS(end)- EEGTS(1)-1)])
            xlim(T_range)
            
            %             vline((ts_evt(trial_run,StimulusOnset) - EEGTS(1)),'r','StimulusOnset')
            %             vline((ts_evt(trial_run,Choice) - EEGTS(1)),'r','Choice')
            
            
            msg= sprintf('Stimulus = %s', Stimulus_str{ts_evt(trial_run,Stimulus)});
            text(1.02,0.7,msg,'units','normalized','fontsize',15);
            
            msg= sprintf('%s', Perf_str{ts_evt(trial_run,Correctness)+1});
            text(1.02,0.5,msg,'units','normalized','fontsize',15);
            
            msg= sprintf('Latency= %1.2f (s)', ts_evt(trial_run,ChoiceLatency));
            text(1.02,0.3,msg,'units','normalized','fontsize',15);
            
            
            
            
            %% Cross spectral frequency (2017/09/10)
            
            
            
            
            %             ts_vector = [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
            %
            %             [EEG,EEGTS] = get_EEG(csc_ID, ts_vector, bit2milivolt);
            
            
            
            
            
            %  x :                   nchan*npoints signal
            % para.Fs:               sample frequency
            % para.v :               Vector of interested  high frequency
            % para.xlim              range of interested low frequency range. e.g.[1
            %                        60]; default is all. This tries to save space
            % para.K:                length of window to estimate (in second)
            % para.L:                sliding steps (in second)
            % para.Ncycles:           number of cycles to estimate high frequency power
            % para.nFFT              nfft points windows of fft, which determines frequency
            %                        resolution(in second)
            % para.detrend           detrend or not 'yes' or 'no'
            
            CFC =[]; CFCs_X =[];
            
            para          = [];
            para.Fs       = sampling_freq;
            para.v        = 30:5:150;
            para.xlim     = [4 25];
            para.K        = 0.1;
            para.L        = 0.05;
            para.Ncycles   = 2;
            para.nFFT     = 0.5;
            para.detrend  = 'yes';
            
            
            CFC = cfc_dist_onetrial(EEG,para);
            
            
            para          = [];
            para.method    = 'coh';
            CFCs_X = cfc_quantification(CFC,[],para);
            
            
            
            CFC_mat(:,:,trial_run)= squeeze(CFCs_X.CFC(1,:,:));
            
            
            subplot('Position', [0.15 0.13 0.18 0.18]);
            
            imagesc(CFCs_X.freqVec_X, CFCs_X.freqVec_Y, CFC_mat(:,:,trial_run));axis xy;colorbar; box off;
            title('Cross-Frequency Coupling');
            xlabel('Phase Frequency(Hz)  ','fontsize',11)
            ylabel('Amplitude frequency(Hz) ','fontsize',11)
            
            
            %             para            =[];
            % %             para.freqVec_x   =  4:25;
            %             para.freqVec_x   =  5:16;
            %             para.fwidth      =  2 ;
            %             para.jack        = 'no';
            %             CFDs_X = cfd_quantification(CFC,[],para);
            
            %
            %             subplot('Position', [0.35 0.13 0.18 0.18]);
            %
            %             imagesc(CFCs_X.freqVec_X,CFCs_X.freqVec_Y,squeeze(CFCs_X.CFC(1,:,:)));axis xy;colorbar; box off;
            %             title('Cross-Frequency Coupling');
            %             xlabel('Phase Frequency(Hz)  ','fontsize',11)
            %             ylabel('Amplitude frequency(Hz) ','fontsize',11)
            %
            
            
            
            clear EEG*
            
            
            %% Save figure for verification
            
            
            fig_saveROOT= [saveROOT '\' Prefix];
            
            
            if ~exist(fig_saveROOT)
                mkdir(fig_saveROOT);
            end
            
            
            cd(fig_saveROOT)
            filename=[fig_name  '.png'];
            saveImage(fig,filename,fig_pos);
%             saveas(fig,filename);    
% 
            
        clear fig
          
%         memory
        
        end
        
        
        cd(saveROOT)
        save([Prefix '.mat'],'CFCs_X','CFC_mat');
        
        
        
        
        
        
        fig = figure('pos',[250 500 1250 400]);
        subplot('Position', [0.3 0.98 0.3 0.15]);
        text(0,0,Prefix,'fontsize',12);
        axis off;
        
        Max= max(max(mean(CFC_mat,3)));
        Min= min(min(mean(CFC_mat,3)));
        
        
        subplot('Position', [0.1 0.13 0.25 0.7]);
        imagesc(CFCs_X.freqVec_X,CFCs_X.freqVec_Y,mean(CFC_mat,3),[Min Max]);axis xy;colorbar; box off; colormap(jet);
        title('All');
        subplot('Position', [0.4 0.13 0.25 0.7]);
        imagesc(CFCs_X.freqVec_X,CFCs_X.freqVec_Y,mean(CFC_mat(:,:,select.Familiar),3),[Min Max]);axis xy;colorbar; box off;
        title('Familiar(Corr)');
        subplot('Position', [0.7 0.13 0.25 0.7]);
        imagesc(CFCs_X.freqVec_X,CFCs_X.freqVec_Y,mean(CFC_mat(:,:,select.Novel),3),[Min Max]);axis xy;colorbar; box off;
        title('Novel(Corr)');
        filename= [Prefix '.png'];
        
        
        saveImage(fig,filename,[250 500 1250 300]);
        
        
        
        clear CFC* fig
        %
        %
        %
        %            figure();
        %            subplot(1,3,1);
        %            imagesc(CFCs_X.freqVec_X,CFCs_X.freqVec_Y,mean(CFC_mat,3));axis xy;colorbar; box off; colormap(flipud(hot))
        %            subplot(1,3,2);
        %            imagesc(CFCs_X.freqVec_X,CFCs_X.freqVec_Y,mean(CFC_mat(:,:,select.Novel_Corr),3));axis xy;colorbar; box off;
        %            subplot(1,3,3);
        %            imagesc(CFCs_X.freqVec_X,CFCs_X.freqVec_Y,mean(CFC_mat(:,:,select.Novel_Incorr),3));axis xy;colorbar; box off;
        %
        %
        %             diff= mean(CFC_mat(:,:,select.Novel_Corr),3) - mean(CFC_mat(:,:,select.Familiar_Corr),3)
        %             figure()
        %            imagesc(CFCs_X.freqVec_X,CFCs_X.freqVec_Y,diff);axis xy;colorbar; box off;
        
        
        
        
        
        
        
        %
        
        %         cd(saveROOT);
        %
        %
        %         % fprintf(fod,'Rat \tsession \tTT \ttask \tRegion \tlayer \ttheta_power(sampling) \tgamma_low_power(sampling) \tgamma_high_power(sampling) \ttheta_power(choice) \tgamma_low_power(choice) \tgamma_high_power(choice)');
        %
        %         fod=fopen(outputfile,'a');
        %         fprintf(fod,'%s \t%s \t%s \t%s \t%s \t%s \t%1.2f \t%1.2f \t%1.2f \t%1.2f \t%1.2f \t%1.2f', rat, session, TT, task, region, layer...
        %             , Power.theta/1E3, Power.gamma_low/1E3, Power.gamma_high/1E3, Power.theta.choice/1E3, Power.gamma_low.choice/1E3, Power.gamma_high.choice/1E3);
        %         fprintf(fod, '\n');
        %         fclose('all');
        %
        %
        %         filename_png=[Prefix '-' date '.png'];
        %         saveImage(fig,filename_png,fig_pos);
        
        
    end  %  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
    
    
end %   i_s= 1:c_s



end  % function
