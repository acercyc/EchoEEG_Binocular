% Repeat vector elements
function retV = repElement(target, repV)
%======================================================================%
% target: the vector you want to repeat
% repV: the vector contains the repeat time of the 
%   element in the target vector
%
% 1.0 - Acer 2013/08/28 16:30
%======================================================================%

    target(repV == 0) =[];
    repV(repV == 0) = [];

    idxV = zeros(1, sum(repV));
    idxV([1 cumsum(repV)+1]) = 1;
    idxV = cumsum(idxV);
    retV = target(idxV(1:end-1));

end