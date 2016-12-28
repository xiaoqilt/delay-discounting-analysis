function codaObject = sampleWithMatjags(...
	modelFilename, observedData, mcmcparams, initialParameters, monitorparams)

assert(ischar(modelFilename))
assert(isstruct(observedData))
assert(isstruct(mcmcparams))
assert(isstruct(initialParameters))
assert(iscellstr(monitorparams))

%% sampler-specific preparation +++++++++++++++++++++++
startParallelPool()
% +++++++++++++++++++++++++++++++++++++++++++++++++++++

%% Get our sampler to sample
fprintf('\nRunning JAGS (%d chains, %d samples each)\n',...
	mcmcparams.nchains,...
	ceil( mcmcparams.nsamples / mcmcparams.nchains));
[samples, stats] = matjags(...
	observedData,...
	modelFilename,...
	initialParameters,...
	'doparallel', mcmcparams.doparallel,...
	'nchains', mcmcparams.nchains,...
	'nburnin', mcmcparams.nburnin,...
	'nsamples', ceil( mcmcparams.nsamples / mcmcparams.nchains),... % nAdapt', 2000,...
	'thin', 1,...
	'monitorparams', monitorparams,...
	'savejagsoutput', 0,...
	'verbosity', 1,...
	'cleanup', 1,...
	'rndseed', 1,...
	'dic', 0);

% Uncomment this line if you want auditory feedback
%speak('sampling complete')

% return the results as a CODA object
codaObject = CODA(samples, stats);

end