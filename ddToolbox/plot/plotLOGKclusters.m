function plotLOGKclusters(mcmcContainer, data, col, pointEstimateType)

% plot posteriors over log(k) for all participants

figure(12), clf

% build samples
for p = 1:data.nParticipants
	logkSamples(:,p) = mcmcContainer.getSamplesFromParticipantAsMatrix(p, {'logk'});
end

uniG1 = mcmc.UnivariateDistribution(logkSamples,...
    'xLabel', '$\log(k)$',...
    'plotHDI', false,...
	'pointEstimateType', pointEstimateType);

% mcBivariateParticipants = mcmc.BivariateDistribution(...
% 	m,...
% 	c,...
% 	'xLabel','$\log(k)$',...
% 	'yLabel','c',...
% 	'plotStyle','contour',...
% 	'probMass',probMass,...
% 	'pointEstimateType','mode',...
% 	'patchProperties',definePlotOptions4Participant(col));

% keep axes zoomed in on all participants
axis tight
participantAxisBounds = axis;

try % TODO: Deal with this better than a try... catch. I'm not a peasant.
	mcmc.UnivariateDistribution(...
		mcmcContainer.getSamplesAsMatrix({'logk_group'}),...
		'xLabel', '$\log(k)$',...
		'plotHDI', false,...
		'pointEstimateType', pointEstimateType);
catch
	% NO GROUP LEVEL
end

axis(participantAxisBounds)
% set(gca,'XAxisLocation','origin',...
% 	'YAxisLocation','origin')
drawnow

	function plotOpts = definePlotOptions4Participant(col)
		plotOpts = {'FaceAlpha', 0.1,...
			'FaceColor', col,...
			'LineStyle', 'none'};
	end

	function plotOpts = definePlotOptions4Group(col)
		plotOpts = {'FaceColor', 'none',...
			'EdgeColor', col,...
			'LineWidth', 2};
	end
end
