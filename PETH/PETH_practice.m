 %% By Jaerong 2012/05/30


session_folder= 'B:\PRC_POR_ephys\Ephys_data\2015-09-17_21-33-39(2nd pilot)';



%% Loading trial ts info from ParsedEvents.mat


% Trial= 1; Stimulus=2; Correctness=3; Response=4; 

% ChoiceLatency= 5; StimulusOnset=6; Choice=7; Trial_S3_1=8; Trial_S4_1=9; Trial_S3_end=10; Trial_S4_end=11; Trial_Void=12;

load_evt_ts;

load_trial_event_parms;

nb_trial= size(ts_evt,1);


TT_folder=[session_folder '\' summary(i_s).TT];
cd(TT_folder);


cl_name=[summary(i_s).TT '_cluster.' summary(i_s).cluster];


cluster= dlmread(cl_name,',', 13,0);[r_cluster,c_cluster]=size(cluster);ts_spk=cluster(:,18)/1000000; cluster=[];

PETH_=[];
figname=['PETH_20120415' cl_name '.png'];



ts_evt_new=[ts_evt(:,10) ts_evt(:,8) ts_evt(:,5) ts_evt(:,6) ts_evt(:,12)];  % Make a new matrix of timestamps with key events of our interest.
% session_start \ obj_appearance \ obj_touch\ disc_touch\ sensor2_end
selection_1 = find(trial_object==0);
selection_2 = find(trial_object==1);
selection_3 = find(trial_side==0);
selection_4 = find(trial_side==1);
selection_5 = find(trial_corr==0);
selection_6 = find(trial_corr==1);
selection_7 = find(trial_object==0 & trial_corr==1);
selection_8 = find(trial_object==1 & trial_corr==1);
selection_9 = find(trial_object==0 & trial_corr==0);
selection_10= find(trial_object==1 & trial_corr==0);


ref_evt= 3;


%% Color coding of the events

PETH_color_parms;

prefix=sprintf('%s_%s_%s_%s_%s_cluster.%s',summary(i_s).rat, summary(i_s).rec_session, summary(i_s).TT, summary(i_s).Region, summary(i_s).task_name, summary(i_s).cluster);;
suffix=sprintf('%d x %d ms',nb_bins,bin_size*1000);


debugmode=0;


%% GLOBAL PETH
fig_pos=[50 100 1000 1000];
f1=figure('name',[prefix suffix],'Color',[1 1 1],'Position',fig_pos);

r_plot=8;c_plot=10;

peth_1=[];peth_2=[];peth_3=[];peth_4=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



draw_mode=1;
subplot(r_plot,c_plot,[1:5 11:15]);
hold on
set(gca,'FontSize',6)
%                                              axis off
xlim([0 nb_bins*bin_size]);
%ylim([1 r_evt]);
y0=0;
peth_2=Draw_PETH2(ts_evt_new(selection_8,:),ref_evt,color_evt,ts_spk,nb_bins,bin_size,draw_mode,y0); %obj1
trial_nb_obj1= size(ts_evt_new(selection_8,:),1);
y0=y0+length(selection_8)+5;
peth_1=Draw_PETH2(ts_evt_new(selection_7,:),ref_evt,color_evt,ts_spk,nb_bins,bin_size,draw_mode,y0); %obj0
trial_nb_obj0= size(ts_evt_new(selection_7,:),1);
hold off

subplot(r_plot,c_plot,[21:25])
half_PETH_size=(floor(nb_bins/2)*bin_size);

xlim([-half_PETH_size half_PETH_size]);

Draw_PETH3(ts_evt_new([selection_7' selection_8'],:),ref_evt,color_evt,nb_bins,bin_size,peth_1,peth_2,f1,1); % obj0 blue & obj1 red

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear peth_1 peth_2


subplot(r_plot,c_plot,[6:10 16:20]);

draw_mode=1;
hold on
set(gca,'FontSize',6)
%                                             axis off
xlim([0 nb_bins*bin_size]);
%ylim([1 r_evt]);
y0=0;
peth_4=Draw_PETH2(ts_evt_new(selection_5,:),ref_evt,color_evt,ts_spk,nb_bins,bin_size,draw_mode,y0); %incorr
trial_nb_incorr= size(peth_4,1);
y0=y0+length(selection_6)+5;
peth_3=Draw_PETH2(ts_evt_new(selection_6,:),ref_evt,color_evt,ts_spk,nb_bins,bin_size,draw_mode,y0); %corr
trial_nb_corr= size(peth_3,1);
hold off


%% We get the firing rate & total number of spikes of that session with
%% correct vs. incorrect peth

m1=nan;m2=nan;
if ~isempty(peth_3), m1=mean(peth_3./bin_size); end
if ~isempty(peth_4), m2=mean(peth_4./bin_size); end

Total_nb_spk= sum(sum(peth_3)) + sum(sum(peth_4))
Session_FR=nanmean([m1 m2])



%% Get the maximum value of the total firing
%% rate

peth_total = [peth_4; peth_3];
Fr_total= peth_total./bin_size;
Fr_max= max(mean(Fr_total));
Fr_ylim = ceil(Fr_max/5)*5;

clear peth_total Fr_total

subplot(r_plot,c_plot,[26:30])
half_PETH_size=(floor(nb_bins/2)*bin_size);

xlim([-half_PETH_size half_PETH_size]);

Draw_PETH3(ts_evt_new([selection_5' selection_6'],:),ref_evt,color_evt,nb_bins,bin_size,peth_3,peth_4,f1,0);

clear peth_3 peth_4


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% INDIVIDUALS PETH
% those are the median interval between sensor activities


% sensor2_1(obj_appearance)-sensor4_1(startboxexit)
% obj_touch - obj_appearance
% disc_touch - obj_touch
% sensor2(end)-disc_touch


% med_ts(1)= median(ts_evt(:,8) - ts_evt(:,10))= 1.2139
% med_ts(2)= median(ts_evt(:,5)  - ts_evt(:,8))= 1.5278
% med_ts(3)= median(ts_evt(:,6)  - ts_evt(:,5))= 0.9585
% med_ts(4)= median(ts_evt(:,12)  - ts_evt(:,6))= 3.3354

%                         msg= sprintf('med_t1 = %1.2f', t1); disp(msg); % 1.2139
%                         msg= sprintf('med_t2 = %1.2f', t2); disp(msg); % 1.5278
%                         msg= sprintf('med_t3 = %1.2f', t3); disp(msg); % 0.9585
%                         msg= sprintf('med_t4 = %1.2f', t4); disp(msg); % 3.3354


%% PETH centered at each event

nb_bins_(1)=20;
bin_size_(1)=0.05;
nb_bins_(2)=20;
bin_size_(2)=0.05;
nb_bins_(3)=20;
bin_size_(3)=0.05;
nb_bins_(4)=20;
bin_size_(4)=0.05;
nb_bins_(5)=40;
bin_size_(5)=0.05;


session_start=nanmin(nanmin(ts_evt_new));
session_stop=nanmax(nanmax(ts_evt_new));
pool=[];


peth_cond1=[];
peth_cond2=[];
peth_corr=[];
peth_incorr=[];


%% baseline based on boostrap
baseline = PETH_BootstrappedBaseline(ts_spk,nb_bins_(1),bin_size_(1),session_start,session_stop);
[r,c]=size(baseline);
baseline=reshape(baseline,1,r*c);
m_base=mean(baseline);
std_base=std(baseline);
clear baseline

%% P-values for different conditions and events

peth_cond1=[];peth_cond2=[];peth_corr=[];peth_incorr=[];
chance_obj0=nan(5,1);chance_obj1=nan(5,1);chance_corr=nan(5,1);chance_incorr=nan(5,1);
above_cond1=nan(5,4);above_cond2=nan(5,4);above_corr=nan(5,4);above_incorr=nan(5,4);

p_obj0=nan(5,1);p_obj1=nan(5,1);p_corr=nan(5,1);p_incorr=nan(5,1);
SR_p_correctness=nan(5,1);KS_p_correctness=nan(5,1);
SR_p_obj=nan(5,1); KS_p_obj=nan(5,1);


%% The number of spikes for different conditions and events.

nb_spk_obj0_l =[]; nb_spk_obj0_r =[];
nb_spk_obj1_l =[]; nb_spk_obj1_r =[];
nb_spk_corr_l =[]; nb_spk_corr_r =[];
nb_spk_incorr_l =[]; nb_spk_incorr_r =[];
nb_spk_l=[];
nb_spk_r=[];




%%% Conditional PETH (obj 0)


y0=0;
for ref_evt=1:5
    
    subplot(r_plot,c_plot,30+ref_evt)    % object 0 (barney)
    hold on
    set(gca,'FontSize',6)
    xlim([0 nb_bins_(ref_evt)*bin_size_(ref_evt)]);
    peth_obj0=Draw_PETH2(ts_evt_new(selection_7',:),ref_evt,color_evt,ts_spk,nb_bins_(ref_evt),bin_size_(ref_evt),draw_mode,y0); % nb of spikes
    peth_=peth_obj0./bin_size_(ref_evt);  %% firing rate
    
    nb_spk_obj0_l(ref_evt)= nansum(nansum(peth_obj0(:,1:nb_bins_(ref_evt)/2)));
    nb_spk_obj0_r(ref_evt)= nansum(nansum(peth_obj0(:,(nb_bins_(ref_evt)/2)+1:end)));
    
    peth_cond1=[peth_cond1 peth_];
    hold off
    
end



%%% FR Histogram (obj0)



for ref_evt= 1:5
    
    fr_max_obj0= max(mean(peth_cond1));
    subplot(r_plot,c_plot,40+ref_evt);
    set(gca,'FontSize',6, 'ylim', [-2 Fr_ylim])
    hold on
    [p_obj0(ref_evt) chance_obj0(ref_evt),i_max_sup_succ,i_max_inf_succ,max_sup_succ,max_inf_succ]= ...
        PETH_Comparison_method4(peth_cond1(:,20*(ref_evt-1)+1: nb_bins_(ref_evt)+20*(ref_evt-1)),nb_bins_(ref_evt),bin_size_(ref_evt),m_base,std_base);
    above_cond1(ref_evt,1)=i_max_sup_succ;
    above_cond1(ref_evt,3)=max_sup_succ;
    above_cond1(ref_evt,2)=i_max_inf_succ;
    above_cond1(ref_evt,4)=max_inf_succ;
    hold off
end





%%% Conditional PETH (obj1)



y0=0;
for ref_evt=1:5
    
    subplot(r_plot,c_plot,50+ref_evt)   % object 1  (egg)
    hold on
    set(gca,'FontSize',6)
    xlim([0 nb_bins_(ref_evt)*bin_size_(ref_evt)]);
    peth_obj1=Draw_PETH2(ts_evt_new(selection_8',:),ref_evt,color_evt,ts_spk,nb_bins_(ref_evt),bin_size_(ref_evt),draw_mode,y0);
    
    nb_spk_obj1_l(ref_evt)= nansum(nansum(peth_obj1(:,1:nb_bins_(ref_evt)/2)));
    nb_spk_obj1_r(ref_evt)= nansum(nansum(peth_obj1(:,(nb_bins_(ref_evt)/2)+1:end)));
    
    peth_= peth_obj1./bin_size_(ref_evt);
    
    peth_cond2=[peth_cond2 peth_];
    hold off
    
end


%%% FR Histogram (obj1)

for ref_evt= 1:5
    
    fr_max_obj1= max(mean(peth_cond2));
    subplot(r_plot,c_plot,60+ref_evt)
    set(gca,'FontSize',6, 'ylim', [-2 Fr_ylim])
    hold on
    [p_obj1(ref_evt) chance_obj1(ref_evt),i_max_sup_succ,i_max_inf_succ,max_sup_succ,max_inf_succ]= ...
        PETH_Comparison_method4(peth_cond2(:,20*(ref_evt-1)+1: nb_bins_(ref_evt)+20*(ref_evt-1)),nb_bins_(ref_evt),bin_size_(ref_evt),m_base,std_base);
    above_cond2(ref_evt,1)=i_max_sup_succ;
    above_cond2(ref_evt,3)=max_sup_succ;
    above_cond2(ref_evt,2)=i_max_inf_succ;
    above_cond2(ref_evt,4)=max_inf_succ;
    hold off
    
end


total_nb_spk_l = nb_spk_obj0_l + nb_spk_obj1_l
total_nb_spk_r = nb_spk_obj0_r + nb_spk_obj1_r



%%% Conditional PETH(correct)

y0=0;
for ref_evt=1:5
    
    subplot(r_plot,c_plot,35+ref_evt)
    hold on
    set(gca,'FontSize',6)
    xlim([0 nb_bins_(ref_evt)*bin_size_(ref_evt)]);
    peth_corr_spk=Draw_PETH2(ts_evt_new(selection_6',:),ref_evt,color_evt,ts_spk,nb_bins_(ref_evt),bin_size_(ref_evt),draw_mode,y0);
    
    nb_spk_corr_l(ref_evt)= nansum(nansum(peth_corr_spk(:,1:nb_bins_(ref_evt)/2)));
    nb_spk_corr_r(ref_evt)= nansum(nansum(peth_corr_spk(:,(nb_bins_(ref_evt)/2)+1:end)));
    
    peth_= peth_corr_spk./bin_size_(ref_evt);
    
    peth_corr=[peth_corr peth_];
    hold off
    
    
end



nb_spk_obj0_l(ref_evt)= nansum(nansum(peth_obj0(:,1:nb_bins_(ref_evt)/2)));
nb_spk_obj0_r(ref_evt)= nansum(nansum(peth_obj0(:,(nb_bins_(ref_evt)/2)+1:end)));


%%% FR Histogram (correct)

for ref_evt=1:5
    
    fr_max_corr= max(mean(peth_corr));
    subplot(r_plot,c_plot,45+ref_evt)
    set(gca,'FontSize',6, 'ylim', [-2 Fr_ylim])
    hold on
    [p_corr(ref_evt) chance_corr(ref_evt),i_max_sup_succ,i_max_inf_succ,max_sup_succ,max_inf_succ]= ...
        PETH_Comparison_method4(peth_corr(:,20*(ref_evt-1)+1: nb_bins_(ref_evt)+20*(ref_evt-1)),nb_bins_(ref_evt),bin_size_(ref_evt),m_base,std_base);
    above_corr(ref_evt,1)=i_max_sup_succ;
    above_corr(ref_evt,3)=max_sup_succ;
    above_corr(ref_evt,2)=i_max_inf_succ;
    above_corr(ref_evt,4)=max_inf_succ;
    hold off
    
    
end


%%% Conditional PETH(incorrect)

y0=0;
for ref_evt=1:5
    
    subplot(r_plot,c_plot,55+ref_evt)
    hold on
    set(gca,'FontSize',6)
    xlim([0 nb_bins_(ref_evt)*bin_size_(ref_evt)]);
    peth_incorr_spk=Draw_PETH2(ts_evt_new(selection_5',:),ref_evt,color_evt,ts_spk,nb_bins_(ref_evt),bin_size_(ref_evt),draw_mode,y0);
    
    nb_spk_incorr_l(ref_evt)= nansum(nansum(peth_incorr_spk(:,1:nb_bins_(ref_evt)/2)));
    nb_spk_incorr_r(ref_evt)= nansum(nansum(peth_incorr_spk(:,(nb_bins_(ref_evt)/2)+1:end)));
    
    
    peth_= peth_corr_spk./bin_size_(ref_evt);
    
    peth_incorr=[peth_incorr peth_];
    hold off
    
end

clear ts_spk
%%% FR Histogram (incorrect)

for ref_evt= 1:5
    
    fr_max_incorr= max(mean(peth_incorr));
    subplot(r_plot,c_plot,65+ref_evt)
    set(gca,'FontSize',6, 'ylim', [-2 Fr_ylim])
    hold on
    [p_incorr(ref_evt) chance_incorr(ref_evt),i_max_sup_succ,i_max_inf_succ,max_sup_succ,max_inf_succ]=...
        PETH_Comparison_method4(peth_incorr(:,20*(ref_evt-1)+1: nb_bins_(ref_evt)+20*(ref_evt-1)),nb_bins_(ref_evt),bin_size_(ref_evt),m_base,std_base);
    above_incorr(ref_evt,1)=i_max_sup_succ;
    above_incorr(ref_evt,3)=max_sup_succ;
    above_incorr(ref_evt,2)=i_max_inf_succ;
    above_incorr(ref_evt,4)=max_inf_succ;
    hold off
    
end




for ref_evt=1:5
    
    
    [SR_p_obj(ref_evt), KS_p_obj(ref_evt)]= PETH_Comparison_pval(peth_cond1(:,20*(ref_evt-1)+1: nb_bins_(ref_evt)+20*(ref_evt-1)),peth_cond2(:,20*(ref_evt-1)+1: nb_bins_(ref_evt)+20*(ref_evt-1)));
    
    
    
    
    subplot(r_plot,c_plot,70+ref_evt)
    axis off
    
    
    if chance_obj0(ref_evt)
        edge_col='m';
    else
        edge_col='k';
    end
    
    if nb_spk_obj0_l(ref_evt)+nb_spk_obj0_l(ref_evt) > 20    % Minimal number of spikes    (obj0)
        
        pval_obj0=p_obj0(ref_evt);
        if pval_obj0<0.001, pval_obj0=0.000; end
        bgcol=[1 0.6 0.6];                     % pink
        if pval_obj0<0.05, bgcol=[0.6 1 0.6]; end   % green
        msg=sprintf('p=%1.3f',pval_obj0);
        text(0.1,0.7,msg,'BackGroundColor',bgcol,'EdgeColor',edge_col,'Fontsize',6);
        
    else
        p_obj0(ref_evt)=NaN;
        pval_obj0=p_obj0(ref_evt);
        bgcol=[1 0.6 0.6];
        msg=sprintf('p=%1.3f',pval_obj0);
        text(0.1,0.7,msg,'BackGroundColor',bgcol,'EdgeColor',edge_col,'Fontsize',6);
    end
    
    
    
    
    
    if chance_obj1(ref_evt)
        edge_col='m';
    else
        edge_col='k';
    end
    
    
    if nb_spk_obj1_l(ref_evt)+nb_spk_obj1_l(ref_evt) > 20    % Minimal number of spikes  (obj1)
        
        pval_obj1=p_obj1(ref_evt);
        if pval_obj1<0.001, pval_obj1=0.000; end
        bgcol=[1 0.6 0.6];
        if pval_obj1<0.05, bgcol=[0.6 1 0.6]; end
        msg=sprintf('p=%1.3f',pval_obj1);
        text(0.1,0.5,msg,'BackGroundColor',bgcol,'EdgeColor',edge_col,'Fontsize',6);
        
    else
        p_obj1(ref_evt)=NaN;
        pval_obj1=p_obj1(ref_evt);
        bgcol=[1 0.6 0.6];
        msg=sprintf('p=%1.3f',pval_obj1);
        text(0.1,0.5,msg,'BackGroundColor',bgcol,'EdgeColor',edge_col,'Fontsize',6);
    end
    
    
    if ~ (isnan(pval_obj0) && isnan(pval_obj1))
        
        
        if SR_p_obj(ref_evt)<0.001, SR_p_obj(ref_evt)=0.000; end
        bgcol=[1 0.6 0.6];
        if SR_p_obj(ref_evt)<0.05, bgcol=[0.6 1 0.6]; end
        msg=sprintf('sr_p=%1.3f',SR_p_obj(ref_evt));
        text(0.1,0.3,msg,'BackGroundColor',bgcol,'Fontsize',6);
        
        
        if KS_p_obj(ref_evt)<0.001, KS_p_obj(ref_evt)=0.000; end
        bgcol=[1 0.6 0.6];
        if KS_p_obj(ref_evt)<0.05, bgcol=[0.6 1 0.6]; end
        msg=sprintf('ks_p=%1.3f',KS_p_obj(ref_evt));
        text(0.1,0.1,msg,'BackGroundColor',bgcol,'Fontsize',6);
        
    else
        SR_p_obj(ref_evt)= NaN;
        bgcol=[1 0.6 0.6];
        msg=sprintf('sr_p=%1.3f',SR_p_obj(ref_evt));
        text(0.1,0.3,msg,'BackGroundColor',bgcol,'Fontsize',6);
        
        KS_p_obj(ref_evt)= NaN;
        bgcol=[1 0.6 0.6];
        msg=sprintf('ks_p=%1.3f',KS_p_obj(ref_evt));
        text(0.1,0.1,msg,'BackGroundColor',bgcol,'Fontsize',6);
        
    end
    
    
    
end



for ref_evt=1:5
    
    [SR_p_correctness(ref_evt) KS_p_correctness(ref_evt)]= ...
        PETH_Comparison_pval(peth_corr(:,20*(ref_evt-1)+1: nb_bins_(ref_evt)+20*(ref_evt-1)),peth_incorr(:,20*(ref_evt-1)+1: nb_bins_(ref_evt)+20*(ref_evt-1)));
    
    
    
    
    subplot(r_plot,c_plot,75+ref_evt)
    axis off
    
    if chance_corr(ref_evt), edge_col='m'; else edge_col='k'; end
    
    
    if nb_spk_corr_l(ref_evt)+nb_spk_corr_r(ref_evt) > 20    % Minimal number of spikes    (corr)
        
        pval_corr=p_corr(ref_evt);
        if pval_corr<0.001, pval_corr=0.000; end
        bgcol=[1 0.6 0.6]; if pval_corr<0.05, bgcol=[0.6 1 0.6]; end
        msg=sprintf('p=%1.3f',pval_corr);
        text(0.1,0.7,msg,'BackGroundColor',bgcol,'EdgeColor',edge_col,'Fontsize',6);
        
    else
        p_corr(ref_evt)=NaN;
        pval_corr=p_corr(ref_evt);
        bgcol=[1 0.6 0.6];
        msg=sprintf('p=%1.3f',pval_corr);
        text(0.1,0.7,msg,'BackGroundColor',bgcol,'EdgeColor',edge_col,'Fontsize',6);
    end
    
    
    
    
    
    if chance_incorr(ref_evt), edge_col='m'; else edge_col='k'; end
    
    if nb_spk_incorr_l(ref_evt)+nb_spk_incorr_r(ref_evt) > 20    % Minimal number of spikes    (incorr)
        
        
        pval_incorr=p_incorr(ref_evt);
        if pval_incorr<0.001, pval_incorr=0.000; end
        bgcol=[1 0.6 0.6]; if pval_incorr<0.05, bgcol=[0.6 1 0.6]; end
        msg=sprintf('p=%1.3f',pval_incorr);
        text(0.1,0.5,msg,'BackGroundColor',bgcol,'EdgeColor',edge_col,'Fontsize',6);
        
    else
        p_incorr(ref_evt)=NaN;
        pval_incorr=p_incorr(ref_evt);
        bgcol=[1 0.6 0.6];
        msg=sprintf('p=%1.3f',pval_incorr);
        text(0.1,0.5,msg,'BackGroundColor',bgcol,'EdgeColor',edge_col,'Fontsize',6);
    end
    
    
    if ~ (isnan(pval_corr) && isnan(pval_incorr))
        
        
        if SR_p_correctness(ref_evt)<0.001, SR_p_correctness(ref_evt)=0.000; end
        bgcol=[1 0.6 0.6]; if SR_p_correctness(ref_evt)<0.05, bgcol=[0.6 1 0.6]; end
        msg=sprintf('sr_p=%1.3f',SR_p_correctness(ref_evt));
        text(0.1,0.3,msg,'BackGroundColor',bgcol,'Fontsize',6);
        
        
        if KS_p_correctness(ref_evt)<0.001, KS_p_correctness(ref_evt)=0.000; end
        bgcol=[1 0.6 0.6]; if KS_p_correctness(ref_evt)<0.05, bgcol=[0.6 1 0.6]; end
        msg=sprintf('ks_p=%1.3f',KS_p_correctness(ref_evt));
        text(0.1,0.1,msg,'BackGroundColor',bgcol,'Fontsize',6);
        
        
        
    else
        SR_p_correctness(ref_evt)= NaN;
        bgcol=[1 0.6 0.6];
        msg=sprintf('sr_p=%1.3f',KS_p_correctness(ref_evt));
        text(0.1,0.3,msg,'BackGroundColor',bgcol,'Fontsize',6);
        
        KS_p_correctness(ref_evt)= NaN;
        bgcol=[1 0.6 0.6];
        msg=sprintf('ks_p=%1.3f',KS_p_correctness(ref_evt));
        text(0.1,0.1,msg,'BackGroundColor',bgcol,'Fontsize',6);
    end
    
    
end



peth_cond1=[];
peth_cond2=[];
peth_corr=[];
peth_incorr=[];




Session_FR,Total_nb_spk, nb_trial, trial_nb_obj0, trial_nb_obj1, trial_nb_corr, trial_nb_incorr, memory

%                             pause

%% Output file generation
cd([dataROOT '\Analysis\PETH']);

fod=fopen(outputfile,'a');
fprintf(fod,'%s \t%s \t%s \t%s \t%s \t%f \t%d \t%d \t%d \t%d \t%d \t%d', rat,session, cl_name, task, region, Session_FR,Total_nb_spk, nb_trial, trial_nb_obj0, trial_nb_obj1, trial_nb_corr, trial_nb_incorr);

for ref_evt=1:5
    fprintf(fod,'\t%d\t%f',nb_bins_(ref_evt),bin_size_(ref_evt));
    fprintf(fod,'\t%d\t%d\t%d\t%d',chance_obj0(ref_evt),chance_obj1(ref_evt),chance_corr(ref_evt),chance_incorr(ref_evt));
    fprintf(fod,'\t%d\t%d\t%d\t%d\t%d\t%d', nb_spk_obj0_l(ref_evt), nb_spk_obj0_r(ref_evt), nb_spk_obj1_l(ref_evt),nb_spk_obj1_r(ref_evt),total_nb_spk_l(ref_evt),total_nb_spk_r(ref_evt));         % nb of spks
    fprintf(fod,'\t%1.4f \t%1.4f \t%1.4f \t%1.4f',p_obj0(ref_evt), p_obj1(ref_evt), p_corr(ref_evt), p_incorr(ref_evt));
    fprintf(fod,'\t%1.4f\t%1.4f',SR_p_obj(ref_evt),SR_p_correctness(ref_evt));
    fprintf(fod,'\t%1.4f\t%1.4f',KS_p_obj(ref_evt) ,KS_p_correctness(ref_evt));
    
end
fprintf(fod, '\n');
fclose('all');
%                             pause

saveImage(f1,[ date '-' prefix '_' suffix '.png'],fig_pos);
%                             close all

end


fclose('all');
end






