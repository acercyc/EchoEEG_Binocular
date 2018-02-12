classdef PsyOval < PsyDraw
%======================================================================%
% Modified by Acer 2013/02/13 15:48
% 2.0 - Acer 2013/10/25 13:34
%       Change ObjSize to size
% 2.1 - Acer 2015/02/04 12:49
%       change private function
%======================================================================%
    
    properties
        size = [30 30];
        xy;
        center;
    end
    
    properties (Hidden = true, Access = private)
        setFlag = 0;
    end
    
    
    
%% Constructor
    methods
        function obj = PsyOval(winObj)
            obj = obj@PsyDraw(winObj);
            obj.center = [winObj.xcenter winObj.ycenter];
            obj.xySet;            
        end
        
%% Function function
        function draw(obj)
            Screen('FillOval', obj.winObj.windowPtr, obj.color, obj.xy);
        end
    end

%% 'Set' functions
    methods 
        function set.center(obj,value)
            if numel(value) ~= 2
                error('center input error');
            end
            obj.center = value;
            if obj.setFlag == 0 %#ok<*MCSUP>
                obj.setFlag = 1;
                xySet(obj);     
                obj.setFlag = 0;
            end
        end
        
        function set.size(obj, value)
            if numel(value) ~= 2
                error('size input error');
            end            
            obj.size = value;
            if obj.setFlag == 0 %#ok<*MCSUP>
                obj.setFlag = 1;
                xySet(obj);     
                obj.setFlag = 0;
            end
        end   
        
        function set.xy(obj, value)
            if numel(value) ~= 4
                error('xy input error');
            end            
            obj.xy = value;
            if obj.setFlag == 0 %#ok<*MCSUP>
                obj.setFlag = 1;
                obj.center = [mean(value([1 3])), mean(value([2 4]))];
                obj.size = [(value(3) - value(1)), (value(4) - value(2))];
                obj.setFlag = 0;
            end
        end           
    end
    
%% Private function
    methods (Hidden = true)
        function xySet(obj)
            obj.xy = [(obj.center(1) - obj.size(1)/2), ...
                      (obj.center(2) - obj.size(2)/2), ...
                      (obj.center(1) + obj.size(1)/2), ...
                      (obj.center(2) + obj.size(2)/2)];     
        end
    end
end