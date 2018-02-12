function [X, Y] = LinearSeparation(n, dist, center, angle)

% 1.0 - Acer 2013/10/25 17:57
if ~exist('center', 'var'); center = [0 0]; end
if ~exist('angle', 'var'); angle = 0; end


XY = zeros(2, n);
distAll = dist*(n-1);
XY(1,:) = linspace(-distAll/2, distAll/2, n);
XY = ([cos(angle) -sin(angle); sin(angle) cos(angle)] * XY)';
XY = bsxfun(@plus, XY, center);
X = XY(:,1);
Y = XY(:,2);