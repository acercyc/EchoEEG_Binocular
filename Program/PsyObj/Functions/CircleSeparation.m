function [X, Y] = CircleSeparation(n, cenDist, origPos, rotAng)
% pos = CircleSeparation(n, cenDist, origShift)
%======================================================================%
% n: Number of elements
% cenDist: the distance between elements and the origin
% origPos: the Cartesian position of the origin 
% rotAng: rotate angle for the cylindrical coordinate
%======================================================================%
% 1.0 - Acer 2012/11/21 17:24
% 1.1 - Acer 2013/10/31 10:23
%       Delete redundant point 

if ~exist('origPos', 'var')
    origPos = [0,0];
end

if isempty(origPos)
    origPos = [0,0];
end

if ~exist('rotAng', 'var')
    rotAng = 0;
end

polPos = linspace(0, 2*pi, n+1);
[X, Y] = pol2cart(polPos(1:end-1) + rotAng, cenDist);
X = X + origPos(1);
Y = Y + origPos(2);
end