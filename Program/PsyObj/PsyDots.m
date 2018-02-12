% 1.0 - Acer 2011/08/28_12:13
% 2.0 - Acer 2013/10/25 13:38
%       replace dotSize to size

classdef PsyDots < PsyDraw
    properties
        size = 6;
        xy;
        dotType = 1; % 1:circle; 0:squire
        allCenter = [];
    end    
    
%% Constructor
    methods
        function obj = PsyDots(winObj)
            obj = obj@PsyDraw(winObj);
            obj.allCenter = [winObj.xcenter winObj.ycenter];
            Screen('BlendFunction', obj.winObj.windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        end
        
%% Function function
        function draw(obj)
            Screen('DrawDots', obj.winObj.windowPtr, obj.xy, obj.size, obj.color, obj. allCenter, obj.dotType);
        end
    end
end