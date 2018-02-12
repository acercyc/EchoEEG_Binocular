classdef PsyPic < PsyDraw
%======================================================================%
% 
% 1.0 - Acer 2012/11/21 14:48
% 1.1 - Acer 2013/10/19 15:41
%       Add mechanism to clean texture memory when change new picture
%======================================================================%


    properties
        origSize
        targetSize = []
        targetCenter = [];
        xy = []
        imgInfo = []
        imgArray = []
        imgIndex = []
        rotationAngle = 0
    end

    methods
        function obj = PsyPic(winObj)
            obj = obj@PsyDraw(winObj);
            obj.targetCenter = [winObj.xcenter winObj.ycenter];
        end
        
        function read(obj, filename)
            obj.imgArray = imread(filename);
            obj.imgInfo = imfinfo(filename);
            % obj.origSize(1) = obj.imgInfo.Width;
            % obj.origSize(2) = obj.imgInfo.Height;
            % obj.targetSize = obj.origSize;
        end
        
        function MakeTexture(obj)
        % 1.1 - Acer 2013/10/19 15:33
            if ~isempty(obj.imgIndex)
                Screen('close', obj.imgIndex);
            end
            obj.imgIndex = Screen('MakeTexture',...
                                  obj.winObj.windowPtr, obj.imgArray);
            obj.xySet();
        end
        
        function draw(obj)
            if isempty(obj.imgIndex)
                error('No image index in this object. Nothing can be drawn.')
            end
            Screen('DrawTexture',...
                   obj.winObj.windowPtr,...
                   obj.imgIndex,...
                   [],...
                   obj.xy,...
                   obj.rotationAngle);            
        end
        
        function delete(obj)
            if ~isempty(obj.imgIndex)
                Screen('close', obj.imgIndex);
            end
        end        
        
        % set functions
        %------------------------------------------------------------------
        function set.targetCenter(obj,value)
            if numel(value) ~= 2
                error('targetCenter input error');
            end
            obj.targetCenter = value;
            if ~isempty(obj.imgArray)               
                obj.xySet();
            end
        end
        
        function set.targetSize(obj,value)
            if numel(value) ~= 2
                error('targetSize input error');
            end
            obj.targetSize = value;
            if ~isempty(obj.imgArray) 
                obj.xySet(); 
            end
        end
        
        function set.imgArray(obj,value)
            obj.imgArray = value;
            obj.origSize(1) = size(obj.imgArray, 2);
            obj.origSize(2) = size(obj.imgArray, 1);  %#ok<*MCSUP>
            obj.MakeTexture();            
        end         
    end
    
    
    methods (Hidden = true, Access = private)
        function xySet(obj)
            if isempty(obj.targetSize)
                obj.xy = [(obj.targetCenter(1) - obj.origSize(1)/2), ...
                          (obj.targetCenter(2) - obj.origSize(2)/2), ...
                          (obj.targetCenter(1) + obj.origSize(1)/2), ...
                          (obj.targetCenter(2) + obj.origSize(2)/2)];                   
            else
                obj.xy = [(obj.targetCenter(1) - obj.targetSize(1)/2), ...
                          (obj.targetCenter(2) - obj.targetSize(2)/2), ...
                          (obj.targetCenter(1) + obj.targetSize(1)/2), ...
                          (obj.targetCenter(2) + obj.targetSize(2)/2)];   
            end
        end
    end    
end
