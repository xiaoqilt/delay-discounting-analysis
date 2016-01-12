classdef ModelSeparate < ModelBaseClass
	%ModelSeperate A model to estimate the magnitide effect.
	%	Models a number of participants, but they are all treated as independent.
	%	There is no group-level estimation.

	properties (Access = protected)
	end


	methods (Access = public)

		% CONSTRUCTOR =====================================================
		function obj = ModelSeparate(toolboxPath, sampler, data, saveFolder)
			% Because this class is a subclass of "ModelBaseClass" then we use
			% this next line to create an instance
			obj = obj@ModelBaseClass(toolboxPath, sampler, data, saveFolder);

			switch sampler
				case{'JAGS'}
					obj.sampler = JAGSSampler([toolboxPath '/jagsModels/separateME.txt'])
					[~,obj.modelType,~] = fileparts(obj.sampler.fileName);
				case{'STAN'}
					error('NOT IMPLEMENTED YET')
			end

			% give sampler a handle back to the model (ie this hierarchicalME model)
			obj.sampler.modelHandle = obj;

			%% Create variables
			% -------------------------------------------------------------------
			% Participant-level -------------------------------------------------
			m = Variable('m','m', [], true);
			m.seed.func = @() normrnd(-0.243,10);
			m.seed.single = false;

			m_prior = Variable('m_prior','m prior', [], true);
			m_prior.seed.func = @() normrnd(-0.243,10);
			m_prior.seed.single = true;

			c = Variable('c','c', [], true);
			c.seed.func = @() normrnd(0,10);
			c.seed.single = false;

			c_prior = Variable('c_prior','c prior', [], true);
			c_prior.seed.func = @() normrnd(0,10);
			c_prior.seed.single = true;

			epsilon = Variable('epsilon','\epsilon', [0 0.5], true);
			epsilon.seed.func = @() rand/2;
			epsilon.seed.single = false;

			epsilon_prior = Variable('epsilon_prior','\epsilon prior', [0 0.5], true);
			epsilon_prior.seed.func = @() rand/2;
			epsilon_prior.seed.single = true;

			alpha = Variable('alpha','\alpha', 'positive', true);
			alpha.seed.func = @() abs(normrnd(0,10));
			alpha.seed.single = false;

			alpha_prior = Variable('alpha_prior','\alpha prior', 'positive', true);
			alpha_prior.seed.func = @() abs(normrnd(0,10));
			alpha_prior.seed.single = true;

			% posterior predictive ----------------------------------------------
			Rpostpred = Variable('Rpostpred','Rpostpred', [0 1], true);
			Rpostpred.plotMCMCchainFlag = false;

			% define which to analyse (univariate analysis)
			m.analysisFlag = 1;
			c.analysisFlag = 1;
			epsilon.analysisFlag = 1;
			alpha.analysisFlag = 1;

			% Create a Variable array -------------------------------------------
			obj.variables = [m, c, epsilon, alpha,...
				m_prior, c_prior, epsilon_prior, alpha_prior,...
				Rpostpred];
			
			% Variable list, used for plotting
			obj.varList.participant_level_variables = {'m', 'c','alpha','epsilon'};
			
			obj.varList.participant_level_prior_variables={'m_prior',...
				'c_prior',...
				'alpha_prior',...
				'epsilon_prior'};
		end
		% ================================================================
		
		
		function plot(obj)
			close all
			
			% plot univariate summary statistics for the parameters we have
			% made inferences about
			obj.figUnivariateSummary(obj.data.IDname, obj.varList.participant_level_variables)
			% EXPORTING ---------------------
			latex_fig(16, 5, 5)
			myExport(obj.saveFolder, obj.modelType, '-UnivariateSummary')
			% -------------------------------
			
			obj.plotPsychometricParams( obj.sampler.getAllSamples() )
			myExport(obj.saveFolder, obj.modelType, '-PsychometricParams')
			
			obj.figParticipantLevelWrapper(obj.varList.participant_level_variables,...
				obj.varList.participant_level_prior_variables)
		end

	end


	methods(Static)

		function plotPsychometricParams(samples)
			% Plot priors/posteriors for parameters related to the psychometric
			% function, ie how response 'errors' are characterised
			figure(7), clf
			P=size(samples.m,3); % number of participants
			%====================================
			subplot(3,2,1)
			plotPriorPostHist(samples.alpha_prior(:), []);
			title('\alpha prior')

			subplot(3,2,5)
			for p=1:P % plot participant level alpha (alpha(:,:,p))
				%histogram(vec(samples.alpha(:,:,p)));
				[F,XI]=ksdensity(vec(samples.alpha(:,:,p)),...
					'support','positive',...
					'function','pdf');
				plot(XI, F)
				hold on
			end
			xlabel('\alpha_p')
			box off
			%====================================
			subplot(3,2,2)
			plotPriorPostHist(samples.epsilon_prior(:), []);
			title('\epsilon prior')

			% subplot(3,4,7),
			% plotPriorPostHist(samples.wprior(:), samples.w(:));
			% xlabel('\omega (mode)')
			%
			% subplot(3,4,8),
			% plotPriorPostHist(samples.kprior(:), samples.k(:));
			% xlabel('\kappa (concentration)')

			subplot(3,2,6)
			for p=1:P % plot participant level alpha (alpha(:,:,p))
				%histogram(vec(samples.epsilon(:,:,p)));
				[F,XI]=ksdensity(vec(samples.epsilon(:,:,p)),...
					'support','positive',...
					'function','pdf');
				plot(XI, F)
				hold on
			end
			xlabel('\epsilon_p')
			box off
		end

	end


end
