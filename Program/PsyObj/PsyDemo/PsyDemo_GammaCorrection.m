%======================================================================%
% Demo:
% Add gamma correction to all the stimulus
% 1.0 - Acer 2014/02/20 19:23
%======================================================================%
clc
clear all
clear classes
addpath(genpath('..\'));
PsyInitialize;


w = PsyScreen();

%======================= Enable Gamma correction ======================%

w.ctrl_gammaCorrection = 1;

%======================================================================%

w.openTest;


% play an oval stimulus
o = PsyOval(w);
for ii = 0:255
    o.color = ii;
    o.play;
end
                          