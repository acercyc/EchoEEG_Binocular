function main()
% ============================================================================ %
% EEG echo binocular transfer experiment 
% 
% 
% trigger type:
%   1: rep x 0
%   2: rep x 1
%   3
%   4
%   100: target trial
%   254: Rest start
%   255: Rest end
%
% data.trialInfo(#).iShowLR
% 1: left
% 2: right
% 3: both

% condition:
% 1: LR
% 2: RL
% 3: both
% 4: LL
% 5: RR

% trigger code:
% D1D2
% D1: condition
% D2: repetition
 



% 1.0 - Acer 2016/11/01 10:32
% 2.0 - Acer 2018/02/21 16:16
%       Add target trials
% 2.1 - Acer 2018/02/22 10:56
%       Fix trigger error
% ============================================================================ %

%% Initialize
clear all;
clear classes;
clc;

addpath(genpath('PsyObj'));
addpath(genpath('Functions'));
disp('PsyObj imported');


% parallele obj
% ----------------------------------------------------------------------
parallelObj = PsyParallelPort;
% parallelObj.enableTTL;
% parallelObj.disablePrint;
parallelObj.send(0);

% date log in
data.date = datestr(now); 

% Change Priority
Priority(2);


%% Subject information input
subjInfo = SubjInfObj;
subjInfo.gui;
data.subjInfo = subjInfo.makeStructure();


%% Parameters

% Screen
% ----------------------------------------------------------------------------
para.screen.wNum = 1;
para.screen.resolustionSet = 0;
para.screen.refreshRate = 160;
para.screen.width = 800;
para.screen.height = 600;
para.screen.isGammaCorrection = 0;
% checkScreenSetting(para.screen.wNum);

% binocular 
% ----------------------------------------------------------------------------
[centreLeftShift, centreRightShift] = readPosition();
para.binocular.centreLeftShift = centreLeftShift;
para.binocular.centreRightShift = centreRightShift;


% trial
% ----------------------------------------------------------------------------
para.trial.restTrialNum = 50;
para.trial.restSec = 4;
para.trial.ITI = [2.5 3.5];


% disk sequence 
% ----------------------------------------------------------------------------
para.seq.duration = 3.125;
para.seq.size = 100;
para.seq.eccentricity = [0 -120]; 
para.seq.nFrame = para.seq.duration * para.screen.refreshRate;


% repeat sequence
% ----------------------------------------------------------------------------
para.repSeq.nRep = 4;
para.repSeq.nSetByCondition = [50 50 50 25 25];
% condition:
% 1: LR
% 2: RL
% 3: both
% 4: LL
% 5: RR

% para.repSeq.nSet = 200;
para.repSeq.nSet = sum(para.repSeq.nSetByCondition);
para.repSeq.num = para.repSeq.nRep * para.repSeq.nSet;


% target 
% ----------------------------------------------------------------------
para.target.duration = 1;
para.target.size = 50;
para.target.intensityAmp = 6;
para.target.showRate = 0.2;
para.target.showJitter = [0, para.seq.duration - para.target.duration];
para.target.num = round( para.repSeq.num .* (para.target.showRate ./ (1 - para.target.showRate)) );


% save to data
% ----------------------------------------------------------------------------
para.trial.num = para.repSeq.num + para.target.num;
data.para = para;


%% Design

% make repeat sequence set index
iSeq = repmat(1:para.repSeq.nSet, para.repSeq.nRep, 1);
nRep = repmat( (1:para.repSeq.nRep)', 1, para.repSeq.nSet);

% Sequence set types
% ----------------------------------------------------------------------------
iCondi = repElement(1:length(para.repSeq.nSetByCondition), ...
    para.repSeq.nSetByCondition);
iCondi = iCondi(randperm(length(iCondi)));
iCondi = repmat(iCondi, para.repSeq.nRep, 1);


% target trial
targetSlot = para.repSeq.nSet - 1;
iTargetSlot = randi(targetSlot, 1, para.target.num);


% add target to sequence lists
iSeq_comb = [];
nRep_comb = [];
iCondi_comb = [];

for iSet = 1:para.repSeq.nSet
    nTopping = sum(iTargetSlot == iSet);
    topping = ones(1, nTopping) * -1;
    
    iSeq_comb = [iSeq_comb, iSeq(:, iSet)'];
    iSeq_comb = [iSeq_comb, topping];
    
    nRep_comb = [nRep_comb, nRep(:, iSet)'];
    nRep_comb = [nRep_comb, topping];
    
    iCondi_comb = [iCondi_comb, iCondi(:, iSet)'];
    iCondi_comb = [iCondi_comb, topping];    
end

iSeq = iSeq_comb;
nRep = nRep_comb;
iCondi = iCondi_comb;



% Make sequence and assign parameters to trials
% ----------------------------------------------------------------------------
seqMat = NaN(para.trial.num, para.seq.nFrame);
for iTrial = 1:para.trial.num
    if nRep(iTrial) == 1
        tSeq = MakeSequence(para.screen.refreshRate, para.seq.duration, 1);
    elseif nRep(iTrial) == -1
        tSeq = MakeSequence(para.screen.refreshRate, para.seq.duration, 1);
    end
    
    seqMat(iTrial, :) = tSeq;  
    
    data.trialInfo(iTrial).ITI = unidrand2(1, para.trial.ITI);
    data.trialInfo(iTrial).seqIndex = iSeq(iTrial);
    data.trialInfo(iTrial).nRep = nRep(iTrial);
    data.trialInfo(iTrial).sequence = seqMat(iTrial, :);
    
    data.trialInfo(iTrial).iCondi = iCondi(iTrial);
    
    % assign LR to tiral 
    if nRep(iTrial) ~= para.repSeq.nRep
        % if not the final repetition
        switch iCondi(iTrial)
            case 1
                iShowLR = 1;
            case 2
                iShowLR = 2;
            case 3
                iShowLR = 3;
            case 4
                iShowLR = 1;
            case 5
                iShowLR = 2;
        end     
    else
        % Final repetition
        switch iCondi(iTrial)
            case 1
                iShowLR = 2;
            case 2
                iShowLR = 1;
            case 3
                iShowLR = 3;
            case 4
                iShowLR = 1;
            case 5
                iShowLR = 2;
            case -1
                iShowLR = randi([1, 3], 1);
        end        
    end
    
    data.trialInfo(iTrial).iShowLR = iShowLR;
    
    
    % Target trial arrangment
    if nRep(iTrial) ~= -1
        data.trialInfo(iTrial).triggerCode = nRep(iTrial) + iCondi(iTrial)*10;
        data.trialInfo(iTrial).jitterTime = NaN;
        data.trialInfo(iTrial).isTarget = 0;
    else
        data.trialInfo(iTrial).triggerCode = 100;
        data.trialInfo(iTrial).jitterTime = unifrnd( para.target.showJitter(1),...
            para.target.showJitter(2), 1);
        data.trialInfo(iTrial).isTarget = 1;
    end
end


% save to data
% ----------------------------------------------------------------------------
data.sequence = seqMat;


%% Initialize Psychotoolbox and objects
PsyInitialize;
commandwindow();

% Screen
Screen('Preference', 'SkipSyncTests', 1);
w = PsyScreen(para.screen.wNum);
w.ctrl_gammaCorrection = para.screen.isGammaCorrection;
if para.screen.resolustionSet
    w.resolustion_experiment.width = para.screen.width;
    w.resolustion_experiment.height = para.screen.height;
    w.resolustion_experiment.hz = para.screen.refreshRate;
    w.resolutionSet();
end

w.openTest([100 100 800 800]);
% w.open();



% Rest Text
p = PsyText_Prompt(w);                  


% disk
d = PsyOval(w);
d.size = [para.seq.size, para.seq.size];
d.center = para.seq.eccentricity + [w.xcenter w.ycenter];
diskCentreL = [w.xcenter w.ycenter] + para.seq.eccentricity + centreLeftShift;
diskCentreR = [w.xcenter w.ycenter] + para.seq.eccentricity + centreRightShift;


% fixation
fix = PsyCross(w);
fix.color = [50, 50, 50];


% target
t = PsyRect(w);
t.size = [para.target.size, para.target.size];
t.color = para.target.intensityAmp + d.color;
t.center = para.seq.eccentricity + [w.xcenter w.ycenter];


% command window message
mesg = PsyCommandWindowMessage;


% record variables
frameTimingMat = NaN(size(seqMat));


% Break time counter
cBreak = 0;


% binacular
centreL = centreLeftShift + [w.xcenter w.ycenter];
centreR = centreRightShift + [w.xcenter w.ycenter];

%% Exp start
% ======================================================================

parallelObj.send(254);
p.playWelcome_and_prompt();
parallelObj.send(255);

mesg.blockMessage('Experiment starts');
for iTrial = 1:para.trial.num
    
    % Trial Initialize
    % ---------------------------------------------------------------------
    mesg.trialNum(iTrial);
        
    % Resting Screen
    % ---------------------------------------------------------------------    
    if ( floor( (iTrial-1) ./ para.trial.restTrialNum) - cBreak ) > 0 &&...
            data.trialInfo(iTrial).nRep == 1
        parallelObj.send(254);
        mesg.blockMessage('Rest block onset');
        
        [remainBlcok] = calBlockRemain(iTrial,...
            para.trial.restTrialNum,...
            para.trial.num);
        
        p.playRest_Block_pressKey(remainBlcok); 
        
        parallelObj.send(255);
        mesg.blockMessage('Rest block offset');
        WaitSecs(3);
        cBreak = cBreak + 1;                
    end
    
    % fixation
    fix.xy = centreL;
    fix.draw();
    fix.xy = centreR;  
    fix.play();
    
    WaitSecs( data.trialInfo(1, 1).ITI );

    
    % =====================================================================
    % Run sequence
    % =====================================================================
    % Send onset Trigger
    
    parallelObj.send( data.trialInfo(iTrial).triggerCode );
    t0 = GetSecs();
        
    
    % Sequence Presentation
    for iFrame = 1:length( data.trialInfo(iTrial).sequence )
        d.color = repmat( data.trialInfo(iTrial).sequence(iFrame), 1, 3);

        % draw fixation
        fix.xy = centreL;
        fix.draw();
        fix.xy = centreR;  
        fix.draw();

        % draw disk 
        if data.trialInfo(iTrial).iShowLR == 1
            d.center = diskCentreL;
            d.draw();
        elseif data.trialInfo(iTrial).iShowLR == 2
            d.center = diskCentreR;
            d.draw();
        elseif data.trialInfo(iTrial).iShowLR == 3
            d.center = diskCentreL;
            d.draw();                
            d.center = diskCentreR;
            d.draw();                
        end
       
        % -------------------------------------------------------------
        % Target display period
        % -------------------------------------------------------------
        if data.trialInfo(iTrial).isTarget
            t1 = GetSecs;
            if ((t1 - t0) >= data.trialInfo(iTrial).jitterTime) &...
               ((t1 - t0) < (data.trialInfo(iTrial).jitterTime + para.target.duration))
                tTcolor = para.target.intensityAmp + d.color;                   
                if tTcolor > 255; tTcolor = 255; end
                t.color = tTcolor;


                if data.trialInfo(iTrial).iShowLR == 1
                    t.center = diskCentreL;
                    t.draw();
                elseif data.trialInfo(iTrial).iShowLR == 2
                    t.center = diskCentreR;
                    t.draw();
                elseif data.trialInfo(iTrial).iShowLR == 3
                    t.center = diskCentreL;
                    t.draw();                
                    t.center = diskCentreR;
                    t.draw();                
                end              

                t.draw();
%                 fix.draw();
            end            
        end
        % -------------------------------------------------------------
        
        frameTimingMat(iTrial, iFrame) = d.flip();
    end
    
    parallelObj.send(0);
    fix.xy = centreL;
    fix.draw();
    fix.xy = centreR;    
    fix.play();
    
    % ================================ KB response =============================== %
    keyIsDown = 0;
    t0 = GetSecs();
    while GetSecs()-t0 < data.trialInfo(iTrial).ITI
        keyIsDown = KbCheck();
    end
    
    if data.trialInfo(iTrial).isTarget
        data.trialInfo(iTrial).isCorrect = keyIsDown;
    else
        data.trialInfo(iTrial).isCorrect = ~keyIsDown;
    end
    
    % ======================= End of sequence presentation ======================= % 
    
    
    % data login 
    data.trialInfo(iTrial).trialEndTime = datestr(now,'yyyy-mm-dd HH:MM:SS');
    data.trialInfo(iTrial).frameTiming = frameTimingMat(iTrial, :);    
    
    % Save Timing Matrix
    data.frameTimingMat = frameTimingMat;
    
    
    % Save to file
    save(sprintf('data_s%s.mat', data.subjInfo.SubjectID), 'data');
    
end

%% End of the experiment
save(sprintf('data_s%s_all.mat', data.subjInfo.SubjectID));

w.close();
Priority(0);
mesg.blockMessageLarge('End Experiment');

