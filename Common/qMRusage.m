function qMRusage(ModelObj,mstr)
if nargin<2, mstr=methods(ModelObj); disp(['<strong>Methods available in ModelObj=' class(ModelObj) ':</strong>']); end
if ischar(mstr), mstr = {mstr}; end
for im=1:length(mstr)
    mess = {};
    switch mstr{im}
        case 'equation'
            mess = {'Compute MR signal',...
                'USAGE:',...
                '  Smodel = ModelObj.equation(x)',...
                'INPUT:',...
               ['  x: [struct] OR [vector] containing Model (' class(ModelObj) ') parameters: ' cell2str_v2(ModelObj.xnames)],...
                'EXAMPLE:',...
               ['      ModelObj = ' class(ModelObj)],...
               ['      x = struct;']};
            for ix=1:length(ModelObj.xnames)
                mess = {mess{:},...
               ['      x.' ModelObj.xnames{ix} ' = ' num2str(ModelObj.st(ix)) ';']};
            end
            mess = {mess{:},...
                '      ModelObj.equation(x)'};

            
        case 'fit'
            mess = {'Fit experimental data',...
                'USAGE:',...
                '  FitResults = ModelObj.fit(data)',...
                'INPUT:',...
                ['  data: [struct] containing: ' cell2str_v2(ModelObj.MRIinputs)]};
                if ModelObj.voxelwise
                    mess = {mess{:},'NOTE: data are 1D. For 4D datasets use FitData(data,ModelObj)'};
                end
                mess={mess{:},...
                'EXAMPLE:',...
                ['      ModelObj = ' class(ModelObj)],...
                 '      % LOAD DATA'};
            for ix=1:length(ModelObj.MRIinputs)
                mess = {mess{:},...
                ['      data.' ModelObj.MRIinputs{ix} ' = load_nii_data(''' ModelObj.MRIinputs{ix} '.nii.gz'');']};
            end
                mess = {mess{:},...
                 '      % FIT all voxels',...
                 '      FitResults = FitData(data,ModelObj);',...
                 '      % SAVE results to NIFTI',...
                ['      FitResultsSave_nii(FitResults,''' ModelObj.MRIinputs{1} '.nii.gz''); % use header from ''' ModelObj.MRIinputs{1} '.nii.gz''']};
                %['      ModelObj = ' class(ModelObj)],...
            
        case 'plotmodel'

            mess = {'Plot model equation (and fitting)',...
                'USAGE:',...
                '       ModelObj.plotmodel(x)',...
                '       ModelObj.plotmodel(x, data)',...
                'INPUT:',...
                ['  x: [struct] OR [vector] containing Model (' class(ModelObj) ') parameters: ' cell2str_v2(ModelObj.xnames)],...
                ['  data: [struct] containing: ' cell2str_v2(ModelObj.MRIinputs)],...
                'EXAMPLE:',...
                ['      ModelObj = ' class(ModelObj)],...
                ['      x = struct;']};
            for ix=1:length(ModelObj.xnames)
                mess = {mess{:},...
                ['      x.' ModelObj.xnames{ix} ' = ' num2str(ModelObj.st(ix)) ';']};
            end
            mess = {mess{:},...
                '      ModelObj.plotmodel(x)'};
            
        case 'Sim_Single_Voxel_Curve'
            Opt.SNR=50;
            
            try
                Opt = button2opts(ModelObj.Sim_Single_Voxel_Curve_buttons);
                isfieldopt = true;
            catch
                isfieldopt = false;
            end
            mess = {'Simulates Single Voxel curves:',...
                '   (1) use equation to generate synthetic MRI data',...
                '   (2) add rician noise',...
                '   (3) fit and plot curve',...
                'USAGE:',...
                '  FitResults = ModelObj.Sim_Single_Voxel_Curve(x)',...
                '  FitResults = ModelObj.Sim_Single_Voxel_Curve(x, Opt,display)',...
                'INPUT:',...
                ['  x: [struct] OR [vector] containing fit results: ' cell2str_v2(ModelObj.xnames)],...
                 '  display: [binary] 1=display, 0=nodisplay',... 
                 strrep(evalc('Opt'),sprintf(['\nOpt = \n\n']),'  Opt:'),...
                 'EXAMPLE:',...
                ['      ModelObj = ' class(ModelObj)],...
                 '      x = struct;'};
            for ix=1:length(ModelObj.xnames)
                mess = {mess{:},...
                ['      x.' ModelObj.xnames{ix} ' = ' num2str(ModelObj.st(ix)) ';']};
            end
            if isfieldopt
                mess = {mess{:},...
                 '      % Get all possible options',...
                 '      Opt = button2opts(ModelObj.Sim_Single_Voxel_Curve_buttons,1);'};
            else
                mess = {mess{:},...
                '       Opt.SNR = 50;'};
            end
            mess = {mess{:},...
                '      % run simulation using options `Opt(1)`',...
                '      ModelObj.Sim_Single_Voxel_Curve(x,Opt(1))'};
            
        case 'Sim_Sensitivity_Analysis'
            Opt.SNR=50;
            try
                Opt = button2opts([ModelObj.Sim_Single_Voxel_Curve_buttons, ModelObj.Sim_Sensitivity_Analysis_buttons]);
                isfieldopt = true;
            catch
                isfieldopt = false;
            end
            mess = {'Simulates sensitivity to fitted parameters:',...
                '   (1) vary fitting parameters from lower (lb) to upper (ub) bound in 10 steps',...
                '   (2) run Sim_Single_Voxel_Curve Nofruns times',...
                '   (3) Compute mean and std across runs',...
                'USAGE:',...
                '  SimVaryResults = ModelObj.Sim_Sensitivity_Analysis(OptTable, Opt);',...
                'INPUT:',...
                '  OptTable: [struct] nominal value and range for each parameter.',... 
               ['     st: [vector] nominal values for ' cell2str_v2(ModelObj.xnames)],...
                '     fx: [binary vector] do not vary this parameter?',...
                '     lb: [vector] vary from lb...',...
                '     ub: [vector] up to ub',...
                 strrep(evalc('Opt'),sprintf(['\nOpt = \n\n']),sprintf('  Opt: [struct] Options of the simulation with fields:\n')),...
                 'EXAMPLE:',...
                ['      ModelObj = ' class(ModelObj)],...
                ['      %              ' sprintf('%-14s',ModelObj.xnames{:})],...
                ['      OptTable.st = [' num2str(ModelObj.st,'%-14.2g') ']; % nominal values'],...
                ['      OptTable.fx = [' num2str([false true(1,length(ModelObj.xnames)-1)],'%-14.0g') ']; %vary ' ModelObj.xnames{1} '...'],...
                ['      OptTable.lb = [' num2str(ModelObj.lb,'%-14.2g') ']; %...from ' num2str(ModelObj.lb(1))],...
                ['      OptTable.ub = [' num2str(ModelObj.ub,'%-14.2g') ']; %...to ' num2str(ModelObj.ub(1))],...
                 };
            if isfieldopt
                mess = {mess{:},...
                 '      % Get all possible options',...
                 '      Opt = button2opts([ModelObj.Sim_Single_Voxel_Curve_buttons, ModelObj.Sim_Sensitivity_Analysis_buttons],1);'};
            else
                mess = {mess{:},...
                '       Opt.SNR = 50;',...
                '       Opt.Nofrun = 20;'};
            end
            mess = {mess{:},...
                '      % run simulation using options `Opt(1)`',...
                '      SimResults = ModelObj.Sim_Sensitivity_Analysis(OptTable,Opt(1))',...
               ['      SimVaryPlot(SimResults,' ModelObj.xnames{1} ',' ModelObj.xnames{1} ')']};
    end
    if ~isempty(mess)
        disp(['<strong>' mstr{im} '</strong>'])
        for imess=1:length(mess)
            disp(['   ' mess{imess}])
        end
        disp(' ')
    end
end
