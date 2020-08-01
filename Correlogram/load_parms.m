%% By Jaerong
%% PETH parameter setting
%% Revised for PRC & POR by 2015/09/24
PETH=[];
PETH_FR= [];
PETH_FR_smoothed = [];


%% Bin size & number
nb_bins=80;bin_size=0.10; % sec
% nb_bins=40;bin_size=0.1; % sec
% nb_bins=60;bin_size=0.1; % sec

%% Number of time bins for normalized SDF (2016/10/09)

nb_win=30;
% nb_win=20;


draw_mode=1;
marker_size=3;
marker_color={'r','b','g'};

Stimulus_color = [0 0 0; 153 153 153; 95 175 80; 180 150 10]./255;

half_PETH_size=(floor(nb_bins/2)*bin_size);
PETH_winsize= 4;



%% FR criteria
% fr_criteria= 1;  %% (in Hertz) firing rate criteria
fr_criteria= 0.5;  %% (in Hertz) firing rate criteria


%% Fig parms
bgcol=[1 0.6 0.6; 0.6 1 0.6];
txt_size= 10;
r_plot=7;c_plot=4;
%         reshape([1:r_plot*c_plot],c_plot,r_plot)'
% fig_pos= [177,174,750,900]; %lab computer
fig_pos= [350,100,1160,900]; %lab computer


%% Gaussian window for convolution
gaussFilter = gausswin(10);
gaussFilter = gaussFilter/sum(gaussFilter);


%% AUC parms
bootstrap_nb=10;
AUC_std_criteria= 3; % over 3s.d.
consecutive_crit= 3;  % Required number of consecutive numbers following a first one




