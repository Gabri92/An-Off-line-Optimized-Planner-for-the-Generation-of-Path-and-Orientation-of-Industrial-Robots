function [pk_new,curve_new] = elab_data(pk,curve,N)    
    
% 'elab_data' - Impose a delay of 3N to the curve obtained by the 
%  FIR filters to remove the transitory

% INPUT
%   pk - Piecewise constant function
%   curve - Curve obtained by the FIR filters
%   N - Number of samples

% OUTPUT
%   pk_new - Elaborated piecewise constant function
%   curve_new - Elaborated curve
    
curve(1:3*N) = curve(3*N);
post_curve = curve(2*N+1:end);
clear curve;
curve_new = zeros(1,length(post_spline));
curve_new = post_curve;
temp = curve_new(end);
curve_new(end+1:end+N) = temp;

clear temp;
pk = pk(2*N+1:end);
temp = pk(end);
pk(end+1:end+N) = temp;