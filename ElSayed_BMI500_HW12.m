%% Create 3 functions: 
    % filtered = preprocess_marker_data(raw, time, cutoff_frequencies)
    % outcomes = tremor_analysis(fname, markername)
    % primary_component = pc1(filtered)
    % Code to loop over files and markers and aggregate outcomes into the output dataset
clc; clear; close;
% to load a trcs files from all directories: 
icdT= readtable("icd.csv");
Directory='C:\Users\relsay2\Desktop\BMI500\lab12\HW12\deidentified_trc';
id=icdT.id;
icd=icdT.icd;
OUT={zeros(length(id),8)};
% Loop over the data sets and plot each one individually  
for i=1:length(id)
sourcedir = fullfile(Directory,sprintf('%u%s', id(i)))
file=fullfile(sourcedir,'\sit-rest1-TP.trc');
if exist(file) == 2;
else
   file=fullfile(sourcedir,'\sit-point1-TP.trc');
end
markername="L.Finger3.M3";
outcomes=tremor_analysis(file,markername);
OUT{i,1}=id(i);
OUT{i,2}=string(icd(i));
OUT{i,3}=string(file);
OUT{i,4}=markername;
OUT{i,5}=outcomes(:,1);
OUT{i,6}=outcomes(:,2);
OUT{i,7}=outcomes(:,3);
OUT{i,8}=outcomes(:,4);
end
TableOut=cell2table(OUT);
TableOut.Properties.VariableNames = {'Record_ID' 'ICD' 'File' 'Markername' 'max_p' 'f_max_p' 'f_sd' 'rms_power'};
writetable(TableOut,'output.csv')
%% Visulaizing time-varying tremor: 
Directory='C:\Users\relsay2\Desktop\BMI500\lab12\HW12\deidentified_trc\416\sit-rest1-TP.trc';
trc=rename_trc(read_trc(Directory));
markername="L.Finger3.M3";
raw_data=trc{:,startsWith(names(trc),markername)};
filtered_data=preprocess_marker_data(raw_data,trc.Time,0.1,0.6);
time_s=trc.Time;
[t,pc1_mm]=pc1(filtered_data);
figure()
plot(time_s,pc1_mm(:,1))
xlim([0 5]); xlabel ("Time (seconds)"); ylabel("mm"); title("Time vs. SVD")
pc=pc1_mm(:,3);
TT=timetable(seconds(time_s),pc);
TT.Properties.VariableNames=[markername];
TT.Properties.VariableUnits=["mm"];
[p, f, t]=pspectrum(TT,'spectrogram','MinThreshold',-50,'FrequencyResolution',0.5,'FrequencyLimits',[0 100]);
figure()
waterfall(f,seconds(t),p')
xlabel('frequency')
ylabel('Time(seconds)')
title("3D Visualization of Frequency vs. Power Spectrum")
wtf=gca;
wtf.XDir='reverse';
view([30 45])

% different Visualization: 
figure()
hold on 
for j=1:size(p,2)
    plot(f,p(:,j));
end
xlabel("Hz")
ylabel("mm2/Hz")
title("3D Visualization of Frequency vs. Power Spectrum")
