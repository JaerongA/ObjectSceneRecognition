function  [summary,summary_header]=  Summary_OBJ_FR(summary, summary_header, dataROOT)

%% Created by Jaerong 2018/05/27
%% This filter prints out the mean firing rate of the event period (stimulus onset to choice) per object
%% Correct trial only
%% For manuscript revision in Cell Reports



%% Output folder

saveROOT=[dataROOT '\Analysis\ObjectFR\' date];
if ~exist(saveROOT), mkdir(saveROOT), end
cd(saveROOT);



%% Load output files

outputfile= 'ObjectFR(FourOBJ).csv';

fod = fopen(outputfile,'w');
txt_header = 'Key#, RatID, Session, Task_session, Task, Region, SubRegion, ClusterID,';
fprintf(fod, txt_header);

txt_header = 'MeanFR(ALL), MeanFR(Icecream), MeanFR(House), MeanFR(Owl), MeanFR(Phone),';
fprintf(fod, txt_header);

txt_header = 'NormFR(Icecream), NormFR(House), NormFR(Owl), NormFR(Phone)';
fprintf(fod, txt_header);

txt_header = '\n';
fprintf(fod, txt_header);
fclose(fod);




%% Fig Parm
fig_pos=[70,250,1000,550];

%     Icecream = 1;
%     House = 2;
%     Owl = 3;
%     Phone = 4;


[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if  strcmp(summary(i_s).Quality_ok,'1')
        
        %% Set cluster prefix
        
        set_cluster_prefix;
        
        
        %% Loading trial ts info from ParsedEvents.mat
        
        load_ts_evt;
        
        
        %% Select trial types
        
        select_trial_type;
        
        
        %% Loading clusters
        
        load_clusters;
        
        
        %% Get epoch firing rates  & significance test
        
        mean_fr=[];
        
        mean_fr.ALL = get_epoch_FR(ts_spk, ts_evt);
        
        
        [mean_fr.Stimulus1_Corr sem_fr.Stimulus1_Corr] = get_epoch_FR(ts_spk, ts_evt(select.Stimulus1_Corr,:));
        [mean_fr.Stimulus2_Corr sem_fr.Stimulus2_Corr] = get_epoch_FR(ts_spk, ts_evt(select.Stimulus2_Corr,:));
        [mean_fr.Stimulus3_Corr sem_fr.Stimulus3_Corr] = get_epoch_FR(ts_spk, ts_evt(select.Stimulus3_Corr,:));
        [mean_fr.Stimulus4_Corr sem_fr.Stimulus4_Corr] = get_epoch_FR(ts_spk, ts_evt(select.Stimulus4_Corr,:));
        
        
        object_fr= [mean_fr.Stimulus1_Corr mean_fr.Stimulus2_Corr mean_fr.Stimulus3_Corr mean_fr.Stimulus4_Corr];
        object_sem= [sem_fr.Stimulus1_Corr sem_fr.Stimulus2_Corr sem_fr.Stimulus3_Corr sem_fr.Stimulus4_Corr];
        
        norm_object_fr= object_fr./mean_fr.ALL;
        Owl_preference = norm_object_fr(Owl) - ((norm_object_fr(Icecream) + norm_object_fr(House) + norm_object_fr(Phone))/3);  %% to see how the CA2 prefers OWL stimulus
        
        
        
        
        %% Print out cell ID
        fig=figure('name',Prefix,'Color',[1 1 1],'Position',fig_pos);
        subplot('Position', [0.3 0.95 0.4 0.2]);
        text(0,0,Prefix,'fontsize',12);
        axis off;
        
        subplot('position',[0.15 0.15 0.5 0.6]);
        
        bar(object_fr);
        hold on
        eh= errorbar(object_fr, object_sem,'.'); set(eh,'color','k')
        box off;
        set(gca,'xticklabel',{'Icecream','House','Owl','Phone'})
        ylabel('Firing Rate (Hz)'); 
        
        
        msg= sprintf('Owl Preference = %1.4f', Owl_preference);
        text(1.1,0.5,msg,'units','normalized','fontsize',11);
        
        
        
        %% Save figure for verification
        
        cd(saveROOT)
        
%         filename_ai=[Prefix '.eps'];
%         print( gcf, '-painters', '-r300', filename_ai, '-depsc');
        
        filename=[Prefix  '.png'];
        saveImage(fig,filename,fig_pos);
        
        
        
        if strcmp(summary(i_s).Region,'PER')
        Subregion = 'PER';
        end
        
        
        
        
        %% Output file generation
        
        
        fod= fopen(outputfile,'a');
        fprintf(fod,'%s ,%s ,%s ,%s ,%s ,%s ,%s ,%s',Key, RatID, Session, Task_session,  Task, Region, Subregion, ClusterID);
        fprintf(fod,',%1.3f, %1.3f, %1.3f, %1.3f, %1.3f', mean_fr.ALL, object_fr(Icecream), object_fr(House), object_fr(Owl), object_fr(Phone));
        fprintf(fod,',%1.3f, %1.3f, %1.3f, %1.3f', norm_object_fr(Icecream), norm_object_fr(House), norm_object_fr(Owl), norm_object_fr(Phone));
        fprintf(fod,',%1.3f', Owl_preference);
        fprintf(fod,'\n');
        fclose('all');
        
        
        
        
    end  % ~strcmp(summary(i_s).Region,'x') && ~strcmp(summary(i_s).Bregma,'?')
    
end

end




