%% Revised for PRC & POR study by Jaerong 2015/09/21 
%% INITIALIZATION

clc; clear all; close all;

%% VARIABLE & FILE NAME DECLARATION

% dataROOT='E:\PRC_POR_ephys';
% ToolboxROOT='E:\PRC-POR_ephys_toolbox';


dataROOT='H:\PRC_POR_ephys';  %% home
ToolboxROOT='H:\PRC-POR_ephys_toolbox';


summary_path=[dataROOT '\Analysis\Summary'];
% summaryTXT_filename='Cluster_summary.txt';  %% We read from this file
% summary_newTXTname='Cluster_summary_final.txt';   %% The file to be generated 
% 
% 

%% Only includes neurons used in the study
% summaryTXT_filename='Cluster_summary(FourOBJ).txt';  %% We read from this file
% summary_newTXTname='Cluster_summary_final(FourOBJ).txt';   %% The file to be generated 
% summary_MATname='Clustercutting_summary.mat';


%% Includes all the neurons recorded in the task
% summaryTXT_filename='Cluster_summary(FourOBJ_ALL).txt';  %% We read from this file
% summary_newTXTname='Cluster_summary_final(FourOBJ_ALL).txt';   %% The file to be generated 
% summary_MATname='Clustercutting_summary.mat';


summaryTXT_filename='Cluster_summary(SceneOBJ).txt';  %% We read from this file
summary_newTXTname='Cluster_summary_final(SceneOBJ).txt';   %% The file to be generated 
summary_MATname='Clustercutting_summary.mat';


% Ntt_Extractor(session_folder)

%% LOAD THE SUMMARY


 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Epoch FR filter 2016/11/04
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
% 
% disp('Loading Summary TXT file'); 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%   
% [summary,summary_header]= Summary_Epoch_FR(summary, summary_header, dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);
% disp('END');







% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Unit Profiler
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% disp('Loading Summary TXT file'); 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% [summary,summary_header]= Get_unit_profiler(summary, summary_header, dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);
% % % 
% %%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Get cluster plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % 
% % 
% disp('Loading Summary TXT file'); 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% [summary,summary_header]= Get_cluster_plane(summary, summary_header, dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);
% % % % 





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the proportion of zero spike trials (for repetition suppression
% effect).
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% disp('Loading Summary TXT file'); 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% [summary,summary_header]= Get_zero_trial_proportion(summary, summary_header, dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);
% % % % 





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Examine unit stability during a behavioral period (2017/06/30)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% disp('Loading Summary TXT file'); 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% [summary,summary_header]= Summary_Get_Stability(summary, summary_header, dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);
% % % 




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Print out the quality criteria 1 for units that passed the quality criteria 
% (stability ok & zero spike trial proportion < 50%, firing rate >= 0.5 Hz)  2018/05/26
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% disp('Loading Summary TXT file'); 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% [summary,summary_header]= Summary_QualityOK(summary, summary_header, dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program for examining the repetition suppression effect (Correct Trial
% Only)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% [summary,summary_header]= Summary_Get_Repetition_Suppression(summary, summary_header, dataROOT);
% 
% disp('Saving The new TXT File');
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);
% disp('END');





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program for examining the repetition suppression effect 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% [summary,summary_header]= Summary_Get_Repetition_Suppression_All(summary, summary_header, dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);
% disp('END');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Get raster plots and peri-event time histograms (PETH)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

% disp('Loading Summary TXT file');
% addpath([ToolboxROOT '\PETH']);
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% Summary_GetPETH(summary, summary_header, dataROOT);
% % Summary_GetPETH_onset(summary, summary_header, dataROOT);
% 
% disp('END');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get event specificity PETH for 2nd revision in CR (2018/10/05)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% disp('Loading Summary TXT file');
% addpath([ToolboxROOT '\PETH']);
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% Summary_evtRaster(summary, summary_header, dataROOT);
% 
% disp('END');







% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Get raster plots and peri-event time histograms (PETH)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

% disp('Loading Summary TXT file');
% addpath([ToolboxROOT '\AUC']);
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% Summary_AUC(summary, summary_header, dataROOT);
% % Summary_AUC_incorr(summary, summary_header, dataROOT);
% 
% disp('END');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get AUC and discrimination index based on bootstrapped baseline  %% 2017/10/22
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% addpath([ToolboxROOT '\AUC']);
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% Summary_AUC_bootstrap(summary, summary_header, dataROOT);
% 
% disp('END');





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Get population AUC
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% disp('Loading Summary TXT file');
% addpath([ToolboxROOT '\AUC']);
% 
% Population_AUC(dataROOT);
% 
% disp('END');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get population vector (based on time-normalized firing rate)
%% 2016/11/06
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% disp('Loading Summary TXT file');
% addpath([ToolboxROOT '\Population']);
% 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% Get_pop_PETH(summary, summary_header, dataROOT)
% 
% disp('END');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get population vector matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% disp('Loading Summary TXT file');
% addpath([ToolboxROOT '\Population']);
% 
% Population_vector(dataROOT);
% 
% disp('END');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program for examining the repetition suppression effect (first two trials)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% [summary,summary_header]= Summary_Get_Repetition_Suppression_twotrial(summary, summary_header, dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);




% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %% CrossCorrelogram 2017/01/16
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% disp('Loading Summary TXT file');
% addpath([ToolboxROOT '\Correlogram']);
% 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% Summary_Correlogram(summary, summary_header, dataROOT)
% 
% disp('END');
% 




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Object firing rates 2018/05/27  for CR revisions
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% 
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
%  
% Summary_OBJ_FR(summary, summary_header, dataROOT)
% 
% disp('END');

