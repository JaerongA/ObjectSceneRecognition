%% PETH parameter setting
%% Revised for PRC & POR by 2015/09/24


% PETH_StimulusOnset=1; PETH_Choice=2;
PETH=[];

%% Bin size & number

nb_bins=80;bin_size=0.10; % sec
% nb_bins=40;bin_size=0.1; % sec
% nb_bins=60;bin_size=0.1; % sec

%% Number of time bins for normalized SDF (2016/10/09)

nb_win=30;
% nb_win=20;


draw_mode=1;
marker_size=3;
markers = {'o','o','o'};
marker_color={'r','b','g'};

% Stimulus_color = [0 0 0; 153 153 153; 165 190 100; 220 210 10]./255;
Stimulus_color = [43 87 167; 87 200 223; 238 50 45; 246 141 51]./255;   %% revision 2018/03/26

half_PETH_size=(floor(nb_bins/2)*bin_size);
PETH_winsize= 4;



%% FR criteria
fr_criteria= 1;  %% (in Hertz) firing rate criteria


%% Fig parms
bgcol=[1 0.6 0.6; 0.6 1 0.6];
txt_size= 12;
r_plot=7;c_plot=8;
%         reshape([1:r_plot*c_plot],c_plot,r_plot)'
% fig_pos= [177,174,750,900]; %lab computer
fig_pos= [140,130,1300,900]; %lab computer
% fig_pos= [140,130,850,600]; %lab computer


%% Gaussian window for convolution

gaussFilter = gausswin(10);
gaussFilter = gaussFilter/sum(gaussFilter);
