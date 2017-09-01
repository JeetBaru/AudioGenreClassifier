clear all;
addpath C:\ecen5322\Volumes\project\software\ma;
p.fs = 11025; %% sampling frequency of given wav (unit: Hz)
p.do_visu = 0; %% create some figures
p.do_sone = 1; %% compute sone (otherwise dB)
p.do_spread = 1; %% apply spectral masking
p.outerear = 'terhardt'; %% outer ear model {'terhardt' | 'none'}
p.fft_size = 256; %% window size (unit: samples)
p.hopsize = 128;
fid=fopen('C:\ecen5322\AudioClassification\Input\PathToTracks.txt');

a = textscan(fid, '%s');
b = char(a{1,1});

for j=1:728
    wav=audioread(b(j,:));
    s=ma_sone(wav,p);
    t=mean(s);
    l=length(t);
    for i=1:100
        index(i)=round(l*rand()/100+l*(i-1)/100);
        if index(i)==0
            index(i)=1;
        end
        RDM(j,i)=t(index(i));
    end
end

training(1:300,:)=RDM(1:300,:);
training(301:400,:)=RDM(321:420,:);
training(401:420,:)=RDM(435:454,:);
training(421:460,:)=RDM(461:500,:);
training(461:535,:)=RDM(506:580,:);
training(536:640,:)=RDM(608:712,:);
group(1:300)=1;
group(301:400)=2;
group(401:420)=3;
group(421:460)=4;
group(461:535)=5;
group(536:640)=6;
sample(1,:)=RDM(302,:);
sample(2,:)=RDM(422,:);
sample(3,:)=RDM(455,:);
sample(4,:)=RDM(502,:);
sample(5,:)=RDM(582,:);
class=knnclassify2( sample, training, group, 1,'cosine');