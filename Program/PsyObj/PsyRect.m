%======================================================================%
% 1.1 - Acer 2013/08/14 12:50
%       Large modify the locating mechanism (refer to PsyOval)
% 1.2 - Acer 2013/10/25 11:52
%       Add frame rect and penWidth
%======================================================================%

classdef PsyRect < PsyDraw
    properties
        size = [30 30]
        center
        xy
        penWidth = 1;
    end
    
    
    properties (Hidden = true, Access = private)
        setFlag = 0;
    end
    
    
    
    
    
    methods
        function obj = PsyRect(winObj)
            obj = obj@PsyDraw(winObj);
            obj.center = [winObj.xcenter winObj.ycenter];
            obj.xySet;
        end
        
        function draw(obj)
            Screen(obj.winObj.windowPtr,'FillRect', obj.color, obj.xy);
        end
        
        function drawFrameRect(obj)
            Screen(obj.winObj.windowPtr,'FrameRect', obj.color, obj.xy, obj.penWidth);
        end
        
        function t = playFrameRect(obj)
            obj.drawFrameRect();
            t = obj.winObj.flip();
        end          
        
        function blank(obj)
            Screen(obj.winObj.windowPtr,'FillRect', obj.winObj.backgroundColor);
        end
        
        function playBlank(obj)
            obj.blank;
            obj.flip;
        end
    end
    
    

    
    % 'Set' functions
    % ---------------------------------------------------------------------
    % 1.0 - Acer 2013/08/14 12:55
    % ---------------------------------------------------------------------
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
    
    
    
    
    
    % Private function
    % --------------------------------------------------------------------
    methods (Hidden = true, Access = private)
        function xySet(obj)
            obj.xy = [(obj.center(1) - obj.size(1)/2), ...
                      (obj.center(2) - obj.size(2)/2), ...
                      (obj.center(1) + obj.size(1)/2), ...
                      (obj.center(2) + obj.size(2)/2)];     
        end
    end    
    
    
    
    
    
end