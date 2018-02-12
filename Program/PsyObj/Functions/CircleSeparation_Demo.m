%======================================================================%
% Acer 2013/10/31 09:50
%======================================================================%
n = 3;
[X, Y] = CircleSeparation(n, 6, [0, 0], pi/2);
Y = -Y;

figure();
plot(X, Y);
axis equal
set(gca,'YDir','reverse');

for ii = 1:n
    coStr = sprintf('(%.3f, %.3f)', X(ii), Y(ii));
    text(X(ii), Y(ii),  coStr);
    fprintf('p%d = %s\n', ii, coStr);
end