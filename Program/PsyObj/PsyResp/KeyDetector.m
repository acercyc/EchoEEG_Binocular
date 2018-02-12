function [keyIsDown, secs, keyName, keyCode, iKey] = KeyDetector(key)
% [keyIsDown secs keyName keyCode] = KeyDetector(key)
% Detect a certain key or key combination is pressed and return logical
% value
% ***** work with KbName_acer.m to prevent L/R key error******
%
% input: key
% !!!!! The format of input argument 'key' is crucial important!!!!!
% is string >> allow to detect one key
%              ex: key = 'left_control'
%
% is cell including strings >> allow to detect key combination 
%          ex: key = {'left_control' 'right_control'}, press two keys
%          together to trigger action
%
% is cell including cells >> allow to detect multiple key or key
%                            combination
%          ex1: key = {{'left_control' 'right_control'} {'a' 'b'}}
%              press either two controls or 'a and b' to trigger action
%          ex2: key = {{'z'} {'/?'}}
%              press either z or /? to trigger action
%
%   
% 1.0 - Acer 2011/05/25_15:14
% 2.0 - Acer 2011/06/08_17:26
% 2.0.1 - Acer 2013/10/16 18:52
%         just add comma on output
% 2.1 - Acer 2013/10/31 16:50
% 2.2 - Acer 2015/03/22 13:03
%       Add iKey: Matched key index in key
% ======================================================================

% get key
[keyIsDown, secs, keyCode] = KbCheck;

keyCode(16:18) = 0; % !!delete ctrl, shift, alt!!
iKey = NaN;

%----------------------------------------------------------------------%
% Replace KbName_acer by KbName
% I forget why I want to use KbName_acer ....
%   Acer - 2013/10/31 16:50
%----------------------------------------------------------------------%
% keyName = PsyResp.KbName_acer(keyCode);
keyName = KbName(keyCode);
%----------------------------------------------------------------------%

if ~keyIsDown
    return
else
    % if allow any key
    if ~exist('key', 'var'); return; end
    if isempty(key); return; end    
    
    keyPressNum = sort(find(keyCode));
    
    % allow key is a string
    if ischar(key)
        keyIsDown = keyMatching(keyPressNum, key);
    end
    
    % cell
    if iscell(key)
        % key combination
        if ischar(key{1})
            keyIsDown = keyMatching(keyPressNum, key);
        
        % Multiple key combination
        elseif iscell(key{1})
            for k_comb_i = 1:length(key)
                keyIsDown = keyMatching(keyPressNum, key{k_comb_i});
                if keyIsDown; iKey = k_comb_i; return; end
            end
        end
    end
end


function keyIsDown = keyMatching(keyPressNum, key)
    keyNum = sort(KbName(key)); % Acer - 2013/10/31 16:56
    keyIsDown = isequal(keyPressNum, keyNum);
