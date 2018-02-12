function x = pdf2one(x)
% Normalise pdf to 1
%
% 1.0 - Acer 2014/03/07 18:23
% 2.0 - Acer 2014/06/03 15:47


sPDF = x; 
for n = 1:ndims(x)
   sPDF = sum(sPDF);
end
x = x ./ sPDF;