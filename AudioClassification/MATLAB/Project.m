clear all;
clc;

addpath C:\ecen5322\Volumes\project\software\ma;
ma_g1c_FeatureExtraction('C:\ecen5322\AudioClassification\Input\PathToTracks.txt','C:\ecen5322\AudioClassification\Output');
ma_g1c_ComputeSimilarities('C:\ecen5322\AudioClassification\Output','C:\ecen5322\AudioClassification\Output\DistanceMatrix.txt');

fid=fopen('C:\ecen5322\AudioClassification\Output\DistanceMatrix.txt');
formatspec=repmat('%s ',1,765);
a = textscan(fid, formatspec);
for i=1:765
    sm(:,i)=a{1,i};
end
for i=1:764
    for j=1:764
        matrix(i,j)=str2num(char(sm(766+i,1+j)));
    end
end

w=matrix;
%{
training(1:300,:)=w(1:300,:);
training(301:400,:)=w(321:420,:);
training(401:420,:)=w(435:454,:);
training(421:460,:)=w(461:500,:);
training(461:535,:)=w(506:580,:);
training(536:640,:)=w(608:712,:);
group(1:300)=1;
group(301:400)=2;
group(401:420)=3;
group(421:460)=4;
group(461:535)=5;
group(536:640)=6;
sample(1:20,:)=w(301:320,:);
sample(21:34,:)=w(421:434,:);
sample(35:40,:)=w(455:460,:);
sample(41:45,:)=w(501:505,:);
sample(46:72,:)=w(581:607,:);
sample(73:84,:)=w(713:724,:);
y(1:20)=1;
y(21:34)=2;
y(35:40)=3;
y(41:45)=4;
y(46:72)=5;
y(73:84)=6;
class=knnclassify2( sample, training, group, 5,'cosine');
%}
%{
clear v;
clear a;
y(1:320)=1;
y(321:434)=2;
y(435:460)=3;
y(461:505)=4;
y(506:607)=5;
y(608:729)=6;
indices=crossvalind('Kfold',729,5);
for i=1:5
    u=1;
    v=1;
    for j=1:729
        if indices(j,1)==i
            sample(u,:)=w(j,:);
            ysample(u)=y(j);
            u=u+1;
        else
            training(v,:)=w(j,:);
            ytraining(v)=y(j);
            v=v+1;
        end
    end
    class=knnclassify2( sample, training, ytraining', 10);
    a=class==ysample';
    C(:,:,i)=confusionmat(class',ysample);
    C(:,:,i)=C(:,:,i)./sum(C(:,:,i));
    percentacc(i)=trace(C(:,:,i))/6*100
end
%}