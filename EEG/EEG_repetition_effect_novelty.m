%% Created by Jaerong 2017/09/01  for PER & POR ephys analysis
%% Revised by Jaerong 2017/09/25


function [summary,summary_header]=EEG_repetition_effect_novelty(summary, summary_header,dataROOT)


%% Load EEG Parms

EEG_parms;


%% Fig parms

fig_pos = [100 100 1100 1000];



%% Parms

global alpha
global xpos
global ypos

alpha= 0.05;
xpos=1;
ypos=1;



%% Save folder
saveROOT= [dataROOT '\Analysis\EEG\Repetition\Novelty\' date ];

if ~exist(saveROOT)
    mkdir(saveROOT);
end

cd(saveROOT)



%% Output file

outputfile= 'EEG_repetition.csv';

fod=fopen(outputfile,'w');
txt_header = 'Key#, RatID, Session, Task_session, Task, Region, Subregion, Layer, Bregma, TT,';
fprintf(fod, txt_header);
txt_header = 'Fitting_Category(Theta), CorrR(Theta), Slope(Theta), Polarity(Theta),';
fprintf(fod, txt_header);
txt_header = 'Fitting_Category(LoGamma), CorrR(LoGamma),  Slope(LoGamma), Polarity(LoGamma),';
fprintf(fod, txt_header);
txt_header = 'Fitting_Category(highGamma), CorrR(highGamma),  Slope(highGamma), Polarity(highGamma),';
fprintf(fod, txt_header);
fprintf(fod,'\n');
fclose(fod);




[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if  strcmp(summary(i_s).Visual_Inspection, '1')  &&  strcmp(summary(i_s).Power_criteria, '1')
        
        
        
        
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
        
        
        %% Performance
        
        Perf =[];
        Familiar= 1;
        Novel= 2;
        
        
        Perf(Familiar) = mean(ts_evt(select.Familiar,Correctness));
        Perf(Novel) = mean(ts_evt(select.Novel,Correctness));
        
        
        
        
        %% Maxout trial removal (for EEG only)
        
        cd([Session_folder '\EEG\']);
        load([Prefix '_maxout.mat' ]);
        ts_evt(maxout_MAT==1,:)=[];
        
        
        %% Select trial types
        
        select_trial_type;
       
        
        
        %% Look up the ADBitVolts
        
        bit2milivolt = str2num(summary(i_s).ADBitmilivolts); %read ADBitVolts
        
        
        %% Extract EEG during the event period
        
        EEG_MAT=[];
        
        
        for trial_run= 1:size(ts_evt,1) % for each trial
            
            ts_vector = [];
            EEG = [];
            
            
            cd([Session_folder '\EEG\Noise_reduction']);
            csc_ID= sprintf('CSC%s_Noise_filtered.ncs',summary(i_s).TT);
            
            
            ts_vector = [ts_evt(trial_run,StimulusOnset) ts_evt(trial_run,Choice)];
            
            
            EEG = get_EEG(csc_ID, ts_vector, bit2milivolt);
            
            EEG_MAT{trial_run} = EEG;
            
            
        end
        
        clear EEG
        
        
        
        %% Calculate the frequency power
        
        Power_All=[];
        Power_Theta=[];
        Power_GammaLow=[];
        Power_GammaHigh=[];
        
        
        for trial_run= 1:size(EEG_MAT,2)
            
            Power_All(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)));
            Power_Theta(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.theta);
            Power_GammaLow(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.lowgamma);
            Power_GammaHigh(trial_run) = bandpower(cell2mat(EEG_MAT(trial_run)), sampling_freq,freq_range.highgamma);
            
        end
        
        clear EEG*
        
        
        
        
%         %% Noisy trial elimination
%         
%         criteria = [];
%         
%         criteria = mean(Power_All) + std(Power_All)*2;
%         
%         
%         nb_voided_trials= sum(Power_All > criteria);
%         to_be_voided= (Power_All > criteria);
%         msg= sprintf('nb trials voided = %d',sum(nb_voided_trials));
%         disp(msg); clear msg;
%         
%         
%         
%         Power_All(to_be_voided) = [];
%         Power_Theta(to_be_voided) = [];
%         Power_GammaLow(to_be_voided) = [];
%         Power_GammaHigh(to_be_voided) = [];
%         ts_evt(find(to_be_voided == 1)',:) = [];
%         
%         
%         
%         %% Select trial types
%         
%         
%         select_trial_type;
%         
%         
%         ts_evt= ts_evt(select.Corr,:);
        
        
%         %% Min Max normalization
%         
%         
%         Power_All = mapminmax(Power_All, 0, 10)';
%         Power_Theta = mapminmax(Power_Theta, 0, 10)';
%         Power_GammaLow = mapminmax(Power_GammaLow, 0, 10)';
%         Power_GammaHigh = mapminmax(Power_GammaHigh, 0, 10)';
        
        
        
        
        
        %% Create figures
        %% Print out cell ID
        
        
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        
        subplot('Position', [0.3 0.98 0.3 0.2]);
        text(0,0,Prefix,'fontsize',13);
        axis off;
        
        
        
        
        
        %% Output file generation
        
        cd(saveROOT)
        fod=fopen(outputfile,'a');
        fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Region, Subregion, Layer, Bregma, TTID);
        fclose('all');
        
        
        
        
        %% Theta
        
        
        target_Power=[];
        target_Power= Power_Theta;
        
        CorrR=[];
        Corr_Pval=[];
        Pval_sig=[];
        Slope=[];
        Polarity =cell(1,2);
        
        
        
        subplot('position',[0.15 0.7 0.25 0.2]);
        
        
        [CorrR(Familiar), Corr_Pval(Familiar), Pval_sig(Familiar), Slope(Familiar), Polarity{Familiar}] = get_repetition_novelty(target_Power, select.Familiar_Corr);
        
        msg= sprintf('Perf = %1.2f', Perf(Familiar));
        text(xpos,ypos-.6,msg,'units','normalized')
        title('Familiar(Corr)','fontsize',13);
        
        text(-0.45, 0.5,'Theta','units','normalized', 'fontsize', 12);
        
        
        
        
        
        subplot('position',[0.6 0.7 0.25 0.2]);
        
        
        [CorrR(Novel), Corr_Pval(Novel), Pval_sig(Novel),  Slope(Novel), Polarity{Novel}] = get_repetition_novelty(target_Power, select.Novel_Corr);
        
        msg= sprintf('Perf = %1.2f', Perf(Novel));
        text(xpos,ypos-.6,msg,'units','normalized')
        title('Novel(Corr)','fontsize',13);
        
        
        %% Get repetition categorization
        
        switch sum(Pval_sig)
            
            case 0
                
                
                Fitting_cat ='Nofitting';
                
                
            case 1
                
                if Pval_sig(Familiar)
                    
                    Fitting_cat= 'Familiar';
                    
                else
                    
                    Fitting_cat= 'Novel';
                    
                end
                
            case 2
                
                Fitting_cat= 'All';
                
        end
        
        
        
        if sum(Pval_sig)==1
            
            CorrR= CorrR(logical(Pval_sig));
            Corr_Pval = Corr_Pval(logical(Pval_sig));
            Slope = Slope(logical(Pval_sig));
            Polarity = cell2mat(Polarity(logical(Pval_sig)));
            
        elseif  sum(Pval_sig)> 1
            
            ind= find(abs(CorrR) == max(abs(CorrR)));
            CorrR= CorrR(ind);
            Corr_Pval = Corr_Pval(ind);
            Slope = Slope(ind);
            Polarity =cell2mat(Polarity(ind));
            
        else
            
            CorrR= nan;
            Corr_Pval = nan;
            Slope = nan;
            Polarity = nan;
            
        end
        
        
        %% Output file generation
        
        fod=fopen(outputfile,'a');
        fprintf(fod,',%s, %1.2f, %1.2f, %s',Fitting_cat, CorrR, Slope, Polarity);
        fclose('all');
        
        %% Low gamma
        target_Power=[];
        target_Power= Power_GammaLow;
        
        CorrR=[];
        Corr_Pval=[];
        trial_nb=[];
        norm_Power=[];
        Pval_sig=[];
        Slope=[];
        Polarity =cell(1,2);
        
        subplot('position',[0.15 0.4 0.25 0.2]);
        [CorrR(Familiar), Corr_Pval(Familiar), Pval_sig(Familiar), Slope(Familiar), Polarity{Familiar}] = get_repetition_novelty(target_Power, select.Familiar_Corr);
        
        msg= sprintf('Perf = %1.2f', Perf(Familiar));
        text(xpos,ypos-.6,msg,'units','normalized')
        title('Familiar(Corr)','fontsize',13);
        
        text(-0.55, 0.5,'Low(Gamma)','units','normalized', 'fontsize', 12);
        
        subplot('position',[0.6 0.4 0.25 0.2]);
        [CorrR(Novel), Corr_Pval(Novel), Pval_sig(Novel),  Slope(Novel), Polarity{Novel}] = get_repetition_novelty(target_Power, select.Novel_Corr);
        
        msg= sprintf('Perf = %1.2f', Perf(Novel));
        text(xpos,ypos-.6,msg,'units','normalized')
        title('Novel(Corr)','fontsize',13);
        
        %% Get repetition categorization
        
        switch sum(Pval_sig)
            
            case 0
                
                
                Fitting_cat ='Nofitting';
                
                
            case 1
                
                if Pval_sig(Familiar)
                    
                    Fitting_cat= 'Familiar';
                    
                else
                    
                    Fitting_cat= 'Novel';
                    
                end
                
            case 2
                
                Fitting_cat= 'All';
                
        end
        
        
        
        if sum(Pval_sig)==1
            
            CorrR= CorrR(logical(Pval_sig));
            Corr_Pval = Corr_Pval(logical(Pval_sig));
            Slope = Slope(logical(Pval_sig));
            Polarity = cell2mat(Polarity(logical(Pval_sig)));
            
        elseif  sum(Pval_sig)> 1
            
            ind= find(abs(CorrR) == max(abs(CorrR)));
            CorrR= CorrR(ind);
            Corr_Pval = Corr_Pval(ind);
            Slope = Slope(ind);
            Polarity =cell2mat(Polarity(ind));
            
        else
            
            CorrR= nan;
            Corr_Pval = nan;
            Slope = nan;
            Polarity = nan;
            
        end        
        
        %% Output file generation
        
        fod=fopen(outputfile,'a');
        fprintf(fod,',%s, %1.2f, %1.2f, %s',Fitting_cat, CorrR, Slope, Polarity);
        fclose('all');
        
        %% High gamma

        target_Power=[];
        target_Power= Power_GammaHigh;
        
        
        CorrR=[];
        Corr_Pval=[];
        Pval_sig=[];
        Slope=[];
        Polarity =cell(1,2);
        
        
        subplot('position',[0.15 0.1 0.25 0.2]);
        
        
        [CorrR(Familiar), Corr_Pval(Familiar), Pval_sig(Familiar), Slope(Familiar), Polarity{Familiar}] = get_repetition_novelty(target_Power, select.Familiar_Corr);
        
        msg= sprintf('Perf = %1.2f', Perf(Familiar));
        text(xpos,ypos-.6,msg,'units','normalized')
        title('Familiar(Corr)','fontsize',13);
        
        text(-0.55, 0.5,'High(Gamma)','units','normalized', 'fontsize', 12);
        
        
        subplot('position',[0.6 0.1 0.25 0.2]);
        
        
        [CorrR(Novel), Corr_Pval(Novel), Pval_sig(Novel),  Slope(Novel), Polarity{Novel}] = get_repetition_novelty(target_Power, select.Novel_Corr);
        
        msg= sprintf('Perf = %1.2f', Perf(Novel));
        text(xpos,ypos-.6,msg,'units','normalized')
        title('Novel(Corr)','fontsize',13);
        
        
        
        
        
        %% Get repetition categorization
        
        
        
        
        switch sum(Pval_sig)
            
            case 0
                
                
                Fitting_cat ='Nofitting';
                
                
            case 1
                
                if Pval_sig(Familiar)
                    
                    Fitting_cat= 'Familiar';
                    
                else
                    
                    Fitting_cat= 'Novel';
                    
                end
                
            case 2
                
                Fitting_cat= 'All';
                
        end
        
        
        
        if sum(Pval_sig)==1
            
            CorrR= CorrR(logical(Pval_sig));
            Corr_Pval = Corr_Pval(logical(Pval_sig));
            Slope = Slope(logical(Pval_sig));
            Polarity = cell2mat(Polarity(logical(Pval_sig)));
            
        elseif  sum(Pval_sig)> 1
            
            ind= find(abs(CorrR) == max(abs(CorrR)));
            CorrR= CorrR(ind);
            Corr_Pval = Corr_Pval(ind);
            Slope = Slope(ind);
            Polarity =cell2mat(Polarity(ind));
            
        else
            
            CorrR= nan;
            Corr_Pval = nan;
            Slope = nan;
            Polarity = nan;
            
        end        
        
        
        %% Output file generation
        
        
        
        
        fod=fopen(outputfile,'a');
        fprintf(fod,',%s, %1.2f, %1.2f, %s,',Fitting_cat, CorrR, Slope, Polarity);
        fprintf(fod, '\n');
        fclose('all');
        
        
        
        
        clear norm*
        
        
        %% Save figure for verification
        
        cd(saveROOT)
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
    end  %    strcmp(summary(i_s).Visual_Inspection, '1')
    
    
end %   i_s= 1:c_s



end  % function
