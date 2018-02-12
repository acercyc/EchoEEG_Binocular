function [pdf, tics] = circularGaussian(mu, sigma, nTic)
% 1.0 - Acer 2014/12/09 10:14
% 1.1 - Acer 2014/12/10 13:03

% mu = pi/180*50;
% sigma = pi/180*30;
% nTic = 360;

% create tics
tics = linspace(mu-pi, mu+pi, nTic + 1);
tics(end) = [];

% convert to positive value
tics_posi = mod(tics, (2*pi));

% create pdf 
pdf = normpdf(tics, mu, sigma);
pdf = pdf./sum(pdf);

[tics, iSort] = sort(tics_posi);
pdf = pdf(iSort);

% plot
% figure 
% polar(tics, pdf)
% figure
% plot(tics, pdf)