classdef PsyRdmObj < rdmObj & PsyDots
%======================================================================%
% 1.0 - Acer 2013/02/15 17:47
% 1.1 - Acer 2015/02/04 11:13
%       Modify functions: play
%       add function: newDotsByDistribution
%======================================================================%

    properties
        para
        dirt
        b
    end
    
    
    
    
    
    
    methods
        
        
        
        
        
        function obj = PsyRdmObj(winObj, para)
            obj = obj@PsyDots(winObj);
            obj.para = para;
            obj.b = obj.para.pRange;
            obj.size = para.dotSize;
            obj.color = para.color;
        end
        
        
        
        
        
        function newDots(obj, coh)
        %------------------------------------------------------------------
        % 1.0 - Acer 2013/02/15 17:51
        %------------------------------------------------------------------
            [obj.xy, obj.dirt] = obj.generateDot(obj.para.n, coh, obj.b);
            obj.xy = obj.xy';
        end
        
        
        function newDotsByDistribution(obj, pmf, tics)
        %------------------------------------------------------------------
        % 1.0 - Acer 2013/02/15 17:51
        %------------------------------------------------------------------
            [obj.xy, obj.dirt] = obj.generateDotByDistribution(obj.para.n, obj.b, pmf, tics);
            obj.xy = obj.xy';
        end        
        
        
        
        
        
        function play(obj, duration)
        % 1.1 - Acer 2015/02/04 11:13
            if exist('duration', 'var')
                obj.para.duration = duration;
            end
            
            t0 = GetSecs();
            while GetSecs() - t0 < obj.para.duration
                obj.draw();
                obj.flip();
                obj.xy = rdmObj.nextFrame(obj.xy', obj.dirt, obj.para.speed);
                obj.xy = rdmObj.returnToBoundary(obj.xy, obj.b)';
            end
            obj.flip();
            
        end
        
        
        
        
        
        
        function calBoundary(obj)
            obj.b = [obj.winObj.xcenter + obj.para.pRange(1), ...
                     obj.winObj.ycenter + obj.para.pRange(2), ...
                     obj.winObj.xcenter + obj.para.pRange(3), ...
                     obj.winObj.ycenter + obj.para.pRange(4), ...
                    ];            
        end
        
        
        
    end
    
    
    
    
    
    
    
end