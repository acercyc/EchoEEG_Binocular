classdef PsyCommandWindowMessage < handle
   properties
   end
   
   
   methods   
       
       function blockMessage(obj, s)
           fprintf('%s\n%s\n%s\n',...
               obj.repPrint('=', 40), s, obj.repPrint('=',40));
       end

       function blockMessageLarge(obj, s, line)
           if ~exist('line', 'var')
               line = 5;
           end
           ts = [];
           for ii = 1:line
               ts = [ts obj.repPrint('=', 45 - ii*5) sprintf('\n')];
           end
           
           fprintf('%s\n%s\n%s\n',...
               ts, s, fliplr(ts));
       end       
       
       
   end
   
   
   
   
   methods (Static)
       function trialNum(trialNum)
           fprintf('Trial # = %d\n', trialNum);
       end
       
       
       function s = repPrint(s, n)
           s = repmat(s, 1, n);
       end
       
       
       
   end
    
    
    
    
end