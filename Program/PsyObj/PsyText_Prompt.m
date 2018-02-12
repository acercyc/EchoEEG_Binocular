classdef PsyText_Prompt < PsyText & PsyResp
% 1.0 - Acer 2011/06/23_03:13
% 2.0 - Acer 2012/11/22 08:01
%       Change the name from PsyText_meg to PsyText_Prompt
% 3.0 - Acer 2013/10/25 12:02
%       Change Text to text
%       May not compatable with old code
% 3.0.1 - Acer 2013/11/11 12:51
%         Add play instruction function
%         - playInstruction_textfile
%         - playInstruction_imgfile
% 3.1 - Acer 2015/02/03 12:45
%       Add play goodbye screen function
% 3.2 - Acer 2015/02/07 11:59
%       Modify playRest_Block_pressKey
%       Add playRest_Block_pressKey_autodetect

    properties
    end
    
    methods
        function obj = PsyText_Prompt(winObj)
            obj = obj@PsyText(winObj);
        end        
        
        
        function playWelcome_and_prompt(obj)
            obj.text = sprintf('Welcome to this experiment\n\nPress SPACE to start');
            obj.playCenter;
            obj.allowKey = 'space';
            obj.waitPress();
            obj.flip();            
        end
        
        function playGoodBye_and_prompt(obj)
        % Acer - 2015/02/03 12:46
            obj.text = sprintf('Thank you for your participation.\n\nPress SPACE to exit the program');
            obj.playCenter;
            obj.allowKey = 'space';
            obj.waitPress();
            obj.flip();            
        end        
                
        
        function playRest_Block_pressKey(obj, blockNum)
        % 1.1 - Acer 2015/02/07 11:21
            obj.text = sprintf('Remain %d block(s)\n\nPress SPACE to continue', blockNum);
            obj.playCenter; 
            obj.allowKey = 'space';
            obj.waitPress();
            obj.flip();            
        end
        
        function playRest_Block_pressKey_autodetect(obj, iTrial, nTrialInBlock, nTotalTrial)
        % 1.0 - Acer 2015/02/07 11:20
            [remainBlcok, iTrialInBlcok] = calBlockRemain(iTrial, nTrialInBlock, nTotalTrial);
            if iTrialInBlcok == 1 && iTrial ~= 1
                obj.playRest_Block_pressKey(remainBlcok);  
            end
        end
        
        
        
        function playRest_CountDown(obj, sec)
            t1 = GetSecs();
            while GetSecs() - t1 < sec
                obj.text = sprintf('Take a break. Please wait.\n\n%d', sec - ceil(GetSecs() - t1) + 1);
                obj.playCenter;
            end
            obj.text = 'Press SPACE to continue';
            obj.playCenter;
            obj.allowKey = 'space';
            obj.waitPress();
            obj.flip();
        end
        
        
        function playInstruction_textfile(obj, file, wrapat, vSpacing)
        % 1.0 - Acer 2013/11/11 12:56
            if ~exist('wrapat', 'var'); wrapat = []; end
            if ~exist('vSpacing', 'var'); vSpacing = 2; end
            text = fileread(file);
            DrawFormattedText(obj.winObj.windowPtr, text, [],[],...
                                        obj.color, wrapat, [], [],...
                                        vSpacing, [], []);
            obj.flip();
        end
        
        
        function playInstruction_imgfile(obj, file)
        % 1.0 - Acer 2013/11/11 12:56
            p = PsyPic(obj.winObj);
            p.read(file);
            p.targetSize = fitImageSize(p.origSize, obj.winObj.windowRect(3:4));
            p.play();
        end

    end
    
    
end