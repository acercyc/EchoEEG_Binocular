classdef ExpInfObj < handle    
%======================================================================%
% 1.0 - Acer 2014/06/30 18:07
%======================================================================%


    properties
        StartTime = datestr(now,'ddmmyyyy_HH_MM_SS')
        EndTime = [];

    end
    
    
    methods
        function obj = ExpInfObj()
        end
        
        
        %----------------------------------------------------------------------%
        % Set start time
        % 1.0 - Acer 2014/06/30 18:08
        %----------------------------------------------------------------------%
        function timeStr = SetStartTime(obj, timeStr)        
            if ~exist('timeStr', 'var')
                obj.StartTime = datestr(now,'ddmmyyyy_HH_MM_SS');
                timeStr = obj.StartTime;
            end
        end
        
        
        
    end
    
    
    
    
    
end