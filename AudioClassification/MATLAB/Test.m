%clear all;
addpath C:\ecen5322\Volumes\project\software\ma;

tic;
fid=fopen('C:\ecen5322\AudioClassification\Input\PathToTracks.txt');
a = textscan(fid, '%s');
b = char(a{1,1});

p=struct;
p.length = 1024; %% windows size (ca 6sec @ 11kHz with%% 128 sone hopsize)
p.hopsize = 512;
p.overlap = 512;
p.num_ceps_coeffs = 20;
p.fs = 11025; %% sampling frequency of wav file
p.fft_hopsize = 512; %% (~12ms @ 11kHz) hopsize used to create sone
p.visu = 0; %% do some visualizations
%{
for i=1:length(b(:,1))
    wv=audioread(b(i,:));
    [mfcc, DCT] = ma_mfcc(wv, p);
    l(i)=length(mfcc);
    minl=min(l);
end
%}
for i=1:length(b(:,1))
    wv=audioread(b(i,:));
    [mfcc, DCT] = ma_mfcc(wv, p);
    n=pca(mfcc');
    v(i,:)=n(:);
end

r=v;
%{
for i=1:length(r)
    for j=i:length(r)
        w(i,j)=abs(KLDiv(r(i,:),r(j,:)));
    end
end
w=w+w';
%}
w=v;

training(1:26,:)=w(50:75,:);
training(27:52,:)=w(321:346,:);
training(53:78,:)=w(431:456,:);
training(79:104,:)=w(457:482,:);
training(105:130,:)=w(505:530,:);
training(131:156,:)=w(620:645,:);
y(1:26,1)=1;
y(27:52,1)=2;
y(53:78,1)=3;
y(79:104,1)=4;
y(105:130,1)=5;
y(131:156,1)=6;


%{
y(1:320)=1;
y(321:434)=2;
y(435:460)=3;
y(461:505)=4;
y(506:607)=5;
y(608:729)=6;
training(1:729,:)=w(1:729,:);
%}
z=[2;1;1;4;5;3;6;1;3;6;1;5;1;1;3;1;1;2;1;6;1;6;3;1;6;1;2;4;5;1;1;1;4;4;1];
test(1:35,:)=w(730:length(w),:);
class=knnclassify(test, training, y, 7);
q=z==class;
sum(q)/35