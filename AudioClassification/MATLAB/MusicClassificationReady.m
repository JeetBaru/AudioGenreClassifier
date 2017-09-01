%% Tutorial on music genre classification
% In this tutorial, we shall explain music genre classification (MGC)
% using MFCC (mel-frequency cepstral coefficients) as the basic acoustic features.
% The dataset used here is GTZAN, which is availabe at <http://marsyasweb.appspot.com/download/data_sets http://marsyasweb.appspot.com/download/data_sets>. 
%% Preprocessing
% Before we start, let's add necessary toolboxes to the search path of MATLAB:
addpath d:/users/jang/matlab/toolbox/utility
addpath d:/users/jang/matlab/toolbox/sap
addpath d:/users/jang/matlab/toolbox/machineLearning
%%
% For compatibility, here we list the platform and MATLAB version that we used to run this script:
fprintf('Platform: %s\n', computer);
fprintf('MATLAB version: %s\n', version);
scriptStartTime=tic;
%% Dataset construction
% First of all, we shall collect all the audio files from the corpus
% directory. Note that
%
% * The audio files have extensions of "au".
% * These files have been organized for easy parsing, with a subfolder for each class.
auDir='C:\ecen5322\Volumes\project\tracks';
opt=mmDataCollect('defaultOpt');
opt.extName='wav';
auSet=mmDataCollect(auDir, opt, 1);
%% Feature extraction
% For each audio, we need to extract the corresponding feature vector for classification.
% We shall use the function <../mgcFeaExtract.m mgcFeaExtract.m> (which MFCC and its statistics) for feature extraction.
% We also need to put all the dataset into a single variable "ds" which is easier for further processing, including classifier construction and evaluation.
if ~exist('ds.mat')
	myTic=tic;
	opt=dsCreateFromMm('defaultOpt');
	opt.auFeaFcn=@mgcFeaExtract;	% Function for feature extraction
	opt.auFeaOpt=feval(opt.auFeaFcn, 'defaultOpt');	% Feature options
	opt.auEpdFcn='';		% No need to do endpoint detection
	ds=dsCreateFromMm(auSet, opt, 1);
	fprintf('Time for feature extraction over %d files = %g sec\n', length(auSet), toc(myTic));
	fprintf('Saving ds.mat...\n');
	save ds ds
else
	fprintf('Loading ds.mat...\n');
	load ds.mat
end
%%
% Note that if feature extraction is lengthy, we can simply load ds.mat which has been save in the above code snippet.
%%
% Basically the extracted features are based on MFCC's statistics, including mean, std, min, and max along each dimension.
% Since MFCC has 39 dimensions, the extracted file-based features has 156 (= 39*4) dimensions.
% You can type "mgcFeaExtract" to have a self-demo of the function:
figure; mgcFeaExtract;
%% Dataset visualization
% Once we have every piece of necessary information stored in "ds",
% we can invoke many different functions in Machine Learning Toolbox for
% data visualization and classification.
%%
% For instance, we can display the size of each class:
figure;
[classSize, classLabel]=dsClassSize(ds, 1);
%%
% We can plot the range of features of the dataset:
figure; dsRangePlot(ds);
%%
% We can plot the feature vectors within each class:
figure; dsFeaVecPlot(ds); figEnlarge;
%% Dimensionality reduction
% The dimension of the feature vector is quite large:
dim=size(ds.input, 1)
%%
% We shall consider dimensionality reduction via PCA (principal component
% analysis). First, let's plot the cumulative variance given the descending
% eigenvalues of PCA:
[input2, eigVec, eigValue]=pca(ds.input);
cumVar=cumsum(eigValue);
cumVarPercent=cumVar/cumVar(end)*100;
figure; plot(cumVarPercent, '.-');
xlabel('No. of eigenvalues');
ylabel('Cumulated variance percentage (%)');
title('Variance percentage vs. no. of eigenvalues');
%%
% A reasonable choice is to retain the dimensionality such that the cumulative
% variance percentage is larger than a threshold, say, 95%, as follows:
cumVarTh=95;
index=find(cumVarPercent>cumVarTh);
newDim=index(1);
ds2=ds;
ds2.input=input2(1:newDim, :);
fprintf('Reduce the dimensionality to %d to keep %g%% cumulative variance via PCA.\n', newDim, cumVarTh);
%%
% However, our experiment indicates that if we use PCA for dimensionality
% reduction, the accuracy will be lower. As a result, we shall keep all the
% features for further exploration.
%%
% In order to visualize the distribution of the dataset,
% we can project the original dataset into 2-D space.
% This can be achieved by LDA (linear discriminant analysis):
ds2d=lda(ds);
ds2d.input=ds2d.input(1:2, :);
figure; dsScatterPlot(ds2d); xlabel('Input 1'); ylabel('Input 2');
title('Features projected on the first 2 lda vectors');
%%
% Apparently the separation among classes is not obvious.
% This indicates that either the features or LDA are not very effective. 
%% Classification
% We can try the most straightforward KNNC (k-nearest neighbor classifier):
[rr, computed]=knncLoo(ds);
fprintf('rr=%g%% for original ds\n', rr*100);
ds2=ds; ds2.input=inputNormalize(ds2.input);
[rr2, computed]=knncLoo(ds2);
fprintf('rr=%g%% for ds after input normalization\n', rr2*100);
%%
% Again, the vanilla KNNC does not give satisfactory result. 
% So we shall try other potentially better classifiers, such as SVM.
% Before try SVM, here we use a function <../mgcOptSet.m mgcOptSet.m> to put all the MGC-related options in a single file.
% This will be easier for us to change a single option in this file and check out the accuracy of MGC.
% Here is the code for using SVM:
myTic=tic;
mgcOpt=mgcOptSet;
if mgcOpt.useInputNormalize, ds.input=inputNormalize(ds.input);	end		% Input normalization
cvPrm=crossValidate('defaultOpt');
cvPrm.foldNum=mgcOpt.foldNum;
cvPrm.classifier=mgcOpt.classifier;
plotOpt=1;
figure; [tRrMean, vRrMean, tRr, vRr, computedClass]=crossValidate(ds, cvPrm, plotOpt); figEnlarge;
fprintf('Time for cross-validation = %g sec\n', toc(myTic));
%%
% The recognition rate is 77%, indicating SVM is a much more effective classifier.
%%
% We can plot the confusion matrix:
for i=1:length(computedClass)
	computed(i)=computedClass{i};
end
desired=ds.output;
confMat = confMatGet(desired, computed);
cmOpt=confMatPlot('defaultOpt');
cmOpt.className=ds.outputName;
confMatPlot(confMat, cmOpt); figEnlarge;
%% Summary
% This is a brief tutorial on music genre classification based on MFCC's statistics.
% There are several directions for further improvement:
%
% * Explore other features and feature selection for MGC
% * Explore other classifiers (and their combinations) for MGC
%
%%
% Overall elapsed time:
toc(scriptStartTime)
%%
% <http://mirlab.org/jang Jyh-Shing Roger Jang>, created on
date
%%
% If you are interested in the original MATLAB code for this page, you can
% type "grabcode(URL)" under MATLAB, where URL is the web address of this
% page.