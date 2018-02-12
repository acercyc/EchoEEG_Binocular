classdef PsyRespWheelObj < PsyDraw
% 1.0 - Acer 2015/02/04 16:59
% 1.1 - Acer 2015/02/06 11:30
    
    properties
        aSpeed = pi/360;
        initialAngle = -pi/2;
        ovalObj = [];
        lineObj = [];
        xy = []
        cSize           % circle size
        
    end
    
    
    
    methods
        function obj = PsyRespWheelObj(winObj)
            % c: size of the wheel
            obj = obj@PsyDraw(winObj);     
            obj.cSize = 300;
            
            obj.ovalObj = PsyFrameOval(winObj);
            obj.ovalObj.size = [obj.cSize obj.cSize];
            obj.ovalObj.penHeight = 2;
            obj.ovalObj.penWidth = 2;

            obj.lineObj = PsyLine(winObj); 
            obj.lineObj.width = 4;        
        end        
        
        
        function draw(obj)
            obj.ovalObj.draw();
            obj.lineObj.draw();            
        end
        
        
        
        function [a, rt, respTiming] = play(obj)
        % This method reset the mouse position at every draw to prevent the mouse is at boundary
            t0 = GetSecs();
            a = obj.initialAngle;
            SetMouse(round(obj.winObj.xcenter), round(obj.winObj.ycenter));
            isPress = 0;
            while ~isPress
                [mx, ~, isPress] = GetMouse();
                respTiming = GetSecs();
                SetMouse(round(obj.winObj.xcenter), round(obj.winObj.ycenter));                
                aDiff = (round(mx) - round(obj.winObj.xcenter)) * obj.aSpeed;
                a = a + aDiff;
                obj.lineObj.xy = [obj.ovalObj.center obj.ovalObj.center + [cos(a) sin(a)]*obj.cSize/2];
                obj.draw();
                obj.winObj.flip();                
            end
            rt = respTiming - t0;
            a = mod(a, 2*pi);
        end
            
        
        
        function [a, rt, respTiming] = play_backup_20150206(obj)     
        % This method doesn't reset the mouse position in every draw. 
            a = obj.initialAngle;
            [mx0, ~, isPress] = GetMouse(obj.winObj.windowPtr);
            t0 = GetSecs();
            while ~isPress
                [mx, ~, isPress] = GetMouse(obj.winObj.windowPtr);
                respTiming = GetSecs();
                aDiff = (mx - mx0) * obj.aSpeed;
                mx0 = mx;
                a = a + aDiff;
                obj.lineObj.xy = [obj.ovalObj.center obj.ovalObj.center + [cos(a) sin(a)]*obj.cSize/2];
                obj.draw();
                obj.winObj.flip();                
            end
            rt = respTiming - t0;
            a = mod(a, 2*pi);
        end        
        
        
        
        function set.cSize(obj, value)
            obj.ovalObj.size = [value value]; %#ok<*MCSUP>
            obj.cSize = value;
        end
        
        
        
        
    end
        
end