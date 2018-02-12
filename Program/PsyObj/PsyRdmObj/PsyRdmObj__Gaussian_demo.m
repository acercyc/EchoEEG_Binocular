clc
clear all
clear classes
addpath(genpath('lib'));

%% Parameters

para.rdm.n = 100;
para.rdm.dotSize = 3;       % 0~10
para.rdm.speed = 2;
para.rdm.color = [200, 200, 200];
para.rdm.pRange = [-200, -200, 200, 200];            
para.rdm.duration = 5;


%% 
PI = PsyInitialize;
PI.SkipSyncTests = 1;
w = PsyScreen(0);
w.openTest([5 5 500 500]);
rdm = PsyRdmObj(w, para.rdm);


%% Run RDM
mu = 1 / 180 * pi;
sigma = 100 / 180 * pi;
nTic = 360*8;
[pmf, tics] = circularGaussian(mu, sigma, nTic);
rdm.newDotsByDistribution(pmf, tics);
rdm.play(5);