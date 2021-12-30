function [n_samp] = samp_calc(curve)

% 'samp_calc' - It computes the maximum possible number of samples
% to which the given curve could be oversampled by the 'interparc'
% function by computing minimum distance over the arc length

% INPUT
%   curve - Curve to be oversampled

% OUTPUT
%   n_samp - Number of samples

Arc = arc_length(curve);
for i = 2:length(curve)
    dist(i-1) = (Arc(i)-Arc(i-1))/Arc(end); 
end
minimum = min(dist);
n_samp = round(1/minimum);