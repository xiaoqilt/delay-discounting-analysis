classdef test_frontend_delay_plotting < matlab.unittest.TestCase

	properties
		data
		datapath
		filesToAnalyse
	end

	properties (TestParameter)

	end

	methods (TestClassSetup)
		function setup(testCase)
			% assuming this is running on my maching
			addpath('~/git-local/delay-discounting-analysis/ddToolbox')
			testCase.datapath = '~/git-local/delay-discounting-analysis/demo/datasets/test_data';
			testCase.data = Data(testCase.datapath, 'files', {'example.txt'});
		end
	end



	methods (Test)

		function logk_plotting(testCase)
			% Do an analysis
			model = ModelSeparateLogK(...
				testCase.data,...
				'savePath', fullfile(pwd,'output','logk_analysis'),...
				'pointEstimateType', 'median',...
				'shouldPlot', 'yes',...
				'shouldExportPlots', false,...
				'mcmcParams', struct('nsamples', get_numer_of_samples_for_tests(),...
				'nchains', 2,...
				'nburnin', get_burnin_for_tests()));
		end

		function me_plotting(testCase)
			% Do an analysis
			model = ModelSeparateME(...
				testCase.data,...
				'savePath', fullfile(pwd,'output','me_analysis'),...
				'pointEstimateType', 'median',...
				'shouldPlot', 'yes',...
				'shouldExportPlots', false,...
				'mcmcParams', struct('nsamples', get_numer_of_samples_for_tests(),...
				'nchains', 2,...
				'nburnin', get_burnin_for_tests()));
		end


	end

end
