% SCRIPT
% To test the Gaussian Random Walk model
% This model is most appropriate when applied to data focussing on finding
% indifference points for a set number of delays. Ie, not the Kirby dataset
% because all delays are unique.

%% Setup
addpath('~/git-local/delay-discounting-analysis/ddToolbox')
ddAnalysisSetUp();

%% Load data
datapath = '~/git-local/delay-discounting-analysis/demo-nonparametric/data';
fnames={'CA-gain.txt', 'CA-loss.txt',...
	'CR-gain.txt', 'CR-loss.txt',...
	'CS-gain.txt', 'CS-loss.txt',...
	'RG-gain.txt', 'RG-loss.txt',...
	'ScT-gain.txt', 'ScT-loss.txt'};
% 'CR.txt','CS.txt','RG.txt',...

myData = DataClass(datapath,...
	'files', fnames);


% Create an analysis model
grwModel = ModelGaussianRandomWalkSimple(myData,...
	'saveFolder', 'ModelGaussianRandomWalkSimple',...
	'pointEstimateType','median');

% Do some Bayesian inference with JAGS or STAN
grwModel = grwModel.conductInference('jags',... % {'jags', 'stan'}
	'shouldPlot', 'yes',...
	'mcmcSamples', 10^4); % TODO: add mcmcparams over-ride
