%======================================================================%
% Example:
%     To send TTL signal
%     p = PsyParallelPort;
%     p.enableTTL;
%     p.disablePrint;
%
% 1.1 - Acer 2013/08/15 11:24
% 2.0 - Acer 2013/08/22 14:51
%       Largely modify this funciton 
%======================================================================%

classdef PsyParallelPort < handle
    
    
    
    properties
        ParaObj;
        LineObj;
        
        pulseDuration = 0.02; %default = 20ms
    end
    

    properties %(SetAccess = protected)
        TTL_on = 0;
        Print_on = 1;        
        
        TimerObj = [];
        currentTriggerNum;
    end
    
    
    
    
    %======================================================================
    % Method for user
    %======================================================================    
    methods

        
        function obj = PsyParallelPort
        end
                
        % -----------------------------------------------------------------
        % TTL enable/disable
        % -----------------------------------------------------------------
        function enableTTL(obj)
            if isempty(obj.ParaObj)
                obj.ParaObj = digitalio('parallel','LPT1');
                obj.LineObj = addline(obj.ParaObj,0:7,0,'out');
                putvalue(obj.ParaObj,0);
            end
            obj.TTL_on = 1;
        end
        
        
        
        function disableTTL(obj)
        % stop sending any trigger. You don¡¦t have to delete any
        % trigger related lines in your script. Just disable it.
            obj.TTL_on = 0;
        end
        
        

        % -----------------------------------------------------------------
        % Print enable/disable
        % -----------------------------------------------------------------
        function enablePrint(obj)
            obj.Print_on = 1;
        end        
        
        
        function disablePrint(obj)
            obj.Print_on = 0;
        end         
        
                
        
        
        % -----------------------------------------------------------------
        % send trigger
        % -----------------------------------------------------------------
        function send(obj, value)            
            % Send 
            if obj.TTL_on
                putvalue(obj.ParaObj, value);
            end
            
            % Print on the screen
            if obj.Print_on
                fprintf('trigger: send %d\n', value);
            end            
        end
        
        
        
        % -----------------------------------------------------------------
        % Sending trigger pulse
        % -----------------------------------------------------------------
        function sendPulse(obj, triggerNum, pulseDuration)
        % Sending trigger pulse
        % SendPulse(TriggerObj, triggerNum, PulseDuration) 
        % > triggerNum: Indicate the trigger number(value)
        % > PulseDuration: sustained duration in second
        %    PulseDuration can be omitted, and the default is 0.02 (20ms)
        % 
        % Example 1
        % SendPulse(tObj, 8, 0.01);
        % 
        % Example 2
        % SendPulse(tObj, [0 0 0 1 0 0 0 0], 0.01);
        % 
        % In the two examples, Matlab sends a trigger pulse on channel 195 with 0.01s sustained duration.
        % 1.0 - Acer 2012/02/20_11:35
        
            if exist('pulseDuration', 'var') % check if pulseDuration is omitted
                if obj.pulseDuration ~= pulseDuration
                    obj.pulseDuration = pulseDuration;
                    set(obj.TimerObj, 'StartDelay', obj.pulseDuration);
                end
            end
            obj.currentTriggerNum = triggerNum;
            start(obj.TimerObj);
        end        
        
        
        % -----------------------------------------------------------------
        % Reset: Change trigger state to ZERO
        % -----------------------------------------------------------------
        function reset(obj)        
            obj.send(0);
        end         
        

%----------------------------------------------------------------------%
% I have tried 5 hours on this
% I still can't fix: 
%     '''
%     Objects of class exist.  Cannot clear this class or any of its
%     super-classes
%     '''
% I give up this part.
% Mayeb later....
% 
% Acer - 2013/08/22 14:47
%----------------------------------------------------------------------%
%         function delete(obj)           
%             obj.distruction_Timer;
%             delete(obj.TimerObj)
%             set(obj.TimerObj, 'StartFcn', []);
%             set(obj.TimerObj, 'StartDelay', 1);
%             set(obj.TimerObj, 'TimerFcn', []);
%             disp(obj.TimerObj.StartDelay);                        
%         end        
        
        
    end    %==================== end of method ===========================

    
    
    
    
    
    methods % (Access = protected)
        function initialize_Timer(obj)            
            obj.TimerObj = timer;
            set(obj.TimerObj, 'StartFcn', {@TimerStartFun, obj});
            set(obj.TimerObj, 'ExecutionMode', 'singleShot');
            set(obj.TimerObj, 'StartDelay', obj.pulseDuration);
            set(obj.TimerObj, 'TimerFcn', {@TimerStopFun, obj});
            
            function TimerStartFun(timerObj, event, obj) %#ok<*INUSL>
                obj.send(obj.currentTriggerNum);
            end
            
            function TimerStopFun(timerObj, event, obj)
                obj.reset;
            end
            
          
        end    
        
        
%         function distruction_Timer(obj)            
%             set(obj.TimerObj, 'StartFcn', []);
%             set(obj.TimerObj, 'StartDelay', 1);
%             set(obj.TimerObj, 'TimerFcn', []);
%             delete(obj.TimerObj);
%             
%         end
        
        
        
    end
    
    
    
end