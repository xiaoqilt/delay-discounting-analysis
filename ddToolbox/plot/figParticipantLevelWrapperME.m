function figParticipantLevelWrapperME(mcmc, data, variables,...
	participant_prior_variables, saveFolder, modelType, opts)
  % For each participant, call some plotting functions on the variables provided.

  mPointEstimates = mcmc.getStats('mean', 'm');
  cPointEstimates = mcmc.getStats('mean', 'c');
  epsilonPointEstimates = mcmc.getStats('mean', 'epsilon');
  alphaPointEstimates = mcmc.getStats('mean', 'alpha');

  for n = 1:data.nParticipants
    fh = figure;
    fh.Name=['participant: ' data.IDname{n}];

    % 1) figParticipant plot
    [pSamples] = mcmc.getSamplesAtIndex(n, variables);
    [pData] = data.getParticipantData(n);

		pointEstimate.m = mPointEstimates(n);
		pointEstimate.c = cPointEstimates(n);
		pointEstimate.epsilon = epsilonPointEstimates(n);
		pointEstimate.alpha = alphaPointEstimates(n);
		
    figParticipantME(pSamples, pointEstimate,...
			'pData', pData,...
			'opts',opts);

    latex_fig(16, 18, 4)
		myExport(data.IDname{n},...
				'saveFolder',saveFolder,...
				'prefix', modelType);

    close(fh)

    % 2) Triplot
    posteriorSamples = mcmc.getSamplesFromParticipantAsMatrix(n, variables);
    priorSamples = mcmc.getSamplesAsMatrix(participant_prior_variables);

		figure(87)
		TriPlotSamples(posteriorSamples, variables, ...
			'PRIOR',priorSamples);

		myExport([data.IDname{n} '-triplot'],...
			'saveFolder', saveFolder,...
			'prefix', modelType);
	end
end
