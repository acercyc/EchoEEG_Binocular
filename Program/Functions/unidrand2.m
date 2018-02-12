function r = unidrand2(n, range)
% 1.0 - Acer 2014/02/28 22:07

r = rand(n);
if exist('range', 'var')
    r = r .* diff(range) + range(1);    
end