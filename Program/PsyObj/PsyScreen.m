%======================================================================%
% 1.0 - Acer 2011/05/27_23:32
% 1.1 - Acer 2011/07/22_14:13
%       Add openOffScreenWindow function
% 1.2 - Acer 2012/10/25 15:15
%       Delete timing function
% 1.2.1 - Acer 2013/08/21 21:43
%       just modify the compusition
% 1.3 - Acer 2013/10/16 18:39
%       Add Priority change for Windows system
% 1.4 - Acer 2013/10/17 23:59
%       Largely modify offscreen mechanism
%       Add addOffScreen to create OffScreenWindow
%       Add flipOffScreen to present offScreenWindow
%       Delete openOffScreen method'
% 1.4.1 - Acer 2013/10/18 09:45
%         Change test window size
% 1.4.2 - Acer 2013/11/05 17:59
%         Change default key suppression to TRUE 
% 1.5 - Acer 2013/11/07 18:47
%       Add PsychImaging compatible function
%           - Gamma Correction
% 1.5.1 - Acer 2014/02/21 21:35
%         Change window close setting recovering order
% 1.6 - Acer 2015/02/03 04:09
%       Add closeOffscreen function
%======================================================================%



classdef PsyScreen < handle


    properties
        
        
        % window property after open a window
        % ----------------------------------------------------------------------
        windowPtr
        windowNum
        windowSize
        windowRect
        windowInfo
        xcenter
        ycenter
        
        
        % Screen setting
        % ----------------------------------------------------------------------
        backgroundColor = [0 0 0]
                
        
        % Resolution
        % ----------------------------------------------------------------------
        resolustion_experiment = struct('width', 1024, 'height', 768, 'pixelSize', 32, 'hz', 60)
        resolustion_original
        resolustion_old
        resolustion_available
                
        
        % Control options
        % ----------------------------------------------------------------------
        ctrl_hideCursor = true
        ctrl_hideCharInCommWin = true
        ctrl_setResolution = false
        
        
        % PsychImaging function flag
        % ----------------------------------------------------------------------
        ctrl_gammaCorrection = false
        gammaCorrection_value = 1/2.4
        
        
        
        % Affiliate Offscreen
        % ----------------------------------------------------------------------
        offScreen = []
        
        
        
        % record
        % ----------------------------------------------------------------------
        winOpenTime
        winCloseTime
        
        
        
    end
    
    
    
    
    properties (Dependent = true)
        isEnablePsychImaging
    end
    
    
    
    
    
    
    %% Methods for open and close
    methods
        function obj = PsyScreen(windowNum)
        % Constructor: creat a screen OBJ
        % Default screen is 0;
            % set defult
            if nargin < 1; windowNum = 0; end 
            obj.windowInfo = Screen('Resolution', windowNum);
            obj.resolustion_original = obj.windowInfo;
            obj.windowNum = windowNum;
            obj.resolustion_available= Screen('Resolutions', obj.windowNum);
        end
        
        
        
        
        function open(obj)            
            if obj.ctrl_setResolution % set resolution
                resolutionSet(obj);
            end
            
            
            %------------------------------------------------------------------%
            % open window
            %------------------------------------------------------------------%
            if ~obj.isEnablePsychImaging    
                % open normal window 
                [obj.windowPtr, obj.windowRect] = Screen('openwindow',...
                                                    obj.windowNum, ...
                                                    obj.backgroundColor, ...
                                                    obj.windowSize);
            else                        
                % Prepare PsychImaging window
                PsychImaging('PrepareConfiguration');
                
                if obj.ctrl_gammaCorrection
                    PsychImaging('AddTask', 'FinalFormatting',...
                                 'DisplayColorCorrection', 'SimpleGamma');                
                end
                
                
                [obj.windowPtr, obj.windowRect] = PsychImaging('OpenWindow',...
                                                    obj.windowNum, ...
                                                    obj.backgroundColor, ...
                                                    obj.windowSize);
                                                
                if obj.ctrl_gammaCorrection
                    PsychColorCorrection('SetEncodingGamma', obj.windowPtr,...
                                          obj.gammaCorrection_value);
                end
                                                
            end   % end of open window
            % -----------------------------------------------------------------%
            
            
            
            % Screen infomation 
            obj.winOpenTime = GetSecs;
            obj.xcenter = obj.windowRect(3)/2;
            obj.ycenter = obj.windowRect(4)/2;            
            
            
            % set control options
            if obj.ctrl_hideCursor; HideCursor; end
            if obj.ctrl_hideCharInCommWin; ListenChar(2); end
            
            
            % Set operation system setting
            if IsWin; Priority(2); end;                       
            
        end
        

        
        
        
        function wPtrOut = addOffScreen(obj, iOffScreen)
            % -------------------------------------------------------------
            % Add offscreen window
            % iOffScreen: offscreen index in this object
            %           Could be 1 or 1:3, etc.
            %
            % 1.0 - Acer 2013/10/17 23:58
            % -------------------------------------------------------------
            if ~exist('iOffScreen', 'var'); 
                iOffScreen = length(obj.offScreen) + 1; 
            end
            
            for ii = iOffScreen
                wPtr = Screen('OpenOffscreenWindow', obj.windowPtr, obj.backgroundColor, obj.windowSize);
                obj.offScreen(ii) = wPtr;
            end       
            
             wPtrOut = obj.offScreen(iOffScreen); 
        end
        
        
        function closeOffScreen(obj, wPtr)
        % Acer - 2015/02/03 04:04
            Screen('Close', wPtr);
            obj.offScreen(obj.offScreen == wPtr) = [];            
        end
        
        
        
        function flipTime = flipOffScreen(obj, iOffScreen)
            % 1.0 - Acer 2013/10/17 23:57
            if ~exist('iOffScreen', 'var'); iOffScreen = 1; end
            Screen('CopyWindow', obj.offScreen(iOffScreen), obj.windowPtr)
            flipTime = obj.flip();
        end
        
        
        function clearOffScreen(obj, iOffScreen)
            % 1.0 - Acer 2013/10/18 01:06
            for ii = iOffScreen
                Screen(obj.offScreen(iOffScreen), 'FillRect', obj.backgroundColor);
            end                  
        end
        
        
        
        
        
        function openTest(obj, testSize)
            % open for experimental test, just show in a small window     
            % 1.0.1 - Acer 2013/10/18 09:44
            %         Chang window size
            if ~exist('testSize', 'var'); testSize = [50 50 350 350]; end
            obj.windowSize = testSize;
            obj.ctrl_hideCursor = false;
            obj.ctrl_hideCharInCommWin = false;
            obj.open;
        end
        
        
        
        
        function close(obj)
            obj.winCloseTime = GetSecs;
            
            % I/O
            ShowCursor;
            if obj.ctrl_hideCharInCommWin; ListenChar(1); end   
            
            % system
            if IsWin; Priority(0); end;            
            
            
            % clean offscreen window
            % -----------------------------------------------------------------%
            %       2013/10/18 01:02
            if any(obj.offScreen)
                Screen('Close', obj.offScreen( obj.offScreen ~= 0) );
            end
            
            
            % close mail window
            % -----------------------------------------------------------------%
            Screen('Close', obj.windowPtr);
            
            

            % Recover setting
            % -----------------------------------------------------------------%            
            % Screen
            if obj.ctrl_setResolution
                obj.resolustion_old = SetResolution(obj.windowNum, obj.resolustion_original);
            end
            
            
            
        end
        
        
        
        
        function delete(obj)
            obj.close;
        end
        
        
        
        
        function flipTime = flip(obj)
            flipTime = Screen(obj.windowPtr,'Flip');
        end
        
        
        
        
    end
    
    %% Methods for screen resolution
    methods
        
        
        
        function resolutionDisp(obj) %#ok<MANU>
        % -----------------------------------------------------------------
        % Display current resolution and avaliable resolution
        % -----------------------------------------------------------------
            ResolutionTest;
        end
        
        
        
        function resolutionSet(obj, varargin)
        % -----------------------------------------------------------------
        % set resolution by two ways
        % 1st >> resolutionSet(width, height, hz, pixelSize)
        % 2nd >> resolutionSet >> set by build-in property: resolustion_experiment
        % 1.0 - Acer 2011/05/28_17:24
        % -----------------------------------------------------------------
            obj.resolustion_old = obj.windowInfo;
            try
                if numel(varargin) > 0
                    obj.resolustion_old = SetResolution(obj.windowNum, varargin{1}, varargin{2}, varargin{3}, varargin{4});
                elseif  numel(varargin) == 0
                    obj.resolustion_old = SetResolution(obj.windowNum, obj.resolustion_experiment);
                end
            catch err
                resol_t = nearestResolution(obj.windowNum, obj.resolustion_experiment);
                war_t = sprintf('Resolution is not exist. Set as nearest resolution.\nwidth = %d\nhight = %d\npixelSize = %d\nhz = %d\n',...
                    resol_t.width,...
                    resol_t.height,...
                    resol_t.pixelSize,...
                    resol_t.hz);
                
                h = warndlg(war_t);
                uiwait(h);
                obj.resolustion_old = SetResolution(obj.windowNum, resol_t);
                rethrow(err);
            end   
        end   
        
        
        
    end
    
    
    
    

    %% Set/Get functions    
    methods
        
        
        function v = get.isEnablePsychImaging(obj)
            v = obj.ctrl_gammaCorrection;
        end
        
        
    end
    
    
end