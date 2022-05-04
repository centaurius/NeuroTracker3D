%% PSF Line Profiles Analysis
%%% Cleanup
clc;clear;close all;


OG = readtable('OGStack.csv');
Blurred = readtable('BlurredStack.csv');
Decon = readtable('DeconBlurredStack.csv');

%%% Plot Profiles
figure(100);clf;
plot(OG.Distance__pixels_,OG.Gray_Value);
hold on 
plot(Blurred.Distance__pixels_,Blurred.Gray_Value);
plot(Decon.Distance__pixels_,Decon.Gray_Value);


%% Import and Plot PSF
PSF = readtable('PSF.csv');
figure(50);clf;
plot([1:52]*0.1625,PSF.Gray_Value)
xlim([0,8.67]);


%% Imaris Data: Gold Standard
%clc;clear;close all;
ImData = readtable('ImarisData.csv');



figure(101);clf;
boxplot(ImData.Green_IntensityMean,ImData.Time.*0.25);



Imaris_RFP_stats = kruskalwallis(ImData.Red_IntensityMean,ImData.Time);
Imaris_GFP_stats = kruskalwallis(ImData.Green_IntensityMean,ImData.Time);


Imaris_RPFInt_stats = grpstats(ImData.Red_IntensityMean,ImData.Time);
Imaris_GPFInt_stats = grpstats(ImData.Green_IntensityMean,ImData.Time);
Imaris_RFPInt_lillie = lillietest(ImData.Red_IntensityMean);
Imaris_GFPInt_lillie = lillietest(ImData.Green_IntensityMean);

[ImG,ImG_SEM] = grpstats(ImData.Green_IntensityMean,ImData.Time);
[ImR,ImR_SEM] = grpstats(ImData.Red_IntensityMean,ImData.Time);







%% Analyze Manual Annotation Data
mRed = readtable('ManualAnnotation_RedChannel.csv');
mGreen = readtable('ManualAnnotation_GreenChannel.csv');

mR_lillie = lillietest(mRed.Mean);
mG_lillie = lillietest(mGreen.Mean);

Manual_Red_stats = kruskalwallis(mRed.Mean,mRed.Slice);
Manual_Green_stats = kruskalwallis(mGreen.Mean,mGreen.Slice);

[Manual_RFP_grpStats,Manual_RFP_grpStats_SEM] = grpstats(mRed.Mean,mRed.Slice);
[Manual_GFP_grpStats,Manual_GFP_grpStats_SEM] = grpstats(mGreen.Mean,mGreen.Slice);

figure(51);clf;
subplot(121);
boundedline([1:20]/0.8,Manual_RFP_grpStats,Manual_RFP_grpStats_SEM);
hilite([11.5,17.5],[],[0.85,0.85,0.85]);
xlim([1,25]);
subplot(122);
boundedline([1:20]/0.8,Manual_GFP_grpStats,Manual_GFP_grpStats_SEM);
hilite([11.5,17.5],[],[0.85,0.85,0.85]);
xlim([1,25]);





%% SNR Data
%%% Cleanup
%clc;clear;close all;

%%% Load Data


OG = readtable('OGStack_SNRData.csv');
Blurred = readtable('BlurredStack_SNRData.csv');
Decon = readtable('DeconvolutedBlurredStack_SNRData.csv');

OG_SNR = OG.Mean(1:end-2)./OG.Mean(end);
Blurred_SNR = Blurred.Mean(1:end-2)./Blurred.Mean(end);
Decon_SNR = Decon.Mean(1:end-2)./Decon.Mean(end);

Labels = [repmat(extractBefore(string(cell2mat(OG.Label(1))),".tif"),[size(OG_SNR,1),1]);repmat(extractBefore(string(cell2mat(Blurred.Label(1))),".tif"),[size(Blurred_SNR,1),1]);repmat(extractBefore(string(cell2mat(Decon.Label(1))),".tif"),[size(Decon_SNR,1),1])];
SNR_data = [OG_SNR;Blurred_SNR;Decon_SNR];

SNR_lillie = lillietest(SNR_data);


[SNRp,SNRtbl,SNRstats] = kruskalwallis(SNR_data,cellstr(Labels)');
[SNRc,SNRm,SNRh,SNRgnames] = multcompare(SNRstats);
tbl = array2table(SNRc,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl.("Group A") = SNRgnames(tbl.("Group A"));
tbl.("Group B") = SNRgnames(tbl.("Group B"));
disp(tbl);
writetable(tbl,'SNRStatsComparison');

tbl2 = array2table(SNRm',"VariableNames", ...
    unique(Labels,'stable')',"RowNames",["Mean","Standard Error"]);
disp(tbl2);
writetable(tbl2,'SNRGroupMeans');




%% Read Fiji Intensity Data
%clc;clearvars -except s*;close all;
close all;
gInt = readtable('GreenIntensities.txt');
rInt = readtable('RedIntensities.txt');
Labels = string(cellstr(extractBefore(gInt.Label,":")));
rInt.Label = Labels;
gInt.Label = Labels;
%IntSort = sortrows(Int,Int.Label);
idx = rInt.Label == ["RDARDeconvolutedBlurredStackSegmented"];
gInt(idx,:)=[];
rInt(idx,:)=[];

idx = gInt.Label == ["BlurredStackSegmented"];
gInt_Blur_Table = gInt(idx,:);
idx = gInt.Label == ["DeconvolutedBlurredStackSegmented"];
gInt_Decon_Table = gInt(idx,:);

idx = rInt.Label == ["BlurredStackSegmented"];
rInt_Blur_Table = rInt(idx,:);
idx = rInt.Label == ["DeconvolutedBlurredStackSegmented"];
rInt_Decon_Table = rInt(idx,:);



[Decon_gInt_stats,Decon_gInt_SEM] = grpstats(gInt_Decon_Table.IntensityAvg,gInt_Decon_Table.Frame);
[Blur_gInt_stats,Blur_gInt_SEM] = grpstats(gInt_Blur_Table.IntensityAvg,gInt_Blur_Table.Frame);

Decon_rInt_stats = grpstats(rInt_Decon_Table.IntensityAvg,rInt_Decon_Table.Frame);
Blur_rInt_stats = grpstats(rInt_Blur_Table.IntensityAvg,rInt_Blur_Table.Frame);

Blur_gInt_lillie = lillietest(gInt_Blur_Table.IntensityAvg);
Decon_gInt_lillie = lillietest(gInt_Decon_Table.IntensityAvg);
Blur_rInt_lillie = lillietest(rInt_Blur_Table.IntensityAvg);
Decon_rInt_lillie = lillietest(rInt_Decon_Table.IntensityAvg);

KW_Blur_rInt = kruskalwallis(rInt_Blur_Table.IntensityAvg,rInt_Blur_Table.Frame);
KW_Blur_gInt = kruskalwallis(gInt_Blur_Table.IntensityAvg,gInt_Blur_Table.Frame);
KW_Decon_rInt = kruskalwallis(rInt_Decon_Table.IntensityAvg,rInt_Decon_Table.Frame);
KW_Decon_gInt = kruskalwallis(gInt_Decon_Table.IntensityAvg,gInt_Decon_Table.Frame);




%% Read and Plot Volume Data
%clc;clearvars -except s*;close all;
Vol = readtable('Volumes.txt');
idx = Vol.Label == ["RDARDeconvolutedBlurredStackSegmented"];
Vol(idx,:)=[];



idx = Vol.Label == ["BlurredStackSegmented"];
V_Blur_Table = Vol(idx,:);
idx = Vol.Label == ["DeconvolutedBlurredStackSegmented"];
V_Decon_Table = Vol(idx,:);

Vol_BlurTable_lillie = lillietest(V_Blur_Table.Volume_Pix_);
Vol_DeconTable_lillie = lillietest(V_Decon_Table.Volume_Pix_);

figure(103);clf;
subplot(211);
boxplot(V_Blur_Table.Volume_Pix_,V_Blur_Table.Frame,'plotstyle','compact');
subplot(212);
boxplot(V_Decon_Table.Volume_Pix_,V_Decon_Table.Frame,'plotstyle','compact');

Blur_Volume_stats = kruskalwallis(V_Blur_Table.Volume_Pix_,V_Blur_Table.Frame);
Blur_Volume_grpStats = grpstats(V_Blur_Table.Volume_Pix_,V_Blur_Table.Frame);
Decon_Volume_stats = kruskalwallis(V_Decon_Table.Volume_Pix_,V_Decon_Table.Frame);
Decon_Volume_grpStats = grpstats(V_Decon_Table.Volume_Pix_,V_Decon_Table.Frame);

[V_BvD_h,V_BvD_p,V_BvD_t,V_BvD_stats] = ttest2(Blur_Volume_grpStats,Decon_Volume_grpStats);


%% Read and Plot Surface Data
clc;close all;
Surf = readtable('Surfaces.txt');
idx = Surf.Label == ["RDARDeconvolutedBlurredStackSegmented"];
Surf(idx,:)=[];

idx = Surf.Label == ["BlurredStackSegmented"];
S_Blur_Table = Surf(idx,:);
idx = Surf.Label == ["DeconvolutedBlurredStackSegmented"];
S_Decon_Table = Surf(idx,:);

Surf_BlurTable_lillie = lillietest(S_Blur_Table.Surface_Pix_);
Surf_DeconTable_lillie = lillietest(S_Decon_Table.Surface_Pix_);

figure(104);clf;
subplot(211);
boxplot(S_Blur_Table.Surface_Pix_,S_Blur_Table.Frame,'plotstyle','compact');
subplot(212);
boxplot(S_Decon_Table.Surface_Pix_,S_Decon_Table.Frame,'plotstyle','compact');

Blur_Surf_stats = kruskalwallis(S_Blur_Table.Surface_Pix_,S_Blur_Table.Frame);
Blur_Surf_grpStats = grpstats(S_Blur_Table.Surface_Pix_,S_Blur_Table.Frame);
Decon_Surf_stats = kruskalwallis(S_Decon_Table.Surface_Pix_,S_Decon_Table.Frame);
Decon_Surf_grpStats = grpstats(S_Decon_Table.Surface_Pix_,S_Decon_Table.Frame);

[S_BvD_h,S_BvD_p,S_BvD_t,S_BvD_stats] = ttest2(Blur_Surf_grpStats,Decon_Surf_grpStats);

%% Plot Summary Bar Graphs
figure(56);clf;
t = tiledlayout(1,2);
nexttile(1);
hold on
bar(1,mean(Blur_Volume_grpStats));
errorbar(1,mean(Blur_Volume_grpStats),std(Blur_Volume_grpStats),'k');
bar(2,mean(Decon_Volume_grpStats));
errorbar(2,mean(Decon_Volume_grpStats),std(Decon_Volume_grpStats),'k');
ylim([0,500]);

nexttile(2);
hold on
bar(1,mean(Blur_Surf_grpStats));
errorbar(1,mean(Blur_Surf_grpStats),std(Blur_Surf_grpStats),'k');
bar(2,mean(Decon_Surf_grpStats));
errorbar(2,mean(Decon_Surf_grpStats),std(Decon_Surf_grpStats),'k');
ylim([0,500]);


%% Compare Imaris to Fiji Data
close all;
%{
% RFP data first
rANOVAData = [Imaris_RPFInt_stats,Blur_rInt_stats,Decon_rInt_stats];
[rInt_p,rInt_tbl,rInt_stats] = kruskalwallis(rANOVAData);
%{
[rInt_c,rInt_m,rInt_h,rInt_gnames] = multcompare(rInt_stats);
rtbl = array2table(rInt_c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
rtbl.("Group A") = rInt_gnames(rtbl.("Group A"));
rtbl.("Group B") = rInt_gnames(rtbl.("Group B"));
rtbl.("Group A") = ["Imaris";"Blurred";"Deconvoluted"];
rtbl.("Group B") = ["Blurred";"Deconvoluted";"Deconvoluted"];
disp(rtbl);
writetable(rtbl,'RFPStatsComparison');
%}

gANOVAData = [Imaris_GPFInt_stats,Blur_gInt_stats,Decon_gInt_stats];
[gInt_p,gInt_tbl,gInt_stats] = kruskalwallis(gANOVAData);
%{
[gInt_c,gInt_m,gInt_h,gInt_gnames] = multcompare(gInt_stats);
%}

%{
tbl = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl.("Group A") = gnames(tbl.("Group A"));
tbl.("Group B") = gnames(tbl.("Group B"));
tbl.("Group A") = ["Imaris";"Blurred";"Deconvoluted"];
tbl.("Group B") = ["Blurred";"Deconvoluted";"Deconvoluted"];
disp(tbl);
writetable(tbl,'RFPStatsComparison');
%}
%}

% Redo with switched Imaris RFP and GFP data: could this have been an error
% from NIH?
rANOVAData_redo = [Imaris_GPFInt_stats,Blur_rInt_stats,Decon_rInt_stats];
[rInt_p_redo,rInt_tbl_redo,rInt_stats_redo] = kruskalwallis(rANOVAData_redo);
[rInt_c_redo,rInt_m_redo,rInt_h_redo,rInt_gnames_redo] = multcompare(rInt_stats_redo);
gANOVAData_redo = [Imaris_RPFInt_stats,Blur_gInt_stats,Decon_gInt_stats];
[gInt_p_redo,gInt_tbl_redo,gInt_stats_redo] = kruskalwallis(gANOVAData_redo);
[gInt_c_redo,gInt_m_redo,gInt_h_redo,gInt_gnames_redo] = multcompare(gInt_stats_redo);
tbl = array2table(gInt_c_redo,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl.("Group A") = gnames(tbl.("Group A"));
tbl.("Group B") = gnames(tbl.("Group B"));
tbl.("Group A") = ["Imaris GCaMP";"Imaris GCaMP";"Blurred GCaMP"];
tbl.("Group B") = ["Blurred GCaMP";"Blur + Deconvoluted GCaMP";"Blur + Deconvoluted GCaMP"];
disp(tbl);
writetable(tbl,'GCaMPStatsComparison');

%% Plot Comparison of Imaris and Fiji GCaMP Data
figure(106);clf;
t = tiledlayout(2,1);

% Here we compare the ImData RFP dataset (which should have been labeled
% GCaMP), and the Fiji GCaMP signal.

%[ImG,ImG_SEM] = grpstats(ImData.Green_IntensityMean,ImData.Time);
%[ImR,Imr_SEM] = grpstats(ImData.Red_IntensityMean,ImData.Time);
%[Decon_gInt_stats,Decon_gInt_SEM] = grpstats(gInt_Decon_Table.IntensityAvg,gInt_Decon_Table.Frame);
%[Blur_gInt_stats,Blur_gInt_SEM] = grpstats(gInt_Blur_Table.IntensityAvg,gInt_Blur_Table.Frame);


nexttile(1);
boundedline([1:20]*0.25,ImR,ImR_SEM);
ylim([0,50])
xlim([0.25,5])
nexttile(2);
boundedline([1:20]*0.25,Decon_gInt_stats,Decon_gInt_SEM);
ylim([0,50])
xlim([0.25,5])

