% This program transfers all cluster IDs in the clusterID sheet onto the
% FairClusterList files to be processed in the autoprocess


clear all; clc;
dataROOT = ['Z:\EPhysRawData\CA3_recording_dmSTR_MUS\rat171'];
cd(dataROOT);


faircluster_file= ['FairClusterList.txt'];
if  ~exist(faircluster_file)
    hTEXT = fopen(faircluster_file, 'W');
    fclose(hTEXT); 
end


% Load cluster quality file
inputCSV = fopen('cluster.txt', 'r');
inputLOAD = fscanf(inputCSV, '%c');
inputNewline = find(inputLOAD == sprintf('\n'));




for cellnum = 1:size(inputNewline, 2)
    
    if cellnum == 1
		thisCLUSTER = inputLOAD(1, 1:inputNewline(cellnum) - 2);
	else
		thisCLUSTER = inputLOAD(1, 1 + inputNewline(cellnum - 1):inputNewline(cellnum) - 2);
	end	%cellnum ~= 1
    
	findHYPHEN = find(thisCLUSTER == '-');
  	thisRID = thisCLUSTER(1, 2:findHYPHEN(1) - 1); 
    thisSID = thisCLUSTER(1, findHYPHEN(1)+1: findHYPHEN(2)-1);
	thisTTID = thisCLUSTER(1, findHYPHEN(2) + 1:findHYPHEN(3) - 1);
	thisCLID= thisCLUSTER(1, findHYPHEN(3)+1:end);
    
    newCLUSTER= ['c:\r' thisRID '\r' thisRID '-' thisSID '\TT' thisTTID '\TT' thisTTID '_cluster.' thisCLID]
    
    hTEXT = fopen(faircluster_file, 'A');
    fprintf(hTEXT, '%s\r\n', newCLUSTER);
    fclose(hTEXT); clear hTEXT;
   
end



    
   
