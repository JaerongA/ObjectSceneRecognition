%% Created by Jaerong 2017/09/16  for PER & POR ephys analysis


function [summary,summary_header]=EEG_coherogram(summary, summary_header,dataROOT)


cd(dataROOT);
pre_folder=[];



%% EEG Parms

freq_range.all = [0 150];
freq_range.delta = [1 4]; freq_range.theta = [4 12]; freq_range.beta = [15 25]; freq_range.lowgamma = [30 50]; freq_range.highgamma = [70 120];
global sampling_freq
sampling_freq= 2000;
period=(1/sampling_freq)*10^6;



%% mtspecgramc parameter

% movingwin = [0.1 .05];           %moving window [windowSIZE windowSTEP]; 500ms window and moving by 10ms
movingwin = [0.3 .01];           %moving window [windowSIZE windowSTEP]; 500ms window and moving by 10ms
params.Fs = sampling_freq;               %frequency; here is EEG data frequency
params.tapers = [3 5];          %tapers [TimeBandWidth multipleTAPERS]; 5 is recommended for 500ms window (3 is recormended for 300ms window size)
params.fpass = freq_range.all;          %ROI freqency;
params.pad= 0;
params.trialave = 1;            %if trial to be averaged, set 1
params.err = [1 0.05] ;            % error bar on, p-value



plt = 'l';


% windowsize = 512;
% nfft = windowsize*2;
% noverlap = windowsize/2;
% % noverlap = 100;





%% Fig parms

fig_pos = [50 100 1700 800];




%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\Coherogram(EventPeriod)\' date ];

if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)



% %% Output file
%
% outputfile= ['EEG_POWER_' date '.txt'];
%
% fod=fopen(outputfile,'w');
% fprintf(fod,'Rat \tsession \tTT \ttask \tRegion \tlayer \ttheta_power(sampling) \tgamma_low_power(sampling) \tgamma_high_power(sampling) \ttheta_power(choice) \tgamma_low_power(choice) \tgamma_high_power(choice)');
% fprintf(fod,'\n');
% fclose(fod);




[r_s,c_s]=size(summary);


for i_s= 51:c_s
    
    
    if  strcmp(summary(i_s).Visual_Inspection, '1') && strcmp(summary(i_s).Region, 'PER')
        
        
        
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
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        %% Load EEG
        
        
        
        %         Session_folder= 'F:\PRC_POR_ephys\Ephys_data\r389\r389-04-02_OCRS(FourOBJ)\EEG\noise_reduction';
        %         csc_ID= sprintf('CSC%s_60Hz_filtered.ncs',summary(i_s).TT);
        %         cd(Session_folder);
        
        
        csc_ID= sprintf('CSC%s_RateReduced.ncs',summary(i_s).TT);
        cd(Session_folder);
        
        
        %% Look up the ADBitVolts
        
        [header] = Nlx2MatCSC(csc_ID, [0 0 0 0 0],1,1,[]); % look for ADBitVolts to convert eegs values from bits to volts
        bit2volt = str2num(header{15}(1, 14:end)); %read ADBitVolts
        clear header
        
        
        
        %% Spectrogram window size
        
        SpectroWin= ceil(median(ts_evt(:,ChoiceLatency)));
        
        nb_data_points= sampling_freq *SpectroWin;
        
        %% Extract EEG during the event period
        
        
        eventEEG=[];
        
        
        for trial_run= 1:size(ts_evt,1) % for each trial
            
            ts_vector = [];
            EEG = [];
            
            
            
            ts_vector =  [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,StimulusOnset)+SpectroWin];
            
            
            cd(Session_folder);
            
            EEG = get_EEG(csc_ID, ts_vector, bit2volt);
            
            EEG= EEG(1:nb_data_points);
            
            eventEEG.PER(trial_run,:) = EEG;   %% Raw EEG for trials
            
            
        end
        
        
        clear EEG
        
        
        
        %% Select another TT from a different regions recorded in the same session
        
        
        nb_target =size(summary,2);
        
        
        
        for Target_run= 1: nb_target
            
            
            
            
            %% Set EEG info
            
            target_set_eeg_prefix;
            
            
            if  strcmp(summary(Target_run).Visual_Inspection, '1') && strcmp(summary(Target_run).Region, 'IntHIPP') && strcmp(RatID, RatID2) && strcmp(Session, Session2)
                
                
                
                disp(['Ref TT... ' Prefix]);
                disp(['Target TT... : ' Prefix2]);
                
                
                
                
                
                %% Load EEG
                
                %         cd(Session_folder);
                
                
                csc_ID= sprintf('CSC%s_RateReduced.ncs',summary(Target_run).TT);
                cd(Session_folder);
                
                
                
                %% Look up the ADBitVolts
                
                [header] = Nlx2MatCSC(csc_ID, [0 0 0 0 0],1,1,[]); % look for ADBitVolts to convert eegs values from bits to volts
                bit2volt = str2num(header{15}(1, 14:end)); %read ADBitVolts
                clear header
                
                
                %% Extract EEG during the event period
                
                
                for trial_run= 1:size(ts_evt,1) % for each trial
                    
                    ts_vector = [];
                    EEG = [];
                    
                    
                    
                    ts_vector =  [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,StimulusOnset)+SpectroWin];
                    
                    
                    cd(Session_folder);
                    
                    EEG = get_EEG(csc_ID, ts_vector, bit2volt);
                    
                    EEG= EEG(1:nb_data_points);
                    
                    eventEEG.HIPP(trial_run,:) = EEG;   %% Raw EEG for trials
                    
                    
                end
                
                
                clear EEG
                
                
                
                
                
                
                %% Create figures
                %% Print out cell ID
                
                
                fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
                
                subplot('Position', [0.25 0.98 0.3 0.2]);
                text(0,0,[Prefix ' vs. ' Prefix2],'fontsize',12);
                axis off;
                
                
                
                %% Get coherogram
                
                
                
                S=[];T=[];F=[];
                  
                
                [C, phi, S.Cross, S.PER, S.HIPP, T, F, confC, phistd] = cohgramc(eventEEG.PER', eventEEG.HIPP',movingwin,params);
                
                
%                   clear eventEEG
                
                
                
                
                
                %% Coherogram (ALL)
              
                
                subplot('Position', [0.1 0.75 0.2 0.15]);
                
                imagesc(T,F,10*log(S.PER')); cb= colorbar; ylabel(cb, 'Power(dB)');
                set(gca,'YDir','Normal');  colormap jet; box off;
                title('PER'); ylabel('Frequency(Hz)','fontsize',12);
                
                
                
                
                subplot('Position', [0.1 0.5 0.2 0.15]);
                
                imagesc(T,F,10*log(S.HIPP')); cb= colorbar; ylabel(cb, 'Power(dB)');
                set(gca,'YDir','Normal');  colormap jet; box off;
                title('HIPP'); ylabel('Frequency(Hz)','fontsize',12);
                
                
                
                subplot('Position', [0.1 0.25 0.2 0.15]);
                
%                 imagesc(T,F,10*log(abs(S.Cross)')); cb= colorbar; ylabel(cb, 'Power(dB)');
                imagesc(T,F,C'); cb= colorbar; ylabel(cb, 'Coherence');
%                 imagesc(T,F,mapminmax(C',0,1)); cb= colorbar; ylabel(cb, 'Coherence');
                set(gca,'YDir','Normal');  colormap jet; box off;
                title('Coherence(All)'); ylabel('Frequency(Hz)','fontsize',12); caxis([0 1]);
                
                
                
                %% Coherogram (Familiar)
                
                [C, phi, S.Cross, S.PER, S.HIPP, T, F, confC, phistd] = cohgramc(eventEEG.PER(select.Familiar_Corr,:)', eventEEG.HIPP(select.Familiar_Corr,:)',movingwin,params);
                
                
                subplot('Position', [0.4 0.75 0.2 0.15]);
                
                imagesc(T,F,10*log(S.PER')); cb= colorbar; ylabel(cb, 'Power(dB)');
                set(gca,'YDir','Normal');  colormap jet; box off;
                title('PER'); ylabel('Frequency(Hz)','fontsize',12);
                
                
                subplot('Position', [0.4 0.5 0.2 0.15]);
                
                imagesc(T,F,10*log(S.HIPP')); cb= colorbar; ylabel(cb, 'Power(dB)');
                set(gca,'YDir','Normal');  colormap jet; box off;
                title('HIPP'); ylabel('Frequency(Hz)','fontsize',12);
                
                
                
                subplot('Position', [0.4 0.25 0.2 0.15]);
                
%                 imagesc(T,F,10*log(abs(S.Cross)')); cb= colorbar; ylabel(cb, 'Power(dB)');
                imagesc(T,F,C'); cb= colorbar; ylabel(cb, 'Coherence');
%                 imagesc(T,F,mapminmax(C',0,1)); cb= colorbar; ylabel(cb, 'Coherence');
                set(gca,'YDir','Normal');  colormap jet; box off;
                title('Coherence(Familiar)'); ylabel('Frequency(Hz)','fontsize',12); caxis([0 1]);
                  
                
                
                %% Coherogram (Novel)
                
                
                [C, phi, S.Cross, S.PER, S.HIPP, T, F, confC, phistd] = cohgramc(eventEEG.PER(select.Novel_Corr,:)', eventEEG.HIPP(select.Novel_Corr,:)',movingwin,params);
                
                
                
                subplot('Position', [0.7 0.75 0.2 0.15]);
                
                imagesc(T,F,10*log(S.PER')); cb= colorbar; ylabel(cb, 'Power(dB)');
                set(gca,'YDir','Normal');  colormap jet; box off;
                title('PER'); ylabel('Frequency(Hz)','fontsize',12);
                
                
                subplot('Position', [0.7 0.5 0.2 0.15]);
                
                imagesc(T,F,10*log(S.HIPP')); cb= colorbar; ylabel(cb, 'Power(dB)');
                set(gca,'YDir','Normal');  colormap jet; box off;
                title('HIPP'); ylabel('Frequency(Hz)','fontsize',12);
                
                
                
                subplot('Position', [0.7 0.25 0.2 0.15]);
                
%                 imagesc(T,F,10*log(abs(S.Cross)')); cb= colorbar; ylabel(cb, 'Power(dB)');
                imagesc(T,F,C'); cb= colorbar; ylabel(cb, 'Coherence');
%                 imagesc(T,F,mapminmax(C',0,1)); cb= colorbar; ylabel(cb, 'Coherence');
                set(gca,'YDir','Normal');  colormap jet; box off;
                title('Coherence(Novel)'); ylabel('Frequency(Hz)','fontsize',12); caxis([0 1]);
                
                
                
                %
                %
                %
                %
                %
                %
                %
                %
                %
                %
                %         %% Spectrogram (Diff)
                %
                %         Xdiff =[];
                %         mask =[];
                %         Familiar_sig =[];
                %         Novel_sig =[];
                %
                %
                %
                %         [mask,Xdiff]=plotsigdiff(S.Familliar, Serr_Familliar, S.Novel, Serr_Novel, plt, T, F);
                %
                %
                %         Familiar_sig = mask; Familiar_sig(find(Familiar_sig== -1))= 0;
                %         Novel_sig = mask; Novel_sig(find(Novel_sig== 1))= 0;
                %
                %
                %
                %         subplot('Position', [0.8 0.75 0.16 0.15]);
                %         imagesc(T,F,(mask.*Xdiff)');
                %         %         imagesc(T,F,(a.*Xdiff)');
                %         set(gca,'YDir','Normal');  colormap jet; box off;
                %         title('Familiar - Novel'); ylabel('Frequency(Hz)','fontsize',12);
                %
                %
                %
                %         subplot('Position', [0.8 0.5 0.16 0.15]);
                %         imagesc(T,F,(Familiar_sig.*Xdiff)');
                %         %         imagesc(T,F,(a.*Xdiff)');
                %         set(gca,'YDir','Normal');  colormap jet; box off;
                %         title('Familiar Sig'); ylabel('Frequency(Hz)','fontsize',12);
                %
                %
                %
                %         subplot('Position', [0.8 0.25 0.16 0.15]);
                %         imagesc(T,F,(Novel_sig.*Xdiff)');
                %         %         imagesc(T,F,(a.*Xdiff)');
                %         set(gca,'YDir','Normal');  colormap jet; box off;
                %         xlabel('Time(s)','fontsize',12);
                %         title('Novel Sig'); ylabel('Frequency(Hz)','fontsize',12);
                %
                %
                %
                %         clear Xdiff mask Familiar_sig Novel_sig Serr* T F
                %
                %
                %
                %
                %
                
                %% Save figure for verification
                
                cd(saveROOT)
                
                filename=[Prefix  '.png'];
                saveImage(fig,filename,fig_pos);
                
                
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
                
                
                %     end  %  strcmp(summary(i_s).noise_OK, '1') && strcmp(summary(i_s).depth_OK, '1') && strcmp(summary(i_s).task, 'ambiguity')
                
                
            end %   i_s= 1:c_s
            
        end
        
        
    end
end


