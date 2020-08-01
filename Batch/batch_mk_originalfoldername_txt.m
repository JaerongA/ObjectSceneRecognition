% %  Made by Jaerong 2012/03/04
% %  This creates a text file in every session folder for later reference
% %  before we change the folder name for batch processing
% %  Contained in the text file is the original folder name

motherROOT= pwd;
clear all; clc;

dataROOT= ['B:\PRC_POR_ephys\Ephys_data\r344'];  % change the rat number you want to process
cd(dataROOT)

listing_session= dir('2015*');
folders= size(listing_session,1);

for i = 1:folders
    Org_foldername= listing_session(i).name;
    sprintf('%s', Org_foldername);
    cd(Org_foldername)
    txtfile= fopen('Original_folder_name.txt','w');
    fprintf(txtfile,'%s', Org_foldername);
    fclose(txtfile);
    cd(dataROOT)
end

disp('End')