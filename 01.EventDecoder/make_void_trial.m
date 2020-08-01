clear all; clc;
session_folder = 'H:\PRC_POR_ephys\Ephys_data\r558\r558-05-03_OCRS(FourOBJ)';
cd([session_folder '\ExtractedEvents']);

%% First load the Trial#.mat file that needs to be voided
MatName= 'Trial048.mat';
load(MatName);

Void = 1;

%% save('FileName','Void','-append');

save(MatName,'Void','-append');
clear all;

