% %  Made by Jaerong 2012/03/04
% %  This creates a text file in every session folder for later reference
% %  before we change the folder name for batch processing
% %  Contained in the text file is the original folder name

clear all; clc;


dataROOT= 'H:\PRC_POR_ephys\Ephys_data\r469';  % Specify the rat folder
cd(dataROOT)

listing_session= dir('2017*');
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