% PsyLine
% 1.0 - Acer 2013/10/25 13:39
% 2.0 - Acer 2013/10/25 13:40
%======================================================================%
classdef PsyLine < PsyDraw
    
    properties
        width = 1;
        xy = [];
    end


    methods
        function obj = PsyLine(winObj)
            obj = obj@PsyDraw(winObj);
            obj.xy = [winObj.xcenter - 30, winObj.ycenter, winObj.xcenter + 30, winObj.ycenter]; 
        end
        
        function draw(obj)
            Screen('DrawLine', obj.winObj.windowPtr, obj.color, obj.xy(1), obj.xy(2), obj.xy(3), obj.xy(4), obj.width);
        end
    end
end
