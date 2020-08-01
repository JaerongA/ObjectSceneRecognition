%% Created by Jaerong 2017/09/19  for PER & POR ephys analysis
%% Get the analog-to-digital(AD) bit value from neuralynx

function [summary,summary_header] = EEG_ADBitmicrovolts(summary, summary_header,dataROOT)


% cd(dataROOT);
%
%

[r_s,c_s]=size(summary);


for i_s= 1:c_s
    
    
    if       strcmp(summary(i_s).Rat,'r558') 
    
    
    %% Set EEG info
    
    set_eeg_prefix;
    
    
    
    csc_ID= sprintf('CSC%s_RateReduced.ncs',summary(i_s).TT);
    cd(Session_folder);
    
    
    
    
    %% Look up the ADBitVolts
    
    [header] = Nlx2MatCSC(csc_ID, [0 0 0 0 0],1,1,[]); % look for ADBitVolts to convert eegs values from bits to volts
    bit2volt = str2num(header{15}(1, 14:end)); %read ADBitVolts
    clear header
    
    
    
    disp(sprintf('ADBitmicrovolts = %1.8f',bit2volt*1E6));
    
    
    %% Add to summary
    
    summary(i_s).ADBitmicrovolts= sprintf('%1.8f',bit2volt*1E6);
    
    
    
    end  %     strcmp(summary(i_s).Rat,'r558') 
    
end %   i_s= 1:c_s



end  % function
