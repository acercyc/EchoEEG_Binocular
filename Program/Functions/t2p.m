function p = t2p(t, fs)
% t = t2p(t, fs)
% convert data time to data point
% 1.1 - Acer 2011/10/27_18:07
p = floor(t*fs + 1);