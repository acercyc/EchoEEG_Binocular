function [seqMat, times] = MakeSequence(refreshRate, trialDuration, trialNum)
%======================================================================%
% Modified from Rufin's Script
% refreshRate: in hz
% trialDuration: in Second
%
% 1.0 - Acer 2013/08/13 22:59
%======================================================================%

% Initialize
scalePara = 2.3; 


% Calculate Frame Timing
times = 0 : (1/refreshRate) : trialDuration; 
times = times(1:end-1);
framenumber = length(times);


% Make full band signal
stims2 = rand(framenumber, trialNum);
stimfft = fft(stims2,[],1);
stimfft= stimfft ./ abs(stimfft);
stims2 = ifft(stimfft,[],1);


% Re-scale to 0 ~ 255
stims2 = (stims2 - repmat( mean(stims2,1), [size(stims2,1) 1])) ./ ...
          repmat( std(stims2,[],1), [size(stims2,1) 1] );
stims2 = round(127.5+127.5*stims2/scalePara);
stims2(stims2<0)=0; 
stims2(stims2>255)=255;


% Return
seqMat = stims2';


% Plot
% plot(stims2);