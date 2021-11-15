function outcomes=tremor_analysis(fname,markername)

% read: 
trc=rename_trc(read_trc(fname));
raw_data=trc{:,startsWith(names(trc),markername)};
filtered_data=preprocess_marker_data(raw_data,trc.Time,0.1,0.6);

% Both pc1_data and time are 3600 x1 vectors: 
time_s=trc.Time;
[t,pc1_mm]=pc1(filtered_data);
pc=pc1_mm(:,3);

TT=timetable(seconds(time_s),pc);
TT.Properties.VariableNames=[markername];
TT.Properties.VariableUnits=["mm"];
[p, f, t]=pspectrum(TT,'spectrogram','MinThreshold',-50,'FrequencyResolution',0.5,'FrequencyLimits',[0 60]);

out1=zeros(1,length(t));
out2=zeros(1,length(t));
out4=zeros(1,length(t));

for i=1:length(t)
[out1(i),I]=max(p(:,i)); 
out2(i)=f(I); % f_max_p: frequency at overall max power (Hz)
% average RMS power (mm) within +/- 0.5 Hz of frequency at overall max
% power
x=out2(i)+0.5; %+/-0.5
y=out2(i)-0.5;
[ind,~] = find(f>y& f <x);
v=f([ind]);% the index of the max power
fi = linspace(min(v),max(v),1001); % create a linspace for fi for a peak frequency window 
out4(i) = trapz(fi,p(:,i),1); % area under the peak frequency for calculating the rms_power
end 
out1=max(out1);
out4=sum(out4)/length(t);% take the sum of the area over all the time points/the length of the trail
outcomes =[out1,mean(out2),std(out2),out4];
end 