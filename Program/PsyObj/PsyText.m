classdef PsyText < PsyDraw
% 1.0 - Acer 2011/06/07_14:57 
% 1.0.1 - Acer 2012/11/15 18:04
%         Modify drawCenter()
% 1.0.2 - Acer 2013/10/18 10:59
%         Temporally set draw() to drawCenter()
% 2.0 - Acer 2013/10/25 11:59
%       Change Text to text!!! 
%       May not compatable with old code
% 2.1 - Acer 2013/10/25 18:05
% 2.2 - Acer 2013/10/31 17:33
%       Fix an TextStyle bug
%       Add default value
%       Delete preset words presentation
% 2.3 - Acer 2015/02/02 18:42
%       modify function drawCenter to make the it can draw at any arbitrary center. 

    properties
        text = 'Test Words';
        textFont = [];
        textSize = [];
        textStyle = []; % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend
        center = []
        textbounds = [];
        penX = [];
        penY = [];
        
        xy;
    end

    methods
        function obj = PsyText(winObj)
            obj = obj@PsyDraw(winObj);
            obj.center = [winObj.xcenter winObj.ycenter];
            obj.textFont = Screen('Preference', 'DefaultFontName');
            obj.textSize = Screen('Preference', 'DefaultFontSize');
            obj.textStyle = Screen('Preference', 'DefaultFontStyle');
        end
        
        
        function [nx, ny, textbounds] = drawCenter(obj, text, centerAt)
            % Acer - 2015/02/02 18:41
            
            if exist('text', 'var'); obj.text = text; end
            if exist('centerAt', 'var')
                wOff = obj.winObj.addOffScreen;                
                Screen('TextStyle', wOff, obj.textStyle);            
                Screen('TextFont', wOff, obj.textFont);
                Screen('TextSize', wOff, obj.textSize);
                bounds = TextBounds_unicode(wOff, obj.text);
                Screen(wOff,'DrawText', text, 0, 0, obj.color);
                textbounds = CenterRectOnPoint(bounds, centerAt(1), centerAt(2));
                Screen('CopyWindow', wOff, obj.winObj.windowPtr, bounds, textbounds);
                obj.winObj.closeOffScreen(wOff);
                obj.textbounds = textbounds;
                nx = [];
                ny = [];
            else
                [nx, ny, textbounds] = DrawFormattedText(obj.winObj.windowPtr,...
                    obj.text,'center','center',...
                    obj.color,...
                    [],[],[],[],[],...
                    obj.makeCenterRect( obj.center ) );
                obj.textbounds = textbounds;
                obj.penX = nx;
                obj.penY = ny;
            end
        end
                
        
        function draw(obj) %#ok<*MANU>
            %===================================================================
            % This is just temporally setting
            % Could be changed in the future!!!!!            
            obj.drawCenter();
            % Acer - 2013/10/18 10:58            
            %===================================================================
            
        end
        
        function [nx, ny, textbounds] = playCenter(obj, varargin)
            [nx, ny, textbounds] = obj.drawCenter(varargin{:});
            obj.flip;            
        end
        
        
    end

    
    
    
    %======================================================================%
    % SET methods 
    %======================================================================%
    methods
        function set.textFont(obj, value)
            obj.textFont = value;
            Screen('TextFont', obj.winObj.windowPtr, obj.textFont);
        end
        
        function set.textSize(obj, value)
            obj.textSize = value;
            Screen('TextSize', obj.winObj.windowPtr, obj.textSize); %#ok<*MCSUP>
        end
            
        function set.textStyle(obj, value)
            obj.textStyle = value;
            Screen('TextStyle', obj.winObj.windowPtr, obj.textStyle);            
        end        
    end
    
    
    
    
    
    methods (Access = protected)
        function xyRect = makeCenterRect(~, xy)
            xyRect = [xy(1)-1 xy(2)-1 xy(1)+1 xy(2)+1];
        end
    end
    
    
    
    
    
    
end
