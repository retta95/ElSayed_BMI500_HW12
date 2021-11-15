function filtered = preprocess_marker_data(raw,time, w1, w2)
       % filtered = preprocess_marker_data(raw, rate, cutoff_frequencies)
       % raw: is for raw data
       % rate for sampling rate
       % w1<w2
       

% d = designfilt('bandpassiir','FilterOrder',20, ...
%     'HalfPowerFrequency1',w1,'HalfPowerFrequency2',w2, ...
%     'SampleRate',1500);
% filtered = filtfilt(d,raw);

[b,a] = butter(6,[w1 w2]); %0.1 0.6
filtered = filtfilt(b,a,raw);

subplot(2,1,1)
plot(time,filtered(:,1))
title('Filtered Waveforms Zero-phase Filtering')

subplot(2,1,2)
plot(time,raw(:,1))
title('Original Waveform')

end 