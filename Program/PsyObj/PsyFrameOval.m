classdef PsyFrameOval < PsyOval
%======================================================================%
% 1.0 - Acer 2015/02/04 11:38
%======================================================================%
    
    properties        
        penWidth = 1;
        penHeight = 1;
    end
    
    properties (Hidden = true, Access = private)
        setFlag = 0;
    end
    
    
    
%% Constructor
    methods
        function obj = PsyFrameOval(winObj)
            obj = obj@PsyOval(winObj);         
        end
        
%% Function function
        function draw(obj)
            Screen('FrameOval', obj.winObj.windowPtr, obj.color, obj.xy, obj.penWidth, obj.penHeight);
        end
    end
    
    
end