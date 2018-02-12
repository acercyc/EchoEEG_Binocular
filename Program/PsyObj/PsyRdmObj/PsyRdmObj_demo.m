% 1.0 - Acer 2014/12/01 19:35
clc;
clear all;
clear classes;
addpath(genpath('lib'));
%% Parameters

para.rdm.n = 100;
para.rdm.dotSize = 10;       % 0~10
para.rdm.speed = 2;
para.rdm.color = [200, 200, 200];
para.rdm.pRange = [-200, -200, 200, 200];            
para.rdm.duration = 5;
para.rdm.adapt.initIntensity = 0.3;       % initial coherence
para.rdm.adapt.maxIntensity = 1;
para.rdm.adapt.minIntensity = 0;
para.rdm.adapt.intsChange = 0.02;
para.rdm.adapt.starecase = [3 1];
para.rdm.adapt.nStopAlt = 10;


%%
PI = PsyInitialize;
PI.SkipSyncTests = 1;
w = PsyScreen(1);
w.openTest();
rdm = PsyRdmObj(w, para.rdm);


%% Run RDM
rdm.newDots( 0.5 );
rdm.play();