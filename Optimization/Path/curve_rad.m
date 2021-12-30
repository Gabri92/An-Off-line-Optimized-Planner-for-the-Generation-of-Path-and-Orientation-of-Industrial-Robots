function [rad_norm] = curve_rad(n_original, points, multiplicator)

% 'curve_rad' - Compute the radius of curvature along the points of
% the curve, temporally oversampled through the parameter 'multiplicator'
% to get a better resolution on the curvatures

% INPUT
%   n_original - Original number of points
%   points - Input points
%   multiplicator - Multiplicator of the points

% OUTPUT
%   rad_norm - Norm of the curvature's radius associated to the original
%   buffer of points

%% Curvature calculation and plot

[~,~,curv] = curvature(points');
figure, hold on, plot(points(1,:),points(2,:),'k','Marker','.')
quiver(points(1,:)', points(2,:)', curv(:,1), curv(:,2))
title('Curvature radius'), xlabel('Arc Length - [mm]'), ylabel('Z - [mm]'), grid on

%% Norm 

n = length(points);
points = points';
for i = 1:n
    rr_norm(1,i) = sqrt(curv(i,1)^2+curv(i,2)^2+curv(i,3)^2);
end

%% Assignment of norm and coordinates to the original points 

temp = zeros(n_original,2);
for i = 1:n_original 
    for j = 1:multiplicator 
        temp(j,1) = rr_norm(:,j+(i-1)*multiplicator);
    end
    rad_norm(i,:) = max(temp(:,1));
    index = find(temp(:,1) == max(temp(:,1)));
    index = index(1);
end

