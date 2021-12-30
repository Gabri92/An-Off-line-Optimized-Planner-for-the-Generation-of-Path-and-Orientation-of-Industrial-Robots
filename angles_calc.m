function [theta] = angles_calc(curve)

% 'angles_calc' - It computes the angles between each couple of 
% consecutive points on the curve

% INPUT
%   curve - Input curve

% OUTPUT
%   theta - buffer of output angles

x = linspace(0,1,length(curve));
y = curve;
n = size(curve,1);

for i = 2:n-1
    x1(i-1,1) = x(i)-x(i-1);
    y1(i-1,1) = y(i)-y(i-1);
end
for i = 2:n-1
    x2(i-1,1) = x(i+1)-x(i);
    y2(i-1,1) = y(i+1)-y(i);
end
p1 = [x1 y1 zeros(n-2,1)];
p2 = [x2 y2 zeros(n-2,1)];
theta(1,1) = 0;
for i = 2:n-1
theta(i,1) = atan2d(norm(cross(p1(i-1,:),p2(i-1,:))),dot(p1(i-1,:),p2(i-1,:)));
end
theta(end+1,1) = 0;
