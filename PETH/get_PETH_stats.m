%%  Statistical testing (ANOVA, two sample t test, ranksum test)

pvalue= 0.05;

ttest_pval=[]; ttest_sig=[];
rs_pval=[]; rs_sig=[];
anova_pval= []; %% ANOVA
anova_sig = [];
sig_mat= [];


if strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
    
    
    %%  Statistical testing (ANOVA with object and response as factor)
    
    
    anova_pval= anovan(trial_fr,{ts_evt(:,Stimulus), ts_evt(:,Response)}, 'model', 'full',...
        'varnames',{'Stimulus';'Response'},'display','off');
    
    
    anova_sig= anova_pval< pvalue;
    
    
elseif strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
    
    
    [ttest_sig.Familiar ttest_pval.Familiar]=  ttest2(trial_fr(select.Stimulus1_Corr),trial_fr(select.Stimulus2_Corr));
    [ttest_sig.Novel ttest_pval.Novel]=  ttest2(trial_fr(select.Stimulus3_Corr),trial_fr(select.Stimulus4_Corr));
    
    
    [rs_pval.Familiar rs_sig.Familiar] = ranksum(trial_fr(select.Stimulus1_Corr),trial_fr(select.Stimulus2_Corr));
    [rs_pval.Novel rs_sig.Novel] = ranksum(trial_fr(select.Stimulus3_Corr),trial_fr(select.Stimulus4_Corr));
    
    
    %%  Statistical testing (two sample t test, ranksum test) between the pair of OBJects that share the same behavioral response
    %%  Select the test results between the pair that gives better differentiation.
    
    
    [ttest_sig.Pushing ttest_pval.Pushing]=  ttest2(trial_fr(select.Stimulus1_Corr),trial_fr(select.Stimulus3_Corr));
    [ttest_sig.Digging ttest_pval.Digging]=  ttest2(trial_fr(select.Stimulus2_Corr),trial_fr(select.Stimulus4_Corr));
    
    
    [rs_pval.Pushing rs_sig.Pushing] = ranksum(trial_fr(select.Stimulus1_Corr),trial_fr(select.Stimulus3_Corr));
    [rs_pval.Digging rs_sig.Digging] = ranksum(trial_fr(select.Stimulus2_Corr),trial_fr(select.Stimulus4_Corr));
    
    ttest_pval.CAT = min(ttest_pval.Pushing, ttest_pval.Digging);
    rs_pval.CAT = min(rs_pval.Pushing, rs_pval.Digging);
    
    
    ttest_sig.CAT = or(ttest_sig.Pushing, ttest_sig.Digging);
    rs_sig.CAT = or(rs_sig.Pushing, rs_sig.Digging);
    
    
    %%  Statistical testing (Two-way ANOVA with response and category as factor)
    
    %             pval_anova= anovan(epoch_anova_mat(:,firing_rate),{epoch_anova_mat(:,object_CAT), epoch_anova_mat(:,correctness)}, 'model', 'full',...
    %                 'varnames',{'CATegory';'correctness'},'display','off');
    
    
    anova_pval = anovan(trial_fr(select.Corr,:), {ts_evt(select.Corr,Response), ts_evt(select.Corr,StimulusCAT)}, 'model', 'full',...
        'varnames',{'Response';'CATegory'},'display','off');
    
    
    sig_mat =( anova_pval < pvalue);
    anova_sig.Resp = sig_mat(1);
    anova_sig.CAT = sig_mat(2);
    anova_sig.Int  = sig_mat(3);
    
    
    
elseif strcmp(summary(i_s).Task_name,'OCRS(Modality)')
    
    
    [ttest_sig.VT ttest_pval.VT]=  ttest2(trial_fr(select.Stimulus1_VT_Corr),trial_fr(select.Stimulus2_VT_Corr));
    [ttest_sig.Visual ttest_pval.Visual]=  ttest2(trial_fr(select.Stimulus1_Vis_Corr),trial_fr(select.Stimulus2_Vis_Corr));
    [ttest_sig.Tactile ttest_pval.Tactile]=  ttest2(trial_fr(select.Stimulus1_Tact_Corr),trial_fr(select.Stimulus2_Tact_Corr));
    
    
    [rs_pval.VT rs_sig.VT] = ranksum(trial_fr(select.Stimulus1_VT_Corr),trial_fr(select.Stimulus2_VT_Corr));
    [rs_pval.Visual rs_sig.Visual] = ranksum(trial_fr(select.Stimulus1_Vis_Corr),trial_fr(select.Stimulus2_Vis_Corr));
    [rs_pval.Tactile rs_sig.Tactile] = ranksum(trial_fr(select.Stimulus1_Tact_Corr),trial_fr(select.Stimulus2_Tact_Corr));
    
    
    
    %%  Statistical testing (One-way ANOVA with modality as factor)
    
    
    %     anova_pval= anovan(trial_fr, {ts_evt(:,StimulusCAT), ts_evt(:,Correctness)}, 'model', 'full',...
    %         'varnames',{'Correctness';'Modality'},'display','off');
    
    anova_pval.Pushing = anovan(trial_fr(select.Pushing_Corr,:), {ts_evt(select.Pushing_Corr,StimulusCAT)}, 'model', 'full',...
        'varnames',{'Modality'},'display','off');
    
    
    anova_pval.Digging = anovan(trial_fr(select.Digging_Corr,:), {ts_evt(select.Digging_Corr,StimulusCAT)}, 'model', 'full',...
        'varnames',{'Modality'},'display','off');
    
    if (anova_pval.Pushing < pvalue || anova_pval.Digging < pvalue)
        
        anova_sig = 1;
    else
        anova_sig = 0;
    end
    
    anova_pval= min(anova_pval.Pushing, anova_pval.Digging);
    
    
    
elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
    
    select.Scene = find(ts_evt(:,StimulusCAT)==SceneCAT);
    select.OBJ= find(ts_evt(:,StimulusCAT)==OBJCAT);
    
    
    
    [ttest_sig.Scene ttest_pval.Scene]=  ttest2(trial_fr(select.Stimulus1_Corr),trial_fr(select.Stimulus2_Corr));
    [ttest_sig.OBJ ttest_pval.OBJ]=  ttest2(trial_fr(select.Stimulus3_Corr),trial_fr(select.Stimulus4_Corr));
    
    
    [rs_pval.Scene rs_sig.Scene] = ranksum(trial_fr(select.Stimulus1_Corr),trial_fr(select.Stimulus2_Corr));
    [rs_pval.OBJ rs_sig.OBJ] = ranksum(trial_fr(select.Stimulus3_Corr),trial_fr(select.Stimulus4_Corr));
    
    
    
    %%  Statistical testing (two sample t test, ranksum test) between stimuli that share the same behavioral response (OBJ vs. Scene)
    %%  Select the test results between the pair that gives better differentiation.
    
    
    [ttest_sig.Pushing ttest_pval.Pushing]=  ttest2(trial_fr(select.Stimulus1_Corr,end),trial_fr(select.Stimulus3_Corr,end));
    [ttest_sig.Digging ttest_pval.Digging]=  ttest2(trial_fr(select.Stimulus2_Corr,end),trial_fr(select.Stimulus4_Corr,end));
    
    
    [rs_pval.Pushing rs_sig.Pushing] = ranksum(trial_fr(select.Stimulus1_Corr,end),trial_fr(select.Stimulus3_Corr,end));
    [rs_pval.Digging rs_sig.Digging] = ranksum(trial_fr(select.Stimulus2_Corr,end),trial_fr(select.Stimulus4_Corr,end));
    
    ttest_pval.CAT = min(ttest_pval.Pushing, ttest_pval.Digging);
    rs_pval.CAT = min(rs_pval.Pushing, rs_pval.Digging);
    
    
    ttest_sig.CAT = or(ttest_sig.Pushing, ttest_sig.Digging);
    rs_sig.CAT = or(rs_sig.Pushing, rs_sig.Digging);
    
    
    anova_pval = anovan(trial_fr(select.Corr,:), {ts_evt(select.Corr,Response), ts_evt(select.Corr,StimulusCAT)}, 'model', 'full',...
        'varnames',{'Response';'CATegory'},'display','off');
    
    
    sig_mat =( anova_pval < pvalue);
    anova_sig.Resp = sig_mat(1);
    anova_sig.CAT = sig_mat(2);
    anova_sig.Int  = sig_mat(3);
    
    
    % elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
    
end
