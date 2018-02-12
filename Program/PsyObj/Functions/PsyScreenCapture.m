function PsyScreenCapture(w, filename)
%======================================================================%
% 1.0 - Acer 2013/04/21 09:05
%======================================================================%

imageArray = Screen('GetImage', w);
imwrite(imageArray, filename);