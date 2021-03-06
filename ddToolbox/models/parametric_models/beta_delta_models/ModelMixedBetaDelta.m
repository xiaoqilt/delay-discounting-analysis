classdef ModelMixedBetaDelta < BetaDelta
	%ModelMixedBetaDelta Model for BetaDelta discount function, partial pooling
	%  SOME parameters are estimated hierarchically.

	methods (Access = public, Hidden = true)
		function obj = ModelMixedBetaDelta(data, varargin)
			obj = obj@BetaDelta(data, varargin{:});
			obj.modelFilename = 'mixedBetaDelta';
            obj = obj.addUnobservedParticipant('GROUP');

            % MUST CALL THIS METHOD AT THE END OF ALL MODEL-SUBCLASS CONSTRUCTORS
            obj = obj.conductInference();
		end
    end

    methods (Access = protected)

		function initialParams = initialiseChainValues(obj, nchains)
			% Generate initial values of the root nodes
			nExperimentFiles = obj.data.getNExperimentFiles();
			for chain = 1:nchains
				initialParams(chain).beta 	= unifrnd(0, 1, [nExperimentFiles-1,1]);
				initialParams(chain).delta 	= unifrnd(0, 1, [nExperimentFiles-1,1]);
				initialParams(chain).groupW             = rand;
				initialParams(chain).groupALPHAmu		= rand*100;
				initialParams(chain).groupALPHAsigma	= rand*100;
			end
		end

	end

end
