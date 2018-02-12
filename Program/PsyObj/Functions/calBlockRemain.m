function [remainBlcok, iTrialInBlcok] = calBlockRemain(iTrial, nTrialInBlock, nTotalTrial)
% iTrial: The Current Trial 
% nTrialInBlock: number of trials in one block
% nTotalTrial: number of trials in the whole experiment 
% iTrialInBlcok: the current trial index in this block

% 1.0 - Acer 2015/02/07 10:51

nBlock = ceil(nTotalTrial/nTrialInBlock);
nBlockPassed = floor(iTrial/nTrialInBlock);
remainBlcok = nBlock - nBlockPassed;
iTrialInBlcok = mod(iTrial, nTrialInBlock);