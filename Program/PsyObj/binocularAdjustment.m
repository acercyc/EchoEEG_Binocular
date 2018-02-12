function binocularAdjustment()
% ---------------------------------------------------------------------------- %
%                    Adjust binacular presentation position                    %
%                                     Use:                                     %
%                              wasd for left side                              %
%                              ijkl for right side                             %
%                              y to save and exit                              %
%                             n to exit wihout save                            %
%                          1.0 - Acer 2015/08/28 22:08                         %
% ---------------------------------------------------------------------------- %
% 1.1 - Acer 2015/09/03 10:05
% 2.0 - Acer 2016/10/27 13:10


addpath(genpath('lib'));
commandwindow();

%% Parameters 
% ---------------------------------------------------------------------------- %
% Screen
% ---------------------------------------------------------------------------- %
para.screen.num = 0;
    % If you have just one monitor, use 0
    % If you have multiple(n) monitor, 1 to n indicate the presentation monitor.

para.screen.isOpenTestScreen = 1;
para.screen.testScreenPosi = [10 10 800 800];


% ---------------------------------------------------------------------------- %
% Stimulus Position
% ---------------------------------------------------------------------------- %
para.posi.isCfsRight = 1;
para.posi.defLeft = [-120 0];
para.posi.defRight = [120 0];

% check if saved adjusted position exists 
if exist('Para_Position.txt', 'file')
    [para.posi.Left, para.posi.Right] = readPosition();   
else
    savePosition(para.posi.defLeft, para.posi.defRight);
    para.posi.Left = para.posi.defLeft;
    para.posi.Right = para.posi.defRight;
end


% ---------------------------------------------------------------------------- %
% Fixation
% ---------------------------------------------------------------------------- %
para.fix.isOn = 1; 
para.fix.size = 30;
para.fix.colour = [255 0 0];
para.fix.width = 5;


% ---------------------------------------------------------------------------- %
% Visual frame
% ---------------------------------------------------------------------------- %
para.vFrame.isOn = 1;
para.vFrame.colour = [255 255 255];
para.vFrame.width = 10;
para.vFrame.size = [100 100];


%% Open screen 
PsyInit = PsyInitialize;
PsyInit.SkipSyncTests = 1;

w = PsyScreen(para.screen.num);
if para.screen.isOpenTestScreen
    w.openTest( para.screen.testScreenPosi );
else
    w.open();
end

w.flip();


%% fixation 
fix = PsyCross(w);
fix.color = para.fix.colour;
fix.size = para.fix.size;
fix.width = para.fix.width;

%% visual frame
vf = PsyRect(w);
vf.color = para.vFrame.colour;
vf.penWidth = para.vFrame.width;
vf.size = para.vFrame.size;

%% Instruction text
instText = sprintf([...
    'wasd: Left stimulus\n', ...
    'ijkl: Right stimulus\n',...
    'r: to reset stimulus to default\n',...
    'y: save position and exit program\n',...
    'n: exit program without changing\n'...
    ]);


%% message text
t = PsyText(w);
t.color = [255 255 255];
t.textSize = 12;


%% Position adjustment 
while 1
    
    % draw instruction text
    DrawFormattedText(w.windowPtr, instText,0 ,0, [255 255 255]);
    
    % draw position text
    posiText = sprintf('Left:\t[%.6g, %.5g]\nRight:\t[%.5g, %.5g]',...
        para.posi.Left(:),...
        para.posi.Right(:));
    
    DrawFormattedText(w.windowPtr, posiText, 'right', 0, [255 255 255]);    
    
    % draw visual frame
    vf.center = [w.xcenter w.ycenter] + para.posi.Right;
    vf.drawFrameRect();
    
    vf.center = [w.xcenter w.ycenter] + para.posi.Left;
    vf.drawFrameRect();

    % draw fixation
    fix.xy = [w.xcenter w.ycenter] + para.posi.Right;
    fix.draw();
    
    fix.xy = [w.xcenter w.ycenter] + para.posi.Left;
    fix.draw();
    w.flip();
    
    
    % ---------------------------------------------------------------------------- %
    % keyboard input
    % ---------------------------------------------------------------------------- %
    
    % receive keyboard input
    keyIsDown = 0;
    while ~keyIsDown
        [keyIsDown, ~, keyCode] = KbCheck();        
        GetMouse();
    end 
    keys = KbName(keyCode);
    if iscell( keys )
        keys = keys{1};
    end
    
    % adjust position according to the input key
    switch keys        
        % adjust left side
        case 'a'
            para.posi.Left = para.posi.Left + [-1 0];
        case 'd'
            para.posi.Left = para.posi.Left + [1 0];
        case 'w'
            para.posi.Left = para.posi.Left + [0 -1];
        case 's'
            para.posi.Left = para.posi.Left + [0 1];
            
            
        % adjust right side        
        case 'j'
            para.posi.Right = para.posi.Right + [-1 0];
        case 'l'
            para.posi.Right = para.posi.Right + [1 0];
        case 'i'
            para.posi.Right = para.posi.Right + [0 -1];
        case 'k'
            para.posi.Right = para.posi.Right + [0 1]; 
            
            
        % other functions
        case 'r'    % reset position
            para.posi.Left = para.posi.defLeft;
            para.posi.Right = para.posi.defRight;
            
        case 'y'    % Save position
            if (para.posi.Right(1) - para.posi.Left(1)) >= 0
                savePosition(para.posi.Left, para.posi.Right);
            else
                savePosition(para.posi.Right, para.posi.Left);
            end
            
            t.text = 'Position Saved';
            t.textSize = 20;
            t.play();
            WaitSecs(2);
            break
            
        case 'n'    % Leave without save
            t.text = 'Position unchanged';
            t.textSize = 20;
            t.play();
            WaitSecs(2);            
            break
    end
    
    fprintf('%s\n', posiText);
    
    % --------------------------- End of keyboard input --------------------------
    
end

w.close();


function savePosition(centreLeft, centreRight)
% 1.0 - Acer 2015/08/28 21:12
% 1.1 - Acer 2015/09/03 10:05
%       Use LR instead of CFS and Rhythm

fid = fopen('Para_Position.txt', 'w');
fprintf(fid, 'Left_h %d\r\nLeft_v %d\r\n', centreLeft(1:2));
fprintf(fid, 'Right_h %d\r\nRight_v %d\r\n', centreRight(1:2));
fclose(fid);



function [centreLeft, centreRight] = readPosition()
% 1.0 - Acer 2015/08/28 21:13
% 1.1 - Acer 2015/09/03 10:05
%       Use LR instead of CFS and Rhythm

if ~exist('Para_Position.txt', 'file')
    SetParameters;
end

fid = fopen('Para_Position.txt', 'r');
t = textscan(fid, '%s %f');
fclose(fid);

centreLeft = t{2}(1:2)';
centreRight = t{2}(3:4)';
