function plotExpPowerclusters(mcmcContainer, data, col, modelType, plotOptions)

% TODO:
% remove input:
% - mcmcContainer, just pass in the data
% - data, just pass in 
% rename to plotBivariateDistributions


% plot posteriors over (k,tau) for all participants, as contour plots

probMass = 0.5;

figure(12), clf

% build samples
for p = 1:data.getNExperimentFiles()
	k(:,p) = mcmcContainer.getSamplesFromExperimentAsMatrix(p, {'k'});
	tau(:,p) = mcmcContainer.getSamplesFromExperimentAsMatrix(p, {'tau'});
end

%% plot all actual participants
mcBivariateParticipants = mcmc.BivariateDistribution(...
	k(:,[1:data.getNRealExperimentFiles()]),...
	tau(:,[1:data.getNRealExperimentFiles()]),...
	'xLabel','k',...
	'yLabel','tau',...
	'plotStyle','contour',...
	'probMass',probMass,...
	'pointEstimateType','mode',...
	'patchProperties',definePlotOptions4Participant(col));

% TODO: enable this functionality in BivariateDistribution
% % plot numbers
% for p = 1:data.getNExperimentFiles()
% 	text(mcBivariate.mode(1),mcBivariate.mode(2),...
% 		sprintf('%d',p),...
% 		'HorizontalAlignment','center',...
% 		'VerticalAlignment','middle',...
% 		'FontSize',9,...
% 		'Color',col)
% end

% keep axes zoomed in on all participants
axis tight
participantAxisBounds = axis;

%% plot unobserved participant (ie group level) if they exist
k_group = k(:,data.getNExperimentFiles());
tau_group = tau(:,data.getNExperimentFiles());
if ~any(isnan(k(:,end))) && ~any(isnan(k_group)) && ~any(isnan(tau_group))% do we have (m,c) samples for the group-level?
	if data.isUnobservedPartipantPresent()
		mcBivariateGroup = mcmc.BivariateDistribution(...
			k_group,...
			tau_group,... %xLabel',variableNames{1},'yLabel',variableNames{2},...
			'plotStyle','contour',...
			'probMass',probMass,...
			'pointEstimateType', plotOptions.pointEstimateType,...
			'patchProperties', definePlotOptions4Group(col));
	end
end

axis(participantAxisBounds)
set(gca,'XAxisLocation','origin',...
	'YAxisLocation','origin')
drawnow

if plotOptions.shouldExportPlots
	myExport(plotOptions.savePath, 'summary_plot',...
		'suffix', modelType,...
        'formats', {'png'})
end

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