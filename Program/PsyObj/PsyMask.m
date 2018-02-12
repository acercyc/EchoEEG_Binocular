%======================================================================%
% Make Mask
%
% Current, this only works on [0 0 0] background properly
% Still need to solve that background color is not black
%
% 1.0 - Acer 2013/10/18 10:00
%======================================================================%

classdef PsyMask < handle
    
    properties
        winObj = [];
        offScreenCanvasPtr = [];
        imageArray = [];
        textureIndex = [];
    end
    
    
    
    
    methods
        function obj = PsyMask(w)
            % 1.0 - Acer 2013/10/18 10:00
            obj.winObj = w;
            obj.offScreenCanvasPtr = Screen('OpenOffscreenWindow', ...
                            w.windowPtr,...
                            [0 0 0], ...
                            w.windowSize);            
        end
        
        
        
        function addDraw(obj, drawObj)
            % 1.0 - Acer 2013/10/18 10:03
            drawObj.drawOnWindow( obj.offScreenCanvasPtr );            
        end
        
        
        
        function draw(obj)
            
            % Get image from canvas
            obj.imageArray = Screen('GetImage', obj.offScreenCanvasPtr);
            
            % create alpha layer
            obj.imageArray(:,:,4) = obj.imageArray(:,:,1);
            
            % Re-make texture 
            obj.textureIndex = Screen('MakeTexture',...
                                        obj.winObj.windowPtr,...
                                        obj.imageArray);         
            
            % Change blending function
            [sOld, dOld] = Screen('BlendFunction',...
                obj.winObj.windowPtr,...
                GL_ZERO, GL_SRC_ALPHA);            
            
            % Draw Mask on target window
            Screen('DrawTexture', obj.winObj.windowPtr, obj.textureIndex);            
            
            % Change blending back
            Screen('BlendFunction',...
                obj.winObj.windowPtr,...
                sOld, dOld);                        
            
        end
        
        
        
        function clearCanvas(obj)
            Screen(obj.offScreenCanvasPtr, 'FillRect', [0 0 0]);
        end
        
        
        
    end
    
    
    
    
end