clc
clear all
clear classes
addpath(genpath('lib'));

%% Open window
PI = PsyInitialize;
PI.SkipSyncTests = 1;
w = PsyScreen(1);
w.openTest([5 5 500 500]);

%% Response Panel
rw = PsyRespWheelObj(w);
rw.cSize = 200;
rw.play();