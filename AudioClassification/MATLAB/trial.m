clear all;
addpath C:\ecen5322\Volumes\project\software\ma;

fid=fopen('C:\ecen5322\AudioClassification\Input\PathToTracks.txt');
a = textscan(fid, '%s');
b = char(a{1,1});

p=struct;
p.length = 512; %% windows size (ca 6sec @ 11kHz with%% 128 sone hopsize)
p.hopsize = 256;
p.windowfunction = 'boxcar';
p.fs = 11025; %% sampling frequency of wav file
p.fft_hopsize = 128; %% (~12ms @ 11kHz) hopsize used to create sone
p.visu = 0; %% do some visualizations
for j=1:7
    index(j)=round(827*rand()/7+827*(j-1)/7);
    if index(j)==0
        index(j)=1;
    end
end
for i=1:728
    wv=audioread(b(i,:));
    [mfcc, DCT] = ma_mfcc(wv, p);
    for j=1:7
        RDM(:,j)=mfcc(:,index(j));
    end
    r(i,:)=RDM(:);
end
%{
training(:,:)=r(1:724,:);
group(1:315)=1;
group(316:429)=2;
group(430:455)=3;
group(456:500)=4;
group(501:602)=5;
group(603:724)=6;
sample(1,:)=r(300,:);
sample(2,:)=r(100,:);
sample(3,:)=r(500,:);
sample(4,:)=r(710,:);
sample(5,:)=r(150,:);
class=knnclassify2( sample, training, group, 1,'cosine');
%}