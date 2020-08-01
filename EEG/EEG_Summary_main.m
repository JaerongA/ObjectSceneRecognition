%% ****************************
%% Created by Jaerong (2017/02/22)
%% INITIALIZATION
%% ****************************

clc;clear all; close all;

%% ****************************
%% VARIABLE & FILE NAME DECLARATION
%% ****************************

% dataROOT='E:\PRC_POR_ephys';
% ToolboxROOT='E:\PRC-POR_ephys_toolbox';


dataROOT='H:\PRC_POR_ephys';  %% home
ToolboxROOT='H:\PRC-POR_ephys_toolbox';


%% EEG summary

summary_path=[dataROOT '\Analysis\Summary'];
% cd(summary_path);
% summaryTXT_filename_eeg ='EEG_summary(FourOBJ).txt';  %%We read from this file
summaryTXT_filename_eeg ='EEG_summary(FourOBJ)_2ndRevision.txt';  %%We read from this file
summary_newTXTname_eeg ='EEG_summary_final(FourOBJ).txt';   %%The file to be generated
summary_MATname_eeg ='EEG_summary(FourOBJ).mat';


%% Cluster summary

summaryTXT_filename='Cluster_summary(FourOBJ).txt';  %%We read from this file
summary_newTXTname='Cluster_summary_final(FourOBJ).txt';   %%The file to be generated
% summaryTXT_filename='Cluster_summary(FourOBJ_ALL).txt';  %%We read from this file
% summary_newTXTname='Cluster_summary_final(FourOBJ_ALL).txt';   %%The file to be generated
summary_MATname='Clustercutting_summary.mat';








%% LOAD THE SUMMARY


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Get ADBitVolts (2017/09/19)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_ADBitmicrovolts(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%   Get the number of trials where the EEG maxed out
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_maxout_trials(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Noise filtering (2017/09/20) for making scs file used for analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary,summary_header_eeg]= EEG_noise_filtering(summary, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary,summary_header_eeg,summary_newTXTname_eeg);




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%  Get power ratio for channel selection
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_power_ratio(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);






% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  Get power and normalized power for theta and highgamma (2018/05/22 for
% %  CR revision)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_power_revision(summary_eeg, summary_header_eeg,dataROOT)
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Plot the PSD from HIPP and PER on the same plot for 2nd revision in CR
%  (2018/10/03)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_PSD_interregion(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Plot the PSD from HIPP and PER on the same plot for 2nd revision in CR
%  (2018/10/17)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_PSD_novelty(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Get crosscorrelation (2018/06/13) %% for CR revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_crosscorr(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%   Get crosscorrelation (2018/09/27) %% for 2nd revision in CR
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_crosscorr_nonnorm(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);
% 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Get crosscorrelation based on filtered signal (2018/10/18) %% for 2nd revision in CR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Loading Summary TXT file');
[summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);

[summary_eeg,summary_header_eeg]= EEG_crosscorr_filtered(summary_eeg, summary_header_eeg,dataROOT)

disp('Saving The new TXT File');
cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%   Get crosscorrelation and compare between within-region and bet-region
% %%%   values  ll                                                
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_crosscorr_comp(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%   Get phase-locking (2017/09/18)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% EEG_phaselocking_ALL(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT);
% disp('END');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%   Get phase-locking (2017/09/18) compare correct and incorrect
%%%%%%   trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% EEG_phaselocking_perf(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT);
% disp('END');




% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%   Get phase-locking (2018/01/18) compare novel and familiar objects
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% disp('Loading Summary TXT file');
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% EEG_phaselocking_novelty(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT);
% disp('END');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Get phase-locking (2018/03/05) compare the pruning between
%%%%   novel/familiar objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% EEG_phaselocking_novelty_half(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT);
% % EEG_phaselocking_novelty_half_ALL(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT);
% disp('END');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Determine if a unit is suitable for use in the phaselocking analysis (# of spikes >= 30 in the smaller half of the session)
%% Write the information to a summary file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary,summary_header] = EEG_phaselocking_repetitionOK(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT);
% disp('Saving The new TXT File');
% 
% cd(summary_path);Summary_mat2txt(summary,summary_header,summary_newTXTname);
% disp('END');




% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   Get phase-locking BestOBJ (2017/10/13) using the best-fitting object
% %   only  (Used for the manuscript)
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% EEG_phaselocking_BestOBJ(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT);
% disp('Saving The new TXT File');
% 
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);
% disp('END');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Get phase-locking BestOBJ during the baseline period (for CR revision 2018/06/06)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% EEG_phaselocking_BestOBJ_baseline(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT);
% disp('Saving The new TXT File');
% 
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);
% disp('END');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Examine the effect of repetition on the eeg power 2017/09/01
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_repetition_effect_novelty(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Make a stacked spectrogram (2017/09/25)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_spectrogram_repetition_stack_norm(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%  Examine the effect of repetition on the spectrogram  2017/09/05
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_spectrogram_repetition_v2(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Examine the effect of repetition on the spectrogram  2017/09/05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_spectrogram(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  CFC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]= EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% [summary_eeg,summary_header_eeg]= EEG_crossfreq(summary_eeg, summary_header_eeg,dataROOT)
% 
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);






% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%   Get coherence (2017/09/13)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% disp('Loading Summary TXT file');
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
%
% [summary_eeg,summary_header_eeg]= EEG_coherogram(summary_eeg, summary_header_eeg,dataROOT)
%
% disp('Saving The new TXT File');
% cd(summary_path);EEG_Summary_mat2txt(summary_eeg,summary_header_eeg,summary_newTXTname_eeg);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Get phase-locking OBJ (2017/10/17) using the spikes from all
%%%   significant objects.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% disp('Loading Summary TXT file');
% [summary,summary_header]= Summary_txt2mat([summary_path '\' summaryTXT_filename],[summary_path '\' summary_MATname]);
% 
% [summary_eeg,summary_header_eeg]=EEG_Summary_txt2mat([summary_path '\' summaryTXT_filename_eeg],[summary_path '\' summary_MATname_eeg]);
% 
% EEG_phaselocking_SigOBJ(summary, summary_eeg, summary_header, summary_header_eeg,dataROOT);
% disp('END');
