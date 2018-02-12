%======================================================================%
% 1.0 - Acer 2013/10/18 11:43
%======================================================================%
clc;
clear all;
clear classes;

addpath(genpath('..'));
%%
PsyInitialize;
w = PsyScreen(max(Screen('Screens')));
w.backgroundColor = [100, 100, 100];
w.openTest()

%%
m = PsyMask(w);
d = PsyOval(w);
s = PsyRect(w);

d.OvalCenter = d.OvalCenter + 30;
d.ObjSize = [135 135];
s.objSize = [60 60];

m.clearCanvas();
s.draw();

% Here
m.addDraw(d);
m.draw();

w.flip;


