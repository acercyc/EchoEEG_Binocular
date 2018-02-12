function [centreLeft, centreRight] = readPosition()
% 1.0 - Acer 2015/08/28 21:13
% 1.1 - Acer 2015/09/03 10:05
%       Use LR instead of CFS and Rhythm

fid = fopen('Para_Position.txt', 'r');
t = textscan(fid, '%s %f');
fclose(fid);

centreLeft = t{2}(1:2)';
centreRight = t{2}(3:4)';