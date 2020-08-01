function EEG_filtered = EEG_filter(EEG, filter_order, freq_range, sampling_freq, ftype)

%% By Jaerong
%% Filter in the specified frequency range

nyquist_freq = sampling_freq/2;  %% Nyquist frequency

[b,a]= butter(filter_order, freq_range/nyquist_freq, ftype);

EEG_filtered = filtfilt(b, a, EEG);


end

