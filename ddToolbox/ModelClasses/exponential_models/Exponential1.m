classdef (Abstract) Exponential1 < Parametric

	properties (Access = private)
		getDiscountRate % function handle
	end

	methods (Access = public)

		function obj = Exponential1(data, varargin)
			obj = obj@Parametric(data, varargin{:});
            
            obj.dfClass = @DF_Exponential1;

			% Create variables
			obj.varList.participantLevel = {'k','alpha','epsilon'};
			obj.varList.monitored = {'k','alpha','epsilon', 'Rpostpred', 'P'};

			%% Plotting
			obj.plotFuncs.clusterPlotFunc	= @plotExpclusters;

		end

		function conditionalDiscountRates(obj, reward, plotFlag)
			error('Not applicable to this model')
		end

		function conditionalDiscountRates_GroupLevel(obj, reward, plotFlag)
			error('Not applicable to this model')
		end
        
		function experimentPlot(obj)
			
			names = obj.data.getIDnames('all');
			
			for ind = 1:numel(names)
				fh = figure('Name', ['participant: ' names{ind}]);
				latex_fig(12, 10, 3)

				%%  Set up psychometric function
				psycho = PsychometricFunction('samples', obj.coda.getSamplesAtIndex(ind,{'alpha','epsilon'}));
				
				%% plot bivariate distribution of alpha, epsilon
				subplot(1,4,1)
				samples = obj.coda.getSamplesAtIndex(ind,{'alpha','epsilon'});
				mcmc.BivariateDistribution(...
					samples.epsilon(:),...
					samples.alpha(:),...
					'xLabel','error rate, $\epsilon$',...
					'ylabel','comparison accuity, $\alpha$',...
					'pointEstimateType',obj.pointEstimateType,...
					'plotStyle', 'hist',...
					'axisSquare', true);
				
				%% Plot the psychometric function
				subplot(1,4,2)
				psycho.plot()
				
				%% Set up discount function
				ksamples = obj.coda.getSamplesAtIndex(ind,{'k'});
				% don't plot if we don't have any samples. This is expected
				% to happen if we are currently looking at the group-level
				% unobserved participant and we are analysing a model
				% without group level inferences (ie the mixed or separate
				% models)
				discountFunction = DF_Exponential1('samples', ksamples );
				
				% TODO: this checking needs to be implemented in a
				% smoother, more robust way
				if ~isempty(ksamples) || ~any(isnan(ksamples))
					%% plot distribution of k
					subplot(1,4,3)
					discountFunction.plotParameters()
					
					%% plot discount function
					subplot(1,4,4)
					discountFunction.plot()
				end
				
				
				if obj.shouldExportPlots
					myExport(obj.savePath, 'expt',...
						'prefix', names{ind},...
						'suffix', obj.modelFilename);
				end
				
				close(fh)
			end
		end
		
	end

	
	methods (Abstract)
		initialiseChainValues
    end

end