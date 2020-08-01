cd 'I:\PRh-OCSD\Analysis\sigmoidal_fit';
load cluster_analysis

% idx1 = kmeans(sampling_corr,2)
sampling_red= ones(size(sampling_corr_red,1),1);
samplg_green= ones(size(sampling_corr_green,1),1)*2;
idx1= [sampling_red; samplg_green]
[S1,H] = silhouette(sampling_corr, idx1);
sampling_sil= mean(S1)

% idx2 = kmeans(sampling_corr,2)
choice_red= ones(size(choice_corr_red,1),1);
choice_green= ones(size(choice_corr_green,1),1)*2;
idx2= [choice_red; choice_green]
[S2,H] = silhouette(choice_corr, idx2);
choice_sil= mean(S2)

