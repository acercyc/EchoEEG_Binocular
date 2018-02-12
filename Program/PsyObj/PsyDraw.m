%======================================================================%
% 1.1 - Acer 2011/06/03_15:04
% 1.2 - Acer 2012/10/25 15:14
%       Delete timing function 
% 1.3 - Acer 2012/11/29 00:40
%       Return flip time
% 1.4 - Acer 2013/03/05 10:49
%       Return flip time for .play()
% 1.5 - Acer 2013/08/23 14:02
%       Delete QuitPsych
% 1.6 - Acer 2013/10/18 00:01
%       Add drawOnOffScreen
% 1.6.1 - Acer 2013/10/18 09:37
%======================================================================%
classdef PsyDraw < handle

    properties
        % Present to window
        winObj;
        
        % attribute
        color = [200 200 200];
        flipTime;        
        % time

    end
    
    properties (Abstract = true)
        xy;
    end

    methods
        function obj = PsyDraw(winObj)
            obj.winObj = winObj;
        end
    
        function flipTime = play(obj)
            obj.draw;
            flipTime = obj.flip;
        end
        
        function flipTime = flip(obj)
            flipTime = Screen(obj.winObj.windowPtr,'Flip');
            
            % ---------------------------------------------
            % delete this part to increase the performance
            % Acer - 2013/08/23 14:02
            % ---------------------------------------------
            % obj.flipTime = flipTime;
            % QuitPsych;
            % ---------------------------------------------
        end        
    end
    
    
    methods
        
        
        
        function drawOnOffScreen(obj, iOffScreen)
            % 1.0 - Acer 2013/10/18 00:03
            % 1.0.1 - Acer 2013/10/18 09:40
            
            if ~exist('iOffScreen', 'var'); iOffScreen = 1; end
            
            % Check if this off screen exist
            % If not, open a new one
            if length(obj.winObj.offScreen) < iOffScreen
                obj.winObj.addOffScreen(iOffScreen);
            elseif obj.winObj.offScreen(iOffScreen) == 0
                obj.winObj.addOffScreen(iOffScreen);
            end

            obj.drawOnWindow( obj.winObj.offScreen(iOffScreen) );           
        end
        
        
        function drawOnWindow(obj, wPtr)
            % 1.0 - Acer 2013/10/18 09:37
            wPtr_t = obj.winObj.windowPtr;
            obj.winObj.windowPtr = wPtr;
            obj.draw();
            obj.winObj.windowPtr = wPtr_t;            
        end        
        
        
    end
    
    
    
    methods (Abstract)
        draw(obj);
    end     
end
