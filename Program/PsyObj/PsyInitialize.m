classdef PsyInitialize < handle
    
% Initialization
% 1.0 - Acer 2010/7/27
% 1.1 - Acer 2011/05/27_14:00
% 1.2 - Acer 2011/06/03_14:34
% 1.3 - Acer 2013/10/21 12:24
% 1.4 - Acer 2014/02/20 19:11
%       Add KbName('UnifyKeyNames')

    properties 
        % envirSetting
        SkipSyncTests = 0;
        VisualDebugLevel = 3;
        SuppressAllWarnings = 1;
        
        oldSupressAllWarnings;
        oldVisualDebugLevel;
        oldSkipSyncTests;
        
    end
    
    methods        
        function obj = PsyInitialize
            envirSet(obj);
        end
    end
    
    methods %(Static) may write this as a Static finction in the future
        function envirSet(obj)
            AssertOpenGL;
            KbName('UnifyKeyNames');
            
            obj.oldVisualDebugLevel = Screen('Preference','VisualDebugLevel', obj.VisualDebugLevel);
            obj.oldSupressAllWarnings = Screen('Preference','SuppressAllWarnings', obj.SuppressAllWarnings);
            obj.oldSkipSyncTests = Screen('Preference', 'SkipSyncTests', obj.SkipSyncTests);
        end
        
        
        
        function envirSetByManual(obj)
            % Setting for 
            % VisualDebugLevel
            % SuppressAllWarnings /
            % SkipSyncTests/ 
            % the second argument is for GUI input (ByManual == 1)
            % 1.0 - Acer 2010/7/27
            
            % GUI input
            PromptCell{1} = 'VisualDebugLevel (0~5)';
            PromptCell{2} = 'SuppressAllWarnings (0/1)';
            PromptCell{3} = 'SkipSyncTests (0/1)';

            defCell{1} = num2str(obj.VisualDebugLevel);
            defCell{2} = num2str(obj.SuppressAllWarnings);
            defCell{3} = num2str(obj.SkipSyncTests);

            SetFlag = inputdlg(PromptCell, 'Environment Settings', 1, defCell);

            obj.VisualDebugLevel = str2num(SetFlag{1});
            obj.SuppressAllWarnings = str2num(SetFlag{2});
            obj.SkipSyncTests = str2num(SetFlag{3});
  
            envirSet(obj);
        end
        
        
        function set.SkipSyncTests(obj, value)
            % 1.0 - Acer 2013/10/21 12:26
            obj.oldSkipSyncTests = Screen('Preference', 'SkipSyncTests', value);
            obj.SkipSyncTests = value;
            fprintf('SkipSyncTests is set to %d\n', value);
        end
        
        function set.VisualDebugLevel(obj, value)
            % 1.0 - Acer 2013/10/21 12:26
            obj.oldVisualDebugLevel = Screen('Preference','VisualDebugLevel', value);
            obj.VisualDebugLevel = value;
            fprintf('VisualDebugLevel is set to %d\n', value);
        end

        function set.SuppressAllWarnings(obj, value)
            % 1.0 - Acer 2013/10/21 12:26
            obj.oldSupressAllWarnings = Screen('Preference','SuppressAllWarnings', value);            
            obj.SuppressAllWarnings = value;
            fprintf('SuppressAllWarnings is set to %d\n', value);
        end        
        
        
        
    end
end