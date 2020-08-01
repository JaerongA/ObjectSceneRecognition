%% By AJR 2017/02/08
%% Get cumulative performance vector
%% Enter binary performance vector as an input

function  [Learning_curve Learning_curve_lowerCI Learning_curve_upperCI] = get_latent_learning(Corr_mat, startP, matbugROOT)

%put matlab data in format for matbugs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


dataStruct = struct('n', Corr_mat, 'T', length(Corr_mat), 'startp', startP);

%initial guesses for the MC chains%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3 chains
init1 = struct( 'tau', 0.5);
init2 = struct( 'tau', 1);
init3 = struct( 'tau', 1.5);

initStructs(1) =  init1;
initStructs(2) =  init2;
initStructs(3) =  init3;


%call Winbugs from in Matlab using matbugs.m%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%matbugs.m is available free from
%http://www.cs.ubc.ca/~murphyk/Software/MATBUGS/matbugs.html

[samples, stats, structArray] = matbugs(dataStruct, ...
    fullfile(matbugROOT, 'Model_bern.txt'), ...
    'init', initStructs, ...
    'nChains', 3, ...
    'view', 0, 'nburnin', 1000, 'nsamples', 5000, ...
    'thin', 10, ...
    'monitorParams', {'p','x','tau','tauprior','sigesq'}, ...
    'Bugdir', 'C:/Program Files/WinBUGS14');

%plot Pr(correct response) (Figure 1 in Smith, Frank, et al. 2004)%%%%%%%%%

pdata =[];
for t = 1:length(Corr_mat)
    allsamples   = [samples.p(1,:,t) samples.p(2,:,t) samples.p(3,:,t)];
    sort_samples = sort(allsamples);
    total        = length(sort_samples);
    ll           = sort_samples(fix(0.05*total));  %lower 95%interval
    ml           = sort_samples(fix(0.5*total));
    ul           = sort_samples(fix(0.95*total));
    pdata = [pdata; t ll ml ul];
end
        

Learning_curve= pdata(:,3);
Learning_curve_upperCI= pdata(:,4);
Learning_curve_lowerCI= pdata(:,2);


end