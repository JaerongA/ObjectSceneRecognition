function [EEG, EEG_ts] = get_EEG(csc_ID, ts_vector, bit2microvolt)
%% By Jaerong
%% Input ts_vector should be in seconds

global sampling_freq
global period


ts_vector= ts_vector.* 1E6;

timeSET=1;
BROI = (timeSET)*1E6;               %set Big window for loading event EEG data;

EEG_wind = [ts_vector(1)-BROI ts_vector(2)+BROI];

[EEGTimestamps, EEG] = Nlx2MatCSC(csc_ID, [1 0 0 0 1], 0, 4, EEG_wind);


nb_smp_ts=size(EEGTimestamps,2);
nb_smp_eeg=size(EEG,2);
EEG=reshape(EEG,1,512*nb_smp_eeg);
nb_eeg=size(EEG,2);

EEG_ts=zeros(1,nb_eeg);




for i=1:nb_smp_ts
    start=1+(512*(i-1));
    stop=(512*i);
    EEG_ts(start:stop)=EEGTimestamps(i);
end
for i=1:nb_eeg
    EEG_ts(i)=EEG_ts(i)+(mod(i-1,512) *period);
end




EEG_ind= find(EEG_ts <= ts_vector(2) & EEG_ts >=  ts_vector(1));


EEG= EEG(EEG_ind);

EEG= EEG.*bit2microvolt;
EEG_ts= EEG_ts(EEG_ind);

%
% %% Skip the trial if the signal maxes out of the recording range
%
% if removenoise
%
%     if sum((abs(EEG) == 32767))
%
%         EEG=[];
%         EEST_ts=[];
%         return;
%
%     end
% end
%



% if ~isempty(bit2microvolt)
%     
%     EEG= EEG.*bit2microvolt;
%     %     EEG = EEG.*1E6;  %% microvolt conversion
%     
% end



end

