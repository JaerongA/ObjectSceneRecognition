clear all; clc;
session_folder = 'B:\PRC_POR_ephys\Ephys_data\r396\r396-11-03_OCRS(Modality)';
cd([session_folder '\ExtractedEvents']);

%% First load the Trial#.mat file that needs to be voided
MatName= 'Trial088.mat';
load(MatName);

Void = 1;

%% save('FileName','Void','-append');

save(MatName,'Void','-append');
clear all;

